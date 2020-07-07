import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class DateTimeDefault extends StatefulWidget {
  DateTimeDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DateTimeDefaultState createState() => _DateTimeDefaultState(sample);
}

class _DateTimeDefaultState extends State<DateTimeDefault> {
  _DateTimeDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.x-rates.com/graph/?from=USD&to=INR&amount=1';
    const String source = 'www.x-rates.com';
    return getScopedModel(
        getDefaultDateTimeAxisChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getDefaultDateTimeAxisChart(bool isTileView) {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isTileView
              ? ''
              : 'Euro to USD monthly exchange rate - 2015 to 2018'),
      primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0),
      minimum: DateTime(2015, 1, 1),
      maximum: DateTime(2019, 1, 1),
      intervalType: DateTimeIntervalType.years),
      primaryYAxis: NumericAxis(
        minimum: 1,
        maximum: 1.35,
        interval: 0.05,
        labelFormat: '\${value}',
        title: AxisTitle(text: isTileView ? '' : 'Dollars'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: getDefaultDateTimeSeries(isTileView),
      trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings:
              InteractiveTooltip(format: 'point.x : point.y', borderWidth: 0)));
}

List<LineSeries<ChartSampleData, DateTime>> getDefaultDateTimeSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2015, 1, 1), yValue: 1.13),
    ChartSampleData(x: DateTime(2015, 2, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 3, 1), yValue: 1.08),
    ChartSampleData(x: DateTime(2015, 4, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 5, 1), yValue: 1.1),
    ChartSampleData(x: DateTime(2015, 6, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 7, 1), yValue: 1.1),
    ChartSampleData(x: DateTime(2015, 8, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 9, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2015, 10, 1), yValue: 1.1),
    ChartSampleData(x: DateTime(2015, 11, 1), yValue: 1.06),
    ChartSampleData(x: DateTime(2015, 12, 1), yValue: 1.09),
    ChartSampleData(x: DateTime(2016, 1, 1), yValue: 1.09),
    ChartSampleData(x: DateTime(2016, 2, 1), yValue: 1.09),
    ChartSampleData(x: DateTime(2016, 3, 1), yValue: 1.14),
    ChartSampleData(x: DateTime(2016, 4, 1), yValue: 1.14),
    ChartSampleData(x: DateTime(2016, 5, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2016, 6, 1), yValue: 1.11),
    ChartSampleData(x: DateTime(2016, 7, 1), yValue: 1.11),
    ChartSampleData(x: DateTime(2016, 8, 1), yValue: 1.11),
    ChartSampleData(x: DateTime(2016, 9, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2016, 10, 1), yValue: 1.1),
    ChartSampleData(x: DateTime(2016, 11, 1), yValue: 1.08),
    ChartSampleData(x: DateTime(2016, 12, 1), yValue: 1.05),
    ChartSampleData(x: DateTime(2017, 1, 1), yValue: 1.08),
    ChartSampleData(x: DateTime(2017, 2, 1), yValue: 1.06),
    ChartSampleData(x: DateTime(2017, 3, 1), yValue: 1.07),
    ChartSampleData(x: DateTime(2017, 4, 1), yValue: 1.09),
    ChartSampleData(x: DateTime(2017, 5, 1), yValue: 1.12),
    ChartSampleData(x: DateTime(2017, 6, 1), yValue: 1.14),
    ChartSampleData(x: DateTime(2017, 7, 1), yValue: 1.17),
    ChartSampleData(x: DateTime(2017, 8, 1), yValue: 1.18),
    ChartSampleData(x: DateTime(2017, 9, 1), yValue: 1.18),
    ChartSampleData(x: DateTime(2017, 10, 1), yValue: 1.16),
    ChartSampleData(x: DateTime(2017, 11, 1), yValue: 1.18),
    ChartSampleData(x: DateTime(2017, 12, 1), yValue: 1.2),
    ChartSampleData(x: DateTime(2018, 1, 1), yValue: 1.25),
    ChartSampleData(x: DateTime(2018, 2, 1), yValue: 1.22),
    ChartSampleData(x: DateTime(2018, 3, 1), yValue: 1.23),
    ChartSampleData(x: DateTime(2018, 4, 1), yValue: 1.21),
    ChartSampleData(x: DateTime(2018, 5, 1), yValue: 1.17),
    ChartSampleData(x: DateTime(2018, 6, 1), yValue: 1.17),
    ChartSampleData(x: DateTime(2018, 7, 1), yValue: 1.17),
    ChartSampleData(x: DateTime(2018, 8, 1), yValue: 1.17),
    ChartSampleData(x: DateTime(2018, 9, 1), yValue: 1.16),
    ChartSampleData(x: DateTime(2018, 10, 1), yValue: 1.13),
    ChartSampleData(x: DateTime(2018, 11, 1), yValue: 1.14),
    ChartSampleData(x: DateTime(2018, 12, 1), yValue: 1.15),
    ChartSampleData(x: DateTime(2019, 1, 1), yValue: 1.17)
  ];
  return <LineSeries<ChartSampleData, DateTime>>[
    LineSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.yValue,
      color: const Color.fromRGBO(242, 117, 7, 1),
    )
  ];
}
