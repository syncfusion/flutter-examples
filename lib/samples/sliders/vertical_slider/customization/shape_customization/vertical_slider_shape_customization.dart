///flutter package import
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import 'vertical_slider_divider_customization.dart';
import 'vertical_slider_tick_customization.dart';
import 'vertical_thumb_customization.dart';

///Renders slider with customized shapes
class VerticalShapeCustomizedSliderPage extends SampleView {
  ///Renders slider with customized shapes
  const VerticalShapeCustomizedSliderPage(Key key) : super(key: key);

  @override
  _VerticalShapeCustomizedSliderPageState createState() =>
      _VerticalShapeCustomizedSliderPageState();
}

class _VerticalShapeCustomizedSliderPageState extends SampleViewState {
  _VerticalShapeCustomizedSliderPageState();
  final GlobalKey dividerKey = GlobalKey();
  final GlobalKey thumbKey = GlobalKey();
  final GlobalKey tickKey = GlobalKey();
  final double _min = 0.0;
  final double _max = 100.0;
  double _value = 60.0;

  Widget _buildWebLayout() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.height / 10.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: SfSliderTheme(
                  data: const SfSliderThemeData(
                    overlayColor: Colors.transparent,
                  ),
                  child: SfSlider.vertical(
                    min: _min,
                    max: _max,
                    value: _value,
                    interval: 20.0,
                    showLabels: true,
                    showTicks: true,
                    trackShape: _SfTrackShape(_min, _max),
                    thumbShape: _SfThumbShape(_min, _max),
                    tooltipPosition: SliderTooltipPosition.right,
                    onChanged: (dynamic value) {
                      setState(() {
                        _value = value as double;
                      });
                    },
                  ),
                ),
              ),
              const Text('Track'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: VerticalDividerCustomizedSlider(dividerKey)),
              const Text('Divider'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: VerticalThumbCustomizedSlider(thumbKey)),
              const Text('Thumb'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: VerticalTickCustomizedSlider(tickKey)),
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('Tick'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget slider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: slider),
              );
      },
    );
  }
}

class _SfTrackShape extends SfTrackShape {
  _SfTrackShape(dynamic min, dynamic max) {
    this.min =
        (min.runtimeType == DateTime
                ? min.millisecondsSinceEpoch.toDouble()
                : min)
            as double;
    this.max =
        (max.runtimeType == DateTime
                ? max.millisecondsSinceEpoch.toDouble()
                : max)
            as double;
  }
  late double min;
  late double max;
  double? trackIntermediatePos;

  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Animation<double> enableAnimation,
    required Paint? inactivePaint,
    required Paint? activePaint,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(parentBox, themeData, offset);
    final double actualValue =
        (currentValues.runtimeType == DateTime
                ? currentValue.millisecondsSinceEpoch.toDouble()
                : currentValue)
            as double;
    final double actualValueInPercent =
        ((actualValue - min) * 100) / (max - min);
    trackIntermediatePos = _getTrackIntermediatePosition(trackRect);

    // low volume track.
    final Paint trackPaint = Paint();
    trackPaint.color = actualValueInPercent <= 80.0 ? Colors.green : Colors.red;
    final Rect lowVolumeRect = Rect.fromLTRB(
      trackRect.left,
      trackIntermediatePos!,
      trackRect.right,
      trackRect.bottom,
    );
    context.canvas.drawRect(lowVolumeRect, trackPaint);

    // high volume track.
    trackPaint.color = Colors.red;
    final Rect highVolumeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      trackRect.right,
      trackIntermediatePos!,
    );
    context.canvas.drawRect(highVolumeRect, trackPaint);
  }

  double _getTrackIntermediatePosition(Rect trackRect) {
    final double actualValue = ((80 * (max - min)) + min) / 100;
    return trackRect.bottom -
        (((actualValue - min) / (max - min)) * trackRect.height);
  }
}

class _SfThumbShape extends SfThumbShape {
  _SfThumbShape(dynamic min, dynamic max) {
    this.min =
        (min.runtimeType == DateTime
                ? min.millisecondsSinceEpoch.toDouble()
                : min)
            as double;
    this.max =
        (max.runtimeType == DateTime
                ? max.millisecondsSinceEpoch.toDouble()
                : max)
            as double;
  }
  late double min;
  late double max;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    final double actualValue =
        (currentValues.runtimeType == DateTime
                ? currentValue.millisecondsSinceEpoch.toDouble()
                : currentValue)
            as double;

    final double actualValueInPercent =
        ((actualValue - min) * 100) / (max - min);

    paint = Paint();
    paint.color = actualValueInPercent <= 80 ? Colors.green : Colors.red;

    super.paint(
      context,
      center,
      parentBox: parentBox,
      themeData: themeData,
      currentValue: currentValue,
      paint: paint,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumb: thumb,
      child: child,
    );
  }
}
