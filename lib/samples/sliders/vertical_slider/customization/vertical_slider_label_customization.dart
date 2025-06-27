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

///Render vertical Slider with label customization option
class VerticalSliderLabelCustomization extends SampleView {
  ///Render vertical Slider with label customization option
  const VerticalSliderLabelCustomization(Key key) : super(key: key);

  @override
  _VerticalSliderLabelCustomizationState createState() =>
      _VerticalSliderLabelCustomizationState();
}

class _VerticalSliderLabelCustomizationState extends SampleViewState {
  _VerticalSliderLabelCustomizationState();
  DateTime _yearValue = DateTime(2014);
  double _stepSliderValue = 0;
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

  SfSliderTheme _sliderWithStepDurationCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        min: DateTime(2010),
        max: DateTime(2018),
        edgeLabelPlacement: _edgeLabelPlacement,
        labelPlacement: _labelPlacement,
        showLabels: true,
        interval: 2,
        stepDuration: const SliderStepDuration(years: 2),
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        showTicks: true,
        value: _yearValue,
        onChanged: (dynamic values) {
          setState(() {
            _yearValue = values as DateTime;
          });
        },
        onLabelCreated:
            (dynamic actualValue, String formattedText, TextStyle textStyle) {
              final bool currentDateIndex = actualValue == _yearValue;
              return SliderLabel(
                text: formattedText,
                textStyle: currentDateIndex
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
              return DateFormat.y().format(actualLabel);
            },
      ),
    );
  }

  SfSliderTheme _sliderWithStepCustomization() {
    return SfSliderTheme(
      data: SfSliderThemeData(tooltipBackgroundColor: model.primaryColor),
      child: SfSlider.vertical(
        showLabels: true,
        edgeLabelPlacement: _edgeLabelPlacement,
        labelPlacement: _labelPlacement,
        interval: 5,
        stepSize: 5,
        min: -10.0,
        max: 10.0,
        showTicks: true,
        value: _stepSliderValue,
        onChanged: (dynamic values) {
          setState(() {
            _stepSliderValue = values as double;
          });
        },
        onLabelCreated:
            (dynamic actualValue, String formattedText, TextStyle textStyle) {
              final bool currentIndex = actualValue == _stepSliderValue;
              return SliderLabel(
                text: currentIndex ? formattedText : '$actualValue',
                textStyle: currentIndex
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
              Expanded(child: _sliderWithStepCustomization()),
              const Text('Numeric'),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(child: _sliderWithStepDurationCustomization()),
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
        final Widget slider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 350
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 400, child: slider),
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
