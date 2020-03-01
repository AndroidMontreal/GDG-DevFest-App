import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsData {
  List<Team> teams;

  TeamsData({this.teams});
}

class Team {
  String name;
  String title;
  String photoUrl;
  var socials;

  Team({this.name, this.title, this.photoUrl, this.socials});

  Team.fromDocumentSnapshot(DocumentSnapshot snapshot, String lang) {
    name = snapshot["name"];
    photoUrl = snapshot["photoUrl"];
    title = snapshot["title"][lang];
    socials = snapshot["socials"];
  }
}