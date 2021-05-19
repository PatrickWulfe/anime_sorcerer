import 'package:flutter/widgets.dart';
import 'package:mumen_finder/app/app.dart';

import 'package:mumen_finder/home/home.dart';
import 'package:mumen_finder/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
