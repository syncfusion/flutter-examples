/// Package import
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/custom_button.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the Pie chart with legend
class LegendOptions extends SampleView {
  /// Creates the doughnut chart with legend
  const LegendOptions(Key key) : super(key: key);

  @override
  _LegendOptionsState createState() => _LegendOptionsState();
}

class _LegendOptionsState extends SampleViewState {
  _LegendOptionsState();
  bool toggleVisibility = true;
  bool enableFloatingLegend = false;
  final List<String> _positionList =
      <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
  String _selectedPosition = 'auto';
  LegendPosition _position = LegendPosition.auto;

  final List<String> _modeList = <String>['wrap', 'scroll', 'none'].toList();
  String _selectedMode = 'wrap';
  LegendItemOverflowMode _overflowMode = LegendItemOverflowMode.wrap;
  late double _xOffset = 0.0;
  late double _yOffset = 0.0;

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text('Position ',
                softWrap: false,
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.4 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _selectedPosition,
                  items: _positionList.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'auto',
                        child: Text(value,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onPositionTypeChange(value.toString());
                    stateSetter(() {});
                  }),
            ),
          ),
          ListTile(
            title:
                Text(model.isWebFullView ? 'Overflow \nmode' : 'Overflow mode',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.4 * screenWidth,
                height: 50,
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _selectedMode,
                    items: _modeList.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'wrap',
                          child: Text(value,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onModeTypeChange(value);
                      stateSetter(() {});
                    })),
          ),
          ListTile(
            title: Text(
                model.isWebFullView
                    ? 'Toggle \nvisibility'
                    : 'Toggle visibility',
                softWrap: false,
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.05 * screenWidth),
                width: 0.4 * screenWidth,
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: model.backgroundColor,
                    value: toggleVisibility,
                    onChanged: (bool? value) {
                      setState(() {
                        toggleVisibility = value!;
                        stateSetter(() {});
                      });
                    })),
          ),
          ListTile(
            title: Text(
                model.isWebFullView ? 'Floating \nlegend' : 'Floating legend',
                softWrap: false,
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.05 * screenWidth),
                width: 0.4 * screenWidth,
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: model.backgroundColor,
                    value: enableFloatingLegend,
                    onChanged: (bool? value) {
                      setState(() {
                        enableFloatingLegend = value!;
                        stateSetter(() {});
                      });
                    })),
          ),
          ListTile(
              title: Text('X offset',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                width: 0.4 * screenWidth,
                height: 50,
                child: CustomDirectionalButtons(
                  minValue: -100,
                  maxValue: 100,
                  initialValue: _xOffset,
                  onChanged: (double val) => setState(() {
                    _xOffset = enableFloatingLegend ? val : 0;
                  }),
                  step: enableFloatingLegend ? 10 : 0,
                  iconColor: model.textColor
                      .withOpacity(enableFloatingLegend ? 1 : 0.5),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: model.textColor
                          .withOpacity(enableFloatingLegend ? 1 : 0.5)),
                ),
              )),
          ListTile(
              title: Text('Y offset',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                width: 0.4 * screenWidth,
                height: 50,
                child: CustomDirectionalButtons(
                  minValue: -100,
                  maxValue: 100,
                  initialValue: _yOffset,
                  onChanged: (double val) => setState(() {
                    _yOffset = enableFloatingLegend ? val : 0;
                  }),
                  step: enableFloatingLegend ? 10 : 0,
                  iconColor: model.textColor
                      .withOpacity(enableFloatingLegend ? 1 : 0.5),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: model.textColor
                          .withOpacity(enableFloatingLegend ? 1 : 0.5)),
                ),
              )),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendOptionsChart();
  }

  ///Get the circular chart which has legend
  SfCircularChart _buildLegendOptionsChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Expenses by category'),
      legend: Legend(
          isVisible: true,
          position: _position,
          offset: enableFloatingLegend ? Offset(_xOffset, _yOffset) : null,
          overflowMode: _overflowMode,
          toggleSeriesVisibility: toggleVisibility),
      series: _getLegendOptionsSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  ///Get the pie series
  List<PieSeries<ChartSampleData, String>> _getLegendOptionsSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Tution Fees', y: 21),
      ChartSampleData(x: 'Entertainment', y: 21),
      ChartSampleData(x: 'Private Gifts', y: 8),
      ChartSampleData(x: 'Local Revenue', y: 21),
      ChartSampleData(x: 'Federal Revenue', y: 16),
      ChartSampleData(x: 'Others', y: 8)
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: pieData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }

  ///Changing the legend position
  void _onPositionTypeChange(String item) {
    setState(() {
      _selectedPosition = item;
      if (_selectedPosition == 'auto') {
        _position = LegendPosition.auto;
      }
      if (_selectedPosition == 'bottom') {
        _position = LegendPosition.bottom;
      }
      if (_selectedPosition == 'right') {
        _position = LegendPosition.right;
      }
      if (_selectedPosition == 'left') {
        _position = LegendPosition.left;
      }
      if (_selectedPosition == 'top') {
        _position = LegendPosition.top;
      }
    });
  }

  ///Change the legend overflow mode
  void _onModeTypeChange(String item) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'wrap') {
        _overflowMode = LegendItemOverflowMode.wrap;
      }
      if (_selectedMode == 'scroll') {
        _overflowMode = LegendItemOverflowMode.scroll;
      }
      if (_selectedMode == 'none') {
        _overflowMode = LegendItemOverflowMode.none;
      }
    });
  }
}
