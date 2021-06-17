///flutter package import
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';

///Renders range slider with customized thumb icon
class ThumbCustomizationRangeSliderPage extends SampleView {
  ///Creates range slider with customized thumb icon
  const ThumbCustomizationRangeSliderPage(Key key) : super(key: key);

  @override
  _ThumbCustomizationRangeSliderPageState createState() =>
      _ThumbCustomizationRangeSliderPageState();
}

class _ThumbCustomizationRangeSliderPageState extends SampleViewState {
  _ThumbCustomizationRangeSliderPageState();
  late Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _ThumbCustomizationRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxHeight > 300
          ? rangeSlider
          : SingleChildScrollView(
              child: SizedBox(height: 300, child: rangeSlider),
            );
    });
  }
}

class _ThumbCustomizationRangeSlider extends SampleView {
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
        ),
        child: SfRangeSlider(
          interval: 2.0,
          min: _thumbMin,
          max: _thumbMax,
          startThumbIcon: const Icon(Icons.arrow_back_ios_outlined,
              color: Colors.white, size: 12.0),
          endThumbIcon: const Icon(Icons.arrow_forward_ios_outlined,
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
        data: SfRangeSliderThemeData(thumbRadius: 14),
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

  Widget _buildWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
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
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
