/// Flutter package imports.
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Map import.
import 'package:syncfusion_flutter_maps/maps.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the map widget with crosshair.
class MapCrosshairPage extends SampleView {
  /// Creates the map widget with crosshair.
  const MapCrosshairPage(Key key) : super(key: key);

  @override
  _MapCrosshairPageState createState() => _MapCrosshairPageState();
}

class _MapCrosshairPageState extends SampleViewState {
  _MapCrosshairPageState();

  late _CrosshairZoomPanBehavior _zoomPanBehavior;
  late _CrosshairTileLayerController _tileLayerController;
  late TextEditingController _textController;

  void _refresh() {
    if (mounted) {
      // Called setState to update toolbar icon when scrolling.
      setState(() {});
    }
  }

  @override
  void initState() {
    _tileLayerController = _CrosshairTileLayerController()
      ..addZoomLevelChangeListener(_refresh);
    _textController = TextEditingController();
    _zoomPanBehavior = _CrosshairZoomPanBehavior(
      _tileLayerController,
      _textController,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tileLayerController
      ..removeZoomLevelChangeListener(_refresh)
      ..dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleIncrementClicked() {
    setState(() {
      _zoomPanBehavior.zoomLevel = (_zoomPanBehavior.zoomLevel + 1).clamp(
        _zoomPanBehavior.minZoomLevel,
        _zoomPanBehavior.maxZoomLevel,
      );
    });
  }

  void _handleDecrementClicked() {
    setState(() {
      _zoomPanBehavior.zoomLevel = (_zoomPanBehavior.zoomLevel - 1).clamp(
        _zoomPanBehavior.minZoomLevel,
        _zoomPanBehavior.maxZoomLevel,
      );
    });
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
        _buildMapsWidget(),
        Positioned(
          left: 16.0,
          bottom: 16.0,
          child: IgnorePointer(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: TextField(
                controller: _textController,
                enabled: false,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.apply(color: Colors.black),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ),
        _buildToolbar(),
      ],
    );
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
          controller: _tileLayerController,
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Positioned(
      right: 8.0,
      bottom: 8.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 32,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
              onPressed: _handleIncrementClicked,
              child: Icon(
                Icons.add,
                size: 16,
                color:
                    _zoomPanBehavior.maxZoomLevel == _zoomPanBehavior.zoomLevel
                    ? model.themeData.colorScheme.primary.withValues(alpha: 0.2)
                    : model.themeData.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: 32,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
              onPressed: _handleDecrementClicked,
              child: Icon(
                Icons.remove,
                size: 16,
                color:
                    _zoomPanBehavior.minZoomLevel == _zoomPanBehavior.zoomLevel
                    ? model.themeData.colorScheme.primary.withValues(alpha: 0.2)
                    : model.themeData.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrosshairTileLayerController extends MapTileLayerController {
  ObserverList<VoidCallback>? _zoomLevelListeners =
      ObserverList<VoidCallback>();
  void addZoomLevelChangeListener(VoidCallback listener) {
    _zoomLevelListeners?.add(listener);
  }

  void removeZoomLevelChangeListener(VoidCallback listener) {
    _zoomLevelListeners?.remove(listener);
  }

  void notifyZoomLevelChangeListeners() {
    for (final VoidCallback listener in _zoomLevelListeners!) {
      listener();
    }
  }

  @override
  void dispose() {
    _zoomLevelListeners = null;
    super.dispose();
  }
}

/// Renders the crosshair.
class _CrosshairZoomPanBehavior extends MapZoomPanBehavior {
  /// Creates the instance for [_CrosshairZoomPanBehavior].
  _CrosshairZoomPanBehavior(this.tileLayerController, this.textController)
    : super(
        showToolbar: false,
        enableDoubleTapZooming: true,
        zoomLevel: 3.0,
        minZoomLevel: 3.0,
      );

  final _CrosshairTileLayerController tileLayerController;
  final TextEditingController textController;
  Offset _hoveredOffset = Offset.zero;
  bool _showCrosshair = false;

  @override
  set zoomLevel(double value) {
    if (zoomLevel == value) {
      return;
    }
    super.zoomLevel = value;
    tileLayerController.notifyZoomLevelChangeListeners();
  }

  @override
  void onPanning(MapPanDetails details) {
    textController.text = '';
    _showCrosshair = false;
    super.onPanning(details);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerHoverEvent) {
      _showCrosshair = true;
      _hoveredOffset = event.localPosition;
      final MapLatLng latLng = tileLayerController.pixelToLatLng(
        event.localPosition,
      );
      textController.text =
          'Latitude    : ${latLng.latitude}\nLongitude : ${latLng.longitude}';
    } else if (event is PointerExitEvent) {
      textController.text = '';
      _showCrosshair = false;
    }
    super.handleEvent(event);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_showCrosshair) {
      final Size size = renderBox.size;
      final Paint paint = Paint();
      const double dashWidth = 5;
      const double dashSpace = 5;
      const double space = dashSpace + dashWidth;
      double startX = 0;
      double startY = 0;

      while (startX < size.width) {
        context.canvas.drawLine(
          Offset(startX, _hoveredOffset.dy),
          Offset(startX + dashWidth, _hoveredOffset.dy),
          paint,
        );
        startX += space;
      }

      while (startY < size.height) {
        context.canvas.drawLine(
          Offset(_hoveredOffset.dx, startY),
          Offset(_hoveredOffset.dx, startY + dashWidth),
          paint,
        );
        startY += space;
      }
      super.paint(context, offset);
    }
  }
}
