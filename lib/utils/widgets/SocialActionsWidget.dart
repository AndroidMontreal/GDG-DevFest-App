import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialActions extends StatelessWidget {

  SocialActions(this.socials);
  final socials;

  IconData getSocialIcon(String iconName) {
    switch (iconName) {
      case "linkedin":
        return FontAwesomeIcons.linkedinIn;
      case "twitter":
        return FontAwesomeIcons.twitter;
      case "facebook":
        return FontAwesomeIcons.facebook;
      case "instagram":
        return FontAwesomeIcons.instagram;
      default:
        return FontAwesomeIcons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (var social in socials)
            IconButton(
              icon: Icon(
                getSocialIcon(social["icon"]),
                size: 15,
              ),
              onPressed: () {
                launch(social["link"]);
              },
            ),
        ],
      ),
    );
  }
}
