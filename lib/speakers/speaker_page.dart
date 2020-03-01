import 'dart:math';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/agenda/session_detail.dart';
import 'package:flutter_devfest/home/session.dart';
import 'package:flutter_devfest/home/speaker.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';
import 'package:flutter_devfest/utils/tools.dart';
import 'package:flutter_devfest/utils/widgets/SocialActionsWidget.dart';

class SpeakerPage extends StatelessWidget {
  static const String routeName = "/speakers";

  Stream<List<QuerySnapshot>> getData() {
    Stream session = Firestore.instance.collection('sessions').snapshots();
    Stream speakers = Firestore.instance.collection('speakers').snapshots();
    return StreamZip([session, speakers]);
  }

  Session getSessionForSpeaker(
      BuildContext context, List<DocumentSnapshot> sessions, Speaker speaker) {
    for (var sessionData in sessions) {
      for (var speakerData in sessionData["speakers"]) {
        if (speakerData == speaker.speakerId) {
          Session session = Session.fromDocumentSnapshot(
              sessionData,
              AppLocalizations.of(context).getLanguagesCode(),
              "",
              "",
              [speaker],
              "track",
              Colors.white);
          return session;
        }
      }
    }
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
            List<QuerySnapshot> querySnapshotData = snapshots.data.toList();
            List<DocumentSnapshot> sessions = querySnapshotData[0].documents;
            List<DocumentSnapshot> speakers = querySnapshotData[1].documents;
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (c, i) {
                var language = AppLocalizations.of(context).getLanguagesCode();
                Speaker speaker =
                    Speaker.fromDocumentSnapshot(speakers[i], language);
                Session session =
                    getSessionForSpeaker(context, sessions, speaker);
                return buildCardItem(c, speaker, session);
              },
              itemCount: speakers.length,
            );
          }),
      title: AppLocalizations.of(context).translate("speakers"),
    );
  }

  Widget buildCardItem(BuildContext context, Speaker speaker, Session session) {
    return Card(
      elevation: 0.0,
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionDetail(
                  session: session,
                ),
              ),
            );
          },
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
                    imageUrl: speaker.image,
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
                            speaker.name,
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
                        speaker.title,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        speaker.shortBio,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SocialActions(speaker.socials),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
