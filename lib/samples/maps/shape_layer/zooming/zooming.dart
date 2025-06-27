///Dart import
import 'dart:async';

///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map zooming sample.
class MapZoomingPage extends SampleView {
  /// Creates the map zooming sample.
  const MapZoomingPage(Key key) : super(key: key);

  @override
  _MapZoomingPageState createState() => _MapZoomingPageState();
}

class _MapZoomingPageState extends SampleViewState {
  final double _markerSize = 24;

  late MapShapeSource _mapSource;

  late List<_CountryColor> _countryColors;

  late List<_TouristPlaceDetails> _touristPlaces;

  late MapZoomPanBehavior _zoomPanBehavior;

  Timer? _tooltipTimer;

  @override
  void initState() {
    _zoomPanBehavior = MapZoomPanBehavior();

    _touristPlaces = <_TouristPlaceDetails>[
      const _TouristPlaceDetails(
        MapLatLng(-25.6953, -54.4367),
        'Iguazu Falls, Argentina',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-50.9423, -73.4068),
        'Torres del Paine National Park, Patagonia, Chile',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-15.9254, -69.3354),
        'Lake Titicaca, Bolivia',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-13.1631, -72.5450),
        'Machu Picchu, Peru',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-0.1862504, -78.5706247),
        'The Amazon via Quito, Ecuador',
      ),
      const _TouristPlaceDetails(
        MapLatLng(5.9701, -62.5362),
        'Angel Falls, Venezuela',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-14.0875, -75.7626),
        'Huacachina, Peru',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-25.2637, -57.5759),
        'Asuncion, Paraguay',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-33.0472, -71.6127),
        'Valparaiso, Chile',
      ),
      const _TouristPlaceDetails(
        MapLatLng(0.8056, -77.5858),
        'Santuario de las lajas, Colombia',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-19.5723, -65.7550),
        'Potosi, Bolivia',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-27.5986, -48.5187),
        'Florianopolis, Brazil',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-22.7953, -67.8361),
        'Laguna Verde, Bolivia',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-50.5025092, -73.1997346),
        'Perito Moreno, Venezuela',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-22.9068, -43.1729),
        'Rio de Janeiro, Brazil',
      ),
      const _TouristPlaceDetails(
        MapLatLng(5.1765, -59.4808),
        'Kaieteur Falls, Guyana',
      ),
      const _TouristPlaceDetails(MapLatLng(-13.5320, -71.9675), 'Cusco, Peru'),
      const _TouristPlaceDetails(
        MapLatLng(-34.6037, -58.3816),
        'Buenos Aires, Argentina',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-23.5505, -46.6333),
        'Sao Paulo, Brazil',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-2.7956, -40.5142),
        'Jericoacoara, Brazil',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-33.4489, -70.6693),
        'Santiago, Chile',
      ),
      const _TouristPlaceDetails(
        MapLatLng(4.7110, -74.0721),
        'Bogota, Colombia',
      ),
      const _TouristPlaceDetails(
        MapLatLng(-1.3928, -78.4269),
        'Banos, Ecuador',
      ),
    ];

    _countryColors = <_CountryColor>[
      const _CountryColor('Argentina', Color.fromRGBO(227, 176, 130, 1)),
      const _CountryColor('Bolivia', Color.fromRGBO(242, 214, 70, 1)),
      const _CountryColor('Brazil', Color.fromRGBO(223, 147, 46, 1)),
      const _CountryColor('Chile', Color.fromRGBO(141, 143, 166, 1)),
      const _CountryColor('Colombia', Color.fromRGBO(179, 208, 251, 1)),
      const _CountryColor('Ecuador', Color.fromRGBO(242, 223, 224, 1)),
      const _CountryColor('Falkland Is.', Color.fromRGBO(198, 191, 147, 1)),
      const _CountryColor('Guyana', Color.fromRGBO(211, 120, 120, 1)),
      const _CountryColor('Peru', Color.fromRGBO(185, 244, 127, 1)),
      const _CountryColor('Paraguay', Color.fromRGBO(179, 208, 251, 1)),
      const _CountryColor('Venezuela', Color.fromRGBO(141, 208, 203, 1)),
    ];

    _mapSource = MapShapeSource.asset(
      'assets/south_america.json',
      shapeDataField: 'name',
      dataCount: _countryColors.length,
      primaryValueMapper: (int index) => _countryColors[index].country,
      shapeColorValueMapper: (int index) => _countryColors[index].color,
    );

    super.initState();
  }

  @override
  void dispose() {
    _touristPlaces.clear();
    _countryColors.clear();
    _tooltipTimer?.cancel();
    _tooltipTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    final Color surfaceColor = isLightTheme
        ? const Color.fromRGBO(45, 45, 45, 1)
        : const Color.fromRGBO(242, 242, 242, 1);
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
        return Container(
          padding: scrollEnabled
              ? EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.05,
                )
              : const EdgeInsets.only(top: 10, bottom: 15),
          child: SfMapsTheme(
            data: SfMapsThemeData(
              shapeHoverColor: Colors.transparent,
              shapeHoverStrokeColor: Colors.grey[700],
              shapeHoverStrokeWidth: 1.5,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Align(
                    child: Text(
                      'Tourist Places in South America',
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
                        color: Colors.white,
                        strokeColor: const Color.fromRGBO(242, 242, 242, 1),
                        strokeWidth: 1,
                        source: _mapSource,
                        showDataLabels: true,
                        dataLabelSettings: const MapDataLabelSettings(
                          overflowMode: MapLabelOverflow.ellipsis,
                          textStyle: TextStyle(
                            color: Color.fromRGBO(45, 45, 45, 1),
                          ),
                        ),
                        tooltipSettings: MapTooltipSettings(
                          color: surfaceColor,
                        ),
                        initialMarkersCount: _touristPlaces.length,
                        markerTooltipBuilder:
                            (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _touristPlaces[index].place,
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(
                                        color: isLightTheme
                                            ? const Color.fromRGBO(
                                                255,
                                                255,
                                                255,
                                                1,
                                              )
                                            : const Color.fromRGBO(
                                                10,
                                                10,
                                                10,
                                                1,
                                              ),
                                      ),
                                ),
                              );
                            },
                        markerBuilder: (BuildContext context, int index) {
                          return MapMarker(
                            latitude: _touristPlaces[index].latLng.latitude,
                            longitude: _touristPlaces[index].latLng.longitude,
                            offset: Offset(0, -_markerSize / 2),
                            size: Size(_markerSize, _markerSize * 2),
                            child: Icon(
                              Icons.location_on,
                              color: isLightTheme
                                  ? const Color.fromRGBO(45, 45, 45, 1)
                                  : const Color.fromRGBO(199, 42, 89, 1),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TouristPlaceDetails {
  const _TouristPlaceDetails(this.latLng, this.place);

  final MapLatLng latLng;

  final String place;
}

class _CountryColor {
  const _CountryColor(this.country, this.color);

  final String country;

  final Color color;
}
