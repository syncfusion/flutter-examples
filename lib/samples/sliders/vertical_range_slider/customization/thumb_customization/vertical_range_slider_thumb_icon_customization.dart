///flutter package import
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders range slider with customized thumb icon
class VerticalThumbCustomizationRangeSliderPage extends SampleView {
  ///Creates range slider with customized thumb icon
  const VerticalThumbCustomizationRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalThumbCustomizationRangeSliderPageState createState() =>
      _VerticalThumbCustomizationRangeSliderPageState();
}

class _VerticalThumbCustomizationRangeSliderPageState extends SampleViewState {
  _VerticalThumbCustomizationRangeSliderPageState();
  SfRangeValues _thumbValues = const SfRangeValues(4.0, 6.0);
  final double _thumbMin = 0.0;
  final double _thumbMax = 10.0;
  SfRangeValues _values = const SfRangeValues(4.0, 6.0);

  SfRangeSliderTheme _thumbIconSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        thumbRadius: 16,
        tooltipBackgroundColor: model.primaryColor,
      ),
      child: SfRangeSlider.vertical(
        interval: 2.0,
        min: _thumbMin,
        max: _thumbMax,
        startThumbIcon: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.white,
          size: 16.0,
        ),
        endThumbIcon: const Icon(
          Icons.keyboard_arrow_up_outlined,
          color: Colors.white,
          size: 16.0,
        ),
        minorTicksPerInterval: 1,
        showTicks: true,
        values: _thumbValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _thumbValues = values;
          });
        },
      ),
    );
  }

  Widget _thumbView(dynamic value) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  SfRangeSliderTheme _thumbCustomizationSlider() {
    return SfRangeSliderTheme(
      data: const SfRangeSliderThemeData(thumbRadius: 14),
      child: SfRangeSlider.vertical(
        max: 10.0,
        stepSize: 1,
        startThumbIcon: _thumbView(_values.start),
        endThumbIcon: _thumbView(_values.end),
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
      ),
    );
  }

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
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: _thumbCustomizationSlider()),
              const Text('Text view'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _thumbIconSlider()),
              const Text('Icon view'),
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
        final Widget rangeSlider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: rangeSlider),
              );
      },
    );
  }
}
