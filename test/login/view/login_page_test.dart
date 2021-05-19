import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumen_finder/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

void main() {
  group('LoginPage', () {
    test('has a page', () {
      expect(LoginPage.page(), isA<MaterialPage>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<FirebaseAuthRepository>(
          create: (_) => MockFirebaseAuthRepository(),
          child: const MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
