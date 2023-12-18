/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the doughnut chart with legend
class LegendDefault extends SampleView {
  /// Creates the doughnut chart with legend
  const LegendDefault(Key key) : super(key: key);

  @override
  _LegendDefaultState createState() => _LegendDefaultState();
}

class _LegendDefaultState extends SampleViewState {
  _LegendDefaultState();
  bool _shouldAlwaysShowScrollbar = false;
  late String _selectedMode;
  List<String>? _modeList;
  late LegendItemOverflowMode _overflowMode;
  late String _selectedPosition;
  List<String>? _positionList;
  late LegendPosition _position;

  @override
  void initState() {
    _selectedMode = 'wrap';
    _modeList = <String>['wrap', 'none', 'scroll'].toList();
    _position = LegendPosition.auto;
    _selectedPosition = 'auto';
    _positionList = <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
    _overflowMode = LegendItemOverflowMode.wrap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendDefaultChart();
  }

  ///Get the default circular series with legend
  SfCircularChart _buildLegendDefaultChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Electricity sectors'),
      legend: Legend(
          position: _position,
          isVisible: true,
          overflowMode: _overflowMode,
          shouldAlwaysShowScrollbar: _shouldAlwaysShowScrollbar),
      series: _getLegendDefaultSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  ///Get the default circular series
  List<DoughnutSeries<ChartSampleData, String>> _getLegendDefaultSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Coal', y: 56.2),
            ChartSampleData(x: 'Large Hydro', y: 12.7),
            ChartSampleData(x: 'Small Hydro', y: 1.3),
            ChartSampleData(x: 'Wind Power', y: 10),
            ChartSampleData(x: 'Solar Power', y: 8),
            ChartSampleData(x: 'Biomass', y: 2.6),
            ChartSampleData(x: 'Nuclear', y: 1.9),
            ChartSampleData(x: 'Gas', y: 7),
            ChartSampleData(x: 'Diesel', y: 0.2),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside)),
    ];
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                flex: 14,
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text('Position',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 16,
                              color: model.textColor,
                            )),
                      ),
                      Flexible(
                        child: SizedBox(
                            width: 80,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedPosition,
                                items: _positionList!.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'auto',
                                      child: Text(value,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                onChanged: (dynamic value) {
                                  _onPositionTypeChange(value.toString());
                                  stateSetter(() {});
                                })),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                            model.isWebFullView
                                ? 'Overflow \nmode'
                                : 'Overflow mode',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 16,
                              color: model.textColor,
                            )),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: 80,
                          child: DropdownButton<String>(
                              focusColor: Colors.transparent,
                              isExpanded: true,
                              underline: Container(
                                  color: const Color(0xFFBDBDBD), height: 1),
                              value: _selectedMode,
                              items: _modeList!.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'wrap',
                                    child: Text(value,
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              onChanged: (dynamic value) {
                                _onModeTypeChange(value);
                                stateSetter(() {});
                              }),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Visibility(
                    visible: _overflowMode == LegendItemOverflowMode.scroll,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Show scrollbar \nalways',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: Container(
                              width: 90,
                              alignment: Alignment.centerLeft,
                              child: Checkbox(
                                  activeColor: model.backgroundColor,
                                  value: _shouldAlwaysShowScrollbar,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _shouldAlwaysShowScrollbar = value!;
                                      stateSetter(() {});
                                    });
                                  })),
                        )
                      ],
                    ),
                  )
                ])),
            Expanded(flex: model.isMobile ? 7 : 1, child: Container()),
          ],
        ),
      ]);
    });
  }

  ///Change the legend position
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
