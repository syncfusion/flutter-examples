///Flutter package imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with sublayer
class MapSublayerPage extends SampleView {
  /// Creates the map widget with sublayer
  const MapSublayerPage(Key key) : super(key: key);

  @override
  _MapSublayerPageState createState() => _MapSublayerPageState();
}

class _MapSublayerPageState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late MapShapeSource _mapSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late bool _isDesktop;
  late List<String> _state;
  late ThemeData _themeData;

  @override
  void initState() {
    super.initState();

    _state = [
      'New South Wales',
      'Victoria',
      'Queensland',
      'South Australia',
      'Western Australia',
      'Northern Territory'
    ];

    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/australia.json',
      // Field or group name in the .json file to identify the shapes.
      //
      // Which is used to map the respective shape to data source.
      //
      // On the basis of this value, shape tooltip text is rendered.
      shapeDataField: 'STATE_NAME',
      primaryValueMapper: (index) => _state[index],
      dataCount: _state.length,
      dataLabelMapper: (index) => index == 0 ? 'NSW' : _state[index],
    );

    _zoomPanBehavior = MapZoomPanBehavior();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<List<MapLatLng>>> getJsonData() async {
    final List<List<MapLatLng>> polylines = <List<MapLatLng>>[];
    final String data = await rootBundle.loadString('assets/river.json');
    final dynamic jsonData = json.decode(data);

    final int length = (jsonData['geometries']).length;
    for (int i = 0; i < length; i++) {
      List<dynamic> polylineData;
      if (jsonData['geometries'][i]['type'] == 'LineString') {
        final List<MapLatLng> riverPoints = <MapLatLng>[];
        polylineData = jsonData['geometries'][i]['coordinates'];
        for (int j = 0; j < polylineData.length; j++) {
          riverPoints.add(MapLatLng(polylineData[j][1], polylineData[j][0]));
        }
        polylines.add(riverPoints);
      } else {
        polylineData = <dynamic>[];
        final int length = (jsonData['geometries'][i]['coordinates']).length;
        for (int j = 0; j < length; j++) {
          polylineData.add(jsonData['geometries'][i]['coordinates'][j]);
        }

        for (int k = 0; k < polylineData.length; k++) {
          final List<MapLatLng> riverPoints = <MapLatLng>[];
          for (int index = 0; index < polylineData[k].length; index++) {
            riverPoints.add(MapLatLng(
                polylineData[k][index][1], polylineData[k][index][0]));
          }
          polylines.add(riverPoints);
        }
      }
    }

    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    _isDesktop = model.isWebFullView ||
        _themeData.platform == TargetPlatform.macOS ||
        _themeData.platform == TargetPlatform.windows ||
        _themeData.platform == TargetPlatform.linux;
    return Scaffold(
        backgroundColor:
            _isDesktop ? model.cardThemeColor : model.cardThemeColor,
        body: MediaQuery.of(context).orientation == Orientation.portrait ||
                _isDesktop
            ? _buildMapsWidget()
            : SingleChildScrollView(child: _buildMapsWidget()));
  }

  Widget _buildMapsWidget() {
    final bool isLightTheme = _themeData.brightness == Brightness.light;
    return FutureBuilder(
        future: getJsonData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
          if (snapchat.hasData) {
            final List<List<MapLatLng>> polylines = snapchat.data;
            return Center(
                child: Padding(
              padding:
                  MediaQuery.of(context).orientation == Orientation.portrait ||
                          _isDesktop
                      ? EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.05,
                          right: 10,
                        )
                      : const EdgeInsets.only(right: 10, bottom: 15),
              child: SfMapsTheme(
                data: SfMapsThemeData(
                  shapeHoverColor: Colors.transparent,
                  shapeHoverStrokeColor: Colors.transparent,
                ),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 30),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('Rivers in Australia',
                              style: Theme.of(context).textTheme.subtitle1))),
                  Expanded(
                      child: SfMaps(
                    layers: <MapLayer>[
                      MapShapeLayer(
                        source: _mapSource,
                        color: isLightTheme
                            ? const Color.fromRGBO(254, 246, 214, 1.0)
                            : const Color.fromRGBO(142, 197, 128, 1.0),
                        zoomPanBehavior: _zoomPanBehavior,
                        strokeWidth: 1.0,
                        strokeColor: isLightTheme
                            ? const Color.fromRGBO(205, 195, 152, 0.5)
                            : const Color.fromRGBO(117, 156, 22, 1.0),
                        loadingBuilder: (BuildContext context) {
                          return Container(
                            height: 25,
                            width: 25,
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          );
                        },
                        tooltipSettings: MapTooltipSettings(
                          color: isLightTheme
                              ? Color.fromRGBO(45, 45, 45, 1)
                              : Color.fromRGBO(242, 242, 242, 1),
                          strokeColor: isLightTheme
                              ? Color.fromRGBO(242, 242, 242, 1)
                              : Color.fromRGBO(45, 45, 45, 1),
                        ),
                        showDataLabels: true,
                        dataLabelSettings: MapDataLabelSettings(
                          overflowMode: MapLabelOverflow.visible,
                          textStyle: _themeData.textTheme.caption!.copyWith(
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        sublayers: [
                          MapPolylineLayer(
                            polylines: List<MapPolyline>.generate(
                              polylines.length,
                              (int index) {
                                return MapPolyline(
                                  points: polylines[index],
                                  color: isLightTheme
                                      ? Color.fromRGBO(0, 168, 204, 1.0)
                                      : Color.fromRGBO(11, 138, 255, 1.0),
                                  width: 2.0,
                                );
                              },
                            ).toSet(),
                            tooltipBuilder: (BuildContext context, int index) {
                              final String? tooltipText =
                                  _getTooltipText(index);
                              if (tooltipText != null) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(tooltipText,
                                      style: model.themeData.textTheme.caption!
                                          .copyWith(
                                              color: isLightTheme
                                                  ? Color.fromRGBO(
                                                      255, 255, 255, 1)
                                                  : Color.fromRGBO(
                                                      10, 10, 10, 1))),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
                ]),
              ),
            ));
          } else {
            return Container();
          }
        });
  }

  String? _getTooltipText(int index) {
    if (index == 0) {
      return 'Gwydir';
    } else if (index == 1) {
      return 'Brisbane';
    } else if (index == 2) {
      return 'Swan';
    } else if (index > 2 && index < 6) {
      return 'Ord';
    } else if (index == 6 || index == 9) {
      return 'Daly';
    } else if (index == 7) {
      return 'Staaten';
    } else if (index > 9 && index < 13) {
      return 'Lachian';
    } else if (index > 12 && index < 24) {
      return null;
    } else if (index > 23 && index < 28) {
      return 'Macquarie';
    } else if (index == 28) {
      return 'Roper';
    } else if (index == 29) {
      return 'Burdekin';
    } else if (index > 29 && index < 48) {
      return 'Macintyre';
    } else if (index == 48) {
      return 'Vectoria';
    } else if (index == 49 || index == 72 || index == 8) {
      return 'Fitzroy';
    } else if (index == 50) {
      return 'South Esk';
    } else if (index == 51) {
      return 'Blackwood';
    } else if (index > 51 && index < 70) {
      return 'Barwon';
    } else if (index == 70) {
      return 'Darling';
    } else if (index == 71) {
      return 'Denvert';
    } else if (index > 73) {
      return 'Macintyre';
    }

    return null;
  }
}
