import 'dart:async';

import 'package:anime_sorcerer/app/app.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })   : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const LoginState.unknown()) {
    _authenticationStatusSubscription = _authenticationRepository.status
        .listen((status) => add(LoginStatusChanged(status: status)));
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginStatusChanged) {
      yield await _mapLoginStatusChangedToState(event);
    } else if (event is LoginLoginRequested) {
      var authUrl = await _authenticationRepository.getAuthUrl();
      yield LoginState.webViewDisplayed(authUrl.toString());
    } else if (event is AuthResponseReceived) {
      await _authenticationRepository.createClient(event.parameters);
    } else if (event is LoginLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<LoginState> _mapLoginStatusChangedToState(
    LoginStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const LoginState.unauthenticated();
      case AuthenticationStatus.gotAuthUrl:
        return LoginState.webViewDisplayed(
            _authenticationRepository.getAuthUrl().toString());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return user != null
            ? LoginState.authenticated(user)
            : const LoginState.authenticated(User('id'));
      default:
        return const LoginState.unknown();
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }
}

/* class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authenticationRepository}) : super(LoginLoggedOut());

  final AuthenticationRepository authenticationRepository;
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginInit) {
      var tmp = authenticationRepository.getLoginUrl();
      await _openWebAuth();
      print('test');
      yield LoginHtmlDisplayed(
          loginRequest: authenticationRepository.getLoginUrl());
    } else if (event is UserLogoutSuccess) {
      yield LoginLoggedOut();
    }
  }

  Future<void> _openWebAuth() async {
    final result = await FlutterWebAuth.authenticate(
      url: authenticationRepository.getLoginUrl(),
      callbackUrlScheme: authenticationRepository.callBackUrlScheme,
    );
    final code = Uri.parse(result).queryParameters['code'];
  }
} */
