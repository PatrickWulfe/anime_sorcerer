import 'package:anime_sorcerer/anime_list/anime_list.dart';
import 'package:anime_sorcerer/home/home.dart';
import 'package:anime_sorcerer/login/view/login_page.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';

import 'page_flow.dart';

export 'cubit/page_flow_cubit.dart';
export 'widgets/widgets.dart';

List<Page> onGenerateAppPages(String page, List<Page> pages) {
  switch (page) {
    case '/login':
      return [HomePage.page(), LoginPage.page()];
    case '/animelist':
      return [AnimeListPage.page()];
    case '/':
      b
      return [HomePage.page()];
    default:
      return [const MaterialPage(child: Text('oops'))];
  }
}

class PageFlow extends StatelessWidget {
  const PageFlow({Key? key, required this.myAnimeListRepository})
      : super(key: key);

  final MyAnimeListRepository myAnimeListRepository;

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
