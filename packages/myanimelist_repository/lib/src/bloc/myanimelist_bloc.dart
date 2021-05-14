import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'myanimelist_event.dart';
part 'myanimelist_state.dart';

class MyanimelistBloc extends Bloc<MyanimelistEvent, MyanimelistState> {
  MyanimelistBloc() : super(MyanimelistInitial());

  @override
  Stream<MyanimelistState> mapEventToState(
    MyanimelistEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
