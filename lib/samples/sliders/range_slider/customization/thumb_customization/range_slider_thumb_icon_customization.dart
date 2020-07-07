import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/samples/sliders/slider_utils.dart';

class ThumbCustomizationRangeSliderPage extends SampleView {
  const ThumbCustomizationRangeSliderPage(Key key) : super(key: key);

  @override
  _ThumbCustomizationRangeSliderPageState createState() =>
      _ThumbCustomizationRangeSliderPageState();
}

class _ThumbCustomizationRangeSliderPageState extends SampleViewState {
  _ThumbCustomizationRangeSliderPageState();
  Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = ThumbCustomizationRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb
        ? rangeSlider
        : SingleChildScrollView(
            child: Container(height: 300, child: rangeSlider),
          );
  }
}

// ignore: must_be_immutable
class ThumbCustomizationRangeSlider extends SampleView {
  @override
  _ThumbCustomizationRangeSliderState createState() =>
      _ThumbCustomizationRangeSliderState();
}

class _ThumbCustomizationRangeSliderState extends SampleViewState {
  SfRangeValues _thumbValues = const SfRangeValues(4.0, 6.0);
  final double _thumbMin = 0.0;
  final double _thumbMax = 10.0;
  SfRangeValues _values = const SfRangeValues(4.0, 6.0);

  SfRangeSliderTheme _thumbIconSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            thumbRadius: 16,
            tooltipBackgroundColor: model.backgroundColor,
            activeTrackHeight: 5.0,
            inactiveTrackHeight: 5.0),
        child: SfRangeSlider(
          interval: 2.0,
          min: _thumbMin,
          max: _thumbMax,
          startThumbIcon:
              const Icon(Icons.arrow_back_ios, color: Colors.white, size: 12.0),
          endThumbIcon: const Icon(Icons.arrow_forward_ios,
              color: Colors.white, size: 12.0),
          minorTicksPerInterval: 1,
          showTicks: true,
          values: _thumbValues,
          onChanged: (SfRangeValues values) {
            setState(() {
              _thumbValues = values;
            });
          },
        ));
  }

  Widget _thumbView(dynamic value) {
    return Container(
        alignment: Alignment.center,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }

  SfRangeSliderTheme _thumbCustomizationSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            activeTrackHeight: 3.0, inactiveTrackHeight: 3.0, thumbRadius: 14),
        child: SfRangeSlider(
          interval: 2.0,
          min: 0.0,
          max: 10.0,
          startThumbIcon: _thumbView(_values.start),
          endThumbIcon: _thumbView(_values.end),
          values: _values,
          onChanged: (SfRangeValues values) {
            setState(() {
              _values = values;
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
