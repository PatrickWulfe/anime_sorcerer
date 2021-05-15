import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:myanimelist_repository/src/utils/hidden_constants.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import 'mal_oauth2_client.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  gotAuthUrl,
}

class MALAuthRepository {
  MALAuthRepository() {
    var _codeChallenge = _getRandomString(128);
    _malOAuth2Client = MALOAuth2Client();
    var authCodeParams = {
      'response_type': 'code',
      'client_id': hiddenClientId,
      'code_challenge': _codeChallenge,
      'code_challenge_method': 'plain',
    };
    var accessTokenParams = {
      'client_id': hiddenClientId,
      'grant_type': 'authorization_code',
      'redirect_uri': 'wulfep.animesorcerer/oauth',
      'code_verifier': _codeChallenge,
    };
    _oAuth2Helper = OAuth2Helper(
      _malOAuth2Client,
      clientId: hiddenClientId,
      authCodeParams: authCodeParams,
      accessTokenParams: accessTokenParams,
    );

    _initAccessToken();
    print(_accessToken!.accessToken);
  }

  final _controller = StreamController<AuthenticationStatus>();
  late final MALOAuth2Client _malOAuth2Client;
  late final OAuth2Helper _oAuth2Helper;
  AccessTokenResponse? _accessToken;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<OAuth2Helper> getHelper() async {
    return _oAuth2Helper;
  }

  Future<void> _initAccessToken() async {
    _accessToken = await _malOAuth2Client.getTokenWithAuthCodeFlow(
      clientId: hiddenClientId,
    );
    _controller.add(AuthenticationStatus.authenticated);
  }

  String _getRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (index) => random.nextInt(255));
    // encoded string will be longer than the number of chars we want, so trim
    return base64UrlEncode(values).substring(0, length - 1); //
  }
}
