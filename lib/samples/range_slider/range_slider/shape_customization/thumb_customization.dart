import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/helper.dart';

// ignore: must_be_immutable
class RangeSliderThumbCustomizationPage extends StatefulWidget {
  RangeSliderThumbCustomizationPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSliderThumbCustomizationPageState createState() =>
      _RangeSliderThumbCustomizationPageState(sample);
}

class _RangeSliderThumbCustomizationPageState
    extends State<RangeSliderThumbCustomizationPage> {
  _RangeSliderThumbCustomizationPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null, sample, RangeSliderThumbCustomizationPageFrontPanel(sample));
  }
}

class RangeSliderThumbCustomizationPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  RangeSliderThumbCustomizationPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _RangeSliderThumbCustomizationPageFrontPanelState createState() =>
      _RangeSliderThumbCustomizationPageFrontPanelState(sampleList);
}

class _RangeSliderThumbCustomizationPageFrontPanelState
    extends State<RangeSliderThumbCustomizationPageFrontPanel> {
  _RangeSliderThumbCustomizationPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: ThumbCustomizedRangeSlider()),
            ),
          );
  }
}

// ignore: must_be_immutable
class ThumbCustomizedRangeSlider extends StatefulWidget {
  @override
  _ThumbCustomizedRangeSliderState createState() =>
      _ThumbCustomizedRangeSliderState();
}

class _ThumbCustomizedRangeSliderState
    extends State<ThumbCustomizedRangeSlider> {
  final double _min = 0;
  final double _max = 100;
  final double _min1 = 0;
  final double _max1 = 100;
  SfRangeValues _values = const SfRangeValues(20.0, 80.0);
  SfRangeValues _values1 = const SfRangeValues(20.0, 80.0);
  final double sizeBoxHeight = 30;

  SfRangeSliderTheme thumbCustomizedSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        trackHeight: 4,
        labelOffset: const Offset(0, 10),
        overlayColor: Colors.transparent,
        activeTrackColor: Colors.teal,
        inactiveTrackColor: Colors.teal[100],
        thumbColor: Colors.teal,
      ),
      child: SfRangeSlider(
        min: _min,
        max: _max,
        values: _values,
        thumbShape: _SfThumbShapeTriangle(),
        divisorShape: _SfDivisorShape(),
        onChanged: (dynamic value) {
          setState(() {
            _values = value;
          });
        },
        interval: 20,
        showDivisors: true,
        showTicks: false,
        showLabels: true,
      ),
    );
  }

  SfRangeSliderTheme invertedThumbCustomizedSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        trackHeight: 4,
        labelOffset: const Offset(0, -32),
        overlayColor: Colors.transparent,
        activeTrackColor: Colors.teal,
        inactiveTrackColor: Colors.teal[100],
        thumbColor: Colors.teal,
      ),
      child: SfRangeSlider(
        min: _min1,
        max: _max1,
        values: _values1,
        thumbShape: _SfThumbShapeInvertedTriangle(),
        divisorShape: _SfDivisorShape(),
        onChanged: (dynamic value) {
          setState(() {
            _values1 = value;
          });
        },
        interval: 20,
        showDivisors: true,
        showTicks: false,
        showLabels: true,
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
          _getAlignedTextWidget('Thumb with traingle'),
          invertedThumbCustomizedSlider(),
          sizedBox,
          _getAlignedTextWidget('Thumb with line'),
          thumbCustomizedSlider(),
          sizedBox,
        ],
      ),
    );
  }
}

class _SfThumbShapeTriangle extends SfThumbShape {
  @override
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size(10, 14);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      bool isDiscrete,
      TextDirection textDirection,
      SfThumb thumb}) {
    final double halfTrackHeight = themeData.trackHeight;
    final Canvas canvas = context.canvas;
    final Size iconSize = getPreferredSize(themeData, isEnabled);
    final double iconHeight = iconSize.height;
    final double iconWidth = iconSize.width;
    final Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(center.dx, center.dy - halfTrackHeight);
    path.lineTo(
        center.dx - iconWidth, center.dy - halfTrackHeight - iconHeight);
    path.lineTo(
        center.dx + iconWidth, center.dy - halfTrackHeight - iconHeight);
    canvas.drawPath(
        path,
        Paint()
          ..color = themeData.thumbColor
          ..strokeWidth = 0
          ..style = PaintingStyle.fill);
  }
}

class _SfThumbShapeInvertedTriangle extends SfThumbShape {
  @override
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size(10, 15);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      bool isDiscrete,
      TextDirection textDirection,
      SfThumb thumb}) {
    final double halfTrackHeight = themeData.trackHeight;
    final Canvas canvas = context.canvas;
    final Size iconSize = getPreferredSize(themeData, isEnabled);
    final double iconHeight = iconSize.height;

    canvas.drawLine(
        Offset(center.dx, center.dy + halfTrackHeight + iconHeight / 2),
        Offset(center.dx, center.dy - halfTrackHeight - iconHeight / 2),
        Paint()
          ..color = themeData.thumbColor
          ..strokeWidth = 3
          ..style = PaintingStyle.fill);
  }
}

class _SfDivisorShape extends SfDivisorShape {
  @override
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size(3, 4);
  }

  @override
  void paint(PaintingContext context, Offset center, Offset thumbCenter,
      Offset endThumbCenter,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      bool isDiscrete,
      TextDirection textDirection}) {
    context.canvas.drawLine(
        Offset(center.dx, center.dy - themeData.trackHeight / 2),
        Offset(center.dx, center.dy + themeData.trackHeight / 2),
        Paint()
          ..color = Colors.white
          ..strokeWidth = getPreferredSize(themeData, isEnabled).width);
  }
}
