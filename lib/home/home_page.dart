import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/home/index.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    var _homeBloc = HomeBloc();

    return DevScaffold(
      body: HomeScreen(homeBloc: _homeBloc),
      title: AppLocalizations.of(context).translate("homeTitle"),
    );
  }
}
