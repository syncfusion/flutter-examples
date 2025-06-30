/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the vertical water fall series chart sample.
class VerticalWaterFall extends SampleView {
  /// Creates the vertical water fall series chart.
  const VerticalWaterFall(Key key) : super(key: key);

  @override
  _VerticalWaterFallState createState() => _VerticalWaterFallState();
}

class _VerticalWaterFallState extends SampleViewState {
  _VerticalWaterFallState();

  TooltipBehavior? tooltipBehavior1;
  TooltipBehavior? tooltipBehavior2;
  TooltipBehavior? tooltipBehavior3;

  List<_ChartSampleData>? _chartData1;
  List<_ChartSampleData>? _chartData2;
  List<_ChartSampleData>? _chartData3;

  @override
  void initState() {
    _chartData1 = _buildChartData1();
    _chartData2 = _buildChartData2();
    _chartData3 = _buildChartData3();
    tooltipBehavior1 = TooltipBehavior(enable: true);
    tooltipBehavior2 = TooltipBehavior(enable: true);
    tooltipBehavior3 = TooltipBehavior(enable: true);
    super.initState();
  }

  List<_ChartSampleData>? _buildChartData1() {
    return [
      _ChartSampleData(
        x: 'Income',
        y: 46,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Sales',
        y: -14,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Research',
        y: -9,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Revenue',
        y: 15,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Balance',
        intermediateSumPredicate: true,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Expense',
        y: -13,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Tax',
        y: -8,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Profit',
        intermediateSumPredicate: false,
        totalSumPredicate: true,
      ),
    ];
  }

  List<_ChartSampleData>? _buildChartData2() {
    return [
      _ChartSampleData(
        x: 'Income',
        y: 47,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Sales',
        y: -15,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Research',
        y: -8,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Revenue',
        y: 10,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Balance',
        intermediateSumPredicate: true,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Expense',
        y: -14,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Tax',
        y: -9,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Profit',
        intermediateSumPredicate: false,
        totalSumPredicate: true,
      ),
    ];
  }

  List<_ChartSampleData>? _buildChartData3() {
    return [
      _ChartSampleData(
        x: 'Income',
        y: 51,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Sales',
        y: -16,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Research',
        y: -11,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Revenue',
        y: 19,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Balance',
        intermediateSumPredicate: true,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Expense',
        y: -15,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Tax',
        y: -9,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Profit',
        intermediateSumPredicate: false,
        totalSumPredicate: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          isCardView ? '' : 'Company revenue and profit',
          style: TextStyle(
            fontSize: isCardView ? 0 : 18.0,
            fontFamily: 'Segoe UI',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
        ),
        Expanded(child: _buildVerticalWaterfallChart()),
      ],
    );
  }

  /// Combine all three waterfall charts into one row.
  Row _buildVerticalWaterfallChart() {
    return Row(
      children: <Widget>[
        Expanded(flex: 40, child: _buildWaterfallChart2015()),
        Expanded(flex: 30, child: _buildWaterfallChart2016()),
        Expanded(flex: 30, child: _buildWaterfallChart2017()),
      ],
    );
  }

  /// Method to create the chart for the year 2015.
  SfCartesianChart _buildWaterfallChart2015() {
    return SfCartesianChart(
      onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
        tooltipBehavior2!.hide();
        tooltipBehavior3!.hide();
      },
      plotAreaBorderWidth: 0,
      isTransposed: true,
      title: ChartTitle(
        text: isCardView ? '' : '2015',
        textStyle: const TextStyle(
          fontSize: 12.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontFamily: 'Normal',
        ),
      ),
      primaryXAxis: CategoryAxis(
        axisLine: AxisLine(
          color: model.drawerBackgroundColor == Colors.white
              ? const Color.fromRGBO(181, 181, 181, 0.5)
              : const Color.fromRGBO(101, 101, 101, 1),
        ),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        name: 'Expenditure',
        minimum: 0,
        interval: 30,
        maximum: 60,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildWaterFallSeries2015(),
      tooltipBehavior: tooltipBehavior1,
    );
  }

  /// Method to create the chart for the year 2016.
  SfCartesianChart _buildWaterfallChart2016() {
    return SfCartesianChart(
      onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
        tooltipBehavior1!.hide();
        tooltipBehavior3!.hide();
      },
      plotAreaBorderWidth: 0,
      isTransposed: true,
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      title: ChartTitle(
        text: isCardView ? '' : '2016',
        textStyle: const TextStyle(
          fontSize: 12.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontFamily: 'Normal',
        ),
      ),
      primaryXAxis: CategoryAxis(
        name: 'XAxis',
        axisLine: AxisLine(
          color: model.drawerBackgroundColor == Colors.white
              ? const Color.fromRGBO(181, 181, 181, 0.5)
              : const Color.fromRGBO(101, 101, 101, 1),
        ),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.wrap
            : AxisLabelIntersectAction.rotate45,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel('', null);
        },
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        name: 'Expenditure',
        minimum: 0,
        maximum: 60,
        interval: 30,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text, null);
        },
      ),
      series: _buildWaterFalSeries2016(),
      tooltipBehavior: tooltipBehavior2,
    );
  }

  /// Method to create the chart for the year 2017.
  SfCartesianChart _buildWaterfallChart2017() {
    return SfCartesianChart(
      onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
        tooltipBehavior1!.hide();
        tooltipBehavior2!.hide();
      },
      plotAreaBorderWidth: 0,
      isTransposed: true,
      title: ChartTitle(
        text: isCardView ? '' : '2017',
        textStyle: const TextStyle(
          fontSize: 12.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontFamily: 'Normal',
        ),
      ),
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      primaryXAxis: CategoryAxis(
        name: 'XAxis',
        axisLine: AxisLine(
          color: model.drawerBackgroundColor == Colors.white
              ? const Color.fromRGBO(181, 181, 181, 0.5)
              : const Color.fromRGBO(101, 101, 101, 1),
        ),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.wrap
            : AxisLabelIntersectAction.rotate45,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel('', null);
        },
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        name: 'Expenditure',
        minimum: 0,
        maximum: 60,
        interval: 30,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text, null);
        },
      ),
      series: _buildWaterFallSeries2017(),
      tooltipBehavior: tooltipBehavior3,
    );
  }

  List<WaterfallSeries<_ChartSampleData, dynamic>> _buildWaterFallSeries2015() {
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
        dataSource: _chartData1,
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,
        name: '2015',
        intermediateSumPredicate: (_ChartSampleData data, int index) =>
            data.intermediateSumPredicate,
        totalSumPredicate: (_ChartSampleData data, int index) =>
            data.totalSumPredicate,
        dataLabelSettings: DataLabelSettings(
          isVisible: isCardView ? false : true,
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        color: const Color.fromRGBO(0, 189, 174, 1),
        negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
        intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
        totalSumColor: const Color.fromRGBO(79, 129, 188, 1),
      ),
    ];
  }

  List<WaterfallSeries<_ChartSampleData, dynamic>> _buildWaterFalSeries2016() {
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
        dataSource: _chartData2,
        name: '2016',
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,
        intermediateSumPredicate: (_ChartSampleData data, int index) =>
            data.intermediateSumPredicate,
        totalSumPredicate: (_ChartSampleData data, int index) =>
            data.totalSumPredicate,
        dataLabelSettings: DataLabelSettings(
          isVisible: isCardView ? false : true,
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        color: const Color.fromRGBO(0, 189, 174, 1),
        negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
        intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
        totalSumColor: const Color.fromRGBO(79, 129, 188, 1),
      ),
    ];
  }

  List<WaterfallSeries<_ChartSampleData, dynamic>> _buildWaterFallSeries2017() {
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
        dataSource: _chartData3,
        name: '2017',
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,
        intermediateSumPredicate: (_ChartSampleData data, int index) =>
            data.intermediateSumPredicate,
        totalSumPredicate: (_ChartSampleData data, int index) =>
            data.totalSumPredicate,
        dataLabelSettings: DataLabelSettings(
          isVisible: isCardView ? false : true,
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        color: const Color.fromRGBO(0, 189, 174, 1),
        negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
        intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
        totalSumColor: const Color.fromRGBO(79, 129, 188, 1),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData1!.clear();
    _chartData2!.clear();
    _chartData3!.clear();
    super.dispose();
  }
}

class _ChartSampleData {
  _ChartSampleData({
    this.x,
    this.y,
    this.intermediateSumPredicate,
    this.totalSumPredicate,
  });

  final String? x;
  final num? y;
  final bool? intermediateSumPredicate;
  final bool? totalSumPredicate;
}
