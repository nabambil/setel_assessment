import 'package:flutter/foundation.dart';
import 'package:flutter_geofence/geofence.dart';

enum TypeFence {
  inside,
  outside
}

class GeoFenceModule {
  GeoFenceModule(){
    Geofence.initialize();
  }

  // to setup current location of devices as geofence
  Future<void> setCurrentGeoAsFence({@required double radius}){
    return Future.value();
  }

  // to setup manually by given info as geofence
  Future<void> setGeoAsFence({@required double lat, @required double lng}){
    return Future.value();
  }


  Future<bool> removeGeofence(){
    return Future.value(true);
  }

  TypeFence statusOfFence(){
    return TypeFence.outside;
  }
}

