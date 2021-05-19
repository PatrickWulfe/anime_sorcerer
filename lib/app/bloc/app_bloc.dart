import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required FirebaseAuthRepository firebaseAuthRepository})
      : _firebaseAuthRepository = firebaseAuthRepository,
        super(
          firebaseAuthRepository.currentUser.isNotEmpty
              ? AppState.authenticated(firebaseAuthRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _firebaseAuthRepository.user.listen(_onUserChanged);
  }

  final FirebaseAuthRepository _firebaseAuthRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      unawaited(_firebaseAuthRepository.logOut());
    }
  }

  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
