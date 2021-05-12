import 'package:anime_sorcerer/home/home.dart';
import 'package:anime_sorcerer/login/login.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'page_flow.dart';

export 'cubit/page_flow_cubit.dart';

List<Page> onGenerateAppPages(String page, List<Page> pages) {
  if (page == '/') {
    return [
      HomePage.page(),
    ];
  }
  return [
    LoginPage.page(),
  ];
}

class PageFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageFlowCubit(),
      child: BlocBuilder<PageFlowCubit, String>(
        builder: (context, state) {
          return FlowBuilder<String>(
            state: state,
            onGeneratePages: onGenerateAppPages,
          );
        },
      ),
    );
  }
}
