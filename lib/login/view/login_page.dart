import 'package:anime_sorcerer/app/app.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
              myAnimeListRepository:
                  RepositoryProvider.of<MyAnimeListRepository>(context)),
        ),
      ],
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginCubit>(context);
    var pageCubit = BlocProvider.of<PageFlowCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Sorcerer'),
      ),
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
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
          if (state is LoggedIn) {
            return Column(
              children: [
                const Center(
                  child: Text('YAAAASSSS'), //${authRepository.accessToken}'),
                ),
                ElevatedButton(
                  onPressed: () => pageCubit.updateFlow('/animelist'),
                  child: const Text('Logged in, go to anime list'),
                )
              ],
            );
          } else {
            return Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () => loginCubit.userLoginRequested(),
                    child: const Text('Login with MyAnimeList'),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
