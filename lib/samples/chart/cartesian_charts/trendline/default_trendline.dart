/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Render the default trendline chart sample.
class TrendLineDefault extends SampleView {
  /// craetes the default trendline chart sample
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
  late String _selectedTrendLineType;
  late TrendlineType _type;
  late int _polynomialOrder;
  late int _period;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _selectedTrendLineType = 'Linear';
    _type = TrendlineType.linear;
    _polynomialOrder = 2;
    _period = 2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrendLineDefaultChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text('Trendline type',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.6 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedTrendLineType,
                items: _trendlineTypeList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child:
                        Text(value, style: TextStyle(color: model.textColor)),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  _onTrendLineTypeChanged(value.toString());
                  stateSetter(() {});
                },
              ),
            ),
          ),
          Visibility(
            visible: _selectedTrendLineType != 'Polynomial' ? false : true,
            maintainState: true,
            child: ListTile(
              title: Text('Polynomial Order',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                width: 0.6 * screenWidth,
                padding: EdgeInsets.only(left: 0.03 * screenWidth),
                child: CustomDirectionalButtons(
                  minValue: 2,
                  maxValue: 6,
                  initialValue: _polynomialOrder.toDouble(),
                  onChanged: (double val) => setState(() {
                    _polynomialOrder = val.floor();
                  }),
                  loop: true,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _selectedTrendLineType != 'MovingAverage' ? false : true,
            maintainState: true,
            child: ListTile(
              title: Text('Period',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                width: 0.6 * screenWidth,
                padding: EdgeInsets.only(left: 0.03 * screenWidth),
                child: CustomDirectionalButtons(
                  minValue: 2,
                  maxValue: periodMaxValue.toDouble(),
                  initialValue: _period.toDouble(),
                  onChanged: (double val) => setState(() {
                    _period = val.floor();
                  }),
                  loop: true,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  /// Returns the column chart with defaul trendline types.
  SfCartesianChart _buildTrendLineDefaultChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'No. of website visitors in a week'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Visitors'),
        majorTickLines: const MajorTickLines(width: 0),
        numberFormat: NumberFormat.compact(),
        axisLine: const AxisLine(width: 0),
        interval: !isCardView ? 5000 : 10000,
        labelFormat: '{value}',
      ),
      series: _getTrendLineDefaultSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which
  /// need to render on the column chart with defaul trendline.
  List<ColumnSeries<ChartSampleData, String>> _getTrendLineDefaultSeries() {
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
                dashArray: <double>[15, 3, 3, 3],
                enableTooltip: true,
                polynomialOrder: _polynomialOrder,
                period: _period)
          ])
    ];
  }

  /// Method to update the selected trendline type for the chart.
  void _onTrendLineTypeChanged(String item) {
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
    setState(() {
      /// update the trend line  changes
    });
  }
}
