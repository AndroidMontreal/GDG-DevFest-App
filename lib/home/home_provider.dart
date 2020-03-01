import 'package:flutter_devfest/home/session.dart';
import 'package:flutter_devfest/home/speaker.dart';
import 'package:flutter_devfest/home/team.dart';
import 'package:flutter_devfest/network/i_client.dart';
import 'package:flutter_devfest/utils/dependency_injection.dart';
import 'package:flutter_devfest/utils/Config.dart';

abstract class IHomeProvider {
}

class HomeProvider implements IHomeProvider {
  IClient _client;

  static final String kConstGetSpeakersUrl =
      "${Config.baseUrl}/speaker-kol.json";



  //! Not Working
  static final String kConstGetTeamsUrl = "${Config.baseUrl}/team-kol.json";

  HomeProvider() {
    _client = Injector().currentClient;
  }


}
