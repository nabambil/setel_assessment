import 'package:flutter/foundation.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:location/location.dart';

class GeoFenceModule {
  final Geolocation location;
  final Function(Geolocation) callbackExit;
  final Function(Geolocation) callbackEntry;

  GeoFenceModule(
      {@required int radius,
      @required this.callbackExit,
      @required this.callbackEntry,
      double latitude,
      double longitude})
      : this.location = Geolocation(
          id: '0',
          latitude: latitude,
          longitude: longitude,
          radius: radius.toDouble(),
        ) {
    Geofence.initialize();
    Geofence.addGeolocation(location, GeolocationEvent.exit);
    Geofence.addGeolocation(location, GeolocationEvent.entry);
  }

  static Future<LocationData> get currentLocation {
    return Location().getLocation();
  }

  void startListen(){
    Geofence.startListening(GeolocationEvent.exit, callbackExit);
    Geofence.startListening(GeolocationEvent.entry, callbackEntry);
  }

  Future<void> removeGeofence() async {
    try {
      await Geofence.removeGeolocation(location, GeolocationEvent.exit);
      await Geofence.removeGeolocation(location, GeolocationEvent.entry);
    } catch (err) {
      return Future.error(err);
    }

    return Future.value();
  }
}
