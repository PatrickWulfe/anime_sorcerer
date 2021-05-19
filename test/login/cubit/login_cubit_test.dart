// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:form_inputs/form_imputs.dart';
import 'package:mumen_finder/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 't0pS3cret1234';
  const validPassword = Password.dirty(validPasswordString);

  group('LoginCubit', () {
    late FirebaseAuthRepository firebaseAuthRepository;

    setUp(() {
      firebaseAuthRepository = MockFirebaseAuthRepository();
      when(
        () => firebaseAuthRepository.logInWithGoogle(),
      ).thenAnswer((_) async => null);
      when(
        () => firebaseAuthRepository.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => null);
    });

    test('initial state is LoginState', () {
      expect(LoginCubit(firebaseAuthRepository).state, LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(firebaseAuthRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <LoginState>[
          LoginState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(firebaseAuthRepository),
        seed: () => LoginState(password: validPassword),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(firebaseAuthRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <LoginState>[
          LoginState(
            password: invalidPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(firebaseAuthRepository),
        seed: () => LoginState(email: validEmail),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('logInWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginCubit(firebaseAuthRepository),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => LoginCubit(firebaseAuthRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        verify: (_) {
          verify(
            () => firebaseAuthRepository.logInWithEmailAndPassword(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => LoginCubit(firebaseAuthRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
            password: validPassword,
          )
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails',
        build: () {
          when(
            () => firebaseAuthRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
          return LoginCubit(firebaseAuthRepository);
        },
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
          )
        ],
      );
    });

    group('logInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginCubit(firebaseAuthRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        verify: (_) {
          verify(() => firebaseAuthRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithGoogle succeeds',
        build: () => LoginCubit(firebaseAuthRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails',
        build: () {
          when(
            () => firebaseAuthRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
          return LoginCubit(firebaseAuthRepository);
        },
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, pure] '
        'when logInWithGoogle is cancelled',
        build: () {
          when(() => firebaseAuthRepository.logInWithGoogle()).thenThrow(
            NoSuchMethodError.withInvocation(
              null,
              Invocation.getter(#logInWithGoogle),
            ),
          );
          return LoginCubit(firebaseAuthRepository);
        },
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.pure)
        ],
      );
    });
  });
}
