import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:settle_assessment/utils/constant.dart';

class GeoFenceModule {
  // final Geolocation location;
  final Location _location;
  final Geolocator _geolocation;
  final Function(ZoneStatus) callbackStatus;
  final Function(double) callbackDistance;
  final double latitude;
  final double longitude;
  final int radius;
  StreamSubscription<LocationData> streaming;

  GeoFenceModule({
    @required this.radius,
    @required this.callbackStatus,
    @required this.callbackDistance,
    @required this.latitude,
    @required this.longitude,
  })  : _location = Location(),
        _geolocation = Geolocator() {
    streaming = _location.onLocationChanged.listen((event) async {
      final distance = await _geolocation.distanceBetween(
        event.latitude,
        event.longitude,
        latitude,
        longitude,
      );
      print(distance);
      callbackDistance(distance);
      callbackStatus(distance < radius ? ZoneStatus.inside : ZoneStatus.outside);
    });
  }

  static Future<LocationData> get currentLocation {
    return Location().getLocation();
  }

  void dispose(){
    streaming.cancel();
  }
}
