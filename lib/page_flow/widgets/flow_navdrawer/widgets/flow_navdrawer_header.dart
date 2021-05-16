import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/flow_navdrawer_header_cubit.dart';

class FlowNavdrawerHeader extends StatelessWidget {
  const FlowNavdrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowNavdrawerHeaderCubit, FlowNavdrawerHeaderState>(
      builder: (context, state) {
        return DrawerHeader(child: Text(state.name));
      },
    );
  }
}
