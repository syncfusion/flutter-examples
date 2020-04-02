import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';

//ignore: must_be_immutable
class PieTooltipPosition extends StatefulWidget {
  PieTooltipPosition({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _PieTooltipPositionState createState() => _PieTooltipPositionState(sample);
}

class _PieTooltipPositionState extends State<PieTooltipPosition> {
  _PieTooltipPositionState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, TooltipPositioningPanel(sample));
  }
}

dynamic getPieTooltipPositionChart(bool isTileView,
    [String chartType, TooltipPosition _tooltipPosition, double duration]) {
  dynamic _chart;
  if (chartType == 'column')
    _chart = SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isTileView ? '' : 'Age distribution'),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          tooltipPosition: _tooltipPosition,
          duration: duration * 1000,
          canShowMarker: false),
      primaryXAxis: CategoryAxis(
          title: AxisTitle(text: isTileView ? '' : 'Years'),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}M',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getCartesianSeries(isTileView),
    );
  else
    _chart = SfCircularChart(
      title: ChartTitle(
          text: isTileView
              ? ''
              : 'Various countries population density and area'),
      legend: Legend(
          isVisible: isTileView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap),
      series: _getPieSeries(isTileView),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        tooltipPosition: _tooltipPosition,
        duration: (duration == null ? 2.0 : duration) * 1000,
      ),
    );
  return _chart;
}

final List<_ChartData> chartData = <_ChartData>[
  _ChartData(
    'CHN',
    54,
    const Color.fromRGBO(53, 92, 125, 1),
  ),
  _ChartData(
    'USA',
    67,
    const Color.fromRGBO(192, 108, 132, 1),
  ),
  _ChartData(
    'IDN',
    65,
    const Color.fromRGBO(246, 114, 128, 1),
  ),
  _ChartData('JAP', 61, const Color.fromRGBO(248, 177, 149, 1)),
  _ChartData('BRAZ', 68, const Color.fromRGBO(116, 180, 155, 1))
];
List<ChartSeries<_ChartData, String>> _getCartesianSeries(bool isTileView) {
  return <ColumnSeries<_ChartData, String>>[
    ColumnSeries<_ChartData, String>(
      dataSource: chartData,
      pointColorMapper: (_ChartData sales, _) => sales.color,
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y1,
    ),
  ];
}

List<PieSeries<ChartSampleData, String>> _getPieSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
    ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
    ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
    ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
    ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
    ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
    ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%')
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}

class _ChartData {
  _ChartData(this.x, this.y1, [this.color]);
  final String x;
  final double y1;
  final Color color;
}

//ignore: must_be_immutable
class TooltipPositioningPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TooltipPositioningPanel([this.sample]);
  SubItem sample;

  @override
  _TooltipPositioningPanelState createState() =>
      _TooltipPositioningPanelState(sample);
}

class _TooltipPositioningPanelState extends State<TooltipPositioningPanel> {
  _TooltipPositioningPanelState(this.sample);
  final SubItem sample;
  
   Widget sampleWidget(SampleModel model) => getPieTooltipPositionChart(true);

  // final List<String> _modeList =
  //     <String>['column', 'pie'].toList();
  String _selectedChartType = 'pie';

  String _chartType = 'pie';

  final List<String> _tooltipPositionList =
      <String>['auto', 'pointer'].toList();
  String _selectedTooltipPosition = 'auto';
  TooltipPosition _tooltipPosition = TooltipPosition.auto;
  double duration = 2;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getPieTooltipPositionChart(
                        false, _chartType, _tooltipPosition, duration)),
              ),
              floatingActionButton: model.isWeb ? null :
              FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
  }

  void onPositionTypeChange(String item, SampleModel model) {
    setState(() {
      _selectedTooltipPosition = item;
      if (_selectedTooltipPosition == 'auto') {
        _tooltipPosition = TooltipPosition.auto;
      }
      if (_selectedTooltipPosition == 'pointer') {
        _tooltipPosition = TooltipPosition.pointer;
      }
    });
  }

  void _showSettingsPanel(SampleModel model) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleModel model) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 170,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * height,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 40,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Settings',
                                        style: TextStyle(
                                            color: model.textColor,
                                            fontSize: 18,
                                            letterSpacing: 0.34,
                                            fontWeight: FontWeight.w500)),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: model.textColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 50, 0, 0),
                                child: ListView(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text('Tooltip position  ',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 0, 0),
                                              height: 50,
                                              width: 150,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                      value:
                                                          _selectedTooltipPosition,
                                                      item: _tooltipPositionList
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value:
                                                                (value != null)
                                                                    ? value
                                                                    : 'auto',
                                                            child: Text(
                                                                '$value',
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      }).toList(),
                                                      valueChanged:
                                                          (dynamic value) {
                                                        onPositionTypeChange(
                                                            value.toString(),
                                                            model);
                                                      }),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Hide delay      ',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: model.textColor)),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 1,
                                                maxValue: 10,
                                                initialValue: duration,
                                                onChanged: (dynamic val) =>
                                                    setState(() {
                                                  duration = val;
                                                }),
                                                step: 2,
                                                horizontal: true,
                                                loop: true,
                                                padding: 0,
                                                iconUp: Icons.keyboard_arrow_up,
                                                iconDown:
                                                    Icons.keyboard_arrow_down,
                                                iconLeft:
                                                    Icons.keyboard_arrow_left,
                                                iconRight:
                                                    Icons.keyboard_arrow_right,
                                                iconUpRightColor:
                                                    model.textColor,
                                                iconDownLeftColor:
                                                    model.textColor,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: model.textColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ))));
  }

  void onChartTypeChange(String item, SampleModel model) {
    setState(() {
      _selectedChartType = item;
      if (_selectedChartType == 'column') {
        _chartType = 'column';
      }
      if (_selectedChartType == 'pie') {
        _chartType = 'pie';
      }
      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
    });
  }
}
