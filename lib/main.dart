import 'package:flutter/material.dart';
import 'package:settle_assessment/bloc/blocConfiguration.dart';
import 'package:settle_assessment/utils/constant.dart';
import 'package:toast/toast.dart';
import 'widgets/CustomTile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: fontName),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BlocConfiguration _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = BlocConfiguration(context: context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical:40),
        children: [
          _CustomTitle('My Assessment'),
          CustomTile(
            title: 'Radius of Zone ',
            firstOption: 'Default : 500 meter',
            secondOption: 'Configure :',
            type: FieldRequire.single,
            firstLabel: 'Radius (meter)',
            onChangeOption: _bloc.changeRadiusOption,
            onChangeFirstText: _bloc.insertRadius,
            result$: _bloc.optRadius,
            isNumber: true,
          ),
          CustomTile(
            title: 'Geolocation of Zone ',
            firstOption: 'Default : Current Location',
            secondOption: 'Configure :',
            type: FieldRequire.dual,
            firstLabel: 'latitude (decimal)',
            secondLabel: 'longitude (decimal)',
            onChangeOption: _bloc.changeGeoOption,
            onChangeFirstText: _bloc.insertLatitude,
            onChangeSecondText: _bloc.insertLongitude,
            result$: _bloc.optGeo,
            isNumber: true,
          ),
          CustomTile(
            title: 'Wifi Name ',
            firstOption: 'Default : Any wifi connection',
            secondOption: 'Configure :',
            type: FieldRequire.single,
            firstLabel: 'Wifi ssid',
            onChangeOption: _bloc.changeWifiOption,
            onChangeFirstText: _bloc.insertWifi,
            result$: _bloc.optWifi,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black38,
        label: Text('Begin'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (_bloc.enableSubmit() == false){
            Navigator.pop(context);
            Toast.show('Check Configure Field', context);
          }
        },
      ),
    );
  }
}

class _CustomTitle extends StatelessWidget {
  final String value;

  _CustomTitle(this.value);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(value, style: _style),
      ),
    );
  }

  TextStyle get _style {
    return TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 32,
      color: Colors.white,
      fontFamily: fontName,
    );
  }
}
