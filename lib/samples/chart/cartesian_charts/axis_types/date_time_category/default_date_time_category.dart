/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';

/// Renders the Line Chart with default DataTimeCategory axis sample.
class DateTimeCategoryDefault extends SampleView {
  const DateTimeCategoryDefault(Key key) : super(key: key);

  @override
  _DateTimeCategoryDefaultState createState() =>
      _DateTimeCategoryDefaultState();
}

/// State class of the Line Chart with default DataTimeCategory axis.
class _DateTimeCategoryDefaultState extends SampleViewState {
  _DateTimeCategoryDefaultState();

  List<_ProductSalesComparisonData>? _productSalesComparisonData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _productSalesComparisonData = <_ProductSalesComparisonData>[
      _ProductSalesComparisonData(DateTime(2017, 12, 22), 24),
      _ProductSalesComparisonData(DateTime(2017, 12, 26), 70),
      _ProductSalesComparisonData(DateTime(2017, 12, 27), 75),
      _ProductSalesComparisonData(DateTime(2018, 1, 2), 82),
      _ProductSalesComparisonData(DateTime(2018, 1, 3), 53),
      _ProductSalesComparisonData(DateTime(2018, 1, 4), 54),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart(context);
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart(BuildContext context) {
    final Color labelColor =
        model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Sales comparison of a product',
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeCategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.multipleRows
            : AxisLabelIntersectAction.rotate45,
        title: AxisTitle(text: isCardView ? '' : 'Business days'),
        plotBands: <PlotBand>[
          PlotBand(
            start: DateTime(2017, 12, 22),
            end: DateTime(2017, 12, 27),
            textAngle: 0,
            verticalTextAlignment: TextAnchor.start,
            verticalTextPadding: '%-5',
            text: 'Christmas Offer \nDec 2017',
            textStyle: TextStyle(color: labelColor, fontSize: 13),
            color: const Color.fromRGBO(50, 198, 255, 1).withValues(alpha: 0.3),
          ),
          PlotBand(
            textAngle: 0,
            start: DateTime(2018, 1, 2),
            end: DateTime(2018, 1, 4),
            verticalTextAlignment: TextAnchor.start,
            verticalTextPadding: '%-5',
            text: 'New Year Offer \nJan 2018',
            textStyle: TextStyle(color: labelColor, fontSize: 13),
            color: Colors.pink.withValues(alpha: 0.2),
          ),
        ],
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}M',
        interval: 20,
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
      ),
      series: <ColumnSeries<_ProductSalesComparisonData, DateTime>>[
        ColumnSeries<_ProductSalesComparisonData, DateTime>(
          dataSource: _productSalesComparisonData,
          name: 'Sales',
          xValueMapper: (_ProductSalesComparisonData x, int index) => x.year,
          yValueMapper: (_ProductSalesComparisonData sales, int index) =>
              sales.sales,
        ),
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }

  @override
  void dispose() {
    _productSalesComparisonData!.clear();
    super.dispose();
  }
}

/// Sample ordinal data type.
class _ProductSalesComparisonData {
  _ProductSalesComparisonData(this.year, this.sales);

  final DateTime year;
  final double sales;
}
