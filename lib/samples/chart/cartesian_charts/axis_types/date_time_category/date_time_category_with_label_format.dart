/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Line Chart with default DataTimeCategory axis sample.
class DateTimeCategoryLabel extends SampleView {
  const DateTimeCategoryLabel(Key key) : super(key: key);

  @override
  _DateTimeCategoryLabelState createState() => _DateTimeCategoryLabelState();
}

/// State class of the Line Chart with default DataTimeCategory axis.
class _DateTimeCategoryLabelState extends SampleViewState {
  _DateTimeCategoryLabelState();

  List<_ServerDownTimeData>? _serverDownTimeData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _serverDownTimeData = <_ServerDownTimeData>[
      _ServerDownTimeData(DateTime(2020, 12, 02, 21), 30),
      _ServerDownTimeData(DateTime(2020, 12, 05, 12, 16), 13),
      _ServerDownTimeData(DateTime(2020, 12, 12, 21), 24),
      _ServerDownTimeData(DateTime(2020, 12, 19, 04, 43), 35),
      _ServerDownTimeData(DateTime(2020, 12, 24, 18, 35), 41),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true, header: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Server down details in a month',
      ),
      primaryXAxis: DateTimeCategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat('''MM/dd/yy\nh:mm a'''),
        title: AxisTitle(text: isCardView ? '' : 'Start time'),
      ),
      primaryYAxis: NumericAxis(
        majorTickLines: const MajorTickLines(size: 0),
        interval: 10,
        minimum: 0,
        maximum: 50,
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}m',
        title: AxisTitle(text: isCardView ? '' : 'Duration in minutes'),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ColumnSeries<_ServerDownTimeData, DateTime>>[
        ColumnSeries<_ServerDownTimeData, DateTime>(
          dataSource: _serverDownTimeData,
          name: 'Server down time',
          xValueMapper: (_ServerDownTimeData x, int index) => x.year,
          yValueMapper: (_ServerDownTimeData sales, int index) => sales.sales,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            offset: Offset(0, -5),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _serverDownTimeData!.clear();
    super.dispose();
  }
}

/// Sample ordinal data type.
class _ServerDownTimeData {
  _ServerDownTimeData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
