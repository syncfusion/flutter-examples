///flutter package import
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';

///Renders slider with customized thumb
class ThumbCustomizationSliderPage extends SampleView {
  ///Creates slider with customized thumb
  const ThumbCustomizationSliderPage(Key key) : super(key: key);

  @override
  _ThumbCustomizationSliderPageState createState() =>
      _ThumbCustomizationSliderPageState();
}

class _ThumbCustomizationSliderPageState extends SampleViewState {
  _ThumbCustomizationSliderPageState();
  double _thumbValue = 4.0;
  final double _thumbMin = 0.0;
  final double _thumbMax = 10.0;
  double _value = 4.0;

  SfSliderTheme _thumbIconSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        thumbRadius: 16,
        tooltipBackgroundColor: model.primaryColor,
      ),
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
            _thumbValue = values as double;
          });
        },
      ),
    );
  }

  Widget _thumbView() {
    if (_thumbValue == _thumbMin) {
      return const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 12.0,
      );
    } else if (_thumbValue == _thumbMax) {
      return const Icon(Icons.arrow_back_ios, color: Colors.white, size: 12.0);
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.arrow_back_ios_outlined, color: Colors.white, size: 12.0),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
            size: 12.0,
          ),
        ],
      );
    }
  }

  SfSliderTheme _thumbCustomizationSlider() {
    return SfSliderTheme(
      data: const SfSliderThemeData(thumbRadius: 14),
      child: SfSlider(
        max: 10.0,
        stepSize: 1,
        thumbIcon: Container(
          alignment: Alignment.center,
          child: Text(
            _value.toInt().toString(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        value: _value,
        onChanged: (dynamic values) {
          setState(() {
            _value = values as double;
          });
        },
      ),
    );
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
        return constraints.maxHeight > 300
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 300, child: slider),
              );
      },
    );
  }
}
