import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class HiloOpenCloseChart extends StatefulWidget {
  HiloOpenCloseChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _HiloOpenCloseChartState createState() => _HiloOpenCloseChartState(sample);
}

class _HiloOpenCloseChartState extends State<HiloOpenCloseChart> {
  _HiloOpenCloseChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getHiloOpenClose(false), sample);
  }
}

SfCartesianChart getHiloOpenClose(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'AAPL - 2016'),
    primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMM(),
        interval: 3,
        intervalType: DateTimeIntervalType.months,
        minimum: DateTime(2016, 01, 01),
        maximum: DateTime(2017, 01, 01),
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: 140,
        maximum: 60,
        interval: 20,
        labelFormat: '\${value}',
        axisLine: AxisLine(width: 0)),
    series: getHiloOpenCloseSeries(isTileView),
    trackballBehavior: TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap),
  );
}

List<HiloOpenCloseSeries<ChartSampleData, DateTime>> getHiloOpenCloseSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2016, 01, 11),
        yValue2: 98.97,
        yValue: 101.19,
        y: 95.36,
        yValue3: 97.13),
    ChartSampleData(
        x: DateTime(2016, 01, 18),
        yValue2: 98.41,
        yValue: 101.46,
        y: 93.42,
        yValue3: 101.42),
    ChartSampleData(
        x: DateTime(2016, 01, 25),
        yValue2: 101.52,
        yValue: 101.53,
        y: 92.39,
        yValue3: 97.34),
    ChartSampleData(
        x: DateTime(2016, 02, 01),
        yValue2: 96.47,
        yValue: 97.33,
        y: 93.69,
        yValue3: 94.02),
    ChartSampleData(
        x: DateTime(2016, 02, 08),
        yValue2: 93.13,
        yValue: 96.35,
        y: 92.59,
        yValue3: 93.99),
    ChartSampleData(
        x: DateTime(2016, 02, 15),
        yValue2: 95.02,
        yValue: 98.89,
        y: 94.61,
        yValue3: 96.04),
    ChartSampleData(
        x: DateTime(2016, 02, 22),
        yValue2: 96.31,
        yValue: 98.0237,
        y: 93.32,
        yValue3: 96.91),
    ChartSampleData(
        x: DateTime(2016, 02, 29),
        yValue2: 96.86,
        yValue: 103.75,
        y: 96.65,
        yValue3: 103.01),
    ChartSampleData(
        x: DateTime(2016, 03, 07),
        yValue2: 102.39,
        yValue: 102.83,
        y: 100.15,
        yValue3: 102.26),
    ChartSampleData(
        x: DateTime(2016, 03, 14),
        yValue2: 101.91,
        yValue: 106.5,
        y: 101.78,
        yValue3: 105.92),
    ChartSampleData(
        x: DateTime(2016, 03, 21),
        yValue2: 105.93,
        yValue: 107.65,
        y: 104.89,
        yValue3: 105.67),
    ChartSampleData(
        x: DateTime(2016, 03, 28),
        yValue2: 106,
        yValue: 110.42,
        y: 104.88,
        yValue3: 109.99),
    ChartSampleData(
        x: DateTime(2016, 04, 04),
        yValue2: 110.42,
        yValue: 112.19,
        y: 108.121,
        yValue3: 108.66),
    ChartSampleData(
        x: DateTime(2016, 04, 11),
        yValue2: 108.97,
        yValue: 112.39,
        y: 108.66,
        yValue3: 109.85),
    ChartSampleData(
        x: DateTime(2016, 04, 18),
        yValue2: 108.89,
        yValue: 108.95,
        y: 104.62,
        yValue3: 105.68),
    ChartSampleData(
        x: DateTime(2016, 04, 25),
        yValue2: 105,
        yValue: 105.65,
        y: 92.51,
        yValue3: 93.74),
    ChartSampleData(
        x: DateTime(2016, 05, 02),
        yValue2: 93.965,
        yValue: 95.9,
        y: 91.85,
        yValue3: 92.72),
    ChartSampleData(
        x: DateTime(2016, 05, 09),
        yValue2: 93,
        yValue: 93.77,
        y: 89.47,
        yValue3: 90.52),
    ChartSampleData(
        x: DateTime(2016, 05, 16),
        yValue2: 92.39,
        yValue: 95.43,
        y: 91.65,
        yValue3: 95.22),
    ChartSampleData(
        x: DateTime(2016, 05, 23),
        yValue2: 95.87,
        yValue: 100.73,
        y: 95.67,
        yValue3: 100.35),
    ChartSampleData(
        x: DateTime(2016, 05, 30),
        yValue2: 99.6,
        yValue: 100.4,
        y: 96.63,
        yValue3: 97.92),
    ChartSampleData(
        x: DateTime(2016, 06, 06),
        yValue2: 97.99,
        yValue: 101.89,
        y: 97.55,
        yValue3: 98.83),
    ChartSampleData(
        x: DateTime(2016, 06, 13),
        yValue2: 98.69,
        yValue: 99.12,
        y: 95.3,
        yValue3: 95.33),
    ChartSampleData(
        x: DateTime(2016, 06, 20),
        yValue2: 96,
        yValue: 96.89,
        y: 92.65,
        yValue3: 93.4),
    ChartSampleData(
        x: DateTime(2016, 06, 27),
        yValue2: 93,
        yValue: 96.465,
        y: 91.5,
        yValue3: 95.89),
    ChartSampleData(
        x: DateTime(2016, 07, 04),
        yValue2: 95.39,
        yValue: 96.89,
        y: 94.37,
        yValue3: 96.68),
    ChartSampleData(
        x: DateTime(2016, 07, 11),
        yValue2: 96.75,
        yValue: 99.3,
        y: 96.73,
        yValue3: 98.78),
    ChartSampleData(
        x: DateTime(2016, 07, 18),
        yValue2: 98.7,
        yValue: 101,
        y: 98.31,
        yValue3: 98.66),
    ChartSampleData(
        x: DateTime(2016, 07, 25),
        yValue2: 98.25,
        yValue: 104.55,
        y: 96.42,
        yValue3: 104.21),
    ChartSampleData(
        x: DateTime(2016, 08, 01),
        yValue2: 104.41,
        yValue: 107.65,
        y: 104,
        yValue3: 107.48),
    ChartSampleData(
        x: DateTime(2016, 08, 08),
        yValue2: 107.52,
        yValue: 108.94,
        y: 107.16,
        yValue3: 108.18),
    ChartSampleData(
        x: DateTime(2016, 08, 15),
        yValue2: 108.14,
        yValue: 110.23,
        y: 108.08,
        yValue3: 109.36),
    ChartSampleData(
        x: DateTime(2016, 08, 22),
        yValue2: 108.86,
        yValue: 109.32,
        y: 106.31,
        yValue3: 106.94),
    ChartSampleData(
        x: DateTime(2016, 08, 29),
        yValue2: 106.62,
        yValue: 108,
        y: 105.5,
        yValue3: 107.73),
    ChartSampleData(
        x: DateTime(2016, 09, 05),
        yValue2: 107.9,
        yValue: 108.76,
        y: 103.13,
        yValue3: 103.13),
    ChartSampleData(
        x: DateTime(2016, 09, 12),
        yValue2: 102.65,
        yValue: 116.13,
        y: 102.53,
        yValue3: 114.92),
    ChartSampleData(
        x: DateTime(2016, 09, 19),
        yValue2: 115.19,
        yValue: 116.18,
        y: 111.55,
        yValue3: 112.71),
    ChartSampleData(
        x: DateTime(2016, 09, 26),
        yValue2: 111.64,
        yValue: 114.64,
        y: 111.55,
        yValue3: 113.05),
    ChartSampleData(
        x: DateTime(2016, 10, 03),
        yValue2: 112.71,
        yValue: 114.56,
        y: 112.28,
        yValue3: 114.06),
    ChartSampleData(
        x: DateTime(2016, 10, 10),
        yValue2: 115.02,
        yValue: 118.69,
        y: 114.72,
        yValue3: 117.63),
    ChartSampleData(
        x: DateTime(2016, 10, 17),
        yValue2: 117.33,
        yValue: 118.21,
        y: 113.8,
        yValue3: 116.6),
    ChartSampleData(
        x: DateTime(2016, 10, 24),
        yValue2: 117.1,
        yValue: 118.36,
        y: 113.31,
        yValue3: 113.72),
    ChartSampleData(
        x: DateTime(2016, 10, 31),
        yValue2: 113.65,
        yValue: 114.23,
        y: 108.11,
        yValue3: 108.84),
    ChartSampleData(
        x: DateTime(2016, 11, 07),
        yValue2: 110.08,
        yValue: 111.72,
        y: 105.83,
        yValue3: 108.43),
    ChartSampleData(
        x: DateTime(2016, 11, 14),
        yValue2: 107.71,
        yValue: 110.54,
        y: 104.08,
        yValue3: 110.06),
    ChartSampleData(
        x: DateTime(2016, 11, 21),
        yValue2: 110.12,
        yValue: 112.42,
        y: 110.01,
        yValue3: 111.79),
    ChartSampleData(
        x: DateTime(2016, 11, 28),
        yValue2: 111.43,
        yValue: 112.465,
        y: 108.85,
        yValue3: 109.9),
    ChartSampleData(
        x: DateTime(2016, 12, 05),
        yValue2: 110,
        yValue: 114.7,
        y: 108.25,
        yValue3: 113.95),
    ChartSampleData(
        x: DateTime(2016, 12, 12),
        yValue2: 113.29,
        yValue: 116.73,
        y: 112.49,
        yValue3: 115.97),
    ChartSampleData(
        x: DateTime(2016, 12, 19),
        yValue2: 115.8,
        yValue: 117.5,
        y: 115.59,
        yValue3: 116.52),
    ChartSampleData(
        x: DateTime(2016, 12, 26),
        yValue2: 116.52,
        yValue: 118.0166,
        y: 115.43,
        yValue3: 115.82),
  ];
  return <HiloOpenCloseSeries<ChartSampleData, DateTime>>[
    HiloOpenCloseSeries<ChartSampleData, DateTime>(
        enableTooltip: true,
        dataSource: chartData,
        name: 'AAPL',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        openValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        closeValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        dataLabelSettings: DataLabelSettings(isVisible: false))
  ];
}
