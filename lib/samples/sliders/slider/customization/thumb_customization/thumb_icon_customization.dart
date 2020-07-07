import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class ThumbCustomizationSliderPage extends SampleView {
  const ThumbCustomizationSliderPage(Key key) : super(key: key);

  @override
  _ThumbCustomizationSliderPageState createState() =>
      _ThumbCustomizationSliderPageState();
}

class _ThumbCustomizationSliderPageState extends SampleViewState {
  _ThumbCustomizationSliderPageState();
  Widget slider;

  @override
  void initState() {
    super.initState();
    slider = ThumbCustomizationSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? slider
        : SingleChildScrollView(
            child: Container(height: 300, child: slider),
          );
  }
}

// ignore: must_be_immutable
class ThumbCustomizationSlider extends SampleView {
  @override
  _ThumbCustomizationSliderState createState() =>
      _ThumbCustomizationSliderState();
}

class _ThumbCustomizationSliderState extends SampleViewState {
  double _thumbValue = 4.0;
  final double _thumbMin = 0.0;
  final double _thumbMax = 10.0;
  double _value = 4.0;

  SfSliderTheme _thumbIconSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            thumbRadius: 16,
            tooltipBackgroundColor: model.backgroundColor,
            activeTrackHeight: 5.0,
            inactiveTrackHeight: 5.0),
        child: SfSlider(
          interval: 2.0,
          min: _thumbMin,
          max: _thumbMax,
          thumbIcon: _thumbView(),
          minorTicksPerInterval: 1,
          showTicks: true,
          value: _thumbValue,
          onChanged: (dynamic values) {
            setState(() {
              _thumbValue = values;
            });
          },
        ));
  }

  Widget _thumbView() {
    if (_thumbValue == _thumbMin) {
      return const Icon(Icons.arrow_forward_ios,
          color: Colors.white, size: 12.0);
    } else if (_thumbValue == _thumbMax) {
      return const Icon(Icons.arrow_back_ios, color: Colors.white, size: 12.0);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.arrow_back_ios, color: Colors.white, size: 12.0),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12.0),
          ]);
    }
  }

  SfSliderTheme _thumbCustomizationSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(
            activeTrackHeight: 3.0, inactiveTrackHeight: 3.0, thumbRadius: 14),
        child: SfSlider(
          interval: 2.0,
          min: 0.0,
          max: 10.0,
          thumbIcon: Container(
              alignment: Alignment.center,
              child: Text(
                _value.toInt().toString(),
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
          value: _value,
          onChanged: (dynamic values) {
            setState(() {
              _value = values;
            });
          },
        ));
  }

  Widget _getWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    final double padding = MediaQuery
        .of(context)
        .size
        .width / 20.0;
    return Container(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title('Text view'),
            columnSpacing10,
            _thumbCustomizationSlider(),
            columnSpacing40,
            title('Icon view'),
            columnSpacing10,
            _thumbIconSlider(),
            columnSpacing40,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
