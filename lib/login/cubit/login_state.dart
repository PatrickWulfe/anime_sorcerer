part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoggedIn extends LoginState {
  const LoggedIn({required this.user});
  final mal_api.User user;
}

class LoggedOut extends LoginState {}
