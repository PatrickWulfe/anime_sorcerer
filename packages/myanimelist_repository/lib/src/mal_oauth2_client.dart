import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';

import '../myanimelist_repository.dart';

class MALOAuth2Client extends OAuth2Client {
  MALOAuth2Client()
      : super(
          authorizeUrl: 'https://myanimelist.net/v1/oauth2/authorize',
          tokenUrl: 'https://myanimelist.net/v1/oauth2/token',
          redirectUri: 'wulfep.animesorcerer://oauth2',
          customUriScheme: 'wulfep.animesorcerer',
        ) {
    _codeChallenge = _getRandomString(128);
  }

  late final String _codeChallenge;

  @override
  Future<AccessTokenResponse> getTokenWithAuthCodeFlow({
    required String clientId,
    List<String>? scopes,
    String? clientSecret,
    bool enablePKCE = true,
    bool enableState = true,
    String? state,
    String? codeVerifier,
    Function? afterAuthorizationCodeCb,
    Map<String, dynamic>? authCodeParams,
    Map<String, dynamic>? accessTokenParams,
    httpClient,
    webAuthClient,
  }) async {
    AccessTokenResponse? tknResp;

    var authResp = await requestAuthorization(
        webAuthClient: webAuthClient,
        clientId: clientId,
        scopes: scopes,
        codeChallenge: _codeChallenge,
        enableState: enableState,
        state: state,
        customParams: authCodeParams);

    if (authResp.isAccessGranted()) {
      if (afterAuthorizationCodeCb != null) afterAuthorizationCodeCb(authResp);

      tknResp = await requestAccessToken(
          httpClient: httpClient,
          //If the authorization request was successfull, the code must be set
          //otherwise an exception is raised in the OAuth2Response constructor
          code: authResp.code!,
          clientId: clientId,
          scopes: scopes,
          clientSecret: clientSecret,
          codeVerifier: _codeChallenge,
          customParams: accessTokenParams);
    } else {
      tknResp = AccessTokenResponse.errorResponse();
    }

    return tknResp;
  }

  /// Requests and Access Token using the provided Authorization [code].
  @override
  Future<AccessTokenResponse> requestAccessToken(
      {required String code,
      required String clientId,
      String? clientSecret,
      String? codeVerifier,
      List<String>? scopes,
      Map<String, dynamic>? customParams,
      httpClient}) async {
    final params = getTokenUrlParams(
        code: code,
        redirectUri: redirectUri,
        codeVerifier: _codeChallenge,
        customParams: customParams);

    var response = await _performAuthorizedRequest(
        url: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret,
        params: params,
        httpClient: httpClient);

    return http2TokenResponse(response, requestedScopes: scopes);
  }

  /// Refreshes an Access Token issuing a refresh_token grant to the OAuth2 server.
  @override
  Future<AccessTokenResponse> refreshToken(String refreshToken,
      {httpClient, required String clientId, String? clientSecret}) async {
    final Map params = getRefreshUrlParams(refreshToken: refreshToken);

    var response = await _performAuthorizedRequest(
        url: _getRefreshUrl(),
        clientId: clientId,
        params: params,
        httpClient: httpClient);

    return http2TokenResponse(response);
  }

  @override
  String getAuthorizeUrl(
      {required String clientId,
      String responseType = 'code',
      String? redirectUri,
      List<String>? scopes,
      bool enableState = true,
      String? state,
      String? codeChallenge,
      Map<String, dynamic>? customParams}) {
    return '$malAuthorizationEndpoint?response_type=code&client_id=$clientId' +
        '&redirect_uri=$redirectUri&code_challenge=$codeChallenge&state=$state';
  }

  /// Performs a post request to the specified [url],
  /// adding authentication credentials as described here: https://tools.ietf.org/html/rfc6749#section-2.3
  Future<http.Response> _performAuthorizedRequest(
      {required String url,
      required String clientId,
      String? clientSecret,
      Map? params,
      httpClient}) async {
    httpClient ??= http.Client();

    var body = {
      'client_id': clientId,
      'grant_type': 'authorization_code',
      'code': params!['code'],
      'code_verifier': _codeChallenge,
      'redirect_uri': 'wulfep.animesorcerer://oauth2',
    };
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var response = await httpClient.post(
      Uri.parse('https://myanimelist.net/v1/oauth2/token'),
      headers: headers,
      body: body,
    );

    return response;
  }

  String _getRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (index) => random.nextInt(255));
    // encoded string will be longer than the number of chars we want, so trim
    return base64UrlEncode(values).substring(0, length - 1); //
  }

  String _getRefreshUrl() {
    return refreshUrl ?? tokenUrl;
  }
}
