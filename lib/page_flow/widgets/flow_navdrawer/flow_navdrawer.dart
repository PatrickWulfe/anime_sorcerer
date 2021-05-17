import 'package:anime_sorcerer/app/app.dart';
import 'package:anime_sorcerer/page_flow/widgets/flow_navdrawer/widgets/cubit/flow_navdrawer_header_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';

import 'widgets/wigets.dart';

class FlowNavdrawer extends StatelessWidget {
  const FlowNavdrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _myAnimeListRepository =
        RepositoryProvider.of<MyAnimeListRepository>(context);

    return Drawer(
      child: BlocBuilder<PageFlowCubit, String>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: const FlowNavdrawerHeader(),
              ))
            ],
          );
        },
      ),
    );
  }
}
