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
import '../../slider_utils.dart';

///Render Slider with label customization option
class LabelCustomizationSlider extends SampleView {
  ///Render Slider with label customization option
  const LabelCustomizationSlider(Key key) : super(key: key);

  @override
  _LabelCustomizationSliderState createState() =>
      _LabelCustomizationSliderState();
}

class _LabelCustomizationSliderState extends SampleViewState {
  _LabelCustomizationSliderState();
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
      child: SfSlider(
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
      child: SfSlider(
        edgeLabelPlacement: _edgeLabelPlacement,
        labelPlacement: _labelPlacement,
        showLabels: true,
        interval: 5,
        min: -10.0,
        max: 10.0,
        showTicks: true,
        stepSize: 5.0,
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
          title('Numeric'),
          columnSpacing10,
          _sliderWithStepCustomization(),
          columnSpacing40,
          title('DateTime'),
          columnSpacing10,
          _sliderWithStepDurationCustomization(),
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

  @override
  Widget buildSettings(BuildContext buildContext) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
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
                        value: (value != null) ? value : 'onTicks',
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
    if (_selectedType == 'inside') {
      _edgeLabelPlacement = EdgeLabelPlacement.inside;
    }
    if (_selectedType == 'auto') {
      _edgeLabelPlacement = EdgeLabelPlacement.auto;
    }

    setState(() {
      /// update the edge label placement changes
    });
  }
}
