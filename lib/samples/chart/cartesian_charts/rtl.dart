import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Sample to depict the RTL feature
class RTLModeChart extends DirectionalitySampleView {
  ///Constructor for RTL chart
  const RTLModeChart(Key key) : super(key: key);

  @override
  _RTLModeChartState createState() => _RTLModeChartState();
}

class _RTLModeChartState extends DirectionalitySampleViewState {
  _RTLModeChartState();

  List<ChartSampleData>? chartData;
  String? _title;
  late bool isInversedX, isOpposedPosition;
  String? firstSeriesName, secondSeriesName, thirdSeriesName;
  late TooltipBehavior tooltip;

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    isInversedX = true;
    isOpposedPosition = true;
    super.initState();
  }

  @override
  Widget buildSample(BuildContext context) {
    _onLoadChartDataSource();
    return _buildDefaultLineChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Inverse \nx-axis',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 16,
                    color: model.textColor,
                  )),
              SizedBox(
                  width: 110,
                  child: CheckboxListTile(
                      activeColor: model.backgroundColor,
                      value: isInversedX,
                      onChanged: (bool? value) {
                        setState(() {
                          stateSetter(() {
                            isInversedX = value!;
                          });
                        });
                      })),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Oppose \ny-axis',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 16,
                    color: model.textColor,
                  )),
              const SizedBox(width: 1),
              SizedBox(
                  width: 105,
                  child: CheckboxListTile(
                      activeColor: model.backgroundColor,
                      value: isOpposedPosition,
                      onChanged: (bool? value) {
                        setState(() {
                          stateSetter(() {
                            isOpposedPosition = value!;
                          });
                        });
                      }))
            ],
          ),
        ],
      );
    });
  }

  /// Get the cartesian chart with column series
  Widget _buildDefaultLineChart() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: (model.isWeb || model.isDesktop) ? 0 : 70.0),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: _title!),
        legend: Legend(
          isVisible: true,
        ),
        primaryXAxis: CategoryAxis(
            labelIntersectAction: AxisLabelIntersectAction.multipleRows,
            isInversed: isInversedX,
            majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            maximum: 20,
            interval: 4,
            axisLine: const AxisLine(width: 0),
            opposedPosition: isOpposedPosition,
            majorTickLines: const MajorTickLines(size: 0)),
        series: _getDefaultColumnSeries(),
        tooltipBehavior: tooltip,
      ),
    );
  }

  /// The method returns column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: firstSeriesName,
          color: const Color.fromRGBO(251, 193, 55, 1)),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: secondSeriesName,
          color: const Color.fromRGBO(177, 183, 188, 1)),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: thirdSeriesName,
          color: const Color.fromRGBO(140, 92, 69, 1))
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  // Method to update data source, title and name of the series based on the culture
  void _onLoadChartDataSource() {
    if (model.locale == const Locale('en', 'US')) {
      chartData = <ChartSampleData>[
        ChartSampleData(
            x: 'Norway', y: 16, secondSeriesYValue: 8, thirdSeriesYValue: 13),
        ChartSampleData(
            x: 'USA', y: 8, secondSeriesYValue: 10, thirdSeriesYValue: 7),
        ChartSampleData(
            x: 'Germany', y: 12, secondSeriesYValue: 10, thirdSeriesYValue: 5),
        ChartSampleData(
            x: 'Canada', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
        ChartSampleData(
            x: 'Netherlands',
            y: 8,
            secondSeriesYValue: 5,
            thirdSeriesYValue: 4),
      ];
      _title = 'Winter Olympic medals count - 2022';
      firstSeriesName = 'Gold';
      secondSeriesName = 'Silver';
      thirdSeriesName = 'Bronze';
    } else if (model.locale == const Locale('ar', 'AE')) {
      chartData = <ChartSampleData>[
        ChartSampleData(
            x: 'النرويج', y: 16, secondSeriesYValue: 8, thirdSeriesYValue: 13),
        ChartSampleData(
            x: 'الولايات المتحدة الأمريكية',
            y: 8,
            secondSeriesYValue: 10,
            thirdSeriesYValue: 7),
        ChartSampleData(
            x: 'ألمانيا', y: 12, secondSeriesYValue: 10, thirdSeriesYValue: 5),
        ChartSampleData(
            x: 'كندا', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
        ChartSampleData(
            x: 'هولندا', y: 8, secondSeriesYValue: 5, thirdSeriesYValue: 4),
      ];
      _title = 'عدد الميداليات الأولمبية الشتوية - 2022';
      firstSeriesName = 'ذهب';
      secondSeriesName = 'فضة';
      thirdSeriesName = 'برونزية';
    }
  }
}
