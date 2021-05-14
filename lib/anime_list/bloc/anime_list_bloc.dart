import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../anime_list.dart';

part 'anime_list_event.dart';
part 'anime_list_state.dart';

class AnimeListBloc extends Bloc<AnimeListEvent, AnimeListState> {
  AnimeListBloc({required this.accessToken}) : super(AnimeListInitial()) {}

  final String accessToken;

  @override
  Stream<AnimeListState> mapEventToState(
    AnimeListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
