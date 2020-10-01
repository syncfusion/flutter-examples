/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

///Renders histogram chart sample
class VerticalWaterFall extends SampleView {
  const VerticalWaterFall(Key key) : super(key: key);

  @override
  _VerticalWaterFallState createState() => _VerticalWaterFallState();
}

class _VerticalWaterFallState extends SampleViewState {
  _VerticalWaterFallState();

  TooltipBehavior tooltipBehavior1 = TooltipBehavior(enable: true);
  TooltipBehavior tooltipBehavior2 = TooltipBehavior(enable: true);
  TooltipBehavior tooltipBehavior3 = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
      children: [
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
                  textStyle: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Normal')),
              primaryXAxis: CategoryAxis(
                axisLine: AxisLine(
                    color: model.bottomSheetBackgroundColor == Colors.white
                        ? Color.fromRGBO(181, 181, 181, 0.5)
                        : Color.fromRGBO(101, 101, 101, 1)),
                majorTickLines: MajorTickLines(width: 0),
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                  isVisible: false,
                  name: 'Expenditure',
                  minimum: 0,
                  interval: 30,
                  maximum: 60,
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0)),
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
              onAxisLabelRender: (AxisLabelRenderArgs args) {
                if (args.axisName == 'XAxis') {
                  args.text = '';
                }
              },
              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
              title: ChartTitle(
                  text: isCardView ? '' : '2016',
                  textStyle: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Normal')),
              primaryXAxis: CategoryAxis(
                  name: 'XAxis',
                  axisLine: AxisLine(
                      color: model.bottomSheetBackgroundColor == Colors.white
                          ? Color.fromRGBO(181, 181, 181, 0.5)
                          : Color.fromRGBO(101, 101, 101, 1)),
                  majorTickLines: MajorTickLines(width: 0),
                  majorGridLines: MajorGridLines(width: 0),
                  labelIntersectAction: isCardView
                      ? AxisLabelIntersectAction.wrap
                      : AxisLabelIntersectAction.rotate45),
              primaryYAxis: NumericAxis(
                  isVisible: false,
                  name: 'Expenditure',
                  minimum: 0,
                  maximum: 60,
                  interval: 30,
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0)),
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
                  textStyle: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Normal')),
              onAxisLabelRender: (AxisLabelRenderArgs args) {
                if (args.axisName == 'XAxis') {
                  args.text = '';
                }
              },
              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
              primaryXAxis: CategoryAxis(
                  name: 'XAxis',
                  axisLine: AxisLine(
                      color: model.bottomSheetBackgroundColor == Colors.white
                          ? Color.fromRGBO(181, 181, 181, 0.5)
                          : Color.fromRGBO(101, 101, 101, 1)),
                  majorTickLines: MajorTickLines(width: 0),
                  majorGridLines: MajorGridLines(width: 0),
                  labelIntersectAction: isCardView
                      ? AxisLabelIntersectAction.wrap
                      : AxisLabelIntersectAction.rotate45),
              primaryYAxis: NumericAxis(
                  isVisible: false,
                  name: 'Expenditure',
                  minimum: 0,
                  maximum: 60,
                  interval: 30,
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0)),
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
          color: Color.fromRGBO(0, 189, 174, 1),
          negativePointsColor: Color.fromRGBO(229, 101, 144, 1),
          intermediateSumColor: Color.fromRGBO(79, 129, 188, 1),
          totalSumColor: Color.fromRGBO(79, 129, 188, 1))
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
          color: Color.fromRGBO(0, 189, 174, 1),
          negativePointsColor: Color.fromRGBO(229, 101, 144, 1),
          intermediateSumColor: Color.fromRGBO(79, 129, 188, 1),
          totalSumColor: Color.fromRGBO(79, 129, 188, 1))
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
          color: Color.fromRGBO(0, 189, 174, 1),
          negativePointsColor: Color.fromRGBO(229, 101, 144, 1),
          intermediateSumColor: Color.fromRGBO(79, 129, 188, 1),
          totalSumColor: Color.fromRGBO(79, 129, 188, 1))
    ];
  }

  @override
  void initState() {
    super.initState();
  }
}

class _ChartSampleData {
  _ChartSampleData(
      {this.x, this.y, this.intermediateSumPredicate, this.totalSumPredicate});

  final String x;
  final num y;
  final bool intermediateSumPredicate;
  final bool totalSumPredicate;
}
