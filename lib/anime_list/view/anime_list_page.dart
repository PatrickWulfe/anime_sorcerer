import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../anime_list.dart';

class AnimeListPage extends StatelessWidget {
  const AnimeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimeListView();
  }
}

class AnimeListView extends StatelessWidget {
  const AnimeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(context, index) {
    var listItem =
        (BlocProvider.of<AnimeListBloc>(context).state as AnimeListPopulated)
            .animeList[index];
    return Card(
      child: GridTile(
        child: Column(
          children: [Image.network(listItem.imgUrl), Text(listItem.name)],
        ),
      ),
    );
  }
}
