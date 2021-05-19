// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mumen_finder/app/app.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppEvent', () {
    group('AppUserChanged', () {
      final user = MockUser();
      test('supports value comparisons', () {
        expect(
          AppUserChanged(user),
          AppUserChanged(user),
        );
      });
    });

    group('AppLogoutRequested', () {
      test('supports value comparisons', () {
        expect(
          AppLogoutRequested(),
          AppLogoutRequested(),
        );
      });
    });
  });
}
