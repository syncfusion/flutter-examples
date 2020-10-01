/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';

///Renders default High-low-open-close series chart
class HiloOpenCloseChart extends SampleView {
  ///Creates default High-low-open-close series chart
  const HiloOpenCloseChart(Key key) : super(key: key);

  @override
  _HiloOpenCloseChartState createState() => _HiloOpenCloseChartState();
}

class _HiloOpenCloseChartState extends SampleViewState {
  _HiloOpenCloseChartState();
  bool _toggleVisibility;
  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Show indication for\nsame values ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCheckBox(
                  activeColor: model.backgroundColor,
                  switchValue: _toggleVisibility,
                  valueChanged: (dynamic value) {
                    setState(() {
                      _toggleVisibility = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getHiloOpenClose();
  }

  ///Get the cartesian chart with hilo open close series
  SfCartesianChart _getHiloOpenClose() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
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
      series: _getHiloOpenCloseSeries(),
      trackballBehavior: TrackballBehavior(
          enable: true, activationMode: ActivationMode.singleTap),
    );
  }

  ///Get the hilo open close series
  List<HiloOpenCloseSeries<ChartSampleData, DateTime>>
      _getHiloOpenCloseSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2016, 01, 11),
          secondSeriesYValue: 98.97,
          yValue: 101.19,
          y: 95.36,
          thirdSeriesYValue: 97.13),
      ChartSampleData(
          x: DateTime(2016, 01, 18),
          secondSeriesYValue: 98.41,
          yValue: 101.46,
          y: 93.42,
          thirdSeriesYValue: 101.42),
      ChartSampleData(
          x: DateTime(2016, 01, 25),
          secondSeriesYValue: 101.52,
          yValue: 101.53,
          y: 92.39,
          thirdSeriesYValue: 97.34),
      ChartSampleData(
          x: DateTime(2016, 02, 01),
          secondSeriesYValue: 96.47,
          yValue: 97.33,
          y: 93.69,
          thirdSeriesYValue: 94.02),
      ChartSampleData(
          x: DateTime(2016, 02, 08),
          secondSeriesYValue: 93.13,
          yValue: 96.35,
          y: 92.59,
          thirdSeriesYValue: 93.99),
      ChartSampleData(
          x: DateTime(2016, 02, 15),
          secondSeriesYValue: 91.02,
          yValue: 94.89,
          y: 90.61,
          thirdSeriesYValue: 92.04),
      ChartSampleData(
          x: DateTime(2016, 02, 22),
          secondSeriesYValue: 96.31,
          yValue: 98.0237,
          y: 98.0237,
          thirdSeriesYValue: 96.31),
      ChartSampleData(
          x: DateTime(2016, 02, 29),
          secondSeriesYValue: 99.86,
          yValue: 106.75,
          y: 99.65,
          thirdSeriesYValue: 106.01),
      ChartSampleData(
          x: DateTime(2016, 03, 07),
          secondSeriesYValue: 102.39,
          yValue: 102.83,
          y: 100.15,
          thirdSeriesYValue: 102.26),
      ChartSampleData(
          x: DateTime(2016, 03, 14),
          secondSeriesYValue: 101.91,
          yValue: 106.5,
          y: 101.78,
          thirdSeriesYValue: 105.92),
      ChartSampleData(
          x: DateTime(2016, 03, 21),
          secondSeriesYValue: 105.93,
          yValue: 107.65,
          y: 104.89,
          thirdSeriesYValue: 105.67),
      ChartSampleData(
          x: DateTime(2016, 03, 28),
          secondSeriesYValue: 106,
          yValue: 110.42,
          y: 104.88,
          thirdSeriesYValue: 109.99),
      ChartSampleData(
          x: DateTime(2016, 04, 04),
          secondSeriesYValue: 110.42,
          yValue: 112.19,
          y: 108.121,
          thirdSeriesYValue: 108.66),
      ChartSampleData(
          x: DateTime(2016, 04, 11),
          secondSeriesYValue: 108.97,
          yValue: 112.39,
          y: 108.66,
          thirdSeriesYValue: 109.85),
      ChartSampleData(
          x: DateTime(2016, 04, 18),
          secondSeriesYValue: 108.89,
          yValue: 108.95,
          y: 104.62,
          thirdSeriesYValue: 105.68),
      ChartSampleData(
          x: DateTime(2016, 04, 25),
          secondSeriesYValue: 105,
          yValue: 105.65,
          y: 92.51,
          thirdSeriesYValue: 93.74),
      ChartSampleData(
          x: DateTime(2016, 05, 02),
          secondSeriesYValue: 93.965,
          yValue: 95.9,
          y: 91.85,
          thirdSeriesYValue: 92.72),
      ChartSampleData(
          x: DateTime(2016, 05, 09),
          secondSeriesYValue: 93,
          yValue: 93.77,
          y: 89.47,
          thirdSeriesYValue: 90.52),
      ChartSampleData(
          x: DateTime(2016, 05, 16),
          secondSeriesYValue: 92.39,
          yValue: 95.43,
          y: 91.65,
          thirdSeriesYValue: 95.22),
      ChartSampleData(
          x: DateTime(2016, 05, 23),
          secondSeriesYValue: 95.87,
          yValue: 100.73,
          y: 95.67,
          thirdSeriesYValue: 100.35),
      ChartSampleData(
          x: DateTime(2016, 05, 30),
          secondSeriesYValue: 99.6,
          yValue: 100.4,
          y: 96.63,
          thirdSeriesYValue: 97.92),
      ChartSampleData(
          x: DateTime(2016, 06, 06),
          secondSeriesYValue: 97.99,
          yValue: 101.89,
          y: 97.55,
          thirdSeriesYValue: 98.83),
      ChartSampleData(
          x: DateTime(2016, 06, 13),
          secondSeriesYValue: 98.69,
          yValue: 99.12,
          y: 95.3,
          thirdSeriesYValue: 95.33),
      ChartSampleData(
          x: DateTime(2016, 06, 20),
          secondSeriesYValue: 96,
          yValue: 96.89,
          y: 92.65,
          thirdSeriesYValue: 93.4),
      ChartSampleData(
          x: DateTime(2016, 06, 27),
          secondSeriesYValue: 93,
          yValue: 96.465,
          y: 91.5,
          thirdSeriesYValue: 95.89),
      ChartSampleData(
          x: DateTime(2016, 07, 04),
          secondSeriesYValue: 95.39,
          yValue: 96.89,
          y: 94.37,
          thirdSeriesYValue: 96.68),
      ChartSampleData(
          x: DateTime(2016, 07, 11),
          secondSeriesYValue: 96.75,
          yValue: 99.3,
          y: 96.73,
          thirdSeriesYValue: 98.78),
      ChartSampleData(
          x: DateTime(2016, 07, 18),
          secondSeriesYValue: 98.7,
          yValue: 101,
          y: 98.31,
          thirdSeriesYValue: 98.66),
      ChartSampleData(
          x: DateTime(2016, 07, 25),
          secondSeriesYValue: 98.25,
          yValue: 104.55,
          y: 96.42,
          thirdSeriesYValue: 104.21),
      ChartSampleData(
          x: DateTime(2016, 08, 01),
          secondSeriesYValue: 104.41,
          yValue: 107.65,
          y: 104,
          thirdSeriesYValue: 107.48),
      ChartSampleData(
          x: DateTime(2016, 08, 08),
          secondSeriesYValue: 107.52,
          yValue: 108.94,
          y: 107.16,
          thirdSeriesYValue: 108.18),
      ChartSampleData(
          x: DateTime(2016, 08, 15),
          secondSeriesYValue: 108.14,
          yValue: 110.23,
          y: 108.08,
          thirdSeriesYValue: 109.36),
      ChartSampleData(
          x: DateTime(2016, 08, 22),
          secondSeriesYValue: 108.86,
          yValue: 109.32,
          y: 106.31,
          thirdSeriesYValue: 106.94),
      ChartSampleData(
          x: DateTime(2016, 08, 29),
          secondSeriesYValue: 106.62,
          yValue: 108,
          y: 105.5,
          thirdSeriesYValue: 107.73),
      ChartSampleData(
          x: DateTime(2016, 09, 05),
          secondSeriesYValue: 107.9,
          yValue: 108.76,
          y: 103.13,
          thirdSeriesYValue: 103.13),
      ChartSampleData(
          x: DateTime(2016, 09, 12),
          secondSeriesYValue: 102.65,
          yValue: 116.13,
          y: 102.53,
          thirdSeriesYValue: 114.92),
      ChartSampleData(
          x: DateTime(2016, 09, 19),
          secondSeriesYValue: 115.19,
          yValue: 116.18,
          y: 111.55,
          thirdSeriesYValue: 112.71),
      ChartSampleData(
          x: DateTime(2016, 09, 26),
          secondSeriesYValue: 111.64,
          yValue: 114.64,
          y: 111.55,
          thirdSeriesYValue: 113.05),
      ChartSampleData(
          x: DateTime(2016, 10, 03),
          secondSeriesYValue: 112.71,
          yValue: 114.56,
          y: 112.28,
          thirdSeriesYValue: 114.06),
      ChartSampleData(
          x: DateTime(2016, 10, 10),
          secondSeriesYValue: 115.02,
          yValue: 118.69,
          y: 114.72,
          thirdSeriesYValue: 117.63),
      ChartSampleData(
          x: DateTime(2016, 10, 17),
          secondSeriesYValue: 117.33,
          yValue: 118.21,
          y: 113.8,
          thirdSeriesYValue: 116.6),
      ChartSampleData(
          x: DateTime(2016, 10, 24),
          secondSeriesYValue: 117.1,
          yValue: 118.36,
          y: 113.31,
          thirdSeriesYValue: 113.72),
      ChartSampleData(
          x: DateTime(2016, 10, 31),
          secondSeriesYValue: 113.65,
          yValue: 114.23,
          y: 108.11,
          thirdSeriesYValue: 108.84),
      ChartSampleData(
          x: DateTime(2016, 11, 07),
          secondSeriesYValue: 110.08,
          yValue: 111.72,
          y: 105.83,
          thirdSeriesYValue: 108.43),
      ChartSampleData(
          x: DateTime(2016, 11, 14),
          secondSeriesYValue: 107.71,
          yValue: 110.54,
          y: 104.08,
          thirdSeriesYValue: 110.06),
      ChartSampleData(
          x: DateTime(2016, 11, 21),
          secondSeriesYValue: 114.12,
          yValue: 115.42,
          y: 115.42,
          thirdSeriesYValue: 114.12),
      ChartSampleData(
          x: DateTime(2016, 11, 28),
          secondSeriesYValue: 111.43,
          yValue: 112.465,
          y: 108.85,
          thirdSeriesYValue: 109.9),
      ChartSampleData(
          x: DateTime(2016, 12, 05),
          secondSeriesYValue: 110,
          yValue: 114.7,
          y: 108.25,
          thirdSeriesYValue: 113.95),
      ChartSampleData(
          x: DateTime(2016, 12, 12),
          secondSeriesYValue: 113.29,
          yValue: 116.73,
          y: 112.49,
          thirdSeriesYValue: 115.97),
      ChartSampleData(
          x: DateTime(2016, 12, 19),
          secondSeriesYValue: 115.8,
          yValue: 117.5,
          y: 115.59,
          thirdSeriesYValue: 116.52),
      ChartSampleData(
          x: DateTime(2016, 12, 26),
          secondSeriesYValue: 116.52,
          yValue: 118.0166,
          y: 115.43,
          thirdSeriesYValue: 115.82),
    ];
    return <HiloOpenCloseSeries<ChartSampleData, DateTime>>[
      HiloOpenCloseSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          name: 'AAPL',
          showIndicationForSameValues: isCardView ? true : _toggleVisibility,
          xValueMapper: (ChartSampleData sales, _) => sales.x,

          /// High, low, open and close values used to render the HLOC series.
          lowValueMapper: (ChartSampleData sales, _) => sales.y,
          highValueMapper: (ChartSampleData sales, _) => sales.yValue,
          openValueMapper: (ChartSampleData sales, _) =>
              sales.secondSeriesYValue,
          closeValueMapper: (ChartSampleData sales, _) =>
              sales.thirdSeriesYValue)
    ];
  }

  @override
  void initState() {
    _toggleVisibility = true;
    super.initState();
  }
}
