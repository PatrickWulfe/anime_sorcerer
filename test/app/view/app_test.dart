import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mumen_finder/app/app.dart';
import 'package:mumen_finder/home/home.dart';
import 'package:mumen_finder/login/login.dart';

class MockUser extends Mock implements User {}

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  group('App', () {
    late FirebaseAuthRepository firebaseAuthRepository;
    late User user;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
    });

    setUp(() {
      firebaseAuthRepository = MockFirebaseAuthRepository();
      user = MockUser();
      when(() => firebaseAuthRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => firebaseAuthRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(firebaseAuthRepository: firebaseAuthRepository),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late FirebaseAuthRepository firebaseAuthRepository;
    late AppBloc appBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
    });

    setUp(() {
      firebaseAuthRepository = MockFirebaseAuthRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: firebaseAuthRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: firebaseAuthRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
