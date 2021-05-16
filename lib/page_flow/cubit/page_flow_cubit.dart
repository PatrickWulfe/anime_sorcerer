import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class PageFlowCubit extends Cubit<String> {
  PageFlowCubit() : super('/');

  void updateFlow(flow) => emit(flow);
}
