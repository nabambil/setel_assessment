import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:settle_assessment/features/geofence.dart';
import 'package:settle_assessment/monitor.dart';
import 'package:settle_assessment/utils/constant.dart';

import 'blocMonitor.dart';

class BlocConfiguration {
  final BuildContext context;
  double longitude;
  double latitude;
  String wifi;
  int radius;

  final _optionRadius =
      BehaviorSubject<OptionType>.seeded(OptionType.useDefault);
  final _optionWifi = BehaviorSubject<OptionType>.seeded(OptionType.useDefault);
  final _optionGeo = BehaviorSubject<OptionType>.seeded(OptionType.useDefault);

  Stream<OptionType> get optRadius => _optionRadius.stream;
  Stream<OptionType> get optWifi => _optionWifi.stream;
  Stream<OptionType> get optGeo => _optionGeo.stream;

  BlocConfiguration({@required this.context});

  void _submit() async {
    if (_optionRadius.value == OptionType.useDefault) radius = 500;
    if (_optionGeo.value == OptionType.useDefault) {
      final location = await GeoFenceModule.currentLocation;
      latitude = location.latitude;
      longitude = location.longitude;
    }

    final bloc = BlocMonitor(latitude, longitude, radius, wifi);

    Timer(Duration(milliseconds: 1000), () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => MonitorScreen(bloc: bloc),
        ),
      ).then((value) => reset());
    });
  }

  void reset() {
    longitude = null;
    latitude = null;
    wifi = null;
    radius = null;
    _optionRadius.add(OptionType.useDefault);
    _optionWifi.add(OptionType.useDefault);
    _optionGeo.add(OptionType.useDefault);
  }

  void changeRadiusOption(OptionType value) {
    if (value == OptionType.useDefault) radius = null;
    _optionRadius.add(value);
  }

  void changeWifiOption(OptionType value) {
    if (value == OptionType.useDefault) wifi = null;
    _optionWifi.add(value);
  }

  void changeGeoOption(OptionType value) {
    if (value == OptionType.useDefault) {
      latitude = null;
      longitude = null;
    }
    _optionGeo.add(value);
  }

  Future<bool> insertLongitude(String value) {
    try {
      if (value.length == 0) throw 'Please insert field';
      longitude = double.parse(value);

      if (longitude == 0.0) throw 'Invalid value';
      if (!(longitude > -180.0 && longitude < 180))
        throw 'Invalid value, must be between -180.0 to 180.0 ';

      return Future.value(true);
    } catch (err) {
      longitude = null;

      return Future.error(err is String ? err : 'Invalid value');
    }
  }

  Future<bool> insertLatitude(String value) {
    try {
      if (value.length == 0) throw 'Please insert field';
      latitude = double.parse(value);

      if (latitude == 0.0) throw 'Invalid value';
      if (!(latitude > -90.0 && latitude < 90))
        throw 'Invalid value, must be between -90.0 to 90.0';

      return Future.value(true);
    } catch (err) {
      latitude = null;

      return Future.error(err is String ? err : 'Invalid value');
    }
  }

  Future<bool> insertRadius(String value) {
    try {
      if (value.length == 0) throw 'Please insert field';
      radius = int.parse(value);

      if (radius == 0.0) throw 'Invalid value';

      return Future.value(true);
    } catch (err) {
      radius = null;

      return Future.error(err is String ? err : 'Invalid value');
    }
  }

  Future<bool> insertWifi(String value) {
    try {
      wifi = value;
      if (value.length == 0) throw 'Please insert field';

      return Future.value(true);
    } catch (err) {
      wifi = null;

      return Future.error(err is String ? err : 'Invalid value');
    }
  }

  bool enableSubmit() {
    showDialog(
        context: context, child: Center(child: CircularProgressIndicator()));

    if (_optionRadius.value == OptionType.useConfigure && radius == null)
      return false;
    if (_optionGeo.value == OptionType.useConfigure &&
        (latitude == null || longitude == null)) return false;
    if (_optionWifi.value == OptionType.useConfigure && wifi == null)
      return false;

    _submit();

    return true;
  }

  void dispose() {
    _optionRadius.close();
    _optionGeo.close();
    _optionWifi.close();
  }
}
