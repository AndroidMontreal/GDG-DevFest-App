import 'package:cloud_firestore/cloud_firestore.dart';

class SpeakersData {
  List<Speaker> speakers;

  SpeakersData({this.speakers});
}

class Speaker {
  String speakerId;
  String name;
  String title;
  String image;
  String bio;
  String shortBio;
  String company;
  String country;
  var socials;

  Speaker(
      {this.name,
      this.title,
      this.image,
      this.bio,
      this.shortBio,
      this.speakerId,
      this.company,
      this.country,
      this.socials});

  Speaker.fromDocumentSnapshot(DocumentSnapshot snapshot, String lang) {
    speakerId = snapshot.documentID;
    name = snapshot["name"];
    title = snapshot[lang]["title"];
    image = snapshot["photoUrl"];
    bio = snapshot[lang]["bio"];
    shortBio = snapshot[lang]["shortBio"];
    company = snapshot[lang]["company"];
    country = snapshot[lang]["country"];
    socials = snapshot["socials"];
  }
}
