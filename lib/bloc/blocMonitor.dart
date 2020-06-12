import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:settle_assessment/features/connectivity.dart';
import 'package:settle_assessment/features/geofence.dart';
import 'package:settle_assessment/utils/constant.dart';

class BlocMonitor {
  final SignalActivity _activity;
  StreamSubscription<ConnectionStatus> connectionListening;
  GeoFenceModule geoModule;
  final int radius;
  final double latitude;
  final double longitude;
  final String wifi;
  Timer timer;

  BlocMonitor(this.latitude, this.longitude, this.radius, this.wifi)
      : this._activity = SignalActivity(wifi: wifi) {
    geoModule = GeoFenceModule(
      radius: radius,
      latitude: latitude,
      longitude: longitude,
      callbackStatus: listenGeo,
      callbackDistance: listenDistance,
    );

    if (wifi != null) _wifiLatestName.add(wifi);

    connectionListening = _activity.listenConnection.listen((event) {
      if (_activity.connectAny == true)
        _activity.wifiName.then((value) => _wifiLatestName
            .add(value == '<unknown ssid>' ? 'no connection' : value));
      _connection.add(event);
    });
    timer = Timer.periodic(Duration(milliseconds: 1500), (value) {
      try {
        _activity.getStrength().then((value) => _connection.add(value));
      } catch (err) {
        print(err);
        value.cancel();
      }
    });
  }

  final _zone = BehaviorSubject<ZoneStatus>.seeded(ZoneStatus.outside);
  final _distance = BehaviorSubject<double>.seeded(0.0);
  final _connection =
      BehaviorSubject<ConnectionStatus>.seeded(ConnectionStatus.disconnected);
  final _wifiLatestName = BehaviorSubject<String>();

  Stream<ZoneStatus> get statZone => _zone.stream;
  Stream<double> get statDistance => _distance.stream;
  Stream<ConnectionStatus> get statConnection => _connection.stream;
  Stream<ZoneStatus> get statCombination =>
      CombineLatestStream([statZone, statConnection], (values) {
        for (final value in values) {
          if (value is ZoneStatus) {
            if (value == ZoneStatus.inside) return value;
          } else if (value is ConnectionStatus) {
            if (value != ConnectionStatus.disconnected)
              return ZoneStatus.inside;
          }
        }

        return ZoneStatus.outside;
      });
  Stream<String> get wifiName => _wifiLatestName.stream;

  void listenGeo(ZoneStatus value) => _zone.add(value);
  void listenDistance(double value) => _distance.add(value);

  Future<void> dispose() async {
    try {
      timer.cancel();
      _zone.close();
      _connection.close();
      _distance.close();
      _wifiLatestName.close();
      connectionListening.cancel();
      geoModule.dispose();
    } catch (err) {
      return Future.error(err);
    }

    return Future.value();
  }
}
