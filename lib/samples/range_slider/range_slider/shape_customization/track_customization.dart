import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/helper.dart';

// ignore: must_be_immutable
class RangeSliderTrackCustomizationPage extends StatefulWidget {
  RangeSliderTrackCustomizationPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSliderTrackCustomizationPageState createState() =>
      _RangeSliderTrackCustomizationPageState(sample);
}

class _RangeSliderTrackCustomizationPageState
    extends State<RangeSliderTrackCustomizationPage> {
  _RangeSliderTrackCustomizationPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null, sample, RangeSliderTrackCustomizationPageFrontPanel(sample));
  }
}

class RangeSliderTrackCustomizationPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  RangeSliderTrackCustomizationPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _RangeSliderTrackCustomizationPageFrontPanelState createState() =>
      _RangeSliderTrackCustomizationPageFrontPanelState(sampleList);
}

class _RangeSliderTrackCustomizationPageFrontPanelState
    extends State<RangeSliderTrackCustomizationPageFrontPanel> {
  _RangeSliderTrackCustomizationPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: TrackCustomizedRangeSlider()),
            ),
          );
  }
}

// ignore: must_be_immutable
class TrackCustomizedRangeSlider extends StatefulWidget {
  @override
  _TrackCustomizedRangeSliderState createState() =>
      _TrackCustomizedRangeSliderState();
}

class _TrackCustomizedRangeSliderState
    extends State<TrackCustomizedRangeSlider> {
  final double _min = 0;
  final double _max = 100;
  SfRangeValues _values = const SfRangeValues(30.0, 70.0);
  final double _min1 = 0;
  final double _max1 = 100;
  SfRangeValues _values1 = const SfRangeValues(30.0, 70.0);
  final double sizeBoxHeight = 30;

  SfRangeSliderTheme tickCustomizedSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        trackHeight: 4,
        thumbRadius: 9,
        overlayColor: Colors.transparent,
        activeTrackColor: Colors.pink,
        inactiveTrackColor: Colors.pink[100],
        thumbColor: Colors.pink,
        tickOffset: const Offset(0, 12),
        labelOffset: const Offset(0, -47),
      ),
      child: SfRangeSlider(
        min: _min1,
        max: _max1,
        tickShape: _SfTickShape(),
        values: _values1,
        interval: 20,
        showTicks: true,
        showLabels: true,
        onChanged: (dynamic value) {
          setState(() {
            _values1 = value;
          });
        },
      ),
    );
  }

  SfRangeSliderTheme trackCustomizedSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        trackHeight: 4,
        overlayColor: Colors.transparent,
        thumbColor: Colors.white,
      ),
      child: SfRangeSlider(
        min: _min,
        max: _max,
        values: _values,
        trackShape: _SfTrackShape(),
        thumbShape: _SfThumbShape(),
        onChanged: (dynamic value) {
          setState(() {
            _values = value;
          });
        },
      ),
    );
  }

  Widget _getAlignedTextWidget(String text,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        padding: const EdgeInsets.only(left: 10),
      ),
    );
  }

  Widget get sizedBox => SizedBox(height: sizeBoxHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getAlignedTextWidget('Tick customization'),
          tickCustomizedSlider(),
          sizedBox,
        ],
      ),
    );
  }
}

LinearGradient get gradientColor {
  final List<Color> colors = <Color>[];
  colors.add(Colors.pink);
  colors.add(Colors.green);
  final List<double> stops = <double>[0.0, 1.0];
  return LinearGradient(colors: colors, stops: stops);
}

class _SfThumbShape extends SfThumbShape {
  @override
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size(10, 15);
  }

  bool isLeftThumb = true;

  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      bool isDiscrete,
      TextDirection textDirection,
      SfThumb thumb}) {
    if (isLeftThumb) {
      context.canvas.drawCircle(
          center,
          getPreferredSize(themeData, isEnabled).width,
          Paint()
            ..isAntiAlias = true
            ..strokeWidth = 0
            ..color = isEnabled ? Colors.pink : themeData.disabledThumbColor);
      isLeftThumb = false;
    } else {
      context.canvas.drawCircle(
          center,
          getPreferredSize(themeData, isEnabled).width,
          Paint()
            ..isAntiAlias = true
            ..strokeWidth = 0
            ..color = isEnabled ? Colors.green : themeData.disabledThumbColor);
    }

    context.canvas.drawCircle(
        center,
        getPreferredSize(themeData, isEnabled).width,
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 3
          ..color = Colors.white
          ..style = PaintingStyle.stroke);
  }
}

class _SfTrackShape extends SfTrackShape {
  @override
  void paint(PaintingContext context, Offset offset, Offset startThumbCenter,
      Offset endThumbCenter,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection}) {
    super.paint(context, offset, startThumbCenter, endThumbCenter,
        isEnabled: isEnabled,
        parentBox: parentBox,
        themeData: themeData,
        animation: animation,
        textDirection: textDirection);

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 0
      ..color = Colors.pink[100];

    final Canvas canvas = context.canvas;
    final Radius radius = Radius.circular(themeData.trackCornerRadius);

    Rect actualTrackRect =
        getPreferredRect(parentBox, themeData, offset, isEnabled);
    Rect activeTrackRect = Rect.fromLTRB(actualTrackRect.left,
        actualTrackRect.top, startThumbCenter.dx, actualTrackRect.bottom);
    RRect activeTrackRRect = RRect.fromRectAndCorners(activeTrackRect,
        topLeft: radius, bottomLeft: radius);
    canvas.drawRRect(activeTrackRRect, paint);

    actualTrackRect = getPreferredRect(parentBox, themeData, offset, isEnabled);
    activeTrackRect = Rect.fromLTRB(startThumbCenter.dx, actualTrackRect.top,
        endThumbCenter.dx, actualTrackRect.bottom);
    activeTrackRRect = RRect.fromRectAndCorners(activeTrackRect);
    paint.shader = gradientColor.createShader(activeTrackRect);
    canvas.drawRRect(activeTrackRRect, paint);

    paint.color = Colors.green[50];
    actualTrackRect = getPreferredRect(parentBox, themeData, offset, isEnabled);
    activeTrackRect = Rect.fromLTRB(endThumbCenter.dx, actualTrackRect.top,
        actualTrackRect.width + actualTrackRect.left, actualTrackRect.bottom);
    activeTrackRRect = RRect.fromRectAndCorners(activeTrackRect,
        topRight: radius, bottomRight: radius);
    canvas.drawRRect(activeTrackRRect, paint);
  }
}

class _SfTickShape extends SfTickShape {
  @override
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size(10, 10);
  }

  @override
  void paint(PaintingContext context, Offset center, Offset thumbCenter,
      Offset endThumbCenter,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection}) {
    final Size tickSize = getPreferredSize(themeData, isEnabled);
    final bool isTickRightOfThumb = endThumbCenter == null
        ? center.dx > thumbCenter.dx
        : center.dx < thumbCenter.dx || center.dx > endThumbCenter.dx;
    final Color begin = isTickRightOfThumb
        ? themeData.disabledInactiveTickColor
        : themeData.disabledActiveTickColor;
    final Color end = isTickRightOfThumb
        ? themeData.inactiveTickColor
        : themeData.activeTickColor;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = tickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(animation);

    final Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx - (tickSize.width / 2), center.dy + tickSize.height);
    path.lineTo(center.dx + (tickSize.width / 2), center.dy + tickSize.height);
    context.canvas.drawPath(path, paint);
  }
}
