import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_devfest/home/speaker.dart';

class SessionsData {
  List<Session> sessions;

  SessionsData({this.sessions});
}

class Session {
  String sessionId;
  String sessionTitle;
  String sessionDesc;
  String sessionImage;
  String sessionStartTime;
  String sessionTotalTime;
  List<Speaker> speakers;
  String language;
  String track;
  Color backgroundColor;

  Session({
    this.sessionId,
    this.sessionTitle,
    this.sessionDesc,
    this.sessionImage,
    this.sessionStartTime,
    this.sessionTotalTime,
    this.speakers,
    this.track,
  });

  String getSpeakersNames() {
    String names = "";
    for (int i = 0; i < speakers.length; i++) {
      names += speakers[i].name;
      if (i < speakers.length - 1) {
        names += " & ";
      }
    }
    return names;
  }

  Session.fromDocumentSnapshot(
      DocumentSnapshot sessionSnapShot,
      String lang,
      String startTime,
      String totalTime,
      List<Speaker> speakers,
      String track,
      Color backgroundColor) {
    sessionId = sessionSnapShot.documentID;
    sessionTitle = sessionSnapShot[lang]["title"];
    sessionDesc = sessionSnapShot[lang]["description"];
    language = sessionSnapShot[lang]["language"];
    sessionStartTime = startTime;
    sessionTotalTime = totalTime;
    this.speakers = speakers;
    this.track = track;
    this.backgroundColor = backgroundColor;
  }
}
