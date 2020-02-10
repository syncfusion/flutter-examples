import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BarSpacing extends StatefulWidget {
  BarSpacing({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BarSpacingState createState() => _BarSpacingState(sample);
}

class _BarSpacingState extends State<BarSpacing> {
  _BarSpacingState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, BarSettingsFrontPanel(sample));
  }
}

SfCartesianChart getSpacingBarChart(bool isTileView,
    [double columnWidth, double columnSpacing]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Exports & Imports of US'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: NumericAxis(
        minimum: 2005,
        maximum: 2011,
        interval: 1,
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
      labelFormat: '{value}%',
      title: AxisTitle(text: isTileView ? '' : 'Goods and services (% of GDP)'),
    ),
    series: getSpacingBarSeries(isTileView, columnWidth, columnSpacing),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<BarSeries<ChartSampleData, num>> getSpacingBarSeries(
    bool isTileView, double columnWidth, double columnSpacing) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2006, y: 16.219, yValue2: 10.655),
    ChartSampleData(x: 2007, y: 16.461, yValue2: 11.498),
    ChartSampleData(x: 2008, y: 17.427, yValue2: 12.514),
    ChartSampleData(x: 2009, y: 13.754, yValue2: 11.012),
    ChartSampleData(x: 2010, y: 15.743, yValue2: 12.315),
  ];
  return <BarSeries<ChartSampleData, num>>[
    BarSeries<ChartSampleData, num>(
        enableTooltip: true,
        width: isTileView ? 0.8 : columnWidth,
        spacing: isTileView ? 0.2 : columnSpacing,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Import'),
    BarSeries<ChartSampleData, num>(
        enableTooltip: true,
        width: isTileView ? 0.8 : columnWidth,
        spacing: isTileView ? 0.2 : columnSpacing,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Export')
  ];
}

//ignore:must_be_immutable
class BarSettingsFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  BarSettingsFrontPanel(this.subItemList);
  SubItem subItemList;

  @override
  _BarSettingsFrontPanelState createState() =>
      _BarSettingsFrontPanelState(subItemList);
}

class _BarSettingsFrontPanelState extends State<BarSettingsFrontPanel> {
  _BarSettingsFrontPanelState(this.sample);
  final SubItem sample;
  double columnWidth = 0.8;
  double columnSpacing = 0.2;
  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();

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
                    child:
                        getSpacingBarChart(false, columnWidth, columnSpacing)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Width  ',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: model.textColor)),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 0,
                                                maxValue: 1,
                                                initialValue: columnWidth,
                                                onChanged: (double val) =>
                                                    setState(() {
                                                  columnWidth = val;
                                                }),
                                                step: 0.1,
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
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text('Spacing  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 0,
                                                maxValue: 0.9,
                                                initialValue: columnSpacing,
                                                onChanged: (double val) =>
                                                    setState(() {
                                                  columnSpacing = val;
                                                }),
                                                step: 0.1,
                                                horizontal: true,
                                                loop: true,
                                                padding: 5.0,
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
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ))));
  }
}
