/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

///Renders histogram chart sample
class HistogramDefault extends SampleView {
  ///Creates histogram chart sample
  const HistogramDefault(Key key) : super(key: key);

  @override
  _HistogramDefaultState createState() => _HistogramDefaultState();
}

class _HistogramDefaultState extends SampleViewState {
  _HistogramDefaultState();
  late bool _showDistributionCurve;

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _showDistributionCurve = true;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 5.250),
      ChartSampleData(x: 7.750),
      ChartSampleData(x: 0.0),
      ChartSampleData(x: 8.275),
      ChartSampleData(x: 9.750),
      ChartSampleData(x: 7.750),
      ChartSampleData(x: 8.275),
      ChartSampleData(x: 6.250),
      ChartSampleData(x: 5.750),
      ChartSampleData(x: 5.250),
      ChartSampleData(x: 23.000),
      ChartSampleData(x: 26.500),
      ChartSampleData(x: 26.500),
      ChartSampleData(x: 27.750),
      ChartSampleData(x: 25.025),
      ChartSampleData(x: 26.500),
      ChartSampleData(x: 28.025),
      ChartSampleData(x: 29.250),
      ChartSampleData(x: 26.750),
      ChartSampleData(x: 27.250),
      ChartSampleData(x: 26.250),
      ChartSampleData(x: 25.250),
      ChartSampleData(x: 34.500),
      ChartSampleData(x: 25.625),
      ChartSampleData(x: 25.500),
      ChartSampleData(x: 26.625),
      ChartSampleData(x: 36.275),
      ChartSampleData(x: 36.250),
      ChartSampleData(x: 26.875),
      ChartSampleData(x: 40.000),
      ChartSampleData(x: 43.000),
      ChartSampleData(x: 46.500),
      ChartSampleData(x: 47.750),
      ChartSampleData(x: 45.025),
      ChartSampleData(x: 56.500),
      ChartSampleData(x: 56.500),
      ChartSampleData(x: 58.025),
      ChartSampleData(x: 59.250),
      ChartSampleData(x: 56.750),
      ChartSampleData(x: 57.250),
      ChartSampleData(x: 46.250),
      ChartSampleData(x: 55.250),
      ChartSampleData(x: 44.500),
      ChartSampleData(x: 45.525),
      ChartSampleData(x: 55.500),
      ChartSampleData(x: 46.625),
      ChartSampleData(x: 46.275),
      ChartSampleData(x: 56.250),
      ChartSampleData(x: 46.875),
      ChartSampleData(x: 43.000),
      ChartSampleData(x: 46.250),
      ChartSampleData(x: 55.250),
      ChartSampleData(x: 44.500),
      ChartSampleData(x: 45.425),
      ChartSampleData(x: 55.500),
      ChartSampleData(x: 56.625),
      ChartSampleData(x: 46.275),
      ChartSampleData(x: 56.250),
      ChartSampleData(x: 46.875),
      ChartSampleData(x: 43.000),
      ChartSampleData(x: 46.250),
      ChartSampleData(x: 55.250),
      ChartSampleData(x: 44.500),
      ChartSampleData(x: 45.425),
      ChartSampleData(x: 55.500),
      ChartSampleData(x: 46.625),
      ChartSampleData(x: 56.275),
      ChartSampleData(x: 46.250),
      ChartSampleData(x: 56.875),
      ChartSampleData(x: 41.000),
      ChartSampleData(x: 63.000),
      ChartSampleData(x: 66.500),
      ChartSampleData(x: 67.750),
      ChartSampleData(x: 65.025),
      ChartSampleData(x: 66.500),
      ChartSampleData(x: 76.500),
      ChartSampleData(x: 78.025),
      ChartSampleData(x: 79.250),
      ChartSampleData(x: 76.750),
      ChartSampleData(x: 77.250),
      ChartSampleData(x: 66.250),
      ChartSampleData(x: 75.250),
      ChartSampleData(x: 74.500),
      ChartSampleData(x: 65.625),
      ChartSampleData(x: 75.500),
      ChartSampleData(x: 76.625),
      ChartSampleData(x: 76.275),
      ChartSampleData(x: 66.250),
      ChartSampleData(x: 66.875),
      ChartSampleData(x: 80.000),
      ChartSampleData(x: 85.250),
      ChartSampleData(x: 87.750),
      ChartSampleData(x: 89.000),
      ChartSampleData(x: 88.275),
      ChartSampleData(x: 89.750),
      ChartSampleData(x: 97.750),
      ChartSampleData(x: 98.275),
      ChartSampleData(x: 96.250),
      ChartSampleData(x: 95.750),
      ChartSampleData(x: 95.250),
    ];

    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Show distribution line',
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            Checkbox(
              activeColor: model.primaryColor,
              value: _showDistributionCurve,
              onChanged: (bool? value) {
                setState(() {
                  _showDistributionCurve = value!;
                  stateSetter(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: model.isWebFullView || !isCardView ? 0 : 60,
      ),
      child: _buildDefaultHistogramChart(),
    );
  }

  /// Returns the cartesian histogram series chart.
  SfCartesianChart _buildDefaultHistogramChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: const ChartTitle(text: 'Examination Result'),
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      primaryYAxis: const NumericAxis(
        name: 'Number of Students',
        minimum: 0,
        maximum: 50,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildHistogramSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian histogram series.
  List<HistogramSeries<ChartSampleData, double>> _buildHistogramSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color curveColor = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(99, 85, 199, 1)
              : const Color.fromRGBO(51, 182, 119, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return <HistogramSeries<ChartSampleData, double>>[
      HistogramSeries<ChartSampleData, double>(
        name: 'Score',
        dataSource: _chartData,
        yValueMapper: (ChartSampleData data, int index) => data.x,

        /// Enables the normal distribution curve on the histogram.
        showNormalDistributionCurve: _showDistributionCurve,

        // Sets the color for the distribution curve.
        curveColor: curveColor,
        binInterval: 20,

        /// Adds a dashed pattern to the distribution curve.
        curveDashArray: const <double>[12, 3, 3, 3],
        width: 0.99,
        curveWidth: 2.5,

        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
