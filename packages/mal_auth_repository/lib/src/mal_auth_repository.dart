import 'dart:async';

import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import '../mal_auth_repository.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  gotAuthUrl,
}

class MALAuthRepository {
  MALAuthRepository() {
    _oAuth2Helper = OAuth2Helper(
      _oAuth2Client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: '5c943b5a50e820deb39eb8f9d873e8b6',
    );

    _initAccessToken();
    print(_accessToken!.accessToken);
  }

  final _controller = StreamController<AuthenticationStatus>();
  final _oAuth2Client = OAuth2Client(
    authorizeUrl: 'https://myanimelist.net/v1/oauth2/authorize',
    tokenUrl: 'https://myanimelist.net/v1/oauth2/token',
    redirectUri: 'wulfep.animesorcerer://oauth2',
    customUriScheme: 'wulfep.animesorcerer',
    //credentialsLocation: CredentialsLocation.BODY,
  );
  late final OAuth2Helper _oAuth2Helper;
  AccessTokenResponse? _accessToken;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> _initAccessToken() async {
    _accessToken = await _oAuth2Client.getTokenWithAuthCodeFlow(
      clientId: '5c943b5a50e820deb39eb8f9d873e8b6',
    );
  }
}
