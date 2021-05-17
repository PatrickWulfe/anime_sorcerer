import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';

class FlowNavdrawerHeader extends StatelessWidget {
  const FlowNavdrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myAnimeListRepository =
        RepositoryProvider.of<MyAnimeListRepository>(context);
    return DrawerHeader(child: Text(myAnimeListRepository.currentUser.i));
  }
}
