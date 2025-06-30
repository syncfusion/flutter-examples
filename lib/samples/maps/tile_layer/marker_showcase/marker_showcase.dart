/// Flutter package imports.
import 'package:flutter/material.dart';

/// Map import.
import 'package:syncfusion_flutter_maps/maps.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the map widget with custom bounds.
class DraggableMarker extends SampleView {
  /// Creates the map widget with custom bounds.
  const DraggableMarker(Key key) : super(key: key);

  @override
  _DraggableMarkerState createState() => _DraggableMarkerState();
}

class _DraggableMarkerState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late List<MapLatLng> _markersLatLng;
  late MapTileLayerController _tileLayerController;
  late AnimationController _animationController;
  late CurvedAnimation _animation;
  int _selectedIndex = -1;
  int _previousSelectedIndex = -1;

  @override
  void initState() {
    _tileLayerController = MapTileLayerController();
    _markersLatLng = <MapLatLng>[];
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 0.1,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    super.initState();
  }

  void _addMarker(Offset position) {
    // We have converted the local point into latlng and inserted marker
    // in that position.
    final MapLatLng markerPosition = _tileLayerController.pixelToLatLng(
      position,
    );
    _markersLatLng.add(markerPosition);
    _previousSelectedIndex = _selectedIndex;
    _selectedIndex = _tileLayerController.markersCount;
    _tileLayerController.insertMarker(_tileLayerController.markersCount);
    if (_previousSelectedIndex != -1) {
      _tileLayerController.updateMarkers(<int>[_previousSelectedIndex]);
    }
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _tileLayerController.dispose();
    _markersLatLng.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'images/maps_grid.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        GestureDetector(
          onTapUp: (TapUpDetails details) {
            _addMarker(details.localPosition);
          },
          child: _buildMapsWidget(),
        ),
      ],
    );
  }

  Widget _buildMapsWidget() {
    return SfMaps(
      layers: <MapLayer>[
        MapTileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          initialZoomLevel: 4,
          initialFocalLatLng: const MapLatLng(28.0, 77.0),
          controller: _tileLayerController,
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
              latitude: _markersLatLng[index].latitude,
              longitude: _markersLatLng[index].longitude,
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  final RenderBox markerRenderBox =
                      context.findRenderObject()! as RenderBox;
                  final MapLatLng latLng = _tileLayerController.pixelToLatLng(
                    markerRenderBox.globalToLocal(details.globalPosition),
                  );
                  _markersLatLng[index] = MapLatLng(
                    latLng.latitude,
                    latLng.longitude,
                  );
                  _tileLayerController.updateMarkers(<int>[index]);
                },
                child: _selectedIndex == index
                    ? ScaleTransition(
                        alignment: Alignment.bottomCenter,
                        scale: _animation,
                        child: Icon(
                          Icons.location_on,
                          color:
                              Colors.accents[(index % Colors.accents.length)],
                          size: 30,
                        ),
                      )
                    : Icon(
                        Icons.location_on,
                        color: Colors.accents[(index % Colors.accents.length)],
                        size: 30,
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
