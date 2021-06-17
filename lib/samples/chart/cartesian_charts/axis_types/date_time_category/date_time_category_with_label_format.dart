/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the line chart with default data time axis sample.
class DateTimeCategoryLabel extends SampleView {
  /// Creates the line chart with default data time axis sample.
  const DateTimeCategoryLabel(Key key) : super(key: key);

  @override
  _DateTimeCategoryLabelState createState() => _DateTimeCategoryLabelState();
}

/// State class of the line chart with default data time axis.
class _DateTimeCategoryLabelState extends SampleViewState {
  _DateTimeCategoryLabelState();

  late TooltipBehavior _tooltipBehavior;

  late List<_OrdinalSales> data;

  @override
  void initState() {
    data = <_OrdinalSales>[
      _OrdinalSales(DateTime(2020, 12, 02, 21, 00), 30),
      _OrdinalSales(DateTime(2020, 12, 05, 12, 16), 13),
      _OrdinalSales(DateTime(2020, 12, 12, 21, 00), 24),
      _OrdinalSales(DateTime(2020, 12, 19, 04, 43), 35),
      _OrdinalSales(DateTime(2020, 12, 24, 18, 35), 41),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true, header: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeCategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          dateFormat: DateFormat('''MM/dd/yy\nh:mm a'''),
          title: AxisTitle(
            text: isCardView ? '' : 'Start time',
          ),
        ),
        title: ChartTitle(
            text: isCardView ? '' : 'Server down details in a month'),
        primaryYAxis: NumericAxis(
          majorTickLines: const MajorTickLines(size: 0),
          interval: 10,
          minimum: 0,
          maximum: 50,
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}m',
          title: AxisTitle(
            text: isCardView ? '' : 'Duration in minutes',
          ),
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <ColumnSeries<_OrdinalSales, DateTime>>[
          ColumnSeries<_OrdinalSales, DateTime>(
              dataSource: data,
              name: 'Server down time',
              xValueMapper: (_OrdinalSales x, int xx) => x.year,
              yValueMapper: (_OrdinalSales sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                offset: const Offset(0, -5),
              )),
        ]);
  }
}

/// Sample ordinal data type.
class _OrdinalSales {
  _OrdinalSales(this.year, this.sales);
  final DateTime year;
  final double sales;
}
