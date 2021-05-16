import 'package:myanimelist_api/myanimelist_api.dart' as mal_api;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../anime_list.dart';

class AnimeListWidget extends StatelessWidget {
  const AnimeListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listBloc = BlocProvider.of<AnimeListBloc>(context)
      ..add(const PageLoadRequested(page: 0));
    return BlocProvider.value(
      value: listBloc,
      child: BlocBuilder<AnimeListBloc, AnimeListState>(
        builder: (context, state) {
          if (state is AnimeListPageLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: _buildListItem,
              itemCount: state.animeList.length,
            );
          } else if (state is AnimeListPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Placeholder();
          }
        },
      ),
    );
  }

  Widget _buildListItem(context, index) {
    var listBloc = BlocProvider.of<AnimeListBloc>(context);
    mal_api.AnimeList listItem;
    if (listBloc.state is AnimeListPageLoaded) {
      listItem = (listBloc.state as AnimeListPageLoaded).animeList[index];
      return Card(
        child: GridTile(
          child: Column(
            children: [
              Expanded(
                  child: Image.network(listItem.node!.mainPicture!.medium!)),
              Text(listItem.node!.title!)
            ],
          ),
        ),
      );
    }
    return const Placeholder();
  }
}
