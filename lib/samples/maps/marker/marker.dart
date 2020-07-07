import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart' show DateFormat;

class MapMarkerSample extends SampleView {
  const MapMarkerSample(Key key) : super(key: key);

  @override
  _MapMarkerSampleState createState() => _MapMarkerSampleState();
}

class _MapMarkerSampleState extends SampleViewState {
  List<ClockModel> _clockModelData;

  @override
  void initState() {
    super.initState();

    final DateTime _currentTime = DateTime.now().toUtc();

    // Data source to the map markers.
    _clockModelData = <ClockModel>[
      ClockModel('Seattle', 47.60621, -122.332071,
          _currentTime.subtract(const Duration(hours: 7))),
      ClockModel('Belem', -1.455833, -48.503887,
          _currentTime.subtract(const Duration(hours: 3))),
      ClockModel('Greenland', 71.706936, -42.604303,
          _currentTime.subtract(const Duration(hours: 2))),
      ClockModel('Yakutsk', 62.035452, 129.675475,
          _currentTime.add(const Duration(hours: 9))),
      ClockModel('Delhi', 28.704059, 77.10249,
          _currentTime.add(const Duration(hours: 5, minutes: 30))),
      ClockModel('Brisbane', -27.469771, 153.025124,
          _currentTime.add(const Duration(hours: 10))),
      ClockModel('Harare', -17.825166, 31.03351,
          _currentTime.add(const Duration(hours: 2))),
    ];
  }

  @override
  void dispose() {
    _clockModelData?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? _getMapsWidget()
        : SingleChildScrollView(child: _getMapsWidget());
  }

  Widget _getMapsWidget() {
    return FutureBuilder<dynamic>(
      future: Future<dynamic>.delayed(
          const Duration(milliseconds: kIsWeb ? 0 : 500), () => 'Loaded'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Padding(
              padding:
                  MediaQuery.of(context).orientation == Orientation.portrait ||
                          model.isWeb
                      ? EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.1,
                          right: 10,
                          left: 10)
                      : const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SfMaps(
                title: const MapTitle(
                  text: 'World Clock',
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                ),
                layers: <MapLayer>[
                  MapShapeLayer(
                    delegate: const MapShapeLayerDelegate(
                      // Path of the GeoJSON file.
                      shapeFile: 'assets/world_map.json',
                      // Field or group name in the .json file to identify the shapes.
                      //
                      // Which is used to map the respective shape to data source.
                      shapeDataField: 'name',
                    ),
                    // The number of initial markers.
                    //
                    // The callback for the [markerBuilder] will be called
                    // the number of times equal to the [initialMarkersCount].
                    initialMarkersCount: 7,
                    markerBuilder: (_, int index) {
                      return MapMarker(
                          longitude: _clockModelData[index].longitude,
                          latitude: _clockModelData[index].latitude,
                          child: ClockWidget(
                              countryName: _clockModelData[index].countryName,
                              date: _clockModelData[index].date),
                          size: const Size(150, 150));
                    },
                    strokeWidth: 0,
                    color: model.themeData.brightness == Brightness.light
                        ? const Color.fromRGBO(71, 70, 75, 0.2)
                        : const Color.fromRGBO(71, 70, 75, 1),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Container(
              height: 25,
              width: 25,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          );
        }
      },
    );
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key key, this.countryName, this.date}) : super(key: key);

  final String countryName;
  final DateTime date;

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _currentTime;
  DateTime _date;
  Timer _timer;

  @override
  void initState() {
    _date = widget.date;
    _currentTime = _getFormattedDateTime(widget.date);
    _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _updateTime(_date));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            width: 8,
            height: 8,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.countryName,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Center(
                child: Text(_currentTime,
                    style: Theme.of(context).textTheme.overline.copyWith(
                        letterSpacing: 0.5, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _updateTime(DateTime currentDate) {
    _date = currentDate.add(const Duration(seconds: 1));
    setState(() {
      _currentTime = DateFormat('hh:mm:ss a').format(_date);
    });
  }

  String _getFormattedDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }
}

class ClockModel {
  ClockModel(this.countryName, this.latitude, this.longitude, this.date);

  final String countryName;
  final double latitude;
  final double longitude;
  final DateTime date;
}
