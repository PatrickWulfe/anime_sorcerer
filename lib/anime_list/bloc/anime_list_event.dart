part of 'anime_list_bloc.dart';

abstract class AnimeListEvent extends Equatable {
  const AnimeListEvent();

  @override
  List<Object> get props => [];
}

class PageLoadRequested extends AnimeListEvent {
  const PageLoadRequested({required this.page});

  final int page;
}

class PageLoadSuccess extends AnimeListEvent {
  const PageLoadSuccess({required this.animeList});
  final List<mal_api.AnimeList> animeList;
}
