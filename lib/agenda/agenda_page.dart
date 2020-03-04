import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/agenda/track.dart';
import 'package:flutter_devfest/home/session.dart';
import 'package:flutter_devfest/home/speaker.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';
import 'package:flutter_devfest/utils/tools.dart';

class AgendaPage extends StatelessWidget {
  static const String routeName = "/agenda";

  Stream<List<QuerySnapshot>> getData() {
    Stream schedule = Firestore.instance.collection('schedule').snapshots();
    Stream session = Firestore.instance.collection('sessions').snapshots();
    Stream speakers = Firestore.instance.collection('speakers').snapshots();
    return StreamZip([schedule, session, speakers]);
  }

  DocumentSnapshot getSessionForId(List<DocumentSnapshot> sessions, String id) {
    for (var documentSnapshot in sessions) {
      if (documentSnapshot.documentID == id) {
        return documentSnapshot;
      }
    }
  }

  DocumentSnapshot getSpeakerForKey(
      List<DocumentSnapshot> speakers, String id) {
    for (var documentSnapshot in speakers) {
      if (documentSnapshot.documentID == id) {
        return documentSnapshot;
      }
    }
  }

  String getStartSessionTime(
      String startTime, String endTime, int sessionIndex, int numberOfSession) {
    if (sessionIndex == 0) {
      return startTime;
    }
    var startDateTime = DateTime.parse("2025-03-20 " + startTime + ":00Z");
    var endDateTime = DateTime.parse("2025-03-20 " + endTime + ":00Z");

    var duration = endDateTime.difference(startDateTime).inMilliseconds;
    var sessionDuration =
        new Duration(milliseconds: (duration ~/ numberOfSession).toInt());

    for (var i = 0; i < sessionIndex; i++) {
      startDateTime = startDateTime.add(sessionDuration);
    }

    String minute = startDateTime.minute < 10
        ? "0" + startDateTime.minute.toString()
        : startDateTime.minute.toString();

    String startDateToShow = startDateTime.hour.toString() + ":" + minute;
    return startDateToShow;
  }

  String getDurations(String startTime, String endTime) {
    var startDateTime = DateTime.parse("2025-03-20 " + startTime + ":00Z");
    var endDateTime = DateTime.parse("2025-03-20 " + endTime + ":00Z");

    var duration = endDateTime.difference(startDateTime);

    if (duration.inHours > 0) {
      var minutes = duration.inMinutes - duration.inHours * 60;
      var minutesString =
          minutes < 10 ? "0" + minutes.toString() : minutes.toString();
      return duration.inHours.toString() + "h" + minutesString;
    } else {
      return duration.inMinutes.toString() + "min";
    }
  }

  Map<int, List<Session>> getSessions(
      BuildContext context,
      DocumentSnapshot schedule,
      List<DocumentSnapshot> sessions,
      List<DocumentSnapshot> speakers) {
    var timeslots = schedule.data["timeslots"];
    var tracks = schedule.data["tracks"];
    var rooms = schedule.data["room"];
    var langCode = AppLocalizations.of(context).getLanguagesCode();

    var trackMap = new Map<int, List<Session>>();
    for (var timeslot in timeslots) {
      var startTime = timeslot["startTime"];
      var endTime = timeslot["endTime"];
      int i = 0;
      for (var trackSession in timeslot["sessions"]) {
        var listSession = trackMap[i];
        if (trackMap[i] == null) {
          listSession = new List<Session>();
        }

        int j = 0;
        for (var sessionElement in trackSession["items"]) {
          var startSession = getStartSessionTime(
              startTime, endTime, j, trackSession["items"].length);
          var duration = getDurations(startSession, endTime);

          DocumentSnapshot sessionData =
              getSessionForId(sessions, sessionElement.toString());
          List<Speaker> speakersList = new List<Speaker>();

          for (var speakerKey in sessionData["speakers"]) {
            DocumentSnapshot speakerData =
                getSessionForId(speakers, speakerKey);
            Speaker speaker =
                Speaker.fromDocumentSnapshot(speakerData, langCode);
            speakersList.add(speaker);
          }
          int roomId = sessionData["roomId"];

          Color backgroundColor = Colors.white;
          if (roomId != 1 && roomId != 2) {
            backgroundColor = Tools.wtmBlueLight;
          } else if (speakersList.length == 0) {
            backgroundColor = Tools.wtmGreen;
          }

          String track = rooms[AppLocalizations.of(context).getLanguagesCode()]
              [sessionData["roomId"]]["title"];
          Session session = Session.fromDocumentSnapshot(sessionData, langCode,
              startSession, duration, speakersList, track, backgroundColor);
          //Add general item in all track ( like break, Lunch etc
          if (sessionData["speakers"].length == 0 && sessionElement >= 300) {
            for (int k = 1; k < tracks.length; k++) {
              addSessionToMapTrack(trackMap, k, session);
            }
          }
          j++;
          listSession.add(session);
        }
        trackMap[i] = listSession;
        i++;
      }
    }
    return trackMap;
  }

  void addSessionToMapTrack(
      Map<int, List<Session>> trackMap, int index, Session session) {
    var listPerTrack = trackMap[index];
    if (listPerTrack == null) {
      listPerTrack = new List<Session>();
    }
    listPerTrack.add(session);
    trackMap[index] = listPerTrack;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getData(),
        builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshots) {
          if (!snapshots.hasData)
            return DevScaffold (
                title: AppLocalizations.of(context).translate("schedule"),
                body: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child:
                  Text(AppLocalizations.of(context).translate("loading"))));
          List<QuerySnapshot> querySnapshotData = snapshots.data.toList();

          DocumentSnapshot schedule = querySnapshotData[0].documents[0];
          List<DocumentSnapshot> sessions = querySnapshotData[1].documents;
          List<DocumentSnapshot> speakers = querySnapshotData[2].documents;
          var tracks = schedule.data["tracks"];
          var trackMap = getSessions(context, schedule, sessions, speakers);
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
                      for (var i = 0; i < tracks.length; i++)
                        Track(
                          sessions: trackMap[i],
                        ),
                    ],
                  )));
        });
  }
}
