import 'package:flutter/material.dart';
import 'package:flutter_devfest/Localization/AppLocalizations.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = "/faq";

  @override
  Widget build(BuildContext context) {
    var faqData = AppLocalizations.of(context).translate("faqMenQuestions");
    return DevScaffold(
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        buildQuestion(context, AppLocalizations.of(context).translate("faqMenQuestion")),
        buildResponse(context, AppLocalizations.of(context).translate("faqMenAnswer")),
        buildQuestion(context, AppLocalizations.of(context).translate("faqAgeQuestion")),
        buildResponse(context, AppLocalizations.of(context).translate("faqAgeAnswer")),
        buildQuestion(context, AppLocalizations.of(context).translate("faqTransportQuestion")),
        buildResponse(context, AppLocalizations.of(context).translate("faqTransportAnswer")),
        buildQuestion(context, AppLocalizations.of(context).translate("faqQuestion")),
        buildResponse(context, AppLocalizations.of(context).translate("faqAnswer")),
        buildQuestion(context, AppLocalizations.of(context).translate("faqRefundQuestion")),
        buildResponse(context, AppLocalizations.of(context).translate("faqRefundAnswer")),
      ]),
      title: AppLocalizations.of(context).translate("faq"),
    );
  }

  Widget buildQuestion(BuildContext context, String question) {
   return  ListTile(
      isThreeLine: false,
      title: Text(
        question,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
  Widget buildResponse(BuildContext context, String answer) {
    return ListTile(
      isThreeLine: false,
      title: Text(
        answer,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

}
