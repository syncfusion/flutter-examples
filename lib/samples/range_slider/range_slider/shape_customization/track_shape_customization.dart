import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/helper.dart';

// ignore: must_be_immutable
class TrackShapeCustomizationPage extends StatefulWidget {
  TrackShapeCustomizationPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _TrackShapeCustomizationPageState createState() =>
      _TrackShapeCustomizationPageState(sample);
}

class _TrackShapeCustomizationPageState
    extends State<TrackShapeCustomizationPage> {
  _TrackShapeCustomizationPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null, sample, TrackShapeCustomizationPageFrontPanel(sample));
  }
}

class TrackShapeCustomizationPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TrackShapeCustomizationPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _TrackShapeCustomizationPageFrontPanelState createState() =>
      _TrackShapeCustomizationPageFrontPanelState(sampleList);
}

class _TrackShapeCustomizationPageFrontPanelState
    extends State<TrackShapeCustomizationPageFrontPanel> {
  _TrackShapeCustomizationPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: const TrackShapeCustomizedRangeSlider()),
            ),
          );
  }
}

// ignore: must_be_immutable
class TrackShapeCustomizedRangeSlider extends StatefulWidget {
  const TrackShapeCustomizedRangeSlider();

  @override
  _TrackShapeCustomizedRangeSliderState createState() =>
      _TrackShapeCustomizedRangeSliderState();
}

class _TrackShapeCustomizedRangeSliderState
    extends State<TrackShapeCustomizedRangeSlider> {
  final double _min = 0;
  final double _max = 100;
  final double _min1 = 0;
  final double _max1 = 100;
  SfRangeValues _values = const SfRangeValues(30.0, 60.0);
  SfRangeValues _values1 = const SfRangeValues(30.0, 60.0);
  final double sizeBoxHeight = 20;

  SfRangeSliderTheme get syncCustomizedSlider {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        trackHeight: 15,
        labelOffset: const Offset(0, 10),
        activeTrackColor: Colors.brown[300],
        inactiveTrackColor: Colors.brown[100],
        thumbRadius: 10,
        thumbColor: Colors.brown[300],
        overlayColor: Colors.transparent,
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

  SfRangeSliderTheme get syncInverseCustomizedSlider {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        trackHeight: 15,
        labelOffset: const Offset(0, 10),
        activeTrackColor: Colors.brown[300],
        inactiveTrackColor: Colors.brown[100],
        thumbRadius: 10,
        thumbColor: Colors.brown[300],
        overlayColor: Colors.transparent,
      ),
      child: SfRangeSlider(
        min: _min1,
        max: _max1,
        values: _values1,
        trackShape: _SfTrackInverseShape(),
        thumbShape: _SfThumbShape(),
        onChanged: (dynamic value) {
          setState(() {
            _values1 = value;
          });
        },
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
          sizedBox,
          syncCustomizedSlider,
          sizedBox,
          syncInverseCustomizedSlider,
          sizedBox,
        ],
      ),
    );
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
    final ColorTween activeTrackColorTween = ColorTween(
        begin: themeData.disabledActiveTrackColor,
        end: themeData.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: themeData.disabledInactiveTrackColor,
        end: themeData.inactiveTrackColor);

    final Canvas canvas = context.canvas;
    final Rect actualTrackRect =
        getPreferredRect(parentBox, themeData, offset, isEnabled);

    final double halfTrackHeight = themeData.trackHeight / 2;
    final double trackCenter = offset.dy + halfTrackHeight;
    final double onePercent = halfTrackHeight / actualTrackRect.width;
    final double heightFactor = startThumbCenter.dx * onePercent;

    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(actualTrackRect.left, trackCenter - 2);
    path.lineTo(startThumbCenter.dx - themeData.thumbRadius,
        trackCenter - heightFactor);
    path.lineTo(startThumbCenter.dx - themeData.thumbRadius,
        trackCenter + heightFactor);
    path.lineTo(actualTrackRect.left, trackCenter + 2);
    canvas.drawPath(
        path,
        Paint()
          ..color = inactiveTrackColorTween.evaluate(animation)
          ..strokeWidth = 0
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill);

    path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(startThumbCenter.dx + themeData.thumbRadius,
        trackCenter - heightFactor);
    path.lineTo(endThumbCenter.dx - themeData.thumbRadius,
        trackCenter - (endThumbCenter.dx * onePercent));
    path.lineTo(endThumbCenter.dx - themeData.thumbRadius,
        trackCenter + (endThumbCenter.dx * onePercent));
    path.lineTo(startThumbCenter.dx + themeData.thumbRadius,
        trackCenter + heightFactor);
    canvas.drawPath(
        path,
        Paint()
          ..color = activeTrackColorTween.evaluate(animation)
          ..strokeWidth = 0
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill);

    path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(endThumbCenter.dx + themeData.thumbRadius,
        trackCenter - (endThumbCenter.dx * onePercent));
    path.lineTo(actualTrackRect.width + actualTrackRect.left, offset.dy);
    path.lineTo(actualTrackRect.width + actualTrackRect.left,
        offset.dy + themeData.trackHeight);
    path.lineTo(endThumbCenter.dx + themeData.thumbRadius,
        trackCenter + (endThumbCenter.dx * onePercent));
    canvas.drawPath(
        path,
        Paint()
          ..color = inactiveTrackColorTween.evaluate(animation)
          ..strokeWidth = 0
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill);
  }
}

class _SfTrackInverseShape extends SfTrackShape {
  @override
  void paint(PaintingContext context, Offset offset, Offset startThumbCenter,
      Offset endThumbCenter,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection}) {
    final ColorTween activeTrackColorTween = ColorTween(
        begin: themeData.disabledActiveTrackColor,
        end: themeData.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: themeData.disabledInactiveTrackColor,
        end: themeData.inactiveTrackColor);

    final Canvas canvas = context.canvas;
    final Rect actualTrackRect =
        getPreferredRect(parentBox, themeData, offset, isEnabled);

    final double halfTrackHeight = themeData.trackHeight / 2;
    final double trackCenter = offset.dy + halfTrackHeight;
    final double onePercent = halfTrackHeight / actualTrackRect.width;
    final double heightFactor =
        ((startThumbCenter.dx * onePercent) - halfTrackHeight).abs();

    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(actualTrackRect.left, offset.dy);
    path.lineTo(startThumbCenter.dx - themeData.thumbRadius,
        trackCenter - heightFactor);
    path.lineTo(startThumbCenter.dx - themeData.thumbRadius,
        trackCenter + heightFactor);
    path.lineTo(actualTrackRect.left, offset.dy + themeData.trackHeight);
    canvas.drawPath(
        path,
        Paint()
          ..color = inactiveTrackColorTween.evaluate(animation)
          ..strokeWidth = 0
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill);

    path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(startThumbCenter.dx + themeData.thumbRadius,
        trackCenter - heightFactor);
    path.lineTo(
        endThumbCenter.dx - themeData.thumbRadius,
        trackCenter -
            ((endThumbCenter.dx * onePercent) - halfTrackHeight).abs());
    path.lineTo(
        endThumbCenter.dx - themeData.thumbRadius,
        trackCenter +
            ((endThumbCenter.dx * onePercent) - halfTrackHeight).abs());
    path.lineTo(startThumbCenter.dx + themeData.thumbRadius,
        trackCenter + heightFactor);
    canvas.drawPath(
        path,
        Paint()
          ..color = activeTrackColorTween.evaluate(animation)
          ..strokeWidth = 0
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill);

    path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(
        endThumbCenter.dx + themeData.thumbRadius,
        trackCenter -
            ((endThumbCenter.dx * onePercent) - halfTrackHeight).abs());
    path.lineTo(actualTrackRect.width + actualTrackRect.left, trackCenter - 2);
    path.lineTo(actualTrackRect.width + actualTrackRect.left, trackCenter + 2);
    path.lineTo(
        endThumbCenter.dx + themeData.thumbRadius,
        trackCenter +
            ((endThumbCenter.dx * onePercent) - halfTrackHeight).abs());
    canvas.drawPath(
        path,
        Paint()
          ..color = inactiveTrackColorTween.evaluate(animation)
          ..strokeWidth = 0
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill);
  }
}

class _SfThumbShape extends SfThumbShape {
  @override
  Size getPreferredSize(SfRangeSliderThemeData themeData, bool isEnabled) {
    return const Size(20, 15);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {bool isLeftThumb,
      bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      bool isDiscrete,
      List<dynamic> values,
      TextDirection textDirection,
      SfThumb thumb}) {
    super.paint(context, center,
        isEnabled: isEnabled,
        themeData: themeData,
        animation: animation,
        textDirection: textDirection,
        thumb: thumb);
  
    context.canvas.drawCircle(
        center,
        themeData.thumbRadius,
        Paint()
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..color = Colors.white);
  }
}
