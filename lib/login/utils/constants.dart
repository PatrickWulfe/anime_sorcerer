import 'dart:io';

final authorizationEndpoint = 'https://myanimelist.net/v1/oauth2/authorize';
final tokenEndpoint = 'https://myanimelist.net/v1/oauth2/token';
final redirectUrl = 'https://pwulfe.animesorcerer/oauth';
final credentialsFile = File('~/.com.wulfep.anime_sorcerer/credentials.json');
