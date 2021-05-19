// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mumen_finder/app/app.dart';

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final user = MockUser();
    late FirebaseAuthRepository firebaseAuthRepository;

    setUp(() {
      firebaseAuthRepository = MockFirebaseAuthRepository();
      when(() => firebaseAuthRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
      when(
        () => firebaseAuthRepository.currentUser,
      ).thenReturn(User.empty);
    });

    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(firebaseAuthRepository: firebaseAuthRepository).state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty',
        build: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => firebaseAuthRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
          return AppBloc(firebaseAuthRepository: firebaseAuthRepository);
        },
        seed: () => AppState.unauthenticated(),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        build: () {
          when(() => firebaseAuthRepository.user).thenAnswer(
            (_) => Stream.value(User.empty),
          );
          return AppBloc(firebaseAuthRepository: firebaseAuthRepository);
        },
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        build: () {
          return AppBloc(firebaseAuthRepository: firebaseAuthRepository);
        },
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => firebaseAuthRepository.logOut()).called(1);
        },
      );
    });
  });
}
