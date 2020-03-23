import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/model.dart';

//ignore: must_be_immutable
class TrendLineForecast extends StatefulWidget {
  TrendLineForecast({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _TrendLineForecastState createState() => _TrendLineForecastState(sample);
}

class _TrendLineForecastState extends State<TrendLineForecast> {
  _TrendLineForecastState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null, sample, TrendLineForecastWithOptionsFrontPanel(sample));
  }
}

SfCartesianChart getTrendLineForecastChart(bool isTileView,
    [double forwardForecast, double backwardForecast]) {
  int j = 0;
  final List<ChartSampleData> trendLineData = <ChartSampleData>[];
  final List<double> yValue = <double>[1.2, 1.07, 0.92, 0.90, 0.94, 1.13, 1.24, 1.25, 1.26, 1.37, 1.47, 1.39, 1.33, 1.39, 1.29, 
  1.33, 1.33, 1.11, 1.11, 1.13, 1.18, 1.12];
  for (int i = 1999; i <= 2019; i++) {
    trendLineData.add(ChartSampleData(x: i, y: yValue[j]));
    j++;
  }

  return SfCartesianChart(
    plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isTileView ? '' : 'Euro to USD yearly exchange rate - 1999 to 2019'),
      legend: Legend(isVisible: isTileView ? false : true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isTileView ? '' : 'Dollars'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          minimum: 0.8,
          maximum: 1.8,
          interval:0.2,
          labelFormat: '\${value}',),
      series: <SplineSeries<ChartSampleData, num>>[
        SplineSeries<ChartSampleData, num>(
            color: const Color.fromRGBO(192, 108, 132, 1),
            dataSource: trendLineData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
            markerSettings: MarkerSettings(isVisible: true),
            name: 'Exchange rate',
            trendlines: <Trendline>[
              Trendline(
                  type: TrendlineType.linear,
                  width: 3,
                  dashArray: kIsWeb ? <double>[0, 0] : <double>[10, 10],
                  name: 'Linear',
                  enableTooltip: true,
                  forwardForecast: forwardForecast,
                  backwardForecast: backwardForecast)
            ])
      ]);
}

class TrendLineForecastWithOptionsFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TrendLineForecastWithOptionsFrontPanel(this.subItemList);
  final SubItem subItemList;
  @override
  _TrendLineForecastWithOptionsFrontPanelState createState() =>
      _TrendLineForecastWithOptionsFrontPanelState(subItemList);
}

class _TrendLineForecastWithOptionsFrontPanelState
    extends State<TrendLineForecastWithOptionsFrontPanel> {
  _TrendLineForecastWithOptionsFrontPanelState(this.sample);
  final SubItem sample;
  double _backwardForecastValue = 0.0;
  double _forwardForecastValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleModel model) {
        return Scaffold(
          backgroundColor: model.cardThemeColor,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: getTrendLineForecastChart(
                false, _forwardForecastValue, _backwardForecastValue),
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
                              'https://www.ofx.com/en-au/forex-news/historical-exchange-rates/yearly-average-rates/'),
                          child: Row(
                            children: <Widget>[
                              Text('Source: ',
                                  style: TextStyle(
                                      fontSize: 16, color: model.textColor)),
                              Text('www.ofx.com',
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
              )
        );
      },
    );
  }

  void _showSettingsPanel(SampleModel model) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 20.0,
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
                                          Text(
                                            'Forward forecast',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: model.textColor),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      50, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 0,
                                                maxValue: 50,
                                                initialValue:
                                                    _forwardForecastValue,
                                                onChanged: (dynamic val) =>
                                                    setState(() {
                                                  _forwardForecastValue =
                                                      val;
                                                }),
                                                step: 1,
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
                                          )
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
                                          Text(
                                            'Backward forecast',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: model.textColor),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 0,
                                                maxValue: 50,
                                                initialValue:
                                                    _backwardForecastValue,
                                                onChanged: (dynamic val) =>
                                                    setState(() {
                                                  _backwardForecastValue =
                                                      val;
                                                }),
                                                step: 1,
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
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
  }
}
