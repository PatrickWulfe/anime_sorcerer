import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';
import 'package:myanimelist_api/myanimelist_api.dart' as mal_api;
import 'package:oauth2/oauth2.dart' as oauth2;

enum AuthenticationStatus {
  unknown,
  authenticated,
  authenticationRequested,
  unauthenticated,
}

/// Repository for handling the MyAnimeList authentication domain
/// takes in which
class MyAnimeListRepository {
  MyAnimeListRepository({required String clientId}) {
    _clientId = clientId;
  }

  final File _credentialsFile = File(credentialsFile);
  late final String _clientId;
  late final oauth2.AuthorizationCodeGrant? _grant;
  late final oauth2.Client? _oauthClient;
  late final mal_api.Client? _apiClient;
  late final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unknown;
    yield* _controller.stream;
  }

  Future<User> get currentUser async {
    var userData = await _apiClient?.getUserInfo();
    return User(id: userData!.id!, name: userData.name);
  }

  /// Returns an oauth2 client set up with MyAnimeList
  Future<void> createClient() async {
    var exists = await _credentialsFile.exists();

    // If we have stored credentials, load them
    if (exists) {
      var credentials =
          oauth2.Credentials.fromJson(await _credentialsFile.readAsString());
      _oauthClient = oauth2.Client(credentials, identifier: _clientId);
    }

    // If we don't have stored credentials, get user authorization
    _grant ??= oauth2.AuthorizationCodeGrant(
      _clientId,
      Uri.parse(malAuthorizationEndpoint),
      Uri.parse(malTokenEndpoint),
    );
    _controller.add(AuthenticationStatus.authenticationRequested);
  }

  /// getter for the authrorizationUrl
  Uri get authorizationUrl =>
      _grant!.getAuthorizationUrl(Uri.parse(redirectUrl));

  /// function to retreive a list of AnimeListings based on search parameters
  Future<List<AnimeListing>> getAnimeListings(
      {String keyword = '', int limit = 30, int offset = 0}) async {
    var listings =
        await _apiClient!.searchAnime(keyword, limit: limit, offset: offset);
    var result = listings
        .map((listing) => AnimeListing(
            id: listing.id!,
            title: listing.title!,
            picUrl: listing.mainPicture!.medium.toString()))
        .toList();
    return result;
  }

  /// function to get more details about an anime
  
}
