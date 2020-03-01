import 'package:flutter/material.dart';
import 'package:flutter_devfest/agenda/session_list.dart';
import 'package:flutter_devfest/home/index.dart';
import 'package:flutter_devfest/home/session.dart';

class Track extends StatelessWidget {
  final List<Session> sessions;

  const Track({Key key, this.sessions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SessionList(
      allSessions: sessions,
    );
  }
}
