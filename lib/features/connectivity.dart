import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:settle_assessment/utils/constant.dart';
import 'package:wifi/wifi.dart';
import 'package:connectivity/connectivity.dart';

class SignalActivity {
  final bool connectAny;
  final String wifi;

  SignalActivity({@required this.wifi}) : this.connectAny = wifi == null;
  
  Future<bool> connectToAny() async {
    try {
      final String ssid = await Wifi.ssid;

      if (ssid == null) return false;
      if (ssid.length == 0) return false;
    } catch (err) {
      return Future.error(false);
    }

    return true;
  }

  Future<bool> connectedTo() async {
    if (wifi == null) return false;
    else
      try {
        final String ssid = await Wifi.ssid;

        if (ssid == null) return false;
        if (ssid.length == 0) return false;
        if (ssid.toLowerCase() != wifi.toLowerCase()) return false;
      } catch (err) {
        return Future.error(false);
      }

    return true;
  }

  Future<ConnectionStatus> getStrength() async {

    if (connectAny || await connectedTo()) {
      final int strength = await Wifi.level;

      if (strength == 1)
        return ConnectionStatus.poor;
      else if (strength == 2)
        return ConnectionStatus.good;
      else if (strength == 3) return ConnectionStatus.great;
    }


    return ConnectionStatus.disconnected;
  }

  Future<String> get wifiName => Wifi.ssid;

  Stream<ConnectionStatus> get listenConnection =>
      Connectivity()
      .onConnectivityChanged.transform(
            StreamTransformer<ConnectivityResult, ConnectionStatus>.fromHandlers(
              handleData: (value, sink) async =>
                  sink.add(value == ConnectivityResult.wifi ? await getStrength() : ConnectionStatus.disconnected),
            ),
          );
}
