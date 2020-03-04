import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/agenda/agenda_page.dart';
import 'package:flutter_devfest/config/index.dart';
import 'package:flutter_devfest/faq/faq_page.dart';
import 'package:flutter_devfest/map/map_page.dart';
import 'package:flutter_devfest/speakers/speaker_page.dart';
import 'package:flutter_devfest/sponsors/sponsor_page.dart';
import 'package:flutter_devfest/team/team_page.dart';
import 'package:flutter_devfest/utils/Config.dart';
import 'package:flutter_devfest/utils/tools.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeFront extends StatelessWidget {
  List<Widget> devFestTexts(context) => [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            AppLocalizations.of(context).translate("title"),
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Text(
            AppLocalizations.of(context).translate("homeDescription"),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
      ];

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget actions(context) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        children: <Widget>[
          RaisedButton(
            child: Text(AppLocalizations.of(context).translate("schedule")),
            shape: StadiumBorder(),
            color: Tools.wtmBlueColor,
            colorBrightness: Brightness.dark,
            onPressed: () => Navigator.pushNamed(context, AgendaPage.routeName),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).translate("speakers")),
            shape: StadiumBorder(),
            color: Tools.wtmGreen,
            colorBrightness: Brightness.dark,
            onPressed: () =>
                Navigator.pushNamed(context, SpeakerPage.routeName),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).translate("sponsors")),
            shape: StadiumBorder(),
            color: Tools.wtmBlueLight,
            colorBrightness: Brightness.dark,
            onPressed: () =>
                Navigator.pushNamed(context, SponsorPage.routeName),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).translate("team")),
            shape: StadiumBorder(),
            color: Tools.wtmGreenLight,
            colorBrightness: Brightness.dark,
            onPressed: () => Navigator.pushNamed(context, TeamPage.routeName),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).translate("faq")),
            shape: StadiumBorder(),
            color: Tools.wtmBlueColor,
            colorBrightness: Brightness.dark,
            onPressed: () => Navigator.pushNamed(context, FaqPage.routeName),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).translate("locateUs")),
            shape: StadiumBorder(),
            color: Tools.wtmGreen,
            colorBrightness: Brightness.dark,
            onPressed: () => Navigator.pushNamed(context, MapPage.routeName),
          ),
        ],
      );

  Widget newActions(context) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 20.0,
        runSpacing: 20.0,
        children: <Widget>[
          ActionCard(
            icon: Icons.schedule,
            color: Tools.wtmBlueColor,
            title: AppLocalizations.of(context).translate("schedule"),
            onPressed: () => Navigator.pushNamed(context, AgendaPage.routeName),
          ),
          ActionCard(
            icon: Icons.person,
            color: Tools.wtmGreen,
            title: AppLocalizations.of(context).translate("speakers"),
            onPressed: () =>
                Navigator.pushNamed(context, SpeakerPage.routeName),
          ),
          ActionCard(
            icon: Icons.people,
            color: Tools.wtmBlueLight,
            title: AppLocalizations.of(context).translate("team"),
            onPressed: () => Navigator.pushNamed(context, TeamPage.routeName),
          ),
          ActionCard(
            icon: FontAwesomeIcons.solidHandshake,
            color: Tools.wtmGreenLight,
            title: AppLocalizations.of(context).translate("sponsors"),
            onPressed: () =>
                Navigator.pushNamed(context, SponsorPage.routeName),
          ),
          ActionCard(
            icon: Icons.question_answer,
            color: Tools.wtmBlueColor,
            title: AppLocalizations.of(context).translate("faq"),
            onPressed: () => Navigator.pushNamed(context, FaqPage.routeName),
          ),
          ActionCard(
            icon: Icons.map,
            color: Tools.wtmGreen,
            title: AppLocalizations.of(context).translate("locateUs"),
            onPressed: () => Navigator.pushNamed(context, MapPage.routeName),
          )
        ],
      );

  Widget socialActions(context) => FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.facebookF),
                onPressed: () async {
                  await _launchURL(Config.facebookUrl);
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.twitter),
                onPressed: () async {
                  await _launchURL(Config.twitterUrl);
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.linkedinIn),
                onPressed: () async {
                  _launchURL(Config.linkedinUrl);
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.youtube),
                onPressed: () async {
                  await _launchURL(Config.youtubeUrl);
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.meetup),
                onPressed: () async {
                  await _launchURL(Config.meetupUrl);
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.envelope),
                onPressed: () async {
                  var emailUrl = "mailto:" +
                      Config.email +
                      "?subject=" +
                      AppLocalizations.of(context).translate("emailSubject");
                  var out = Uri.encodeFull(emailUrl);
                  await _launchURL(out);
                },
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
              image: AssetImage(ConfigBloc().darkModeOn
                  ? Config.banner_dark
                  : Config.banner_light),
            ),
        
          SizedBox(
            height: 20,
          ),
          ...devFestTexts(context),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: newActions(context),
          ),
          SizedBox(
            height: 20,
          ),
          socialActions(context),
          SizedBox(
            height: 20,
          ),
          Text(
            Config.app_version,
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
          )
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String title;
  final Color color;

  const ActionCard({Key key, this.onPressed, this.icon, this.title, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
        child: Ink(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
            color: ConfigBloc().darkModeOn
                ? Tools.hexToColor("#1f2124")
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: !ConfigBloc().darkModeOn
                ? [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: color,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 10,
                    ),
              ),
            ],
          ),
      ),
    );
  }
}
