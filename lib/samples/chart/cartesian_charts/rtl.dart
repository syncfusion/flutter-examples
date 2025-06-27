/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart with support
/// for right-to-left (RTL) layout.
class RTLModeChart extends DirectionalitySampleView {
  /// Creates the column series chart with support
  /// for right-to-left (RTL) layout.
  const RTLModeChart(Key key) : super(key: key);

  @override
  _RTLModeChartState createState() => _RTLModeChartState();
}

class _RTLModeChartState extends DirectionalitySampleViewState {
  _RTLModeChartState();
  late bool _isInverseX;
  late bool _isOpposedPosition;
  late TooltipBehavior _tooltip;

  List<ChartSampleData>? _chartData;
  String? _title;
  String? _firstSeriesName;
  String? _secondSeriesName;
  String? _thirdSeriesName;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _isInverseX = true;
    _isOpposedPosition = true;
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
            _buildInverseXAxisSettings(stateSetter),
            _buildOpposedYAxisSettings(stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the settings for inverse x-axis.
  Widget _buildInverseXAxisSettings(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Inverse \nx-axis',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        SizedBox(
          width: 110,
          child: CheckboxListTile(
            activeColor: model.primaryColor,
            value: _isInverseX,
            onChanged: (bool? value) {
              setState(() {
                stateSetter(() {
                  _isInverseX = value!;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the settings for opposed y-axis.
  Widget _buildOpposedYAxisSettings(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Oppose \ny-axis',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        const SizedBox(width: 1),
        SizedBox(
          width: 105,
          child: CheckboxListTile(
            activeColor: model.primaryColor,
            value: _isOpposedPosition,
            onChanged: (bool? value) {
              setState(() {
                stateSetter(() {
                  _isOpposedPosition = value!;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian column series chart with RTL support.
  Widget _buildDefaultLineChart() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: (model.isWeb || model.isDesktop) ? 0 : 70.0,
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: _title!),
        legend: const Legend(isVisible: true),
        primaryXAxis: CategoryAxis(
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          isInversed: _isInverseX,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 20,
          interval: 4,
          axisLine: const AxisLine(width: 0),
          opposedPosition: _isOpposedPosition,
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: _buildDefaultColumnSeries(),
        tooltipBehavior: _tooltip,
      ),
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        name: _firstSeriesName,
        color: const Color.fromRGBO(251, 193, 55, 1),
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        name: _secondSeriesName,
        color: const Color.fromRGBO(177, 183, 188, 1),
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        name: _thirdSeriesName,
        color: const Color.fromRGBO(140, 92, 69, 1),
      ),
    ];
  }

  /// Method to update data source, title and name of the
  ///series based on the culture.
  void _onLoadChartDataSource() {
    if (model.locale == const Locale('en', 'US')) {
      _chartData = <ChartSampleData>[
        ChartSampleData(
          x: 'Norway',
          y: 16,
          secondSeriesYValue: 8,
          thirdSeriesYValue: 13,
        ),
        ChartSampleData(
          x: 'USA',
          y: 8,
          secondSeriesYValue: 10,
          thirdSeriesYValue: 7,
        ),
        ChartSampleData(
          x: 'Germany',
          y: 12,
          secondSeriesYValue: 10,
          thirdSeriesYValue: 5,
        ),
        ChartSampleData(
          x: 'Canada',
          y: 4,
          secondSeriesYValue: 8,
          thirdSeriesYValue: 14,
        ),
        ChartSampleData(
          x: 'Netherlands',
          y: 8,
          secondSeriesYValue: 5,
          thirdSeriesYValue: 4,
        ),
      ];
      _title = 'Winter Olympic medals count - 2022';
      _firstSeriesName = 'Gold';
      _secondSeriesName = 'Silver';
      _thirdSeriesName = 'Bronze';
    } else if (model.locale == const Locale('ar', 'AE')) {
      _chartData = <ChartSampleData>[
        ChartSampleData(
          x: 'النرويج',
          y: 16,
          secondSeriesYValue: 8,
          thirdSeriesYValue: 13,
        ),
        ChartSampleData(
          x: 'الولايات المتحدة الأمريكية',
          y: 8,
          secondSeriesYValue: 10,
          thirdSeriesYValue: 7,
        ),
        ChartSampleData(
          x: 'ألمانيا',
          y: 12,
          secondSeriesYValue: 10,
          thirdSeriesYValue: 5,
        ),
        ChartSampleData(
          x: 'كندا',
          y: 4,
          secondSeriesYValue: 8,
          thirdSeriesYValue: 14,
        ),
        ChartSampleData(
          x: 'هولندا',
          y: 8,
          secondSeriesYValue: 5,
          thirdSeriesYValue: 4,
        ),
      ];
      _title = 'عدد الميداليات الأولمبية الشتوية - 2022';
      _firstSeriesName = 'ذهب';
      _secondSeriesName = 'فضة';
      _thirdSeriesName = 'برونزية';
    }
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
