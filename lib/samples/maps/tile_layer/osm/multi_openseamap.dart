import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MultiLayerMap extends StatefulWidget {
  const MultiLayerMap(Key key) : super(key: key);
  _MultiLayerMapState createState() => _MultiLayerMapState();
}

class _MultiLayerMapState extends State<MultiLayerMap> {
  @override
  Widget build(BuildContext context) {
    final _mapController = MapTileLayerController();
    final _zoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 14,
      focalLatLng: MapLatLng(54.19202, 12.08772),
    );
    return Stack(
      children: [
        SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              zoomPanBehavior: _zoomPanBehavior,
              controller: _mapController,
            ),
            MapTileLayer(
              urlTemplate:
                  'https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png',
              zoomPanBehavior: _zoomPanBehavior,
              controller: _mapController,
            ),
          ],
        ),
      ],
    );
  }
}
