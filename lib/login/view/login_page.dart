import 'package:anime_sorcerer/app/app.dart';
import 'package:mal_auth_repository/mal_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../login/login.dart';

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
                  RepositoryProvider.of<MALAuthRepository>(context),
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
    var loginBloc = BlocProvider.of<LoginBloc>(context);
    var pageCubit = BlocProvider.of<PageFlowCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Sorcerer'),
      ),
      body: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.gotAuthUrl:
          //return WebView(
          //javascriptMode: JavascriptMode.unrestricted,
          //initialUrl: state.infoString,
          //navigationDelegate: (navReq) {
          /* if (navReq.url.startsWith(redirectUrl.toString())) {
                  var responseUrl = Uri.parse(navReq.url);
                  loginBloc.add(AuthResponseReceived(
                    parameters: responseUrl.queryParameters,
                  ));
                  return NavigationDecision.prevent;
                } */
          //return NavigationDecision.navigate;
          //},
          //);
          case AuthenticationStatus.authenticated:
            return Column(
              children: [
                const Center(
                  child: Text('YAAAASSSS'), //${authRepository.accessToken}'),
                ),
                ElevatedButton(
                    onPressed: () => pageCubit.updateFlow('/'),
                    child: const Text('Logged in, go back home'))
              ],
            );
          default:
            return Column(
              children: [
                Center(
                    child: ElevatedButton(
                        onPressed: () => loginBloc.add(LoginLoginRequested()),
                        child: const Text('Login with MyAnimeList'))),
              ],
            );
        }
      }),
    );
  }
}
