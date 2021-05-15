part of 'myanimelist_bloc.dart';

abstract class MyanimelistState extends Equatable {
  const MyanimelistState();
  
  @override
  List<Object> get props => [];
}

class MyanimelistInitial extends MyanimelistState {}
