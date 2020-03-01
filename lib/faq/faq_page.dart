import 'package:flutter/material.dart';
import 'package:flutter_devfest/universal/dev_scaffold.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = "/faq";

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      body: Container(
        child: Center(
          child: Text("Coming Soon"),
        ),
      ),
      title: "FAQ",
    );
  }
}
