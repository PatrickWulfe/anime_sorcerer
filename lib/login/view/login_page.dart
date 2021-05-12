import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../login/login.dart';

part 'login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) {
          return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context));
        }),
      ],
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authRepository =
        RepositoryProvider.of<AuthenticationRepository>(context);
    var loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Sorcerer'),
      ),
      body: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.gotAuthUrl:
            return WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: state.infoString,
              navigationDelegate: (navReq) {
                if (navReq.url.startsWith(redirectUrl.toString())) {
                  var responseUrl = Uri.parse(navReq.url);
                  loginBloc.add(AuthResponseReceived(
                    parameters: responseUrl.queryParameters,
                  ));
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            );
          case AuthenticationStatus.authenticated:
            return Center(
              child: Text('YAAAASSSS ${authRepository.accessToken}'),
            );
          default:
            return Center(
                child: ElevatedButton(
                    onPressed: () => loginBloc.add(LoginLoginRequested()),
                    child: const Text('Login with MyAnimeList')));
        }
      }),
    );
  }
}
