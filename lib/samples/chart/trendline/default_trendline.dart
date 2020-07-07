import 'package:flutter/foundation.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class TrendLineDefault extends StatefulWidget {
  TrendLineDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _TrendLineDefaultState createState() => _TrendLineDefaultState(sample);
}

class _TrendLineDefaultState extends State<TrendLineDefault> {
  _TrendLineDefaultState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(
        null, sample, TrendLineDefaultWithOptionsFrontPanel(sample));
  }
}

int periodMaxValue = 0;
SfCartesianChart getTrendLineDefaultChart(bool isTileView,
    [TrendlineType trendlineType,
    int polynomialOrder,
    int period,
    SampleModel model]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title:
        ChartTitle(text: isTileView ? '' : 'No. of website visitors in a week'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
      title: AxisTitle(text: isTileView ? '' : 'Visitors'),
      majorTickLines: MajorTickLines(width: 0),
      numberFormat: NumberFormat.compact(),
      axisLine: AxisLine(width: 0),
      interval: !isTileView ? 5000 : 10000,
      labelFormat: '{value}',
    ),
    series: getTrendLineDefaultSeries(
        isTileView, trendlineType, polynomialOrder, period, model),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ColumnSeries<ChartSampleData, String>> getTrendLineDefaultSeries(
    bool isTileView,
    TrendlineType trendlineType,
    int polynomialOrder,
    int period,
    SampleModel model) {
  final bool isExistModel = model != null && model.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(text: 'Sun', yValue: 12500),
    ChartSampleData(text: 'Mon', yValue: 14000),
    ChartSampleData(text: 'Tue', yValue: 22000),
    ChartSampleData(text: 'Wed', yValue: 26000),
    ChartSampleData(text: 'Thus', yValue: 19000),
    ChartSampleData(text: 'Fri', yValue: 28000),
    ChartSampleData(text: 'Sat', yValue: 32000),
  ];
  periodMaxValue = chartData.length - 1;
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.text,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        name: 'Visitors count',
        trendlines: <Trendline>[
          Trendline(
              type: isExistModel
                  ? model.properties['TrendlineType']
                  : trendlineType,
              width: 3,
              color: const Color.fromRGBO(192, 108, 132, 1),
              dashArray: kIsWeb ? <double>[0, 0] : <double>[15, 3, 3, 3],
              enableTooltip: true,
              polynomialOrder: isExistModel ? 4 : polynomialOrder,
              period: period)
        ])
  ];
}

//ignore: must_be_immutable
class TrendLineDefaultWithOptionsFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TrendLineDefaultWithOptionsFrontPanel([this.sample]);
  SubItem sample;

  @override
  _TrendLineDefaultWithOptionsFrontPanelState createState() =>
      _TrendLineDefaultWithOptionsFrontPanelState(sample);
}

class _TrendLineDefaultWithOptionsFrontPanelState
    extends State<TrendLineDefaultWithOptionsFrontPanel> {
  _TrendLineDefaultWithOptionsFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _trendlineTypeList = <String>[
    'Linear',
    'Exponential',
    'Power',
    'Logarithmic',
    'Polynomial',
    'MovingAverage'
  ].toList();
  String _selectedTrendLineType = 'Linear';
  TrendlineType _type = TrendlineType.linear;
  int _polynomialOrder = 2;
  int _period = 2;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getTrendLineDefaultChart(false, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedTrendLineType = 'Linear';
    _type = TrendlineType.linear;
    _polynomialOrder = 2;
    _period = 2;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedTrendLineType': _selectedTrendLineType,
        'TrendLineType': _type,
        'PolynomialOrder': _polynomialOrder,
        'Period': _period
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleModel model) {
        return Scaffold(
          backgroundColor: model.cardThemeColor,
          body: !model.isWeb
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                  child: getTrendLineDefaultChart(
                      false, _type, _polynomialOrder, _period, null),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child:
                      getTrendLineDefaultChart(false, null, null, null, null),
                ),
          floatingActionButton: model.isWeb
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    _showSettingsPanel(model, false, context);
                  },
                  child: Icon(Icons.graphic_eq, color: Colors.white),
                  backgroundColor: model.backgroundColor,
                ),
        );
      },
    );
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Properties',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  HandCursor(
                      child: IconButton(
                    icon: Icon(Icons.close, color: model.webIconColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
                ]),
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    'Trendline type',
                    style: TextStyle(
                        color: model.textColor,
                        fontSize: 14.0,
                        letterSpacing: 0.34,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    height: 50,
                    width: 160,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: DropDown(
                          value: model.properties['SelectedTrendLineType'],
                          item: _trendlineTypeList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value != null ? value : 'Linear',
                              child: Text('$value',
                                  style: TextStyle(
                                      color: model.textColor, fontSize: 14)),
                            );
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onTrendLineTypeChanged(value.toString(), model);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
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
                                          children: <Widget>[
                                            Text(
                                              'Trendline type',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.34,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      60, 0, 0, 0),
                                              height: 50,
                                              width: 200,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      canvasColor: model
                                                          .bottomSheetBackgroundColor),
                                                  child: DropDown(
                                                    value:
                                                        _selectedTrendLineType,
                                                    item: _trendlineTypeList
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value != null
                                                            ? value
                                                            : 'Linear',
                                                        child: Text('$value',
                                                            style: TextStyle(
                                                                color: model
                                                                    .textColor)),
                                                      );
                                                    }).toList(),
                                                    valueChanged:
                                                        (dynamic value) {
                                                      onTrendLineTypeChanged(
                                                          value.toString(),
                                                          model);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: _selectedTrendLineType !=
                                                'Polynomial'
                                            ? false
                                            : true,
                                        maintainState: true,
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Polynomial Order',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: _selectedTrendLineType !=
                                                            'Polynomial'
                                                        ? const Color.fromRGBO(
                                                            0, 0, 0, 0.3)
                                                        : model.textColor),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          37, 0, 0, 0),
                                                  child: CustomButton(
                                                    minValue: 2,
                                                    maxValue: 6,
                                                    initialValue:
                                                        _polynomialOrder
                                                            .toDouble(),
                                                    onChanged: (dynamic val) =>
                                                        setState(() {
                                                      _polynomialOrder =
                                                          val.floor();
                                                    }),
                                                    step: 1,
                                                    horizontal: true,
                                                    loop: true,
                                                    padding: 0,
                                                    iconUp:
                                                        Icons.keyboard_arrow_up,
                                                    iconDown: Icons
                                                        .keyboard_arrow_down,
                                                    iconLeft: Icons
                                                        .keyboard_arrow_left,
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _selectedTrendLineType !=
                                                'MovingAverage'
                                            ? false
                                            : true,
                                        maintainState: true,
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Period',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          103, 0, 0, 0),
                                                  child: CustomButton(
                                                    minValue: 2,
                                                    maxValue: periodMaxValue
                                                        .toDouble(),
                                                    initialValue:
                                                        _period.toDouble(),
                                                    onChanged: (dynamic val) =>
                                                        setState(() {
                                                      _period = val.floor();
                                                    }),
                                                    step: 1,
                                                    horizontal: true,
                                                    loop: true,
                                                    padding: 0,
                                                    iconUp:
                                                        Icons.keyboard_arrow_up,
                                                    iconDown: Icons
                                                        .keyboard_arrow_down,
                                                    iconLeft: Icons
                                                        .keyboard_arrow_left,
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
                                              )
                                            ],
                                          ),
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
    return widget ?? Container();
  }

  void onTrendLineTypeChanged(String item, SampleModel model) {
    // setState(() {
    _selectedTrendLineType = item;
    switch (_selectedTrendLineType) {
      case 'Linear':
        _type = TrendlineType.linear;
        break;
      case 'Exponential':
        _type = TrendlineType.exponential;
        break;
      case 'Power':
        _type = TrendlineType.power;
        break;
      case 'Logarithmic':
        _type = TrendlineType.logarithmic;
        break;
      case 'Polynomial':
        _type = TrendlineType.polynomial;
        break;
      case 'MovingAverage':
        _type = TrendlineType.movingAverage;
        break;
    }
    model.properties['SelectedTrendLineType'] = _selectedTrendLineType;
    model.properties['TrendlineType'] = _type;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {
        // ignore: invalid_use_of_protected_member
        model.notifyListeners();
      });

    // });
  }
}
