part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
    this.infoString = '',
  });

  const LoginState.unknown() : this._();

  const LoginState.authenticated(user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const LoginState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const LoginState.webViewDisplayed(String authUrl)
      : this._(
          status: AuthenticationStatus.gotAuthUrl,
          infoString: authUrl,
        );

  final AuthenticationStatus status;
  final User user;
  final String infoString;

  @override
  List<Object> get props => [status, user];
}
