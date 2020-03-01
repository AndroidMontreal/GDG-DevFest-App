import 'dart:math';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/home/team.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';
import 'package:flutter_devfest/utils/tools.dart';
import 'package:flutter_devfest/utils/widgets/SocialActionsWidget.dart';

class TeamPage extends StatelessWidget {
  static const String routeName = "/team";

  Stream<List<QuerySnapshot>> getData() {
    Stream streamMemberTeam1 =  Firestore.instance.collection("team").document("0").collection("members").snapshots();
    Stream documents =  Firestore.instance.collection("team").snapshots();
    Stream streamMemberTeam2 =  Firestore.instance.collection("team").document("1").collection("members").snapshots();
    return StreamZip([streamMemberTeam1, streamMemberTeam2, documents]);
  }

  List getTeamsList(BuildContext context, List<QuerySnapshot> querySnapshotData) {
    List<DocumentSnapshot> documents = querySnapshotData[2].documents;
    List<DocumentSnapshot> team1 = querySnapshotData[0].documents;
    List<DocumentSnapshot> team2 = querySnapshotData[1].documents;
    var lang = AppLocalizations.of(context).getLanguagesCode();

    List list = new List();

    for (var i =0; i < documents.length; i++)  {
      list.add(documents[i]["title"][lang]);
       if (i == 0) {
         for(var team1Data in team1) {
           Team team = Team.fromDocumentSnapshot(team1Data, lang);
           list.add(team);
         }
       } else {
         for(var team2Data in team2) {
           Team team = Team.fromDocumentSnapshot(team2Data, lang);
           list.add(team);
         }
       }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      body: StreamBuilder(
          stream: getData(),
          builder: (context, snapshots) {
            if (!snapshots.hasData)
              return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child:
                      Text(AppLocalizations.of(context).translate("loading")));

            List teamsList = getTeamsList(context,  snapshots.data.toList());
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (c, i) {
                if (teamsList[i] is Team) {
                  return buildCardItem(c, teamsList[i]);
                } else {
                  return buildTitle(c, teamsList[i]);
                }
              },
              itemCount: teamsList.length,
            );
          }),
      title: AppLocalizations.of(context).translate("team"),
    );
  }

  Widget buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );
  }

  Widget buildCardItem(BuildContext context, Team team) {
    return Card(
      elevation: 0.0,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: team.photoUrl,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          team.name,
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 5,
                          color: Tools.multiColors[Random().nextInt(4)],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      team.title,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    SocialActions(team.socials),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
