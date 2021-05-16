part of 'anime_list_bloc.dart';

abstract class AnimeListState extends Equatable {
  const AnimeListState();

  @override
  List<Object> get props => [];
}

class AnimeListInitial extends AnimeListState {}

class AnimeListPageLoading extends AnimeListState {
  const AnimeListPageLoading({required this.page});

  final int page;

  @override
  List<Object> get props => [page];
}

class AnimeListPageLoaded extends AnimeListState {
  const AnimeListPageLoaded({required this.animeList});

  final List<mal_api.AnimeList> animeList;

  @override
  List<Object> get props => [animeList];
}

class AnimeListError extends AnimeListState {
  const AnimeListError({required this.errString});

  final String errString;

  @override
  List<Object> get props => [errString];
}
