///flutter package import
import 'package:flutter/material.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';

///Renders slider with customized thumb
class VerticalThumbCustomizationSliderPage extends SampleView {
  ///Creates slider with customized thumb
  const VerticalThumbCustomizationSliderPage(Key key) : super(key: key);

  @override
  _VerticalThumbCustomizationSliderPageState createState() =>
      _VerticalThumbCustomizationSliderPageState();
}

class _VerticalThumbCustomizationSliderPageState extends SampleViewState {
  _VerticalThumbCustomizationSliderPageState();

  late Widget slider;

  @override
  void initState() {
    super.initState();
    slider = _ThumbCustomizationSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWebFullView
        ? slider
        : SingleChildScrollView(
            child: Container(height: 400, child: slider),
          );
  }
}

class _ThumbCustomizationSlider extends SampleView {
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
        ),
        child: SfSlider.vertical(
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
      return Icon(Icons.keyboard_arrow_up_outlined,
          color: Colors.white, size: 12.0);
    } else if (_thumbValue == _thumbMax) {
      return Icon(Icons.keyboard_arrow_down_outlined,
          color: Colors.white, size: 12.0);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Icon(Icons.keyboard_arrow_up_outlined,
                color: Colors.white, size: 16.0),
            Icon(Icons.keyboard_arrow_down_outlined,
                color: Colors.white, size: 16.0),
          ]);
    }
  }

  SfSliderTheme _thumbCustomizationSlider() {
    return SfSliderTheme(
        data: SfSliderThemeData(thumbRadius: 14),
        child: SfSlider.vertical(
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
            Column(children: [
              Expanded(child: _thumbCustomizationSlider()),
              Text('Text view')
            ]),
            Column(children: [
              Expanded(child: _thumbIconSlider()),
              Text('Icon view'),
            ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return model.isWebFullView ? _buildWebLayout() : _buildMobileLayout();
  }
}
