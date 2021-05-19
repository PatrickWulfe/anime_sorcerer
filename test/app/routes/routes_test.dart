import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mumen_finder/app/app.dart';
import 'package:mumen_finder/home/home.dart';
import 'package:mumen_finder/login/login.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<HomePage>())],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<LoginPage>())],
      );
    });
  });
}
