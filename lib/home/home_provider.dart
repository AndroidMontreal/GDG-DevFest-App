import 'package:flutter_devfest/network/i_client.dart';
import 'package:flutter_devfest/utils/dependency_injection.dart';

abstract class IHomeProvider {}

class HomeProvider implements IHomeProvider {
  IClient _client;

  HomeProvider() {
    _client = Injector().currentClient;
  }
}
