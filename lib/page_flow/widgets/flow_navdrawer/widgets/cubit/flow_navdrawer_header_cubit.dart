import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';

part 'flow_navdrawer_header_state.dart';

class FlowNavdrawerHeaderCubit extends Cubit<FlowNavdrawerHeaderState> {
  FlowNavdrawerHeaderCubit({required this.myAnimeListRepository})
      : super(const FlowNavdrawerHeaderState(name: 'username'));

  final MyAnimeListRepository myAnimeListRepository;

  void updateUser() async {
    var user = await myAnimeListRepository.apiClient.getUserInfo();
    emit(FlowNavdrawerHeaderState(name: user.name!));
  }
}
