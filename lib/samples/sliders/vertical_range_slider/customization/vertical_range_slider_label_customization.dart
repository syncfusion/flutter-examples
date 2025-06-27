///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';

/// Renders vertical range slider with label customization option
class VerticalRangeSliderCustomization extends SampleView {
  /// Creates Vertical range slider with step duration
  const VerticalRangeSliderCustomization(Key key) : super(key: key);

  @override
  _VerticalRangeSliderCustomizationState createState() =>
      _VerticalRangeSliderCustomizationState();
}

class _VerticalRangeSliderCustomizationState extends SampleViewState {
  _VerticalRangeSliderCustomizationState();
  SfRangeValues _yearValues = SfRangeValues(DateTime(2005), DateTime(2015));
  SfRangeValues _values = const SfRangeValues(-25.0, 25.0);
  late String _selectedType;
  List<String>? _edgeList;
  late EdgeLabelPlacement _edgeLabelPlacement;
  late String _selectedLabelPlacementType;
  late List<String> _labelpositionList;
  late LabelPlacement _labelPlacement;

  @override
  void initState() {
    _selectedLabelPlacementType = 'onTicks';
    _labelpositionList = ['onTicks', 'betweenTicks'];
    _labelPlacement = LabelPlacement.onTicks;
    _selectedType = 'inside';
    _edgeList = <String>['auto', 'inside'].toList();
    _edgeLabelPlacement = EdgeLabelPlacement.inside;
    super.initState();
  }

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        min: DateTime(2000),
        max: DateTime(2020),
        edgeLabelPlacement: _edgeLabelPlacement,
        labelPlacement: _labelPlacement,
        showLabels: true,
        interval: 5,
        stepDuration: const SliderStepDuration(years: 5),
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        showTicks: true,
        values: _yearValues,
        onChanged: (SfRangeValues values) {
          setState(() {
            _yearValues = values;
          });
        },
        onLabelCreated:
            (dynamic actualValue, String formattedText, TextStyle textStyle) {
              final DateTime valueDate = actualValue;
              final DateTime startDate = _yearValues.start;
              final DateTime endDate = _yearValues.end;
              final int value = valueDate.year;
              final int start = startDate.year;
              final int end = endDate.year;
              final bool isStartIndex = value == start;
              final bool isEndIndex = value == end;
              return RangeSliderLabel(
                text: formattedText,
                textStyle: (isEndIndex || isStartIndex)
                    ? Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: model.primaryColor,
                        fontWeight: FontWeight.bold,
                      )
                    : textStyle,
              );
            },
        enableTooltip: true,
        tooltipTextFormatterCallback:
            (dynamic actualLabel, String formattedText) {
              return DateFormat.yMMM().format(actualLabel);
            },
      ),
    );
  }

  SfRangeSliderTheme _numericRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfRangeSlider.vertical(
        edgeLabelPlacement: _edgeLabelPlacement,
        labelPlacement: _labelPlacement,
        showLabels: true,
        interval: 25,
        stepSize: 25,
        min: -50.0,
        max: 50.0,
        showTicks: true,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        onLabelCreated:
            (dynamic actualValue, String formattedText, TextStyle textStyle) {
              final int value = actualValue.toInt();
              final int start = _values.start.toInt();
              final int end = _values.end.toInt();
              final bool isStartIndex = value == start;
              final bool isEndIndex = value == end;
              return RangeSliderLabel(
                text: (isStartIndex || isEndIndex)
                    ? formattedText
                    : '$actualValue',
                textStyle: (isStartIndex || isEndIndex)
                    ? Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: model.primaryColor,
                        fontWeight: FontWeight.bold,
                      )
                    : textStyle,
              );
            },
        enableTooltip: true,
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
              Expanded(child: _numericRangeSlider()),
              const Text('Numeric'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _yearRangeSlider()),
              const Text('DateTime'),
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
        return ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model.isWebFullView ? 'Label \nplacement' : 'Label placement',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedLabelPlacementType,
                    items: _labelpositionList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'on ticks',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onLabelPositionTypeChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model.isWebFullView
                      ? 'Edge label \nplacement '
                      : 'Edge label placement',
                  softWrap: false,
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                Container(
                  width: model.isDesktop ? 140 : 143,
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    isExpanded: true,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedType,
                    items: _edgeList!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'inside',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onPositionTypeChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onLabelPositionTypeChange(String item) {
    _selectedLabelPlacementType = item;
    if (_selectedLabelPlacementType == 'onTicks') {
      _labelPlacement = LabelPlacement.onTicks;
    }
    if (_selectedLabelPlacementType == 'betweenTicks') {
      _labelPlacement = LabelPlacement.betweenTicks;
    }
    setState(() {
      /// update the edge label placement changes
    });
  }

  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'auto') {
      _edgeLabelPlacement = EdgeLabelPlacement.auto;
    }
    if (_selectedType == 'inside') {
      _edgeLabelPlacement = EdgeLabelPlacement.inside;
    }

    setState(() {
      /// update the edge label placement changes
    });
  }
}
