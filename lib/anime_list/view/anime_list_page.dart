import 'package:anime_sorcerer/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist_api/myanimelist_api.dart' as mal_api;
import 'package:myanimelist_repository/myanimelist_repository.dart';

import '../anime_list.dart';

class AnimeListPage extends StatelessWidget {
  const AnimeListPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: AnimeListPage());

  @override
  Widget build(BuildContext context) {
    return const AnimeListView();
  }
}

class AnimeListView extends StatelessWidget {
  const AnimeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _myAnimeListRepository =
        RepositoryProvider.of<MyAnimeListRepository>(context);
    return BlocProvider<AnimeListBloc>(
      create: (context) =>
          AnimeListBloc(myAnimeListRepository: _myAnimeListRepository),
      child: BlocBuilder<AnimeListBloc, AnimeListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Anime List'),
            ),
            drawer: const FlowNavdrawer(),
            body: const AnimeListWidget(),
          );
        },
        buildWhen: (previous, current) => previous != current,
      ),
    );
  }
}
