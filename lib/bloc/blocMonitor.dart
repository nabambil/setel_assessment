import 'dart:async';

import 'package:flutter_geofence/geofence.dart';
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
    _locationPoint.add(Coordinate(latitude, longitude));
    geoModule = GeoFenceModule(
      radius: radius,
      callbackExit: listenGeoExit,
      callbackEntry: listenGeoEntry,
      latitude: latitude,
      longitude: longitude,
    );

    if(wifi != null) _wifiLatestName.add(wifi);

    connectionListening = _activity.listenConnection.listen((event) {
      if(_activity.connectAny == true) _activity.wifiName.then((value) => _wifiLatestName.add(value));
      _connection.add(event);
      timer = Timer.periodic(Duration(milliseconds: 1500), (_) => _activity.getStrength().then((value) => _connection.add(value)));
    });
    
  }

  final _locationPoint =
      BehaviorSubject<Coordinate>.seeded(Coordinate(0.0, 0.0));
  final _zone = BehaviorSubject<ZoneStatus>.seeded(ZoneStatus.outside);
  final _connection =
      BehaviorSubject<ConnectionStatus>.seeded(ConnectionStatus.disconnected);
  final _wifiLatestName =
      BehaviorSubject<String>();

  Stream<ZoneStatus> get statZone => _zone.stream;
  Stream<ConnectionStatus> get statConnection => _connection.stream;
  Stream<Coordinate> get point => _locationPoint.stream;
  Stream<String> get wifiName => _wifiLatestName.stream; 

  void listenGeoExit(Geolocation _) => _zone.add(ZoneStatus.outside);
  void listenGeoEntry(Geolocation _) => _zone.add(ZoneStatus.inside);
  void startListenFenceActivity() => geoModule.startListen();

  Future<void> dispose() async {
    try {
      timer.cancel();
      geoModule.removeGeofence();
      _locationPoint.close();
      _zone.close();
      _connection.close();
      _wifiLatestName.close();
      connectionListening.cancel();
    } catch (err) {
      return Future.error(err);
    }

    return Future.value();
  }
}
