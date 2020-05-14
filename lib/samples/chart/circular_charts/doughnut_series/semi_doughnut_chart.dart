import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class DoughnutSemi extends StatefulWidget {
  DoughnutSemi({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DoughnutSemiState createState() => _DoughnutSemiState(sample);
}

class _DoughnutSemiState extends State<DoughnutSemi> {
  _DoughnutSemiState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, SemiDoughnutFrontPanel(sample));
  }
}

SfCircularChart getSemiDoughnutChart(bool isTileView,
    [int startAngle, int endAngle]) {
  return SfCircularChart(
    
    title: ChartTitle(text: isTileView ? '' : 'Sales by sales person'),
    legend: Legend(isVisible: isTileView ? false : true),
    centerY: isTileView ? '65%' : '60%',
    series: getSemiDoughnutSeries(isTileView, startAngle, endAngle),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<DoughnutSeries<ChartSampleData, String>> getSemiDoughnutSeries(
    bool isTileView, int startAngle, int endAngle) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'David', y: 75, text: 'David 74%'),
    ChartSampleData(x: 'Steve', y: 35, text: 'Steve 35%'),
    ChartSampleData(x: 'Jack', y: 39, text: 'Jack 39%'),
    ChartSampleData(x: 'Others', y: 75, text: 'Others 75%')
  ];
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        dataSource: chartData,
        innerRadius: '70%',
        radius: isTileView ? '100%' : '59%',
        startAngle: isTileView ? 270 : startAngle,
        endAngle: isTileView ? 90 : endAngle,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}

//ignore: must_be_immutable
class SemiDoughnutFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  SemiDoughnutFrontPanel([this.sample]);
   SubItem sample;

  @override
  _SemiDoughnutFrontPanelState createState() =>
      _SemiDoughnutFrontPanelState(sample);
}

class _SemiDoughnutFrontPanelState extends State<SemiDoughnutFrontPanel> {
  _SemiDoughnutFrontPanelState(this.sample);
  final SubItem sample;
  int startAngle = 270;
  int endAngle = 90;
  Widget sampleWidget(SampleModel model) => getSemiDoughnutChart(true);
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
                    child: getSemiDoughnutChart(false, startAngle, endAngle)),
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
                              child: Stack(children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            Text('Start Angle  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        40, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 90,
                                                  maxValue: 270,
                                                  initialValue:
                                                      startAngle.toDouble(),
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    startAngle = val.toInt();
                                                  }),
                                                  step: 10,
                                                  horizontal: true,
                                                  loop: false,
                                                  padding: 0,
                                                  iconUp:
                                                      Icons.keyboard_arrow_up,
                                                  iconDown:
                                                      Icons.keyboard_arrow_down,
                                                  iconLeft:
                                                      Icons.keyboard_arrow_left,
                                                  iconRight: Icons
                                                      .keyboard_arrow_right,
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 15, 0, 0),
                                              child: Text('End Angle  ',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: model.textColor)),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        50, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 90,
                                                  maxValue: 270,
                                                  initialValue:
                                                      endAngle.toDouble(),
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    endAngle = val.toInt();
                                                  }),
                                                  step: 10,
                                                  horizontal: true,
                                                  loop: false,
                                                  padding: 5.0,
                                                  iconUp:
                                                      Icons.keyboard_arrow_up,
                                                  iconDown:
                                                      Icons.keyboard_arrow_down,
                                                  iconLeft:
                                                      Icons.keyboard_arrow_left,
                                                  iconRight: Icons
                                                      .keyboard_arrow_right,
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
                              ]),
                            )))))));
  }
}
