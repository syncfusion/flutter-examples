import 'dart:convert';

/// Flutter package imports
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Renders the polygon map sample
class MapPolygonPage extends SampleView {
  /// Creates the polygon map sample
  const MapPolygonPage(Key key) : super(key: key);

  @override
  _MapPolygonPageState createState() => _MapPolygonPageState();
}

class _MapPolygonPageState extends SampleViewState {
  late MapZoomPanBehavior _zoomPanBehavior;
  late List<PolygonDataModel> _polygonData;
  late String _boundaryJson;
  bool _isDesktop = false;
  int _selectedIndex = 1;
  bool _isInvertedPolygon = true;
  late bool _isLightTheme;

  Widget get _expandableAnimatedButton => Padding(
    padding: EdgeInsets.all(_isDesktop ? 8.0 : 10.0),
    child: ExpandableAnimatedButton(
      dataCount: _polygonData.length,
      builder: (int index, BuildContext context) {
        return _ExpandedButton(
          text: _polygonData[index].name,
          color: _polygonData[index].color,
          textStyle: const TextStyle(color: Colors.white),
          size: 35,
          isSelected: index == _selectedIndex,
          opacity: 1.0,
          onSelectionChanged: (bool isSelected) {
            setState(() {
              _selectedIndex = index;
              if (index == 0) {
                _boundaryJson = 'assets/maps_france_boundary.json';
                // France coordinate.
                _zoomPanBehavior
                  ..zoomLevel = 4
                  ..focalLatLng = const MapLatLng(46.2276, 2.2137);
              } else if (index == 1) {
                _boundaryJson = 'assets/maps_brazil_boundary.json';
                // Brazil coordinate.
                _zoomPanBehavior
                  ..zoomLevel = 3
                  ..focalLatLng = const MapLatLng(-14.2350, -51.9253);
              } else if (index == 2) {
                _boundaryJson = 'assets/maps_uk_boundary.json';
                // UK coordinate.
                _zoomPanBehavior
                  ..zoomLevel = 4
                  ..focalLatLng = const MapLatLng(55.3781, -3.4360);
              }
            });
          },
          child: Image.asset(_polygonData[index].imagePath, fit: BoxFit.cover),
        );
      },
    ),
  );

  Widget _toggleButtons(ThemeData themeData) {
    _isLightTheme = themeData.colorScheme.brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.24),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Tooltip(
              message: 'Inverted polygon',
              child: SizedBox(
                height: 32,
                width: 32,
                child: TextButton(
                  style: _getButtonStyle(!_isInvertedPolygon),
                  onPressed: () {
                    setState(() {
                      _isInvertedPolygon = true;
                    });
                  },
                  child: _isLightTheme
                      ? _buildButtonIcons(
                          'images/maps_inverted_polygon_light.png',
                        )
                      : _buildButtonIcons(
                          'images/maps_inverted_polygon_dark.png',
                        ),
                ),
              ),
            ),
            Tooltip(
              message: 'Default polygon',
              child: SizedBox(
                height: 32,
                width: 32,
                child: TextButton(
                  style: _getButtonStyle(_isInvertedPolygon),
                  onPressed: () {
                    setState(() {
                      _isInvertedPolygon = false;
                    });
                  },
                  child: _isLightTheme
                      ? _buildButtonIcons(
                          'images/maps_default_polygon_light.png',
                        )
                      : _buildButtonIcons(
                          'images/maps_default_polygon_dark.png',
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(bool isSelected) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return _isLightTheme
              ? const Color.fromRGBO(217, 217, 217, 1.0)
              : const Color.fromRGBO(102, 102, 102, 1.0);
        }
        return isSelected
            ? (_isLightTheme
                  ? const Color.fromRGBO(250, 250, 250, 1.0)
                  : const Color.fromRGBO(66, 66, 66, 1.0))
            : (_isLightTheme
                  ? const Color.fromRGBO(230, 230, 230, 1.0)
                  : const Color.fromRGBO(
                      88,
                      88,
                      88,
                      1.0,
                    )); // Use the component's default.
      }),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
    );
  }

  Widget _buildButtonIcons(String imagePath) {
    return Center(child: Image.asset(imagePath, height: 20, width: 20));
  }

  Future<Set<MapPolygon>> _getPolygonPoints() async {
    List<dynamic> polygonGeometryData;
    int multipolygonGeometryLength;
    final List<List<MapLatLng>> polygons = <List<MapLatLng>>[];
    final String data = await rootBundle.loadString(_boundaryJson);
    final dynamic jsonData = json.decode(data);
    const String key = 'features';
    final int jsonLength = jsonData[key].length as int;
    for (int i = 0; i < jsonLength; i++) {
      final dynamic features = jsonData[key][i];
      final Map<String, dynamic> geometry =
          features['geometry'] as Map<String, dynamic>;

      if (geometry['type'] == 'Polygon') {
        polygonGeometryData = geometry['coordinates'][0] as List<dynamic>;
        polygons.add(_getLatLngPoints(polygonGeometryData));
      } else {
        multipolygonGeometryLength = geometry['coordinates'].length as int;
        for (int j = 0; j < multipolygonGeometryLength; j++) {
          polygonGeometryData = geometry['coordinates'][j][0] as List<dynamic>;
          polygons.add(_getLatLngPoints(polygonGeometryData));
        }
      }
    }
    return _getPolygons(polygons);
  }

  List<MapLatLng> _getLatLngPoints(List<dynamic> polygonPoints) {
    final List<MapLatLng> polygon = <MapLatLng>[];
    for (int i = 0; i < polygonPoints.length; i++) {
      polygon.add(MapLatLng(polygonPoints[i][1], polygonPoints[i][0]));
    }
    return polygon;
  }

  Set<MapPolygon> _getPolygons(List<List<MapLatLng>> polygonPoints) {
    return List<MapPolygon>.generate(polygonPoints.length, (int index) {
      return MapPolygon(points: polygonPoints[index]);
    }).toSet();
  }

  MapSublayer _getPolygonLayer(Set<MapPolygon> polygons) {
    if (_isInvertedPolygon) {
      return MapPolygonLayer.inverted(
        polygons: polygons,
        color: Colors.black.withValues(alpha: 0.3),
        strokeColor: Colors.red,
      );
    } else {
      return MapPolygonLayer(
        polygons: polygons,
        color: Colors.grey.withValues(alpha: 0.5),
        strokeColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    _polygonData = <PolygonDataModel>[
      PolygonDataModel(
        'France',
        'images/maps_france.png',
        color: const Color.fromRGBO(237, 41, 57, 1.0),
      ),
      PolygonDataModel(
        'Brazil',
        'images/maps_brazil.png',
        color: const Color.fromRGBO(7, 154, 73, 1.0),
      ),
      PolygonDataModel(
        'United Kingdom',
        'images/maps_UK.png',
        color: const Color.fromRGBO(1, 33, 105, 1.0),
      ),
    ];
    _zoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 3,
      // Brazil coordinate.
      focalLatLng: const MapLatLng(-14.2350, -51.9253),
      minZoomLevel: 3,
      maxZoomLevel: 10,
      enableDoubleTapZooming: true,
    );
    _boundaryJson = 'assets/maps_brazil_boundary.json';
    super.initState();
  }

  @override
  void dispose() {
    _polygonData.clear();
    super.dispose();
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
      future: _getPolygonPoints(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'images/maps_grid.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                sublayers: <MapSublayer>[_getPolygonLayer(snapshot.data)],
                zoomPanBehavior: _zoomPanBehavior,
              ),
              _expandableAnimatedButton,
              _toggleButtons(themeData),
            ],
          );
        } else {
          // Showing empty container when the snapshot data is empty.
          return Container();
        }
      },
    );
  }
}

/// Builder for expanded button
typedef ExpandableButtonWidgetBuilder =
    _ExpandedButton Function(int index, BuildContext context);

/// Renders the expandable animated button
class ExpandableAnimatedButton extends StatefulWidget {
  /// Creates the expandable animated button
  const ExpandableAnimatedButton({
    Key? key,
    required this.dataCount,
    required this.builder,
    this.spacing = 10.0,
    this.alignment = Alignment.bottomRight,
  }) : super(key: key);

  /// Data count value
  final int dataCount;

  /// expandable button widget builder
  final ExpandableButtonWidgetBuilder builder;

  /// sapcing value
  final double spacing;

  /// Alignment value
  final AlignmentGeometry alignment;

  @override
  _ExpandableAnimatedButtonState createState() =>
      _ExpandableAnimatedButtonState();
}

class _ExpandableAnimatedButtonState extends State<ExpandableAnimatedButton> {
  WrapCrossAlignment _getCrossAxisAlignment(BuildContext context) {
    final Alignment alignment = widget.alignment.resolve(
      Directionality.of(context),
    );
    return alignment.x == -1
        ? WrapCrossAlignment.start
        : WrapCrossAlignment.end;
  }

  @override
  Widget build(BuildContext context) {
    final WrapCrossAlignment alignment = _getCrossAxisAlignment(context);
    return _InheritedExpandableAnimatedButton(
      alignment: alignment,
      child: Align(
        alignment: widget.alignment,
        child: Wrap(
          spacing: widget.spacing,
          direction: Axis.vertical,
          crossAxisAlignment: alignment,
          children: List<Widget>.generate(
            widget.dataCount,
            (int index) => widget.builder(index, context),
          ),
        ),
      ),
    );
  }
}

class _InheritedExpandableAnimatedButton extends InheritedWidget {
  const _InheritedExpandableAnimatedButton({
    required Widget child,
    required this.alignment,
  }) : super(child: child);

  final WrapCrossAlignment alignment;

  @override
  bool updateShouldNotify(_InheritedExpandableAnimatedButton oldWidget) {
    return oldWidget.alignment != alignment;
  }
}

class _ExpandedButton extends StatefulWidget {
  const _ExpandedButton({
    required this.text,
    required this.child,
    required this.color,
    this.size = 45.0,
    this.opacity = 0.5,
    required this.textStyle,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  final String text;
  final Widget child;
  final Color color;
  final double size;
  final double opacity;
  final TextStyle textStyle;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChanged;

  @override
  _ExpandedButtonState createState() => _ExpandedButtonState();
}

class _ExpandedButtonState extends State<_ExpandedButton>
    with SingleTickerProviderStateMixin {
  static Duration duration = const Duration(milliseconds: 550);
  late AnimationController _controller;
  late Animation<double> _animation;
  late _InheritedExpandableAnimatedButton _ancestor;

  Widget get _text => SizeTransition(
    sizeFactor: _animation,
    axis: Axis.horizontal,
    axisAlignment: -1.0,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(widget.text, style: widget.textStyle),
      ),
    ),
  );

  Widget get _image => ClipRRect(
    borderRadius: BorderRadius.circular(widget.size / 2),
    child: SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.child,
    ),
  );

  void _forward() {
    if (!widget.isSelected) {
      _controller.forward();
    }
  }

  void _reverse() {
    if (!widget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    if (widget.isSelected) {
      _controller.value = 1;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _ancestor = context
        .dependOnInheritedWidgetOfExactType<
          _InheritedExpandableAnimatedButton
        >()!;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_ExpandedButton oldWidget) {
    if (!oldWidget.isSelected && widget.isSelected) {
      _controller.forward();
    } else if (oldWidget.isSelected && !widget.isSelected) {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      opacity: widget.opacity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (PointerEnterEvent event) => _forward(),
        onExit: (PointerExitEvent event) => _reverse(),
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            widget.onSelectionChanged(!widget.isSelected);
          },
          onLongPressStart: (LongPressStartDetails details) => _forward(),
          onLongPressEnd: (LongPressEndDetails details) => _reverse(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: Container(
              color: widget.color,
              height: widget.size,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _ancestor.alignment == WrapCrossAlignment.end
                    ? <Widget>[_text, _image]
                    : <Widget>[_image, _text],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Classs for polygon data model
class PolygonDataModel {
  /// Holds the polygon data model data values
  PolygonDataModel(this.name, this.imagePath, {required this.color});

  /// Holds the string value
  final String name;

  /// Path of image
  final String imagePath;

  /// color value
  final Color color;
}
