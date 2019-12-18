import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:scoped_model/scoped_model.dart';

//ignore: must_be_immutable
class CategoryIndexed extends StatefulWidget {
  CategoryIndexed({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _CategoryIndexedState createState() => _CategoryIndexedState(sample);
}

class _CategoryIndexedState extends State<CategoryIndexed> {
  _CategoryIndexedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, IndexedFrontPanel(sample));
  }
}

SfCartesianChart getIndexedCategoryAxisChart(bool isTileView,
    [bool isIndexed]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Real GDP growth'),
    plotAreaBorderWidth: 0,
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: CategoryAxis(
        arrangeByIndex: isTileView ? true : isIndexed,
        majorGridLines: MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        title: AxisTitle(text: isTileView ? '' : 'GDP growth rate'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getIndexedCategoryAxisSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ColumnSeries<ChartSampleData, String>> getIndexedCategoryAxisSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Myanmar', yValue: 7.3),
    ChartSampleData(x: 'India', yValue: 7.9),
    ChartSampleData(x: 'Bangladesh', yValue: 6.8)
  ];
  final List<ChartSampleData> chartData1 = <ChartSampleData>[
    ChartSampleData(x: 'Poland', yValue: 2.7),
    ChartSampleData(x: 'Australia', yValue: 2.5),
    ChartSampleData(x: 'Singapore', yValue: 2.0)
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        name: '2015'),
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData1,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        name: '2016')
  ];
}

class IndexedFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  IndexedFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _IndexedFrontPanelState createState() => _IndexedFrontPanelState(sampleList);
}

class _IndexedFrontPanelState extends State<IndexedFrontPanel> {
  _IndexedFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

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
                    child: getIndexedCategoryAxisChart(false, isIndexed)),
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

  void _showSettingsPanel(SampleModel model) {
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) =>
            ScopedModelDescendant<SampleModel>(
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
                                  Text('Arrange by index',
                                      style: TextStyle(
                                          color: model.textColor,
                                          fontSize: 16,
                                          letterSpacing: 0.34,
                                          fontWeight: FontWeight.normal)),
                                  BottomSheetCheckbox(
                                    activeColor: model.backgroundColor,
                                    switchValue: isIndexed,
                                    valueChanged: (dynamic value) {
                                      setState(() {
                                        isIndexed = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )));
  }
}
