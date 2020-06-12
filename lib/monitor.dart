import 'package:flutter/material.dart';
import 'package:settle_assessment/bloc/blocMonitor.dart';
import 'package:settle_assessment/utils/constant.dart';

class MonitorScreen extends StatefulWidget {
  final BlocMonitor bloc;

  MonitorScreen({@required this.bloc});

  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: _BuildBody(widget.bloc),
      ),
    );
  }
}

class _BuildBody extends StatelessWidget {
  final BlocMonitor _bloc;

  _BuildBody(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(children: <Widget>[
        Spacer(),
        _CustomCard(
          resultSignal$: _bloc.statConnection,
          resultZone$: _bloc.statCombination,
          resultDistance$: _bloc.statDistance,
        ),
        _CustomInfo(
          title: 'Geo Point',
          subTitle: '** ${_bloc.latitude} | ${_bloc.longitude}',
          iconEnabled: Icons.location_on,
          iconDisabled: Icons.location_off,
          status: _bloc.statZone,
        ),
        _CustomInfo(
          title: 'Radius Fence',
          subTitle: '** ${_bloc.radius} meter',
          iconEnabled: Icons.filter_center_focus,
          iconDisabled: Icons.center_focus_weak,
          status: _bloc.statZone,
        ),
        StreamBuilder<String>(
            stream: _bloc.wifiName,
            builder: (context, snapshot) {
              return _CustomInfo(
                title: 'Wifi Name',
                subTitle: '** ${snapshot.data}',
                iconEnabled: Icons.wifi,
                iconDisabled: Icons.signal_wifi_off,
                status: _bloc.statConnection,
              );
            }),
        Spacer(),
        if (MediaQuery.of(context).orientation == Orientation.portrait)
          Padding(
            padding: const EdgeInsets.all(30),
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Done',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.done, color: Colors.white),
                  )
                ],
              ),
              onPressed: () =>
                  _bloc.dispose().then((_) => Navigator.pop(context)),
            ),
          ),
      ]),
    );
  }
}

class _CustomCard extends StatelessWidget {
  final Stream<ConnectionStatus> resultSignal$;
  final Stream<ZoneStatus> resultZone$;
  final Stream<double> resultDistance$;

  _CustomCard({
    @required this.resultSignal$,
    @required this.resultZone$,
    @required this.resultDistance$,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(30),
        elevation: 12,
        shadowColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<ZoneStatus>(
                stream: resultZone$,
                builder: (context, snapshot) => Text(
                  snapshot.data == ZoneStatus.inside ? 'Inside' : 'Outside',
                  style: TextStyle(fontSize: 32, fontFamily: fontName),
                ),
              ),
              StreamBuilder<ConnectionStatus>(
                stream: resultSignal$,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child:
                        Text('Signal Strength : ${getStrength(snapshot.data)}'),
                  );
                },
              ),
              StreamBuilder<double>(
                stream: resultDistance$,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text('Distance (meter) : ${snapshot.data.toStringAsFixed(3)}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getStrength(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.great:
        return 'great';
      case ConnectionStatus.good:
        return 'good';
      case ConnectionStatus.poor:
        return 'poor';
      case ConnectionStatus.disconnected:
        return 'disconnected';
    }

    return 'disconnected';
  }
}

class _CustomInfo<T> extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData iconEnabled;
  final IconData iconDisabled;
  final Stream<T> status;

  _CustomInfo({
    @required this.title,
    @required this.subTitle,
    @required this.iconEnabled,
    @required this.iconDisabled,
    @required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: status,
      builder: (ctx, snapshot) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        title: Text(title),
        subtitle: Text(subTitle),
        leading: IgnorePointer(
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(getIcon(snapshot.data)),
            onPressed: () {},
            backgroundColor: getColor(snapshot.data),
          ),
        ),
      ),
    );
  }

  Color getColor(T value) {
    if (value is ZoneStatus) {
      switch (value) {
        case ZoneStatus.outside:
          return Colors.grey;
        case ZoneStatus.inside:
          return Colors.greenAccent;
      }
    } else if (value is ConnectionStatus) {
      switch (value) {
        case ConnectionStatus.great:
          return Colors.greenAccent;
        case ConnectionStatus.good:
          return Colors.yellowAccent;
        case ConnectionStatus.poor:
          return Colors.redAccent;
        case ConnectionStatus.disconnected:
          return Colors.grey;
      }
    }

    return Colors.greenAccent;
  }

  IconData getIcon(T value) {
    if (value is ZoneStatus) {
      switch (value) {
        case ZoneStatus.outside:
          return iconDisabled;
        case ZoneStatus.inside:
          return iconEnabled;
      }
    } else if (value is ConnectionStatus) {
      switch (value) {
        case ConnectionStatus.great:
          return iconEnabled;
        case ConnectionStatus.good:
          return iconEnabled;
        case ConnectionStatus.poor:
          return iconEnabled;
        case ConnectionStatus.disconnected:
          return iconDisabled;
      }
    }

    return iconEnabled;
  }
}
