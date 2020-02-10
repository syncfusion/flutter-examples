import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/switch.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class NumericInverse extends StatefulWidget {
  NumericInverse({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _NumericInverseState createState() => _NumericInverseState(sample);
}

class _NumericInverseState extends State<NumericInverse> {
  _NumericInverseState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null,  sample, InversedNumericFrontPanel(sample));
  }
}

SfCartesianChart getInversedNumericAxisChart(bool isTileView,
    [bool isXInversed, bool isYInversed]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Airports count in US'),
    primaryXAxis: NumericAxis(
        minimum: 2000,
        maximum: 2010,
        title: AxisTitle(text: isTileView ? '' : 'Year'),
        isInversed: isXInversed ?? true,
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern(),
        axisLine: AxisLine(width: 0),
        title: AxisTitle(text: isTileView ? '' : 'Count'),
        isInversed: isYInversed ?? true,
        majorTickLines: MajorTickLines(size: 0)),
    series: getInversedNumericSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<LineSeries<ChartSampleData, num>> getInversedNumericSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(xValue: 2000, yValue: 14720),
    ChartSampleData(xValue: 2001, yValue: 14695),
    ChartSampleData(xValue: 2002, yValue: 14801),
    ChartSampleData(xValue: 2003, yValue: 14807),
    ChartSampleData(xValue: 2004, yValue: 14857),
    ChartSampleData(xValue: 2006, yValue: 14858),
    ChartSampleData(xValue: 2007, yValue: 14947),
    ChartSampleData(xValue: 2008, yValue: 14951),
    ChartSampleData(xValue: 2010, yValue: 15079),
  ];
  return <LineSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

class InversedNumericFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  InversedNumericFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _InversedNumericFrontPanelState createState() =>
      _InversedNumericFrontPanelState(sampleList);
}

class _InversedNumericFrontPanelState extends State<InversedNumericFrontPanel> {
  _InversedNumericFrontPanelState(this.sample);
  final SubItem sample;
  bool isYInversed = true;
  bool isXInversed = true;

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
                    child: getInversedNumericAxisChart(
                        false, isXInversed, isYInversed)),
              ),
              floatingActionButton: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                      child: Container(
                        height: 50,
                        width: 250,
                        child: InkWell(
                          onTap: () => launch(
                              'https://www.indexmundi.com/g/g.aspx?c=us&v=121'),
                          child: Row(
                            children: <Widget>[
                              Text('Source: ',
                                  style: TextStyle(
                                      fontSize: 16, color: model.textColor)),
                              Text('www.indexmundi.com',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        _showSettingsPanel(model);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ),
                  ),
                ],
              ));
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
                  height: 150,
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
                              Text('Inverse X axis',
                                  style: TextStyle(
                                      color: model.textColor,
                                      fontSize: 16,
                                      letterSpacing: 0.34,
                                      fontWeight: FontWeight.normal)),
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: BottomSheetSwitch(
                                  activeColor: model.backgroundColor,
                                  switchValue: isXInversed,
                                  valueChanged: (dynamic value) {
                                    setState(() {
                                      isXInversed = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('Inverse Y axis',
                                  style: TextStyle(
                                      color: model.textColor,
                                      fontSize: 16,
                                      letterSpacing: 0.34,
                                      fontWeight: FontWeight.normal)),
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: BottomSheetSwitch(
                                  activeColor: model.backgroundColor,
                                  switchValue: isYInversed,
                                  valueChanged: (dynamic value) {
                                    setState(() {
                                      isYInversed = value;
                                    });
                                  },
                                ),
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
