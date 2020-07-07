/// Package imports
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

import '../../../model/model.dart';
import '../../../model/sample_view.dart';

/// Render the dtefaul trendline chart sample.
class TrendLineDefault extends SampleView {
  const TrendLineDefault(Key key) : super(key: key);

  @override
  _TrendLineDefaultState createState() => _TrendLineDefaultState();
}

/// State class of dtefaul trendline chart.
class _TrendLineDefaultState extends SampleViewState {
  _TrendLineDefaultState();

  int periodMaxValue = 0;
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

  @override
  void initState() {
    _selectedTrendLineType = 'Linear';
    _type = TrendlineType.linear;
    _polynomialOrder = 2;
    _period = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getTrendLineDefaultChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
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
                    fontWeight: FontWeight.normal),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: DropDown(
                      value: _selectedTrendLineType,
                      item: _trendlineTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value != null ? value : 'Linear',
                          child: Text('$value',
                              style: TextStyle(color: model.textColor)),
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
        Visibility(
          visible: _selectedTrendLineType != 'Polynomial' ? false : true,
          maintainState: true,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Polynomial Order',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: _selectedTrendLineType != 'Polynomial'
                          ? const Color.fromRGBO(0, 0, 0, 0.3)
                          : model.textColor),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(37, 0, 0, 0),
                    child: HandCursor(
                      child: CustomButton(
                        minValue: 2,
                        maxValue: 6,
                        initialValue: _polynomialOrder.toDouble(),
                        onChanged: (dynamic val) => setState(() {
                          _polynomialOrder = val.floor();
                        }),
                        step: 1,
                        horizontal: true,
                        loop: true,
                        padding: 0,
                        iconUpRightColor: model.textColor,
                        iconDownLeftColor: model.textColor,
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: _selectedTrendLineType != 'MovingAverage' ? false : true,
          maintainState: true,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Period',
                  style: TextStyle(fontSize: 14.0, color: model.textColor),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(103, 0, 0, 0),
                    child: HandCursor(
                      child: CustomButton(
                        minValue: 2,
                        maxValue: periodMaxValue.toDouble(),
                        initialValue: _period.toDouble(),
                        onChanged: (dynamic val) => setState(() {
                          _period = val.floor();
                        }),
                        step: 1,
                        horizontal: true,
                        loop: true,
                        padding: 0,
                        iconUpRightColor: model.textColor,
                        iconDownLeftColor: model.textColor,
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  
  /// Returns the column chart with defaul trendline types.
  SfCartesianChart getTrendLineDefaultChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'No. of website visitors in a week'),
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Visitors'),
        majorTickLines: MajorTickLines(width: 0),
        numberFormat: NumberFormat.compact(),
        axisLine: AxisLine(width: 0),
        interval: !isCardView ? 5000 : 10000,
        labelFormat: '{value}',
      ),
      series: getTrendLineDefaultSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the column chart with defaul trendline.
  List<ColumnSeries<ChartSampleData, String>> getTrendLineDefaultSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(text: 'Sun', yValue: 12500),
      ChartSampleData(text: 'Mon', yValue: 14000),
      ChartSampleData(text: 'Tue', yValue: 22000),
      ChartSampleData(text: 'Wed', yValue: 26000),
      ChartSampleData(text: 'Thu', yValue: 19000),
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
                type: _type,
                width: 3,
                color: const Color.fromRGBO(192, 108, 132, 1),
                dashArray: kIsWeb ? <double>[0, 0] : <double>[15, 3, 3, 3],
                enableTooltip: true,
                polynomialOrder: _polynomialOrder,
                period: _period)
          ])
    ];
  }

  /// Method to update the selected trendline type for the chart.
  void onTrendLineTypeChanged(String item, SampleModel model) {
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
    setState(() {});
  }
}