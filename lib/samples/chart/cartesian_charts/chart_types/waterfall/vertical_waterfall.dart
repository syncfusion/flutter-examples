/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

///Renders vertical water fall chart sample
class VerticalWaterFall extends SampleView {
  /// Creates the vertical water fall chart
  const VerticalWaterFall(Key key) : super(key: key);

  @override
  _VerticalWaterFallState createState() => _VerticalWaterFallState();
}

class _VerticalWaterFallState extends SampleViewState {
  _VerticalWaterFallState();

  late TooltipBehavior tooltipBehavior1;
  late TooltipBehavior tooltipBehavior2;
  late TooltipBehavior tooltipBehavior3;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        isCardView ? '' : 'Company revenue and profit',
        style: TextStyle(
            fontSize: isCardView ? 0 : 18.0,
            fontFamily: 'Segoe UI',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal),
      ),
      Expanded(child: _getVerticalWaterfallChart())
    ]);
  }

  /// Get the cartesian chart with histogram series
  Row _getVerticalWaterfallChart() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 40,
            child: Container(
                child: SfCartesianChart(
              onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
                tooltipBehavior2.hide();
                tooltipBehavior3.hide();
              },
              plotAreaBorderWidth: 0,
              isTransposed: true,
              title: ChartTitle(
                  text: isCardView ? '' : '2015',
                  textStyle: const TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Normal')),
              primaryXAxis: CategoryAxis(
                axisLine: AxisLine(
                    color: model.bottomSheetBackgroundColor == Colors.white
                        ? const Color.fromRGBO(181, 181, 181, 0.5)
                        : const Color.fromRGBO(101, 101, 101, 1)),
                majorTickLines: const MajorTickLines(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                  isVisible: false,
                  name: 'Expenditure',
                  minimum: 0,
                  interval: 30,
                  maximum: 60,
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0)),
              series: _getWaterFallSeries(),
              tooltipBehavior: tooltipBehavior1,
            ))),
        Expanded(
            flex: 30,
            child: Container(
                child: SfCartesianChart(
              onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
                tooltipBehavior1.hide();
                tooltipBehavior3.hide();
              },
              plotAreaBorderWidth: 0,
              isTransposed: true,
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                return ChartAxisLabel(
                    details.axisName == 'XAxis' ? '' : details.text, null);
              },
              margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              title: ChartTitle(
                  text: isCardView ? '' : '2016',
                  textStyle: const TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Normal')),
              primaryXAxis: CategoryAxis(
                  name: 'XAxis',
                  axisLine: AxisLine(
                      color: model.bottomSheetBackgroundColor == Colors.white
                          ? const Color.fromRGBO(181, 181, 181, 0.5)
                          : const Color.fromRGBO(101, 101, 101, 1)),
                  majorTickLines: const MajorTickLines(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: isCardView
                      ? AxisLabelIntersectAction.wrap
                      : AxisLabelIntersectAction.rotate45),
              primaryYAxis: NumericAxis(
                  isVisible: false,
                  name: 'Expenditure',
                  minimum: 0,
                  maximum: 60,
                  interval: 30,
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0)),
              series: _getWaterFallSecondSeries(),
              tooltipBehavior: tooltipBehavior2,
            ))),
        Expanded(
            flex: 30,
            child: Container(
                child: SfCartesianChart(
              onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
                tooltipBehavior1.hide();
                tooltipBehavior2.hide();
              },
              plotAreaBorderWidth: 0,
              isTransposed: true,
              title: ChartTitle(
                  text: isCardView ? '' : '2017',
                  textStyle: const TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Normal')),
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                return ChartAxisLabel(
                    details.axisName == 'XAxis' ? '' : details.text, null);
              },
              margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              primaryXAxis: CategoryAxis(
                  name: 'XAxis',
                  axisLine: AxisLine(
                      color: model.bottomSheetBackgroundColor == Colors.white
                          ? const Color.fromRGBO(181, 181, 181, 0.5)
                          : const Color.fromRGBO(101, 101, 101, 1)),
                  majorTickLines: const MajorTickLines(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: isCardView
                      ? AxisLabelIntersectAction.wrap
                      : AxisLabelIntersectAction.rotate45),
              primaryYAxis: NumericAxis(
                  isVisible: false,
                  name: 'Expenditure',
                  minimum: 0,
                  maximum: 60,
                  interval: 30,
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0)),
              series: _getWaterFallThirdSeries(),
              tooltipBehavior: tooltipBehavior3,
            )))
      ],
    );
  }

  List<WaterfallSeries<_ChartSampleData, dynamic>> _getWaterFallSeries() {
    final List<_ChartSampleData> chartData = <_ChartSampleData>[
      _ChartSampleData(
          x: 'Income',
          y: 46,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Sales',
          y: -14,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Research',
          y: -9,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Revenue',
          y: 15,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Balance',
          intermediateSumPredicate: true,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Expense',
          y: -13,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Tax',
          y: -8,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Profit',
          intermediateSumPredicate: false,
          totalSumPredicate: true),
    ];
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
          dataSource: chartData,
          name: '2015',
          xValueMapper: (_ChartSampleData sales, _) => sales.x,
          yValueMapper: (_ChartSampleData sales, _) => sales.y,
          intermediateSumPredicate: (_ChartSampleData sales, _) =>
              sales.intermediateSumPredicate,
          totalSumPredicate: (_ChartSampleData sales, _) =>
              sales.totalSumPredicate,
          dataLabelSettings: DataLabelSettings(
              isVisible: isCardView ? false : true,
              labelAlignment: ChartDataLabelAlignment.middle),
          color: const Color.fromRGBO(0, 189, 174, 1),
          negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
          intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
          totalSumColor: const Color.fromRGBO(79, 129, 188, 1))
    ];
  }

  List<WaterfallSeries<_ChartSampleData, dynamic>> _getWaterFallSecondSeries() {
    final List<_ChartSampleData> chartData = <_ChartSampleData>[
      _ChartSampleData(
          x: 'Income',
          y: 47,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Sales',
          y: -15,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Research',
          y: -8,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Revenue',
          y: 10,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Balance',
          intermediateSumPredicate: true,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Expense',
          y: -14,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Tax',
          y: -9,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Profit',
          intermediateSumPredicate: false,
          totalSumPredicate: true),
    ];
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
          dataSource: chartData,
          name: '2016',
          xValueMapper: (_ChartSampleData sales, _) => sales.x,
          yValueMapper: (_ChartSampleData sales, _) => sales.y,
          intermediateSumPredicate: (_ChartSampleData sales, _) =>
              sales.intermediateSumPredicate,
          totalSumPredicate: (_ChartSampleData sales, _) =>
              sales.totalSumPredicate,
          dataLabelSettings: DataLabelSettings(
              isVisible: isCardView ? false : true,
              labelAlignment: ChartDataLabelAlignment.middle),
          color: const Color.fromRGBO(0, 189, 174, 1),
          negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
          intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
          totalSumColor: const Color.fromRGBO(79, 129, 188, 1))
    ];
  }

  List<WaterfallSeries<_ChartSampleData, dynamic>> _getWaterFallThirdSeries() {
    final List<_ChartSampleData> chartData = <_ChartSampleData>[
      _ChartSampleData(
          x: 'Income',
          y: 51,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Sales',
          y: -16,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Research',
          y: -11,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Revenue',
          y: 19,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Balance',
          intermediateSumPredicate: true,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Expense',
          y: -15,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Tax',
          y: -9,
          intermediateSumPredicate: false,
          totalSumPredicate: false),
      _ChartSampleData(
          x: 'Profit',
          intermediateSumPredicate: false,
          totalSumPredicate: true),
    ];
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
          dataSource: chartData,
          name: '2017',
          xValueMapper: (_ChartSampleData sales, _) => sales.x,
          yValueMapper: (_ChartSampleData sales, _) => sales.y,
          intermediateSumPredicate: (_ChartSampleData sales, _) =>
              sales.intermediateSumPredicate,
          totalSumPredicate: (_ChartSampleData sales, _) =>
              sales.totalSumPredicate,
          dataLabelSettings: DataLabelSettings(
              isVisible: isCardView ? false : true,
              labelAlignment: ChartDataLabelAlignment.middle),
          color: const Color.fromRGBO(0, 189, 174, 1),
          negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
          intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
          totalSumColor: const Color.fromRGBO(79, 129, 188, 1))
    ];
  }

  @override
  void initState() {
    tooltipBehavior1 = TooltipBehavior(enable: true);
    tooltipBehavior2 = TooltipBehavior(enable: true);
    tooltipBehavior3 = TooltipBehavior(enable: true);
    super.initState();
  }
}

class _ChartSampleData {
  _ChartSampleData(
      {this.x, this.y, this.intermediateSumPredicate, this.totalSumPredicate});

  final String? x;
  final num? y;
  final bool? intermediateSumPredicate;
  final bool? totalSumPredicate;
}
