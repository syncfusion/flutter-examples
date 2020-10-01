///Dart import
import 'dart:async';

///Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: unused_import
import 'package:flutter/gestures.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../../../model/sample_view.dart';

class MapZoomingPage extends SampleView {
  const MapZoomingPage(Key key) : super(key: key);
  @override
  _MapZoomingPageState createState() => _MapZoomingPageState();
}

class _MapZoomingPageState extends SampleViewState {
  final double _markerSize = 24;

  MapShapeLayerDelegate _mapDelegate;

  List<CountryModel> _dataSource;

  List<TouristPlaceModel> _markerSource;

  MapZoomPanBehavior _zoomPanBehavior;

  Timer _tooltipTimer;

  @override
  void initState() {
    _zoomPanBehavior = MapZoomPanBehavior();

    _markerSource = <TouristPlaceModel>[
      TouristPlaceModel(
          MapLatLng(-25.6953, -54.4367), 'Iguazu Falls, Argentina'),
      TouristPlaceModel(MapLatLng(-50.9423, -73.4068),
          'Torres del Paine National Park, Patagonia, Chile'),
      TouristPlaceModel(
          MapLatLng(-15.9254, -69.3354), 'Lake Titicaca, Bolivia'),
      TouristPlaceModel(MapLatLng(-13.1631, -72.5450), 'Machu Picchu, Peru'),
      TouristPlaceModel(
          MapLatLng(-0.1862504, -78.5706247), 'The Amazon via Quito, Ecuador'),
      TouristPlaceModel(MapLatLng(5.9701, -62.5362), 'Angel Falls, Venezuela'),
      TouristPlaceModel(MapLatLng(-14.0875, -75.7626), 'Huacachina, Peru'),
      TouristPlaceModel(MapLatLng(-25.2637, -57.5759), 'Asuncion, Paraguay'),
      TouristPlaceModel(MapLatLng(-33.0472, -71.6127), 'Valparaiso, Chile'),
      TouristPlaceModel(
          MapLatLng(0.8056, -77.5858), 'Santuario de las lajas, Colombia'),
      TouristPlaceModel(MapLatLng(-19.5723, -65.7550), 'Potosi, Bolivia'),
      TouristPlaceModel(MapLatLng(-27.5986, -48.5187), 'Florianopolis, Brazil'),
      TouristPlaceModel(MapLatLng(-22.7953, -67.8361), 'Laguna Verde, Bolivia'),
      TouristPlaceModel(
          MapLatLng(-50.5025092, -73.1997346), 'Perito Moreno, Venezuela'),
      TouristPlaceModel(
          MapLatLng(-22.9068, -43.1729), 'Rio de Janeiro, Brazil'),
      TouristPlaceModel(MapLatLng(5.1765, -59.4808), 'Kaieteur Falls, Guyana'),
      TouristPlaceModel(MapLatLng(-13.5320, -71.9675), 'Cusco, Peru'),
      TouristPlaceModel(
          MapLatLng(-34.6037, -58.3816), 'Buenos Aires, Argentina'),
      TouristPlaceModel(MapLatLng(-23.5505, -46.6333), 'Sao Paulo, Brazil'),
      TouristPlaceModel(MapLatLng(-2.7956, -40.5142), 'Jericoacoara, Brazil'),
      TouristPlaceModel(MapLatLng(-33.4489, -70.6693), 'Santiago, Chile'),
      TouristPlaceModel(MapLatLng(4.7110, -74.0721), 'Bogota, Colombia'),
      TouristPlaceModel(MapLatLng(-1.3928, -78.4269), 'Banos, Ecuador'),
    ];

    _dataSource = <CountryModel>[
      CountryModel('Argentina', Color.fromRGBO(227, 176, 130, 1)),
      CountryModel('Bolivia', Color.fromRGBO(242, 214, 70, 1)),
      CountryModel('Brazil', Color.fromRGBO(223, 147, 46, 1)),
      CountryModel('Chile', Color.fromRGBO(141, 143, 166, 1)),
      CountryModel('Colombia', Color.fromRGBO(179, 208, 251, 1)),
      CountryModel('Ecuador', Color.fromRGBO(242, 223, 224, 1)),
      CountryModel('Falkland Is.', Color.fromRGBO(198, 191, 147, 1)),
      CountryModel('Guyana', Color.fromRGBO(211, 120, 120, 1)),
      CountryModel('Peru', Color.fromRGBO(185, 244, 127, 1)),
      CountryModel('Paraguay', Color.fromRGBO(179, 208, 251, 1)),
      CountryModel('Venezuela', Color.fromRGBO(141, 208, 203, 1)),
    ];

    _mapDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/south_america.json',
      shapeDataField: 'name',
      dataCount: _dataSource.length,
      primaryValueMapper: (int index) => _dataSource[index].country,
      shapeColorValueMapper: (int index) => _dataSource[index].color,
    );

    super.initState();
  }

  @override
  void dispose() {
    _markerSource?.clear();
    _dataSource?.clear();
    _tooltipTimer?.cancel();
    _tooltipTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme = themeData.brightness == Brightness.light;
    final Color surfaceColor = isLightTheme
        ? Color.fromRGBO(45, 45, 45, 1)
        : Color.fromRGBO(242, 242, 242, 1);
    return FutureBuilder<dynamic>(
      future: Future<dynamic>.delayed(
        Duration(milliseconds: kIsWeb ? 0 : 500),
        () => 'Loaded',
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Container(
                padding: MediaQuery.of(context).orientation ==
                            Orientation.portrait ||
                        kIsWeb
                    ? EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.05)
                    : const EdgeInsets.only(top: 10, bottom: 15),
                child: SfMapsTheme(
                  data: SfMapsThemeData(
                    shapeHoverColor: Colors.transparent,
                    shapeHoverStrokeColor: Colors.grey[700],
                    shapeHoverStrokeWidth: 1.5,
                  ),
                  child: SfMaps(
                    title: MapTitle(
                      text: 'Tourist Places in South America',
                      padding: EdgeInsets.only(top: 15, bottom: 30),
                    ),
                    layers: [
                      MapShapeLayer(
                        color: Colors.white,
                        strokeColor: Color.fromRGBO(242, 242, 242, 1),
                        strokeWidth: 1,
                        delegate: _mapDelegate,
                        showDataLabels: true,
                        dataLabelSettings: MapDataLabelSettings(
                          overflowMode: MapLabelOverflowMode.trim,
                          textStyle: TextStyle(
                            color: Color.fromRGBO(45, 45, 45, 1),
                          ),
                        ),
                        initialMarkersCount: _markerSource.length,
                        markerBuilder: (BuildContext context, int index) {
                          /// This key will be used to show the framework's
                          /// tooltip during interaction.
                          final GlobalKey tooltipKey = GlobalKey();
                          return MapMarker(
                            latitude: _markerSource[index].latLng.latitude,
                            longitude: _markerSource[index].latLng.longitude,
                            size: Size(_markerSize, _markerSize * 2),
                            child: Column(
                              children: [
                                MouseRegion(
                                  child: GestureDetector(
                                    child: Tooltip(
                                      key: tooltipKey,
                                      message: _markerSource[index].place,
                                      preferBelow: false,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        color: surfaceColor,
                                      ),
                                      textStyle:
                                          themeData.textTheme.caption.copyWith(
                                        color: isLightTheme
                                            ? Color.fromRGBO(255, 255, 255, 1)
                                            : Color.fromRGBO(10, 10, 10, 1),
                                      ),
                                      waitDuration: Duration(milliseconds: 0),
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.location_on,
                                          color: isLightTheme
                                              ? Color.fromRGBO(45, 45, 45, 1)
                                              : Color.fromRGBO(199, 42, 89, 1),
                                        ),
                                        onTap: () {
                                          _showTooltip(tooltipKey);
                                        },
                                      ),
                                    ),
                                  ),

                                  /// On hovering the marker, we will show the
                                  /// framework's tooltip to show the details
                                  /// about that place.
                                  onHover: (PointerHoverEvent event) {
                                    _showTooltip(tooltipKey);
                                  },
                                ),
                                SizedBox(
                                  height: _markerSize,
                                ),
                              ],
                            ),
                          );
                        },

                        /// Adding `zoomPanBehavior` will enable the zooming and
                        /// panning in the shape layer.
                        zoomPanBehavior: _zoomPanBehavior,
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Container(
                  height: 25,
                  width: 25,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
              );
      },
    );
  }

  void _showTooltip(GlobalKey tooltipKey) {
    _tooltipTimer?.cancel();
    _tooltipTimer =
        Timer(const Duration(seconds: 3), () => _hideTooltip(tooltipKey));
    final dynamic tooltipState = tooltipKey.currentState;
    tooltipState.ensureTooltipVisible();
  }

  void _hideTooltip(GlobalKey tooltipKey) {
    final dynamic tooltipState = tooltipKey.currentState;
    tooltipState.deactivate();
  }
}

class TouristPlaceModel {
  const TouristPlaceModel(this.latLng, this.place);

  final MapLatLng latLng;

  final String place;
}

class CountryModel {
  const CountryModel(this.country, this.color);

  final String country;

  final Color color;
}
