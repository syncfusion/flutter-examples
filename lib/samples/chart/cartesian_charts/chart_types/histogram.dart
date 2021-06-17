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
  late TooltipBehavior _tooltipBehavior;
  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Show distribution line ',
              style: TextStyle(
                color: model.textColor,
                fontSize: 16,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 90,
                child: CheckboxListTile(
                    activeColor: model.backgroundColor,
                    value: _showDistributionCurve,
                    onChanged: (bool? value) {
                      setState(() {
                        _showDistributionCurve = value!;
                        stateSetter(() {});
                      });
                    })),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: model.isWebFullView || !isCardView ? 0 : 60),
        child: _buildDefaultHistogramChart());
  }

  /// Get the cartesian chart with histogram series
  SfCartesianChart _buildDefaultHistogramChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Examination Result'),
      primaryXAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      primaryYAxis: NumericAxis(
          name: 'Number of Students',
          minimum: 0,
          maximum: 50,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getHistogramSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the histogram series
  List<HistogramSeries<ChartSampleData, double>> _getHistogramSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
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
      ChartSampleData(x: 95.250)
    ];
    return <HistogramSeries<ChartSampleData, double>>[
      HistogramSeries<ChartSampleData, double>(
        name: 'Score',
        dataSource: chartData,

        /// If we enable this property distribution line is sets in histogram.
        showNormalDistributionCurve: _showDistributionCurve,

        /// It used to add the color for distribution line.
        curveColor: const Color.fromRGBO(192, 108, 132, 1),
        binInterval: 20,

        /// It used to add the dashes line for distribution line.
        curveDashArray: <double>[12, 3, 3, 3],
        width: 0.99,
        curveWidth: 2.5,
        yValueMapper: (ChartSampleData sales, _) => sales.x as double,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      )
    ];
  }

  @override
  void initState() {
    _showDistributionCurve = true;
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
}
