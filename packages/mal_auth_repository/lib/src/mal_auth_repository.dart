import 'dart:async';

import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import '../mal_auth_repository.dart';
import 'mal_oauth2_client.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  gotAuthUrl,
}

class MALAuthRepository {
  MALAuthRepository() {
    _malOAuth2Client = MALOAuth2Client();
    var authCodeParams = {'zero': 0, 'one': 1};
    _oAuth2Helper = OAuth2Helper(
      _malOAuth2Client,
      clientId: '5c943b5a50e820deb39eb8f9d873e8b6',
      authCodeParams: authCodeParams,
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

  Future<void> _initAccessToken() async {
    _accessToken = await _malOAuth2Client.getTokenWithAuthCodeFlow(
      clientId: '5c943b5a50e820deb39eb8f9d873e8b6',
    );
    print(_accessToken!.accessToken);
  }
}
