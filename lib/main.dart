import 'package:flutter/material.dart';
import 'package:settle_assessment/bloc/blocConfiguration.dart';
import 'package:settle_assessment/utils/constant.dart';
import 'monitor.dart';
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
          fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BlocConfiguration _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = BlocConfiguration(navigate: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => MonitorScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          CustomTile(
            title: 'Geolocation of Zone ',
            firstOption: 'Default : Current Location',
            secondOption: 'Configure :',
            type: FieldRequire.dual,
            firstLabel: 'latitude (decimal)',
            secondLabel: 'longitude (decimal)',
            onChangeOption: _bloc.changeGeoOption,
            onChangeFirstText: _bloc.insertLongitude,
            onChangeSecondText: _bloc.insertLatitude,
            result$: _bloc.optGeo,
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
        padding: const EdgeInsets.all(12.0),
        child: Text(value, style: _style),
      ),
    );
  }

  TextStyle get _style {
    return TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 32,
      color: Colors.white,
      fontFamily: 'Poppins',
    );
  }
}
