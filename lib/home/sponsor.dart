import 'package:cloud_firestore/cloud_firestore.dart';

class Sponsor {
  String name;
  String logoUrl;
  String url;

  Sponsor({this.name, this.logoUrl, this.url});

  Sponsor.fromDocumentSnapshot(DocumentSnapshot documentSnapshot, String lang) {
    name = documentSnapshot["name"];
    logoUrl = documentSnapshot["logoUrl"];
    url = documentSnapshot["url"][lang];
  }

  bool isImageSvg() {
    return logoUrl.contains(".svg");
  }
}
