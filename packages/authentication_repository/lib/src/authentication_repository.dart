import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../authentication_repository.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  gotAuthUrl
}

class AuthenticationRepository {
  AuthenticationRepository(
      {required this.authorizationEndpoint,
      required this.tokenEndpoint,
      required this.redirectUrl,
      required this.credentialsFile}) {
    state = '';
    codeChallenge = _getRandomString(120);
    _client = http.Client();
  }

  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String identifier = hiddenClientId;
  late final String codeChallenge;
  final String redirectUrl;
  final File credentialsFile;
  late final String state; // recommended, just not implimented yet
  final _controller = StreamController<AuthenticationStatus>();
  late final http.Client _client;
  String? _accessToken;
  String? _refreshToken;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<Uri> getAuthUrl() async {
    var suffix1 = '?response_type=code&client_id=$identifier';
    var suffix2 = '&code_challenge=$codeChallenge';
    return Uri.parse(authorizationEndpoint + suffix1 + suffix2);
  }

  Future<void> createClient(Map<String, String> parameters) async {
    var body = {
      'client_id': identifier,
      'grant_type': 'authorization_code',
      'code': parameters['code'],
      'code_verifier': codeChallenge,
    };
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var result = await _client.post(
      Uri.parse(tokenEndpoint),
      headers: headers,
      body: body,
    );

    var resultBody = jsonDecode(result.body);
    if (resultBody is Map) {
      _accessToken = resultBody['access_token'];
      if (_accessToken != null) {
        _controller.add(AuthenticationStatus.authenticated);
      }
    }
  }

  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  bool logOut() => true; // placeholder

  void dispose() => _controller.close();

  String _getRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (index) => random.nextInt(255));
    // encoded string will be longer than the number of chars we want, so trim
    return base64UrlEncode(values).substring(0, length - 1); //
  }
}
