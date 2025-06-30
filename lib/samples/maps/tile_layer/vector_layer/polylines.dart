/// Flutter package imports
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the polygon lines map sample
class MapPolylinesPage extends SampleView {
  /// Creates the polygon lines map sample
  const MapPolylinesPage(Key key) : super(key: key);

  @override
  _PolylinesSampleState createState() => _PolylinesSampleState();
}

class _PolylinesSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late MapZoomPanBehavior _zoomPanBehavior;
  MapTileLayerController? _mapController;
  AnimationController? _animationController;
  late Animation<double> _animation;
  late bool _isDesktop;
  late List<_RouteDetails> _routes;
  int _currentSelectedCityIndex = 0;
  late String _routeJson;

  @override
  void initState() {
    _routeJson = 'assets/london_to_british.json';
    _routes = <_RouteDetails>[
      _RouteDetails(const MapLatLng(51.4700, -0.4543), null, 'London Heathrow'),
      _RouteDetails(
        const MapLatLng(51.5194, -0.1270),
        Icon(Icons.location_on, color: Colors.red[600], size: 30),
        'The British Museum',
      ),
    ];
    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      zoomLevel: 10,
      focalLatLng: const MapLatLng(51.4700, -0.2843),
      toolbarSettings: const MapToolbarSettings(
        direction: Axis.vertical,
        position: MapToolbarPosition.bottomRight,
      ),
      enableDoubleTapZooming: true,
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _mapController!.dispose();
    _routes.clear();
    super.dispose();
  }

  Future<dynamic> getJsonData() async {
    final List<MapLatLng> polyline = <MapLatLng>[];
    final String data = await rootBundle.loadString(_routeJson);
    final dynamic jsonData = json.decode(data);
    final List<dynamic> polylinePoints =
        jsonData['features'][0]['geometry']['coordinates'] as List<dynamic>;
    for (int i = 0; i < polylinePoints.length; i++) {
      polyline.add(MapLatLng(polylinePoints[i][1], polylinePoints[i][0]));
    }
    // ignore: unawaited_futures
    _animationController?.forward(from: 0);

    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    return FutureBuilder<dynamic>(
      future: getJsonData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapdata) {
        if (snapdata.hasData) {
          final List<MapLatLng> polylinePoints =
              snapdata.data as List<MapLatLng>;
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'images/maps_grid.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
              SfMapsTheme(
                data: const SfMapsThemeData(
                  shapeHoverColor: Colors.transparent,
                ),
                child: SfMaps(
                  layers: <MapLayer>[
                    MapTileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      initialMarkersCount: _routes.length,
                      controller: _mapController,
                      markerBuilder: (BuildContext context, int index) {
                        if (_routes[index].icon != null) {
                          return MapMarker(
                            key: UniqueKey(),
                            latitude: _routes[index].latLan.latitude,
                            longitude: _routes[index].latLan.longitude,
                            alignment: Alignment.bottomCenter,
                            child: _routes[index].icon,
                          );
                        } else {
                          return MapMarker(
                            key: UniqueKey(),
                            latitude: _routes[index].latLan.latitude,
                            longitude: _routes[index].latLan.longitude,
                            iconColor: Colors.white,
                            iconStrokeWidth: 2.0,
                            size: const Size(15, 15),
                            iconStrokeColor: Colors.black,
                          );
                        }
                      },
                      tooltipSettings: const MapTooltipSettings(
                        color: Color.fromRGBO(45, 45, 45, 1),
                      ),
                      markerTooltipBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _routes[index].city,
                            style: model.themeData.textTheme.bodySmall!
                                .copyWith(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                ),
                          ),
                        );
                      },
                      sublayers: <MapSublayer>[
                        MapPolylineLayer(
                          polylines: <MapPolyline>{
                            MapPolyline(
                              points: polylinePoints,
                              color: const Color.fromRGBO(0, 102, 255, 1.0),
                              width: 6.0,
                            ),
                          },
                          animation: _animation,
                          tooltipBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _routes[0].city + ' - ' + _routes[1].city,
                                style: model.themeData.textTheme.bodySmall!
                                    .copyWith(
                                      color: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        1,
                                      ),
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                      zoomPanBehavior: _zoomPanBehavior,
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
                      _buildChipWidget(0, 'The British Museum'),
                      _buildChipWidget(1, 'The Windsor Castle'),
                      _buildChipWidget(2, 'Twickenham Stadium'),
                      _buildChipWidget(3, 'Chessington World of Adventures'),
                      _buildChipWidget(4, 'Hampton Court Palace'),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
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
              _currentNavigationLine(index, city);
            });
          }
        },
      ),
    );
  }

  void _currentNavigationLine(int index, String city) {
    switch (index) {
      case 0:
        setState(() {
          _routeJson = 'assets/london_to_british.json';
          _zoomPanBehavior.focalLatLng = const MapLatLng(51.4700, -0.2843);
          _zoomPanBehavior.zoomLevel = 10;
          _routes[1] = _RouteDetails(
            const MapLatLng(51.5194, -0.1270),
            Icon(Icons.location_on, color: Colors.red[600], size: 30),
            city,
          );
          _mapController!.updateMarkers(<int>[1]);
        });
        break;
      case 1:
        setState(() {
          _routeJson = 'assets/london_to_windsor_castle.json';
          _zoomPanBehavior.focalLatLng = const MapLatLng(51.4700, -0.5443);
          _zoomPanBehavior.zoomLevel = 11;
          _routes[1] = _RouteDetails(
            const MapLatLng(51.4839, -0.6044),
            Icon(Icons.location_on, color: Colors.red[600], size: 30),
            city,
          );
          _mapController!.updateMarkers(<int>[1]);
        });
        break;
      case 2:
        setState(() {
          _routeJson = 'assets/london_to_twickenham_stadium.json';
          _zoomPanBehavior.focalLatLng = const MapLatLng(51.4700, -0.3843);
          _zoomPanBehavior.zoomLevel = 11;
          _routes[1] = _RouteDetails(
            const MapLatLng(51.4560, -0.3415),
            Icon(Icons.location_on, color: Colors.red[600], size: 30),
            city,
          );
          _mapController!.updateMarkers(<int>[1]);
        });
        break;
      case 3:
        setState(() {
          _routeJson = 'assets/london_to_chessington.json';
          _zoomPanBehavior.focalLatLng = const MapLatLng(51.4050, -0.4300);
          _zoomPanBehavior.zoomLevel = 10;
          _routes[1] = _RouteDetails(
            const MapLatLng(51.3472, -0.3192),
            Icon(Icons.location_on, color: Colors.red[600], size: 30),
            city,
          );
          _mapController!.updateMarkers(<int>[1]);
        });
        break;
      case 4:
        setState(() {
          _routeJson = 'assets/london_to_hampton_court_palace.json';
          _zoomPanBehavior.focalLatLng = const MapLatLng(51.4500, -0.4393);
          _zoomPanBehavior.zoomLevel = 11;
          _routes[1] = _RouteDetails(
            const MapLatLng(51.4036, -0.3378),
            Icon(Icons.location_on, color: Colors.red[600], size: 30),
            city,
          );
          _mapController!.updateMarkers(<int>[1]);
        });
        break;
    }
  }
}

class _RouteDetails {
  _RouteDetails(this.latLan, this.icon, this.city);

  MapLatLng latLan;
  Widget? icon;
  String city;
}
