// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:mumen_finder/app/view/app.dart';
import 'package:mumen_finder/app/app_bloc_observer.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final firebaseAuthRepository = FirebaseAuthRepository();
  await firebaseAuthRepository.user.first;
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
    () => runApp(App(firebaseAuthRepository: firebaseAuthRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
