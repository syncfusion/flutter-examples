/// Flutter package imports.
import 'package:flutter/material.dart';

/// Map import.
import 'package:syncfusion_flutter_maps/maps.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the map widget with custom bounds.
class MapCustomBounds extends SampleView {
  /// Creates the map widget with custom bounds.
  const MapCustomBounds(Key key) : super(key: key);

  @override
  _MapCustomBoundsState createState() => _MapCustomBoundsState();
}

class _MapCustomBoundsState extends SampleViewState {
  late List<_TouristPlaceDetails> _touristPlaces;
  late MapZoomPanBehavior _zoomPanBehavior;
  bool _canFitMarkers = false;

  @override
  void initState() {
    _zoomPanBehavior = MapZoomPanBehavior(
      showToolbar: false,
      enableDoubleTapZooming: true,
      minZoomLevel: 2,
      maxZoomLevel: 12,
    );
    _touristPlaces = <_TouristPlaceDetails>[
      const _TouristPlaceDetails(
          MapLatLng(5.9701, -62.5362), 'Angel Falls, Venezuela'),
      const _TouristPlaceDetails(
          MapLatLng(-22.9519, -43.2105), 'Christ the Redeemer, Brazil'),
      const _TouristPlaceDetails(
          MapLatLng(-25.6953, -54.4367), 'Iguazu Falls, Argentina'),
      const _TouristPlaceDetails(
          MapLatLng(-32.6532, -70.0109), 'Aconcagua, Argentina'),
      const _TouristPlaceDetails(MapLatLng(-50.9423, -73.4068),
          'Torres del Paine National Park, Chile'),
      const _TouristPlaceDetails(
          MapLatLng(-20.1338, -67.4891), 'Uyuni Salt Flat, Bolivia'),
      const _TouristPlaceDetails(
          MapLatLng(-15.6093, -72.0896), 'Colca Canyon, Peru'),
      const _TouristPlaceDetails(
          MapLatLng(-13.3328, -72.0845), 'Sacred Valley, Peru'),
      const _TouristPlaceDetails(
          MapLatLng(-13.1631, -72.5450), 'Machu Picchu, Peru'),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _touristPlaces.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
        child: Image.asset(
          'images/maps_grid.png',
          repeat: ImageRepeat.repeat,
        ),
      ),
      _buildMapsWidget(),
    ]);
  }

  Widget _buildMapsWidget() {
    return SfMaps(
      layers: <MapLayer>[
        MapTileLayer(
          /// URL to request the tiles from the providers.
          ///
          /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} —
          /// zoom level, {x} and {y} — tile coordinates.
          ///
          /// We will replace the {z}, {x}, {y} internally based on the
          /// current center point and the zoom level.
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          zoomPanBehavior: _zoomPanBehavior,
          initialMarkersCount: _touristPlaces.length,
          tooltipSettings: const MapTooltipSettings(
            color: Color.fromRGBO(45, 45, 45, 1),
          ),
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
                latitude: _touristPlaces[index].latLng.latitude,
                longitude: _touristPlaces[index].latLng.longitude,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 20,
                ));
          },
          markerTooltipBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _touristPlaces[index].place,
                style: model.themeData.textTheme.caption!.copyWith(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return SingleChildScrollView(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Fit markers',
                style: TextStyle(
                  color: model.textColor,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
                width: 90,
                child: CheckboxListTile(
                    activeColor: model.backgroundColor,
                    value: _canFitMarkers,
                    onChanged: (bool? value) {
                      _canFitMarkers = value!;
                      if (_canFitMarkers) {
                        // South America bounds.
                        _zoomPanBehavior.latLngBounds = const MapLatLngBounds(
                            MapLatLng(8.434375, -34.80546874999999),
                            MapLatLng(-59.891699218750006, -91.654150390625));
                      } else {
                        // World bounds.
                        _zoomPanBehavior.latLngBounds = const MapLatLngBounds(
                            MapLatLng(-90.0, -180.0), MapLatLng(90.0, 180.0));
                      }
                      stateSetter(() {});
                    })),
          ],
        ),
      );
    });
  }
}

class _TouristPlaceDetails {
  const _TouristPlaceDetails(this.latLng, this.place);

  final MapLatLng latLng;

  final String place;
}
