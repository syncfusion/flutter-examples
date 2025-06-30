// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge water level indicator sample.
class WaterLevelIndicator extends SampleView {
  /// Creates the linear gauge water level indicator sample.
  const WaterLevelIndicator(Key key) : super(key: key);

  @override
  _WaterLevelIndicatorState createState() => _WaterLevelIndicatorState();
}

/// State class of water indicator sample.
class _WaterLevelIndicatorState extends SampleViewState {
  _WaterLevelIndicatorState();

  double _level = 150;
  final double _minimumLevel = 0;
  final double _maximumLevel = 500;

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
              height: 350,
              child: _buildWaterIndicator(context),
            ),
          )
        : isCardView
        ? _buildWaterIndicator(context)
        : Center(
            child: SizedBox(height: 300, child: _buildWaterIndicator(context)),
          );
  }

  /// Returns the water indicator.
  Widget _buildWaterIndicator(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SfLinearGauge(
        minimum: _minimumLevel,
        maximum: _maximumLevel,
        orientation: LinearGaugeOrientation.vertical,
        interval: 100,
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 2),
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
            value: _level,
            enableAnimation: false,
            onChanged: (dynamic value) {
              setState(() {
                _level = value as double;
              });
            },
            child: Material(
              elevation: 4.0,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.blue,
              child: Ink(
                width: 32.0,
                height: 32.0,
                child: InkWell(
                  splashColor: Colors.grey,
                  hoverColor: Colors.blueAccent,
                  onTap: () {},
                  child: Center(
                    child: _level == _minimumLevel
                        ? Icon(
                            Icons.keyboard_arrow_up_outlined,
                            color: Colors.white,
                            size: isCardView ? 18.0 : 20.0,
                          )
                        : _level == _maximumLevel
                        ? Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                            size: isCardView ? 18.0 : 20.0,
                          )
                        : RotatedBox(
                            quarterTurns: 3,
                            child: Icon(
                              Icons.code_outlined,
                              color: Colors.white,
                              size: isCardView ? 18.0 : 20.0,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          LinearWidgetPointer(
            value: _level,
            enableAnimation: false,
            markerAlignment: LinearMarkerAlignment.end,
            offset: isCardView
                ? 67
                : isWebOrDesktop
                ? 120
                : 95,
            position: LinearElementPosition.outside,
            child: SizedBox(
              width: 50,
              height: 20,
              child: Center(
                child: Text(
                  _level.toStringAsFixed(0) + ' ml',
                  style: TextStyle(
                    color: brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
        barPointers: <LinearBarPointer>[
          LinearBarPointer(
            value: _maximumLevel,
            enableAnimation: false,
            thickness: isCardView
                ? 150
                : isWebOrDesktop
                ? 250
                : 200,
            offset: 18,
            position: LinearElementPosition.outside,
            color: Colors.transparent,
            child: CustomPaint(
              painter: _CustomPathPainter(
                color: Colors.blue,
                waterLevel: _level,
                maximumPoint: _maximumLevel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomPathPainter extends CustomPainter {
  _CustomPathPainter({
    required this.color,
    required this.waterLevel,
    required this.maximumPoint,
  });
  final Color color;
  final double waterLevel;
  final double maximumPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _buildTumblerPath(size.width, size.height);
    final double factor = size.height / maximumPoint;
    final double height = 2 * factor * waterLevel;
    final Paint strokePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Paint paint = Paint()..color = color;
    canvas.drawPath(path, strokePaint);
    final Rect clipper = Rect.fromCenter(
      center: Offset(size.width / 2, size.height),
      height: height,
      width: size.width,
    );
    canvas.clipRect(clipper);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CustomPathPainter oldDelegate) => true;
}

Path _buildTumblerPath(double width, double height) {
  return Path()
    ..lineTo(width, 0)
    ..lineTo(width * 0.75, height - 15)
    ..quadraticBezierTo(width * 0.74, height, width * 0.67, height)
    ..lineTo(width * 0.33, height)
    ..quadraticBezierTo(width * 0.26, height, width * 0.25, height - 15)
    ..close();
}
