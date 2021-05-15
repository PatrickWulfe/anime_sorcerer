import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../mal_auth_repository.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  gotAuthUrl,
}

class AuthenticationRepository {
  AuthenticationRepository({
    required Uri authorizationEndpoint,
    required Uri tokenEndpoint,
    required String identifier,
    required Uri redirectUrl,
    required String credentialsFile,
  }) {
    _credentialsFile = File(credentialsFile);
    _grant = oauth2.AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint);
    _initClient(identifier, redirectUrl);
  }

  late final oauth2.AuthorizationCodeGrant _grant;
  late final oauth2.Client _client;
  late final Uri _authorizationUrl;
  late final File _credentialsFile;
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> _initClient(
    String identifier,
    Uri redirectUrl,
  ) async {
    var exists = await _credentialsFile.exists();
    _authorizationUrl = _grant.getAuthorizationUrl(redirectUrl);

    if (exists) {
      var credentials =
          oauth2.Credentials.fromJson(await _credentialsFile.readAsString());
      _client = oauth2.Client(
        credentials,
        identifier: identifier,
        basicAuth: false,
      );
      _client = oauth2.Client(credentials, identifier: identifier);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.gotAuthUrl);
    }
  }

  Future<void> createClient(Map<String, String> parameters) async {
    _client = await _grant.handleAuthorizationResponse(parameters);
  }

  Uri get authorizationUrl => _authorizationUrl;

  //String get accessToken => _accessToken!;
  //String get refreshToken => _refreshToken!;

  bool logOut() => true; // placeholder

  void dispose() => _controller.close();
}

/* import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

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
    _httpClient = http.Client();
    grant = oauth2.AuthorizationCodeGrant(
        identifier, Uri.parse(authorizationEndpoint), Uri.parse(tokenEndpoint));
    initAuthUrl();
  }

  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String identifier = hiddenClientId;
  late final Uri _authorizationUrl;
  late final String codeChallenge;
  final String redirectUrl;
  final io.File credentialsFile;
  late final String state; // recommended, just not implimented yet
  final _controller = StreamController<AuthenticationStatus>();
  late final http.Client _httpClient;
  late final oauth2.Client _oauth2Client;
  late final oauth2.AuthorizationCodeGrant grant;
  String? _accessToken;
  String? _refreshToken;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<Uri> getAuthUrlold() async {
    var suffix1 = '?response_type=code&client_id=$identifier';
    var suffix2 = '&code_challenge=$codeChallenge';
    return Uri.parse(authorizationEndpoint + suffix1 + suffix2);
  }

  Uri getAuthUrl() {
    return _authorizationUrl;
  }

  Future<void> initAuthUrl() async {
    var exists = await credentialsFile.exists();

    if (exists) {
      var credentials =
          oauth2.Credentials.fromJson(await credentialsFile.readAsString());
      _oauth2Client = oauth2.Client(
        credentials,
        identifier: identifier,
      );
    }

    _authorizationUrl = grant.getAuthorizationUrl(Uri.parse(redirectUrl));
    _controller.add(AuthenticationStatus.gotAuthUrl);
  }

  Future<void> createClient(Map<String, String> parameters) async {
    _oauth2Client = await grant.handleAuthorizationResponse(parameters);
  }

  Future<void> createClientOld(Map<String, String> parameters) async {
    var body = {
      'client_id': identifier,
      'grant_type': 'authorization_code',
      'code': parameters['code'],
      'code_verifier': codeChallenge,
    };
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var result = await _httpClient.post(
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
 */
