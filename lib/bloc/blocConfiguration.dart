import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:settle_assessment/utils/constant.dart';

class BlocConfiguration {
  final Function navigate;
  double longitude;
  double latitude;
  String wifi;
  int radius;

  final _optionRadius = BehaviorSubject<OptionType>.seeded(OptionType.useDefault);
  final _optionWifi = BehaviorSubject<OptionType>.seeded(OptionType.useDefault);
  final _optionGeo = BehaviorSubject<OptionType>.seeded(OptionType.useDefault);

  Stream<OptionType> get optRadius => _optionRadius.stream;
  Stream<OptionType> get optWifi => _optionWifi.stream;
  Stream<OptionType> get optGeo => _optionGeo.stream;

  BlocConfiguration({@required this.navigate});

  void submit() {
    if (_optionRadius.value == OptionType.useDefault) radius = 500;
    if (_optionGeo.value == OptionType.useDefault) {
      //get geo location
    }
    if (_optionWifi.value == OptionType.useDefault) {
      // use any wifi
    }
  }

  void changeRadiusOption(OptionType value) => _optionRadius.add(value);
  void changeWifiOption(OptionType value) => _optionWifi.add(value);
  void changeGeoOption(OptionType value) => _optionGeo.add(value);

  void insertLongitude(String value) => longitude = double.parse(value);
  void insertLatitude(String value) => latitude = double.parse(value);
  void insertRadius(String value) => radius = int.parse(value);
  void insertWifi(String value) => wifi = value;

  void dispose() {
    _optionRadius.close();
    _optionGeo.close();
    _optionWifi.close();
  }
}