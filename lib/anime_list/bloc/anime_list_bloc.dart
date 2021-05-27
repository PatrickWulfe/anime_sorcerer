import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';
import '../anime_list.dart';

part 'anime_list_event.dart';
part 'anime_list_state.dart';

class AnimeListBloc extends Bloc<AnimeListEvent, AnimeListState> {
  AnimeListBloc({required this.myAnimeListRepository})
      : super(const AnimeListPageLoading(page: 0));

  final MyAnimeListRepository myAnimeListRepository;

  @override
  Stream<AnimeListState> mapEventToState(
    AnimeListEvent event,
  ) async* {
    if (event is PageLoadRequested) {
      yield AnimeListPageLoading(page: event.page);
      var animeList = await myAnimeListRepository.getAnimeListings();
      if (animeList.isNotEmpty) {
        add(PageLoadSuccess(animeList: animeList));
      }
    } else if (event is PageLoadSuccess) {
      yield (AnimeListPageLoaded(animeList: event.animeList));
    }
  }
}
