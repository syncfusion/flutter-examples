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

/// Renders default range slider widget
class VerticalDefaultRangeSliderPage extends SampleView {
  /// Creates default range slider widget
  const VerticalDefaultRangeSliderPage(Key key) : super(key: key);

  @override
  _VerticalDefaultRangeSliderPageState createState() =>
      _VerticalDefaultRangeSliderPageState();
}

class _VerticalDefaultRangeSliderPageState extends SampleViewState {
  _VerticalDefaultRangeSliderPageState();
  final SfRangeValues _inactiveRangeSliderValue = const SfRangeValues(
    20.0,
    80.0,
  );
  SfRangeValues _activeRangeSliderValue = const SfRangeValues(20.0, 80.0);
  bool _isInversed = false;

  SfRangeSlider _inactiveRangeSlider() {
    //ignore: missing_required_param
    return SfRangeSlider.vertical(
      max: 100.0,
      values: _inactiveRangeSliderValue,
      isInversed: _isInversed,
      onChanged: null,
    );
  }

  SfRangeSliderTheme _activeRangeSliderSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        max: 100.0,
        onChanged: (dynamic values) {
          setState(() {
            _activeRangeSliderValue = values as SfRangeValues;
          });
        },
        values: _activeRangeSliderValue,
        isInversed: _isInversed,
        enableTooltip: true,
        numberFormat: NumberFormat('#'),
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
              Expanded(child: _activeRangeSliderSlider()),
              const Text('Enabled'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _inactiveRangeSlider()),
              const Text('Disabled'),
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

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          value: _isInversed,
          title: const Text('Inversed', softWrap: false),
          contentPadding: EdgeInsets.zero,
          activeColor: model.primaryColor,
          onChanged: (bool? value) {
            setState(() {
              _isInversed = value!;
              stateSetter(() {});
            });
          },
        );
      },
    );
  }
}
