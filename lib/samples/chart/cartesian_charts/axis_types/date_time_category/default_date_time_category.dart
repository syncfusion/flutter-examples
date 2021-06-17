/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the line chart with default data time axis sample.
class DateTimeCategoryDefault extends SampleView {
  /// Creates the line chart with default data time axis sample.
  const DateTimeCategoryDefault(Key key) : super(key: key);

  @override
  _DateTimeCategoryDefaultState createState() =>
      _DateTimeCategoryDefaultState();
}

/// State class of the line chart with default data time axis.
class _DateTimeCategoryDefaultState extends SampleViewState {
  _DateTimeCategoryDefaultState();

  late List<_OrdinalSales> data;
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    data = <_OrdinalSales>[
      _OrdinalSales(DateTime(2017, 12, 22), 24),
      _OrdinalSales(DateTime(2017, 12, 26), 70),
      _OrdinalSales(DateTime(2017, 12, 27), 75),
      _OrdinalSales(DateTime(2018, 1, 2), 82),
      _OrdinalSales(DateTime(2018, 1, 3), 53),
      _OrdinalSales(DateTime(2018, 1, 4), 54),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultDateTimeAxisChart(context);
  }

  /// Returns the line chart with default datetime axis.
  SfCartesianChart _buildDefaultDateTimeAxisChart(BuildContext context) {
    final Color labelColor = model.themeData.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeCategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelIntersectAction: isCardView
                ? AxisLabelIntersectAction.multipleRows
                : AxisLabelIntersectAction.rotate45,
            title: AxisTitle(
              text: isCardView ? '' : 'Business days',
            ),
            plotBands: <PlotBand>[
              PlotBand(
                  isVisible: true,
                  start: DateTime(2017, 12, 22),
                  end: DateTime(2017, 12, 27),
                  textAngle: 0,
                  verticalTextAlignment: TextAnchor.start,
                  verticalTextPadding: '%-5',
                  text: 'Christmas Offer \nDec 2017',
                  textStyle: TextStyle(color: labelColor, fontSize: 13),
                  color: const Color.fromRGBO(50, 198, 255, 1),
                  opacity: 0.3),
              PlotBand(
                  isVisible: true,
                  textAngle: 0,
                  start: DateTime(2018, 1, 2),
                  end: DateTime(2018, 1, 4),
                  verticalTextAlignment: TextAnchor.start,
                  verticalTextPadding: '%-5',
                  text: 'New Year Offer \nJan 2018',
                  textStyle: TextStyle(color: labelColor, fontSize: 13),
                  color: Colors.pink,
                  opacity: 0.2),
            ]),
        tooltipBehavior: _tooltipBehavior,
        title:
            ChartTitle(text: isCardView ? '' : 'Sales comparison of a product'),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}M',
            interval: 20,
            majorTickLines: const MajorTickLines(size: 0),
            axisLine: const AxisLine(width: 0)),
        series: <ColumnSeries<_OrdinalSales, DateTime>>[
          ColumnSeries<_OrdinalSales, DateTime>(
            dataSource: data,
            name: 'Sales',
            xValueMapper: (_OrdinalSales x, int xx) => x.year,
            yValueMapper: (_OrdinalSales sales, _) => sales.sales,
          ),
        ]);
  }
}

/// Sample ordinal data type.
class _OrdinalSales {
  _OrdinalSales(this.year, this.sales);

  final DateTime year;
  final double sales;
}
