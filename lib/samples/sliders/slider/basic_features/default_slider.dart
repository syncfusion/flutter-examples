///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

/// Renders default slider widget
class DefaultSliderPage extends SampleView {
  /// Creates default slider widget
  const DefaultSliderPage(Key key) : super(key: key);

  @override
  _DefaultSliderPageState createState() => _DefaultSliderPageState();
}

class _DefaultSliderPageState extends SampleViewState {
  _DefaultSliderPageState();
  final double _inactiveSliderValue = 50.0;
  double _activeSliderValue = 50;

  SfSlider _inactiveSlider() {
    //ignore: missing_required_param
    return SfSlider(max: 100.0, value: _inactiveSliderValue, onChanged: null);
  }

  SfSliderTheme _activeSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider(
        max: 100.0,
        onChanged: (dynamic values) {
          setState(() {
            _activeSliderValue = values as double;
          });
        },
        value: _activeSliderValue,
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
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
          title('Enabled'),
          _activeSlider(),
          columnSpacing40,
          title('Disabled'),
          _inactiveSlider(),
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
