import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/home/session.dart';
import 'package:flutter_devfest/home/speaker.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';
import 'package:flutter_devfest/utils/tools.dart';
import 'package:flutter_devfest/utils/widgets/SocialActionsWidget.dart';

class SessionDetail extends StatelessWidget {
  static const String routeName = "/session_detail";
  final Session session;

  SessionDetail({Key key, @required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var _homeBloc = HomeBloc();
    return DevScaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Hero(
                      tag: session.sessionId,
                      child: getSpeakersAvatar(context, session.speakers)),
                ),
                SizedBox(
                  height: 10,
                ),

                Text(
                  "${session.sessionTitle}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  session.sessionDesc,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                for (Speaker speaker in session.speakers)
                  bioSectionForSpeaker(context, speaker)


              ],
            ),
          ),
        ),
        title: session.getSpeakersNames());
  }

  Widget bioSectionForSpeaker(BuildContext context, Speaker speaker) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          speaker.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "${speaker.title}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title.copyWith(
            fontSize: 14,
            color: Tools.wtmBlueColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          speaker.bio,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          speaker.country + " / " + speaker.company,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
        ),
        SizedBox(
          height: 20,
        ),
        SocialActions(speaker.socials),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget getSpeakersAvatar(BuildContext context, List<Speaker> speakers) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          for (var speaker in speakers)
            CircleAvatar(
              radius: 100,
              backgroundImage: CachedNetworkImageProvider(speaker.image),
            )
        ],
      ),
    );
  }
}
