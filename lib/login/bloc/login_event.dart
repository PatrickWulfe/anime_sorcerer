part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginStatusChanged extends LoginEvent {
  const LoginStatusChanged({required this.status});

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

class LoginLoginRequested extends LoginEvent {}

class AuthResponseReceived extends LoginEvent {
  AuthResponseReceived({required this.parameters});

  final Map<String, String> parameters;
}

class LoginLogoutRequested extends LoginEvent {}
