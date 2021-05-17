import 'dart:async';

import 'package:myanimelist_api/myanimelist_api.dart' as mal_api;
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import '../myanimelist_repository.dart';

enum MALAuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class MyAnimeListRepository {
  MyAnimeListRepository() {
    _malOAuth2Client = MALOAuth2Client();
    _oAuth2Helper = OAuth2Helper(
      _malOAuth2Client,
      clientId: hiddenClientId,
    );

    _initAccessToken();
  }

  late final MALOAuth2Client _malOAuth2Client;
  mal_api.Client? _apiClient;
  late final OAuth2Helper _oAuth2Helper;
  AccessTokenResponse? _accessToken;
  final _controller = StreamController<MALAuthenticationStatus>();

  Stream<MALAuthenticationStatus> get authenticationStatus async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (_accessToken == null) {
      yield MALAuthenticationStatus.unauthenticated;
    } else {
      yield MALAuthenticationStatus.authenticated;
    }
    yield* _controller.stream;
  }

  Future<User> get currentUser async {
    var userData = await _apiClient!.getUserInfo();
    return User(id: userData.id!, name: userData.name!);
  }

  Future<void> _initAccessToken() async {
    _accessToken ??= await _oAuth2Helper.getTokenFromStorage();
    _accessToken ??= await _oAuth2Helper.getToken();
    _accessToken ??= await _malOAuth2Client.getTokenWithAuthCodeFlow(
      clientId: hiddenClientId,
    );
    if (_accessToken != null) {
      _controller.add(MALAuthenticationStatus.authenticated);
      print(_accessToken!.accessToken);
    }
  }
}
