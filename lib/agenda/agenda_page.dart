import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/agenda/track.dart';
import 'package:flutter_devfest/home/index.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';
import 'package:flutter_devfest/utils/tools.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgendaPage extends StatelessWidget {
  static const String routeName = "/agenda";

  @override
  Widget build(BuildContext context) {
    var _homeBloc = HomeBloc();
    return StreamBuilder(
        stream: Firestore.instance.collection("schedule").snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData)
            return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(AppLocalizations.of(context).translate("loading")));
          var tracks = snapshots.data.documents[0].data["tracks"];
          var timeslots = snapshots.data.documents[0].data["timeslots"];
          return DefaultTabController(
              length: tracks.length,
              child: DevScaffold(
                  title: AppLocalizations.of(context).translate("schedule"),
                  tabBar: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Tools.wtmBlueColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                    ),
                    isScrollable: false,
                    tabs: <Widget>[
                      for (var track in tracks)
                        Tab(
                          child: Text(track["title"]),
                        ),
                    ],
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      for (var i=0; i< tracks.length; i++)
                        Track(
                          homeBloc: _homeBloc,
                          timeslots: timeslots,
                          trackIndex: i,
                        ),
                    ],
                  )));
        });
  }
}
