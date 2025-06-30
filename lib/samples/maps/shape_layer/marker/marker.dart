///Dart import
import 'dart:async';

///Flutter package imports
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show DateFormat;

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the world clock marker map widget
class MapMarkerPage extends SampleView {
  /// Creates the world clock marker map widget
  const MapMarkerPage(Key key) : super(key: key);

  @override
  _MapMarkerPageState createState() => _MapMarkerPageState();
}

class _MapMarkerPageState extends SampleViewState {
  late List<_TimeDetails> _worldClockData;
  late MapShapeSource _mapSource;

  @override
  void initState() {
    super.initState();

    final DateTime currentTime = DateTime.now().toUtc();

    // Data source to the map markers.
    _worldClockData = <_TimeDetails>[
      _TimeDetails(
        'Seattle',
        47.60621,
        -122.332071,
        currentTime.subtract(const Duration(hours: 7)),
      ),
      _TimeDetails(
        'Belem',
        -1.455833,
        -48.503887,
        currentTime.subtract(const Duration(hours: 3)),
      ),
      _TimeDetails(
        'Greenland',
        71.706936,
        -42.604303,
        currentTime.subtract(const Duration(hours: 2)),
      ),
      _TimeDetails(
        'Yakutsk',
        62.035452,
        129.675475,
        currentTime.add(const Duration(hours: 9)),
      ),
      _TimeDetails(
        'Delhi',
        28.704059,
        77.10249,
        currentTime.add(const Duration(hours: 5, minutes: 30)),
      ),
      _TimeDetails(
        'Brisbane',
        -27.469771,
        153.025124,
        currentTime.add(const Duration(hours: 10)),
      ),
      _TimeDetails(
        'Harare',
        -17.825166,
        31.03351,
        currentTime.add(const Duration(hours: 2)),
      ),
    ];

    _mapSource = const MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/world_map.json',
      // Field or group name in the .json file to identify
      // the shapes.
      //
      // Which is used to map the respective shape to
      // data source.
      shapeDataField: 'name',
    );
  }

  @override
  void dispose() {
    _worldClockData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool scrollEnabled = constraints.maxHeight > 400;
        double height = scrollEnabled ? constraints.maxHeight : 400;
        if (model.isWebFullView ||
            (model.isMobile &&
                MediaQuery.of(context).orientation == Orientation.landscape)) {
          final double refHeight = height * 0.6;
          height = height > 500 ? (refHeight < 500 ? 500 : refHeight) : height;
        }
        return Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              height: height,
              child: _buildMapsWidget(scrollEnabled),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapsWidget(bool scrollEnabled) {
    return Center(
      child: Padding(
        padding: scrollEnabled
            ? EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.1,
                right: 10,
                left: 10,
              )
            : const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: SfMapsTheme(
          data: const SfMapsThemeData(
            shapeHoverColor: Colors.transparent,
            shapeHoverStrokeColor: Colors.transparent,
            shapeHoverStrokeWidth: 0,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                child: Align(
                  child: Text(
                    'World Clock',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              Expanded(
                child: SfMaps(
                  layers: <MapLayer>[
                    MapShapeLayer(
                      loadingBuilder: (BuildContext context) {
                        return const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        );
                      },
                      source: _mapSource,
                      // The number of initial markers.
                      //
                      // The callback for the [markerBuilder] will be called
                      // the number of times equal to the [initialMarkersCount].
                      initialMarkersCount: 7,
                      markerBuilder: (_, int index) {
                        return MapMarker(
                          longitude: _worldClockData[index].longitude,
                          latitude: _worldClockData[index].latitude,
                          alignment: Alignment.topCenter,
                          offset: const Offset(0, -4),
                          size: const Size(150, 150),
                          child: _ClockWidget(
                            countryName: _worldClockData[index].countryName,
                            date: _worldClockData[index].date,
                          ),
                        );
                      },
                      strokeWidth: 0,
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? const Color.fromRGBO(71, 70, 75, 0.2)
                          : const Color.fromRGBO(71, 70, 75, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClockWidget extends StatefulWidget {
  const _ClockWidget({Key? key, required this.countryName, required this.date})
    : super(key: key);

  final String countryName;
  final DateTime date;

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<_ClockWidget> {
  late String _currentTime;
  late DateTime _date;
  Timer? _timer;

  @override
  void initState() {
    _date = widget.date;
    _currentTime = _getFormattedDateTime(widget.date);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(_date),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
        Text(
          widget.countryName,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Center(
          child: Text(
            _currentTime,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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

class _TimeDetails {
  _TimeDetails(this.countryName, this.latitude, this.longitude, this.date);

  final String countryName;
  final double latitude;
  final double longitude;
  final DateTime date;
}
