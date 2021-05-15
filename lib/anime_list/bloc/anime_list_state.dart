part of 'anime_list_bloc.dart';

abstract class AnimeListState extends Equatable {
  const AnimeListState();

  @override
  List<Object> get props => [];
}

class AnimeListInitial extends AnimeListState {}

class AnimeListPopulated extends AnimeListState {
  const AnimeListPopulated({required this.animeList});

  final List<AnimeListing> animeList;
}
