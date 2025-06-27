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

/// Renders default range slider widget
class DefaultRangeSliderPage extends SampleView {
  /// Creates default range slider widget
  const DefaultRangeSliderPage(Key key) : super(key: key);

  @override
  _DefaultRangeSliderPageState createState() => _DefaultRangeSliderPageState();
}

class _DefaultRangeSliderPageState extends SampleViewState {
  _DefaultRangeSliderPageState();
  final SfRangeValues _inactiveRangeSliderValue = const SfRangeValues(
    20.0,
    80.0,
  );
  SfRangeValues _activeRangeSliderValue = const SfRangeValues(20.0, 80.0);

  SfRangeSlider _inactiveRangeSlider() {
    //ignore: missing_required_param
    return SfRangeSlider(
      max: 100.0,
      values: _inactiveRangeSliderValue,
      onChanged: null,
    );
  }

  SfRangeSliderTheme _activeRangeSliderSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider(
        max: 100.0,
        onChanged: (dynamic values) {
          setState(() {
            _activeRangeSliderValue = values as SfRangeValues;
          });
        },
        values: _activeRangeSliderValue,
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
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          title('Enabled'),
          _activeRangeSliderSlider(),
          columnSpacing40,
          title('Disabled'),
          _inactiveRangeSlider(),
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
            : _getMobileLayout();
        return constraints.maxHeight > 300
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 300, child: rangeSlider),
              );
      },
    );
  }
}
