/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the dashed spline chart.
class SplineDashed extends SampleView {
  const SplineDashed(Key key) : super(key: key);

  @override
  _SplineDashedState createState() => _SplineDashedState();
}

/// State class of the dashed spline chart.
class _SplineDashedState extends SampleViewState {
  _SplineDashedState();

  @override
  Widget build(BuildContext context) {
    return getDashedSplineChart();
  }

  /// Returns the dashed spline chart.
  SfCartesianChart getDashedSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Total investment (% of GDP)'),
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        minimum: 16,
        maximum: 28,
        interval: 4,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
      ),
      series: getDashedSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the dashed spline chart.
  List<SplineSeries<ChartSampleData, num>> getDashedSplineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 1997, y: 17.79, yValue2: 20.32, yValue3: 22.44),
      ChartSampleData(x: 1998, y: 18.20, yValue2: 21.46, yValue3: 25.18),
      ChartSampleData(x: 1999, y: 17.44, yValue2: 21.72, yValue3: 24.15),
      ChartSampleData(x: 2000, y: 19, yValue2: 22.86, yValue3: 25.83),
      ChartSampleData(x: 2001, y: 18.93, yValue2: 22.87, yValue3: 25.69),
      ChartSampleData(x: 2002, y: 17.58, yValue2: 21.87, yValue3: 24.75),
      ChartSampleData(x: 2003, y: 16.83, yValue2: 21.67, yValue3: 27.38),
      ChartSampleData(x: 2004, y: 17.93, yValue2: 21.65, yValue3: 25.31)
    ];
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2,
          name: 'Brazil',
          /// To apply the dashes line for spline.
          dashArray: kIsWeb ? <double>[0, 0] : <double>[12, 3, 3, 3],
          markerSettings: MarkerSettings(isVisible: true)),
      SplineSeries<ChartSampleData, num>(
          enableTooltip: true,
          dataSource: chartData,
          width: 2,
          name: 'Sweden',
          dashArray: kIsWeb ? <double>[0, 0] : <double>[12, 3, 3, 3],
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          markerSettings: MarkerSettings(isVisible: true)),
      SplineSeries<ChartSampleData, num>(
          enableTooltip: true,
          dataSource: chartData,
          width: 2,
          dashArray: kIsWeb ? <double>[0, 0] : <double>[12, 3, 3, 3],
          name: 'Greece',
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }
}
