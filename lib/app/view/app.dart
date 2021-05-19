import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumen_finder/app/app.dart';
import 'package:mumen_finder/theme.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required FirebaseAuthRepository firebaseAuthRepository,
  })   : _firebaseAuthRepository = firebaseAuthRepository,
        super(key: key);

  final FirebaseAuthRepository _firebaseAuthRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _firebaseAuthRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          firebaseAuthRepository: _firebaseAuthRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
