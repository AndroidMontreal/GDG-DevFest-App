import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/home/sponsor.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorPage extends StatelessWidget {
  static const String routeName = "/sponsor";

  Stream<List<QuerySnapshot>> getData() {
    Stream sponsors = Firestore.instance.collection("partners").snapshots();
    Stream platinumSponsors = Firestore.instance
        .collection("partners")
        .document("0")
        .collection("items")
        .snapshots();
    Stream goldSponsors = Firestore.instance
        .collection("partners")
        .document("3")
        .collection("items")
        .snapshots();
    Stream silverSponsors = Firestore.instance
        .collection("partners")
        .document("1")
        .collection("items")
        .snapshots();
    Stream bronzeSponsors = Firestore.instance
        .collection("partners")
        .document("2")
        .collection("items")
        .snapshots();

    return StreamZip([
      sponsors,
      platinumSponsors,
      goldSponsors,
      silverSponsors,
      bronzeSponsors
    ]);
  }

  List getSponsorsList(
      BuildContext context, List<QuerySnapshot> querySnapshotData) {
    List<DocumentSnapshot> documents = querySnapshotData[0].documents;
    List<DocumentSnapshot> platinumSponsors = querySnapshotData[1].documents;
    List<DocumentSnapshot> goldSponsors = querySnapshotData[2].documents;
    List<DocumentSnapshot> silverSponsors = querySnapshotData[3].documents;
    List<DocumentSnapshot> bronzeSponsors = querySnapshotData[4].documents;
    var lang = AppLocalizations.of(context).getLanguagesCode();

    List list = new List();
    list.add(documents[0]["title"][lang]);
    addSponsorsToList(list, platinumSponsors, lang);
    list.add(documents[3]["title"][lang]);
    addSponsorsToList(list, goldSponsors, lang);
    list.add(documents[1]["title"][lang]);
    addSponsorsToList(list, silverSponsors, lang);
    list.add(documents[2]["title"][lang]);
    addSponsorsToList(list, bronzeSponsors, lang);

    return list;
  }

  void addSponsorsToList(
      List list, List<DocumentSnapshot> sponsors, String lang) {
    for (var sponsorData in sponsors) {
      Sponsor sponsor = Sponsor.fromDocumentSnapshot(sponsorData, lang);
      list.add(sponsor);
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

            List sponsorsList =
                getSponsorsList(context, snapshots.data.toList());
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (c, i) {
                if (sponsorsList[i] is Sponsor) {
                  return buildSponsorsImage(c, sponsorsList[i]);
                } else {
                  return buildTitle(c, sponsorsList[i]);
                }
              },
              itemCount: sponsorsList.length,
            );
          }),
      title: AppLocalizations.of(context).translate("sponsors"),
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

  Widget buildSponsorsImage(BuildContext context, Sponsor sponsor) {
    return Card(
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {
          launch(sponsor.url);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: imageWidget(context, sponsor),
        ),
      ),
    );
  }

  Widget imageWidget(BuildContext context, Sponsor sponsor) {
    if (sponsor.isImageSvg()) {
      return SvgPicture.network(
        sponsor.logoUrl,
        height: 200.0,
        width: 200.0,
        fit: BoxFit.contain,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: sponsor.logoUrl,
        height: 200.0,
        width: 200.0,
        fit: BoxFit.contain,
      );
    }
  }
}
