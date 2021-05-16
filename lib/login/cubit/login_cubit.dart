import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist_api/myanimelist_api.dart' as mal_api;
import 'package:myanimelist_repository/myanimelist_repository.dart';

import '../login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.myAnimeListRepository}) : super(LoginInitial()) {
    _malAuthenticationSubscription =
        myAnimeListRepository.authenticationStatus.listen((status) {
      switch (status) {
        case MALAuthenticationStatus.authenticated:
          userLoggedIn();
          break;
        case MALAuthenticationStatus.unauthenticated:
          userLoggedOut();
          break;
        default:
          break;
      }
    });
  }

  final MyAnimeListRepository myAnimeListRepository;
  late StreamSubscription<MALAuthenticationStatus>
      _malAuthenticationSubscription;

  void userLoggedIn() async =>
      emit(LoggedIn(user: await myAnimeListRepository.apiClient.getUserInfo()));

  void userLoginRequested() => myAnimeListRepository.oAuth2Helper.getToken();

  void userLoggedOut() => emit(LoggedOut());
}
