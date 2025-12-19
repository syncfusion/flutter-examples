/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';

/// Renders the gauge marker pointer sample
class MarkerPointerExample extends SampleView {
  /// Creates the gauge marker pointer sample
  const MarkerPointerExample(Key key) : super(key: key);

  @override
  _MarkerPointerExampleState createState() => _MarkerPointerExampleState();
}

class _MarkerPointerExampleState extends SampleViewState {
  _MarkerPointerExampleState();

  late List<String> _markerTypes;

  String _selectedMarkerType = 'invertedTriangle';
  MarkerType _markerType = MarkerType.invertedTriangle;
  double _elevation = 4;

  @override
  void initState() {
    _selectedMarkerType = 'invertedTriangle';
    _markerType = MarkerType.invertedTriangle;
    _markerTypes = <String>[
      'circle',
      'diamond',
      'invertedTriangle',
      'rectangle',
      'triangle',
    ];
    super.initState();
  }

  @override
  void dispose() {
    _markerTypes.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMarkerPointerExample();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Marker type ',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedMarkerType,
                  items: _markerTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'invertedTriangle',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    _onMarkerTypeChange(value.toString());
                    stateSetter(() {});
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Elevation',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: !model.isWebFullView
                      ? const EdgeInsets.fromLTRB(40, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 15,
                    initialValue: _elevation,
                    onChanged: (double val) {
                      setState(() {
                        _elevation = val;
                      });
                    },
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 16.0, color: model.textColor),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Method for updating the marker type
  void _onMarkerTypeChange(String item) {
    setState(() {
      _selectedMarkerType = item;
      if (_selectedMarkerType == 'circle') {
        _markerType = MarkerType.circle;
      } else if (_selectedMarkerType == 'diamond') {
        _markerType = MarkerType.diamond;
      } else if (_selectedMarkerType == 'invertedTriangle') {
        _markerType = MarkerType.invertedTriangle;
      } else if (_selectedMarkerType == 'rectangle') {
        _markerType = MarkerType.rectangle;
      } else if (_selectedMarkerType == 'triangle') {
        _markerType = MarkerType.triangle;
      }
    });
  }

  /// Returns the marker pointer gauge
  SfRadialGauge _buildMarkerPointerExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 180,
          endAngle: 360,
          radiusFactor: 0.9,
          canScaleToFit: true,
          interval: 10,
          showLabels: false,
          showAxisLine: false,
          pointers: <GaugePointer>[
            MarkerPointer(
              value: 70,
              elevation: _elevation,
              markerWidth: 25,
              markerHeight: 25,
              color: const Color(0xFFF67280),
              markerType: _markerType,
              markerOffset: -7,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 175,
              positionFactor: 0.8,
              widget: Text(
                'Min',
                style: TextStyle(
                  fontSize: isCardView ? 12 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 270,
              positionFactor: 0.1,
              widget: Text(
                '70%',
                style: TextStyle(
                  fontSize: isCardView ? 12 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 5,
              positionFactor: 0.8,
              widget: Text(
                'Max',
                style: TextStyle(
                  fontSize: isCardView ? 12 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 100,
              sizeUnit: GaugeSizeUnit.factor,
              gradient: const SweepGradient(
                colors: <Color>[Color(0xFFAB64F5), Color(0xFF62DBF6)],
                stops: <double>[0.25, 0.75],
              ),
              startWidth: 0.4,
              endWidth: 0.4,
              color: const Color(0xFF00A8B5),
            ),
          ],
          showTicks: false,
        ),
      ],
    );
  }
}
