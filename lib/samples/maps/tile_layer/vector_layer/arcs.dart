/// Flutter package imports
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map arc sample
class MapArcsPage extends SampleView {
  /// Creates the map arc sample
  const MapArcsPage(Key key) : super(key: key);

  @override
  _ArcsSampleState createState() => _ArcsSampleState();
}

class _ArcsSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late List<_AirRouteDetails> _airports;
  late List<_MarkerData> _markerData;
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapTileLayerController _mapController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentSelectedCityIndex = 0;
  bool _isDesktop = false;
  bool _enableDashArray = false;
  late bool _canUpdateZoomLevel;
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _currentSublayer;
  late Color _layerColor;
  late List<double> _dashArray;

  @override
  void initState() {
    _mapController = MapTileLayerController();

    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: const MapLatLng(40.7128, -74.0060),
      toolbarSettings: const MapToolbarSettings(
        direction: Axis.vertical,
        position: MapToolbarPosition.bottomRight,
      ),
      enableDoubleTapZooming: true,
      maxZoomLevel: 12,
    );

    _setNavigationLineData(_currentSelectedCityIndex);

    _dropDownMenuItems = _getDropDownMenuItems();
    _currentSublayer = _dropDownMenuItems[0].value!;
    _canUpdateZoomLevel = true;
    _dashArray = <double>[0, 0];

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _animationController.forward(from: 0);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    _markerData.clear();
    _airports.clear();
    super.dispose();
  }

  void _setNavigationLineData(int index) {
    switch (index) {
      case 0:
        _layerColor = const Color.fromRGBO(167, 61, 233, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          const _MarkerData('Denver', MapLatLng(39.7392, -104.9903)),
          const _MarkerData('Bogata', MapLatLng(4.7110, -74.0721)),
          const _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          const _MarkerData('Tashkent', MapLatLng(41.2995, 69.2401)),
          const _MarkerData('Dakar', MapLatLng(14.7167, -17.4677)),
          const _MarkerData('Casablanca', MapLatLng(33.3700, -7.5857)),
          const _MarkerData('Houston', MapLatLng(29.7604, -95.3698)),
          const _MarkerData('Edmonton', MapLatLng(53.5461, -113.4938)),
          const _MarkerData('Panama City', MapLatLng(8.9824, -79.5199)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(4.7110, -74.0721),
            'New York - Bogata',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(51.0447, -114.0719),
            'New York - Calgary',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(41.2995, 69.2401),
            'New York - Tashkent',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(14.7167, -17.4677),
            'New York - Dakar',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(33.3700, -7.5857),
            'New York - Casablanca',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(29.7604, -95.3698),
            'New York - Houston',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(53.5461, -113.4938),
            'New York - Edmonton',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(8.9824, -79.5199),
            'New York - Panama City',
          ),
          const _AirRouteDetails(
            MapLatLng(40.7128, -74.0060),
            MapLatLng(39.7392, -104.9903),
            'New york - Denver',
          ),
        ];
        _updateMarkers();
        break;

      case 1:
        _layerColor = const Color.fromRGBO(65, 72, 22, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('Denver', MapLatLng(39.7392, -104.9903)),
          const _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          const _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          const _MarkerData('Edmonton', MapLatLng(53.5461, -113.4938)),
          const _MarkerData('Paris', MapLatLng(48.8566, 2.3522)),
          const _MarkerData('Panama City', MapLatLng(8.9824, -79.5199)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(39.7392, -104.9903),
            MapLatLng(53.5461, -113.4938),
            'Denver - Edmonton',
          ),
          const _AirRouteDetails(
            MapLatLng(39.7392, -104.9903),
            MapLatLng(51.0447, -114.0719),
            'Denver - Calgary',
          ),
          const _AirRouteDetails(
            MapLatLng(39.7392, -104.9903),
            MapLatLng(40.7128, -74.0060),
            'Denver - New York',
          ),
          const _AirRouteDetails(
            MapLatLng(39.7392, -104.9903),
            MapLatLng(48.8566, 2.3522),
            'Denver - Paris',
          ),
          const _AirRouteDetails(
            MapLatLng(39.7392, -104.9903),
            MapLatLng(8.9824, -79.5199),
            'Denver - Panama City',
          ),
        ];
        _updateMarkers();
        break;

      case 2:
        _layerColor = const Color.fromRGBO(12, 152, 34, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('London', MapLatLng(51.4700, 0.4543)),
          const _MarkerData('Bogata', MapLatLng(4.7110, -74.0721)),
          const _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          const _MarkerData('Moscow', MapLatLng(55.7558, 37.6173)),
          const _MarkerData('Riyath', MapLatLng(24.7136, 46.6753)),
          const _MarkerData('Seoul', MapLatLng(37.5665, 126.9780)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(51.4700, 0.4543),
            MapLatLng(51.0447, -114.0719),
            'London - Calgary',
          ),
          const _AirRouteDetails(
            MapLatLng(51.4700, 0.4543),
            MapLatLng(4.7110, -74.0721),
            'London - Bogata',
          ),
          const _AirRouteDetails(
            MapLatLng(51.4700, 0.4543),
            MapLatLng(55.7558, 37.6173),
            'London - Moscow',
          ),
          const _AirRouteDetails(
            MapLatLng(51.4700, 0.4543),
            MapLatLng(24.7136, 46.6753),
            'London - Riyath',
          ),
          const _AirRouteDetails(
            MapLatLng(51.4700, 0.4543),
            MapLatLng(37.5665, 126.9780),
            'London - Seoul',
          ),
        ];
        _updateMarkers();
        break;

      case 3:
        _layerColor = const Color.fromRGBO(226, 75, 65, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('Dublin', MapLatLng(53.3498, -6.2603)),
          const _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          const _MarkerData('Hong Kong', MapLatLng(22.3193, 114.1694)),
          const _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          const _MarkerData('Addis Abada', MapLatLng(8.9806, 38.7578)),
          const _MarkerData('Helsinki', MapLatLng(60.1699, 24.9384)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(53.3498, -6.2603),
            MapLatLng(22.3193, 114.1694),
            'Dublin - Hong Kong',
          ),
          const _AirRouteDetails(
            MapLatLng(53.3498, -6.2603),
            MapLatLng(8.9806, 38.7578),
            'Dublin - Addis Abada',
          ),
          const _AirRouteDetails(
            MapLatLng(53.3498, -6.2603),
            MapLatLng(60.1699, 24.9384),
            'Dublin - Helsinki',
          ),
          const _AirRouteDetails(
            MapLatLng(53.3498, -6.2603),
            MapLatLng(40.7128, -74.0060),
            'Dublin - New York',
          ),
          const _AirRouteDetails(
            MapLatLng(53.3498, -6.2603),
            MapLatLng(51.0447, -114.0719),
            'Dublin - Calgary',
          ),
        ];
        _updateMarkers();
        break;

      case 4:
        _layerColor = const Color.fromRGBO(108, 27, 212, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('Beijing', MapLatLng(39.9042, 116.4074)),
          const _MarkerData('Seoul', MapLatLng(37.5665, 126.9780)),
          const _MarkerData('Islamabad', MapLatLng(33.6844, 73.0479)),
          const _MarkerData('Addis Abada', MapLatLng(8.9806, 38.7578)),
          const _MarkerData('Tokyo', MapLatLng(35.6762, 139.6503)),
          const _MarkerData('Helsinki', MapLatLng(60.1699, 24.9384)),
          const _MarkerData('Korla', MapLatLng(41.7259, 86.1746)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(39.9042, 116.4074),
            MapLatLng(33.6844, 73.0479),
            'Beijing - Islamabad',
          ),
          const _AirRouteDetails(
            MapLatLng(39.9042, 116.4074),
            MapLatLng(8.9806, 38.7578),
            'Beijing - Addis Abada',
          ),
          const _AirRouteDetails(
            MapLatLng(39.9042, 116.4074),
            MapLatLng(35.6762, 139.6503),
            'Beijing - Tokyo',
          ),
          const _AirRouteDetails(
            MapLatLng(39.9042, 116.4074),
            MapLatLng(60.1699, 24.9384),
            'Beijing - Helsinki',
          ),
          const _AirRouteDetails(
            MapLatLng(39.9042, 116.4074),
            MapLatLng(41.7259, 86.1746),
            'Beijing - Korla',
          ),
          const _AirRouteDetails(
            MapLatLng(39.9042, 116.4074),
            MapLatLng(37.5665, 126.9780),
            'Beijing - Seoul',
          ),
        ];
        _updateMarkers();
        break;
      case 5:
        _layerColor = const Color.fromRGBO(236, 40, 134, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('Delhi', MapLatLng(28.7041, 77.1025)),
          const _MarkerData('London', MapLatLng(51.4700, 0.4543)),
          const _MarkerData('Beijing', MapLatLng(39.9042, 116.4074)),
          const _MarkerData('Chennai', MapLatLng(13.0827, 80.2707)),
          const _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          const _MarkerData('Sydney', MapLatLng(-33.8688, 151.2093)),
          const _MarkerData('Mumbai', MapLatLng(19.0931, 72.8568)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(28.7041, 77.1025),
            MapLatLng(51.4700, 0.4543),
            'Delhi - London',
          ),
          const _AirRouteDetails(
            MapLatLng(28.7041, 77.1025),
            MapLatLng(40.7128, -74.0060),
            'Delhi - New York',
          ),
          const _AirRouteDetails(
            MapLatLng(28.7041, 77.1025),
            MapLatLng(-33.8688, 151.2093),
            'Delhi - Sydney',
          ),
          const _AirRouteDetails(
            MapLatLng(28.7041, 77.1025),
            MapLatLng(39.9042, 116.4074),
            'Delhi - Beijing',
          ),
          const _AirRouteDetails(
            MapLatLng(28.7041, 77.1025),
            MapLatLng(13.0827, 80.2707),
            'Delhi - Chennai',
          ),
          const _AirRouteDetails(
            MapLatLng(28.7041, 77.1025),
            MapLatLng(19.0931, 72.8568),
            'Delhi - Mumbai',
          ),
        ];
        _updateMarkers();
        break;
      case 6:
        _layerColor = const Color.fromRGBO(2, 130, 122, 1.0);
        _markerData = <_MarkerData>[
          const _MarkerData('Chennai', MapLatLng(13.0827, 80.2707)),
          const _MarkerData('London', MapLatLng(51.4700, 0.4543)),
          const _MarkerData('Delhi', MapLatLng(28.7041, 77.1025)),
          const _MarkerData('Riyath', MapLatLng(24.7136, 46.6753)),
          const _MarkerData('Tokyo', MapLatLng(35.6762, 139.6503)),
          const _MarkerData('Singapore', MapLatLng(1.3521, 103.8198)),
          const _MarkerData('Addis Abada', MapLatLng(8.9806, 38.7578)),
        ];

        _airports = <_AirRouteDetails>[
          const _AirRouteDetails(
            MapLatLng(13.0827, 80.2707),
            MapLatLng(51.507351, -0.127758),
            'Chennai - London',
          ),
          const _AirRouteDetails(
            MapLatLng(13.0827, 80.2707),
            MapLatLng(35.6762, 139.6503),
            'Chennai - Tokyo',
          ),
          const _AirRouteDetails(
            MapLatLng(13.0827, 80.2707),
            MapLatLng(8.9806, 38.7578),
            'Chennai - Addis Abada',
          ),
          const _AirRouteDetails(
            MapLatLng(13.0827, 80.2707),
            MapLatLng(24.7136, 46.6753),
            'Chennai - Riyath',
          ),
          const _AirRouteDetails(
            MapLatLng(13.0827, 80.2707),
            MapLatLng(1.3521, 103.8198),
            'Chennai - Singapore',
          ),
          const _AirRouteDetails(
            MapLatLng(13.0827, 80.2707),
            MapLatLng(28.7041, 77.1025),
            'Chennai - Delhi',
          ),
        ];
        _updateMarkers();
        break;
    }
  }

  void _updateMarkers() {
    _mapController.clearMarkers();
    for (int i = 0; i < _markerData.length; i++) {
      _mapController.insertMarker(i);
    }
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    final List<DropdownMenuItem<String>> sublayerItems =
        <DropdownMenuItem<String>>[
          const DropdownMenuItem<String>(value: 'arcs', child: Text('arcs')),
          const DropdownMenuItem<String>(value: 'lines', child: Text('lines')),
        ];
    return sublayerItems;
  }

  MapSublayer _getCurrentSublayer(String currentLegend) {
    if (currentLegend == 'arcs') {
      return MapArcLayer(
        arcs: List<MapArc>.generate(_airports.length, (int index) {
          return MapArc(
            from: _airports[index].from,
            to: _airports[index].to,
            dashArray: _dashArray,
            heightFactor:
                index == 5 &&
                    _airports[index].to == const MapLatLng(13.0827, 80.2707)
                ? 0.5
                : 0.2,
            color: _layerColor,
            width: 2.0,
          );
        }).toSet(),
        animation: _animation,
        tooltipBuilder: _tooltipBuilder,
      );
    } else {
      return MapLineLayer(
        lines: List<MapLine>.generate(_airports.length, (int index) {
          return MapLine(
            from: _airports[index].from,
            to: _airports[index].to,
            dashArray: _dashArray,
            color: _layerColor,
            strokeCap: StrokeCap.round,
            width: 2.0,
          );
        }).toSet(),
        animation: _animation,
        tooltipBuilder: _tooltipBuilder,
      );
    }
  }

  Widget _tooltipBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: SizedBox(
        height: _isDesktop ? 45 : 40,
        child: Column(
          children: <Widget>[
            Text(
              'Route',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                _airports[index].destination,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 4 : 3;
      _zoomPanBehavior.minZoomLevel = _isDesktop ? 4 : 3;
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'images/maps_grid.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        SfMapsTheme(
          data: const SfMapsThemeData(shapeHoverColor: Colors.transparent),
          child: SfMaps(
            layers: <MapLayer>[
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                initialMarkersCount: _markerData.length,
                zoomPanBehavior: _zoomPanBehavior,
                controller: _mapController,
                markerBuilder: (BuildContext context, int index) {
                  return MapMarker(
                    latitude: _markerData[index].latLng.latitude,
                    longitude: _markerData[index].latLng.longitude,
                    child: index == 0
                        ? BlowingCircle(color: _layerColor)
                        : Icon(Icons.circle, color: _layerColor, size: 15),
                  );
                },
                markerTooltipBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _markerData[index].country,
                      style: model.themeData.textTheme.bodySmall!.copyWith(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  );
                },
                tooltipSettings: const MapTooltipSettings(
                  color: Color.fromRGBO(45, 45, 45, 1),
                ),
                sublayers: <MapSublayer>[_getCurrentSublayer(_currentSublayer)],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildChipWidget(0, 'New York'),
                _buildChipWidget(1, 'Denver'),
                _buildChipWidget(2, 'London'),
                _buildChipWidget(3, 'Dublin'),
                _buildChipWidget(4, 'Beijing'),
                _buildChipWidget(5, 'Delhi'),
                _buildChipWidget(6, 'Chennai'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipWidget(int index, String city) {
    return Padding(
      padding: _isDesktop
          ? const EdgeInsets.only(left: 8.0, top: 8.0)
          : const EdgeInsets.only(left: 8.0),
      child: ChoiceChip(
        backgroundColor:
            model.themeData.colorScheme.brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        elevation: 3.0,
        shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
        showCheckmark: false,
        label: Text(city, style: TextStyle(color: model.textColor)),
        selected: _currentSelectedCityIndex == index,
        selectedColor:
            model.themeData.colorScheme.brightness == Brightness.light
            ? model.primaryColor.withValues(alpha: 0.25)
            : const Color.fromRGBO(61, 91, 89, 0.9),
        onSelected: (bool isSelected) {
          if (isSelected) {
            setState(() {
              _currentSelectedCityIndex = index;
              _setNavigationLineData(_currentSelectedCityIndex);
              _zoomPanBehavior.focalLatLng = _markerData[0].latLng;
              _canUpdateZoomLevel = false;
              _animationController.forward(from: 0);
            });
          }
        },
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Layer type',
                    softWrap: false,
                    style: TextStyle(color: model.textColor, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: DropdownButton<String>(
                      dropdownColor: model.drawerBackgroundColor,
                      focusColor: Colors.transparent,
                      value: _currentSublayer,
                      items: _dropDownMenuItems,
                      onChanged: (String? value) {
                        setState(() {
                          _currentSublayer = value!;
                          _canUpdateZoomLevel = false;
                        });
                        stateSetter(() {});
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Show dashes',
                      softWrap: false,
                      style: TextStyle(color: model.textColor, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: _enableDashArray,
                      onChanged: (bool? value) {
                        setState(() {
                          _enableDashArray = value!;
                          _dashArray = _enableDashArray
                              ? <double>[8, 2, 2, 2]
                              : <double>[0, 0];
                          _canUpdateZoomLevel = false;
                        });
                        stateSetter(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MarkerData {
  const _MarkerData(this.country, this.latLng);

  final String country;
  final MapLatLng latLng;
}

class _AirRouteDetails {
  const _AirRouteDetails(this.from, this.to, this.destination);

  final MapLatLng from;
  final MapLatLng to;
  final String destination;
}

class _BlowingCircleCustomPaint extends CustomPainter {
  _BlowingCircleCustomPaint({
    required this.iconColor,
    required this.iconSize,
    required this.animationValue,
  });

  final Color iconColor;

  final Size iconSize;

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final double halfWidth = iconSize.width / 2;
    const Offset center = Offset.zero;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = iconColor;
    canvas.drawCircle(center, halfWidth, paint);
    canvas.drawCircle(
      center,
      halfWidth + halfWidth * 2 * animationValue,
      paint..color = iconColor.withValues(alpha: 1 - animationValue),
    );
  }

  @override
  bool shouldRepaint(_BlowingCircleCustomPaint oldDelegate) => true;
}

/// Renders the blowing  circle sample
class BlowingCircle extends StatefulWidget {
  /// Creates the blowing  circle sample
  const BlowingCircle({Key? key, required this.color}) : super(key: key);

  /// Color value
  final Color color;

  @override
  _BlowingCircleState createState() => _BlowingCircleState();
}

class _BlowingCircleState extends State<BlowingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<dynamic> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation =
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlowingCircleCustomPaint(
        iconColor: widget.color,
        iconSize: const Size(15.0, 15.0),
        animationValue: _animation.value,
      ),
    );
  }
}
