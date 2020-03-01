import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devfest/agenda/session_detail.dart';
import 'package:flutter_devfest/home/session.dart';
import 'package:flutter_devfest/home/speaker.dart';
import 'package:flutter_devfest/utils/tools.dart';

class SessionList extends StatelessWidget {
  final List<Session> allSessions;

  const SessionList({Key key, @required this.allSessions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: allSessions.length,
      itemBuilder: (c, i) {
        if (allSessions[i].speakers.length > 0) {
          return sessionWidget(c, allSessions[i]);
        } else {
          return sessionGeneralWidget(c, allSessions[i]);
        }
      },
    );
  }

  Widget sessionGeneralWidget(BuildContext context, Session session) {
    return Card(
      elevation: 0.0,
      color: session.backgroundColor,
      child: ListTile(
        isThreeLine: false,
        trailing: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${session.sessionTotalTime}\n",
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: session.sessionStartTime,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: "${session.sessionTitle}\n",
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
            children: [
              TextSpan(
                text: session.track,
                style:
                Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sessionWidget(BuildContext context, Session session) {
    return Card(
      elevation: 0.0,
      child: ListTile(
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
        // dense: true,
        isThreeLine: true,
        trailing: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${session.sessionTotalTime}\n",
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: session.sessionStartTime,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
        leading:  Hero(
            tag: session.sessionId,
            child: getSpeakersAvatar(context, session.speakers),
          ),
        title: RichText(
          text: TextSpan(
            text: "${session.sessionTitle}\n",
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
            children: [
              TextSpan(
                text: session.getSpeakersNames(),
                style:
                    Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        subtitle: Text(
          session.language,
          style: Theme.of(context).textTheme.caption.copyWith(
                fontSize: 12.0,
                color: Tools.getColorForLanguage(session.language),
              ),
        ),
      ),
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
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(speaker.image),
            )
        ],
      ),
    );
  }
}
