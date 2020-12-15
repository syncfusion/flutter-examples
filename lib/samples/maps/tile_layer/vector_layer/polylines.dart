/// Flutter package imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

class MapPolylinesPage extends SampleView {
  const MapPolylinesPage(Key key) : super(key: key);
  _PolylinesSampleState createState() => _PolylinesSampleState();
}

class _PolylinesSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  MapZoomPanBehavior _zoomPanBehavior;
  MapTileLayerController _mapController;
  AnimationController _animationController;
  Animation _animation;
  bool _isDesktop;
  List<MarkerData> _markerData;
  int _currentSelectedCityIndex = 0;
  String _routeJson;

  @override
  void initState() {
    _routeJson = 'assets/london_to_british.json';
    _markerData = <MarkerData>[
      MarkerData(MapLatLng(51.4700, -0.4543), null, 'London Heathrow'),
      MarkerData(
          MapLatLng(51.5194, -0.1270),
          Icon(Icons.location_on, color: Colors.red[600], size: 30),
          'The British Museum'),
    ];
    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
        minZoomLevel: 3,
        zoomLevel: 10,
        focalLatLng: MapLatLng(51.4700, -0.2843),
        toolbarSettings: MapToolbarSettings(
            direction: Axis.vertical, position: MapToolbarPosition.bottomRight),
        maxZoomLevel: 15);

    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _mapController?.dispose();
    _markerData?.clear();
    super.dispose();
  }

  Future<dynamic> getJsonData() async {
    List<MapLatLng> polyline = <MapLatLng>[];
    String data = await rootBundle.loadString(_routeJson);
    dynamic jsonData = json.decode(data);
    List<dynamic> polylinePoints =
        jsonData['features'][0]['geometry']['coordinates'];
    for (int i = 0; i < polylinePoints.length; i++) {
      polyline.add(MapLatLng(polylinePoints[i][1], polylinePoints[i][0]));
    }
    _animationController.forward(from: 0);

    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    return FutureBuilder(
        future: getJsonData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapdata) {
          if (snapdata.hasData) {
            final List<MapLatLng> polylinePoints = snapdata.data;
            return Stack(children: [
              Positioned.fill(
                child: Image.asset(
                  'images/maps_grid.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
              SfMaps(
                layers: [
                  MapTileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    initialMarkersCount: _markerData.length,
                    controller: _mapController,
                    markerBuilder: (BuildContext context, int index) {
                      if (_markerData[index].icon != null) {
                        return MapMarker(
                          key: UniqueKey(),
                          latitude: _markerData[index].latLan.latitude,
                          longitude: _markerData[index].latLan.longitude,
                          child: _markerData[index].icon,
                        );
                      } else {
                        return MapMarker(
                          key: UniqueKey(),
                          latitude: _markerData[index].latLan.latitude,
                          longitude: _markerData[index].latLan.longitude,
                          iconType: MapIconType.circle,
                          iconColor: Colors.white,
                          iconStrokeWidth: 2.0,
                          size: Size(15, 15),
                          iconStrokeColor: Colors.black,
                        );
                      }
                    },
                    tooltipSettings: MapTooltipSettings(
                      color: Color.fromRGBO(45, 45, 45, 1),
                    ),
                    markerTooltipBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_markerData[index].city,
                            style: model.themeData.textTheme.caption.copyWith(
                                color: Color.fromRGBO(255, 255, 255, 1))),
                      );
                    },
                    sublayers: [
                      MapPolylineLayer(
                          polylines: [
                            MapPolyline(
                              points: polylinePoints,
                              color: Color.fromRGBO(0, 102, 255, 1.0),
                              width: 6.0,
                            )
                          ].toSet(),
                          animation: _animation,
                          tooltipBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  _markerData[0].city +
                                      ' - ' +
                                      _markerData[1].city,
                                  style: model.themeData.textTheme.caption
                                      .copyWith(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 1))),
                            );
                          }),
                    ],
                    zoomPanBehavior: _zoomPanBehavior,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getChipWidget(0, 'The British Museum'),
                      _getChipWidget(1, 'The Windsor Castle'),
                      _getChipWidget(2, 'Twickenham Stadium'),
                      _getChipWidget(3, 'Chessington World of Adventures'),
                      _getChipWidget(4, 'Hampton Court Palace'),
                    ],
                  ),
                ),
              )
            ]);
          } else {
            return Container();
          }
        });
  }

  Widget _getChipWidget(int index, String city) {
    return Padding(
      padding: _isDesktop
          ? const EdgeInsets.only(left: 8.0, top: 8.0)
          : const EdgeInsets.only(left: 8.0),
      child: ChoiceChip(
        backgroundColor: model?.themeData?.brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        elevation: 3.0,
        label: Text(
          city,
          style: TextStyle(
            color: model.textColor,
          ),
        ),
        selected: _currentSelectedCityIndex == index,
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
          _zoomPanBehavior.focalLatLng = MapLatLng(51.4700, -0.2843);
          _zoomPanBehavior.zoomLevel = 10;
          _markerData[1] = MarkerData(MapLatLng(51.5194, -0.1270),
              Icon(Icons.location_on, color: Colors.red[600], size: 30), city);
          _mapController.updateMarkers([1]);
        });
        break;
      case 1:
        setState(() {
          _routeJson = 'assets/london_to_windsor_castle.json';
          _zoomPanBehavior.focalLatLng = MapLatLng(51.4700, -0.5443);
          _zoomPanBehavior.zoomLevel = 11;
          _markerData[1] = MarkerData(MapLatLng(51.4839, -0.6044),
              Icon(Icons.location_on, color: Colors.red[600], size: 30), city);
          _mapController.updateMarkers([1]);
        });
        break;
      case 2:
        setState(() {
          _routeJson = 'assets/london_to_twickenham_stadium.json';
          _zoomPanBehavior.focalLatLng = MapLatLng(51.4700, -0.3843);
          _zoomPanBehavior.zoomLevel = 11;
          _markerData[1] = MarkerData(MapLatLng(51.4560, -0.3415),
              Icon(Icons.location_on, color: Colors.red[600], size: 30), city);
          _mapController.updateMarkers([1]);
        });
        break;
      case 3:
        setState(() {
          _routeJson = 'assets/london_to_chessington.json';
          _zoomPanBehavior.focalLatLng = MapLatLng(51.4050, -0.4300);
          _zoomPanBehavior.zoomLevel = 10;
          _markerData[1] = MarkerData(MapLatLng(51.3472, -0.3192),
              Icon(Icons.location_on, color: Colors.red[600], size: 30), city);
          _mapController.updateMarkers([1]);
        });
        break;
      case 4:
        setState(() {
          _routeJson = 'assets/london_to_hampton_court_palace.json';
          _zoomPanBehavior.focalLatLng = MapLatLng(51.4500, -0.4393);
          _zoomPanBehavior.zoomLevel = 11;
          _markerData[1] = MarkerData(MapLatLng(51.4036, -0.3378),
              Icon(Icons.location_on, color: Colors.red[600], size: 30), city);
          _mapController.updateMarkers([1]);
        });
        break;
    }
  }
}

class MarkerData {
  MarkerData(this.latLan, this.icon, this.city);

  MapLatLng latLan;
  Widget icon;
  String city;
}
