import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:settle_assessment/monitor.dart';
import 'package:settle_assessment/utils/constant.dart';

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

  void _submit() {
    if (_optionRadius.value == OptionType.useDefault) radius = 500;
    if (_optionGeo.value == OptionType.useDefault) {
      //get geo location
    }
    if (_optionWifi.value == OptionType.useDefault) {
      // use any wifi
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => MonitorScreen()));
  }

  void changeRadiusOption(OptionType value) => _optionRadius.add(value);
  void changeWifiOption(OptionType value) => _optionWifi.add(value);
  void changeGeoOption(OptionType value) => _optionGeo.add(value);

  Future<bool> insertLongitude(String value) {
    try {
      if (value.length == 0) throw 'Please insert field';
      longitude = double.parse(value);

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

      return Future.value(true);
    } catch (err) {
      radius = null;

      return Future.error(err is String ? err : 'Invalid value');
    }
  }

  Future<bool> insertWifi(String value) {
    try {
      wifi = value;
      if (value.length == 0) {
        wifi = null;
        throw 'Please insert field';
      }
      return Future.value(true);
    } catch (err) {
      wifi = null;

      return Future.error(err is String ? err : 'Invalid value');
    }
  }

  bool enableSubmit() {
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
