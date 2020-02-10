import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';

//ignore: must_be_immutable
class CategoryTicks extends StatefulWidget {
  CategoryTicks({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _CategoryTicksState createState() => _CategoryTicksState(sample);
}

class _CategoryTicksState extends State<CategoryTicks> {
  _CategoryTicksState(this.sample);
  final SubItem sample;
 
  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null,  sample, LabelPlacementFrontPanel(sample));
  }
}

SfCartesianChart getTicksCategoryAxisChart(bool isTileView,
    [LabelPlacement _labelPlacement]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Employees task count'),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: _labelPlacement != null
            ? _labelPlacement
            : LabelPlacement.betweenTicks),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        minimum: 7,
        maximum: 12,
        interval: 1),
    series: getTicksCategoryAxisSeries(isTileView, _labelPlacement),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<LineSeries<ChartSampleData, String>> getTicksCategoryAxisSeries(
    bool isTileView, LabelPlacement _labelPlacement) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'John', yValue: 10),
    ChartSampleData(x: 'Parker', yValue: 11),
    ChartSampleData(x: 'David', yValue: 9),
    ChartSampleData(x: 'Peter', yValue: 10),
    ChartSampleData(x: 'Antony', yValue: 11),
    ChartSampleData(x: 'Brit', yValue: 10)
  ];
  return <LineSeries<ChartSampleData, String>>[
    LineSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

class LabelPlacementFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  LabelPlacementFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _LabelPlacementFrontPanelState createState() =>
      _LabelPlacementFrontPanelState(sampleList);
}

class _LabelPlacementFrontPanelState extends State<LabelPlacementFrontPanel> {
  _LabelPlacementFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _labelPosition =
      <String>['betweenTicks', 'onTicks'].toList();

  String _selectedType = 'betweenTicks';

  LabelPlacement _labelPlacement = LabelPlacement.betweenTicks;

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
                    child: getTicksCategoryAxisChart(false, _labelPlacement)),
              ),
              floatingActionButton: FloatingActionButton(
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
      _selectedType = item;
      if (_selectedType == 'betweenTicks') {
        _labelPlacement = LabelPlacement.betweenTicks;
      }
      if (_selectedType == 'onTicks') {
        _labelPlacement = LabelPlacement.onTicks;
      }
    });
  }

  void _showSettingsPanel(SampleModel model) {
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<
                SampleModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleModel model) =>
                Container(
                  height: 120,
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                  child: Stack(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                      child: ListView(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Label placement ',
                                  style: TextStyle(
                                      color: model.textColor,
                                      fontSize: 16,
                                      letterSpacing: 0.34,
                                      fontWeight: FontWeight.normal)),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          canvasColor:
                                              model.bottomSheetBackgroundColor),
                                      child: DropDown(
                                          value: _selectedType,
                                          item: _labelPosition
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                                value: (value != null)
                                                    ? value
                                                    : 'betweenTicks',
                                                child: Text('$value',
                                                    style: TextStyle(
                                                        color:
                                                            model.textColor)));
                                          }).toList(),
                                          valueChanged: (dynamic value) {
                                            onPositionTypeChange(
                                                value.toString(), model);
                                          }),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                )));
  }
}
