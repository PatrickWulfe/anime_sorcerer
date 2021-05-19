// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumen_finder/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

void main() {
  group('SignUpPage', () {
    test('has a route', () {
      expect(SignUpPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<FirebaseAuthRepository>(
          create: (_) => MockFirebaseAuthRepository(),
          child: MaterialApp(home: SignUpPage()),
        ),
      );
      expect(find.byType(SignUpForm), findsOneWidget);
    });
  });
}
