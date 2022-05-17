/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Sample depicts the localization in cartesian chart
class LocalizationChart extends LocalizationSampleView {
  ///Constructor for localization chart
  const LocalizationChart(Key key) : super(key: key);

  @override
  _LocalizationChartState createState() => _LocalizationChartState();
}

class _LocalizationChartState extends LocalizationSampleViewState {
  _LocalizationChartState() : super();

  List<ChartSampleData>? chartData;
  String? _title;
  String? firstSeriesName, secondSeriesName;
  late TooltipBehavior tooltip;

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget buildSample(BuildContext context) {
    return _buildLocalizationChart();
  }

  Widget _buildLocalizationChart() {
    _getDataSource();
    return Padding(
      padding:
          EdgeInsets.only(bottom: (model.isWeb || model.isDesktop) ? 0 : 70.0),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: _title!),
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(
            labelIntersectAction: AxisLabelIntersectAction.multipleRows,
            majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),

            // Formatted the axis labels based on the selected culture
            numberFormat: NumberFormat.compactSimpleCurrency(
                locale: model.locale == const Locale('ar', 'AE')
                    ? const Locale('ar', 'AE').toString()
                    : model.locale == const Locale('en', 'US')
                        ? const Locale('en', 'US').toString()
                        : model.locale == const Locale('es', 'ES')
                            ? const Locale('es', 'ES').toString()
                            : model.locale == const Locale('fr', 'FR')
                                ? const Locale('fr', 'FR').toString()
                                : const Locale('zh', 'CN').toString()),
            maximum: 2500,
            minimum: 500,
            interval: 500,
            majorTickLines: const MajorTickLines(size: 0)),
        series: _getColumnSeries(),
        tooltipBehavior: tooltip,
      ),
    );
  }

  /// The method returns column series
  List<ColumnSeries<ChartSampleData, String>> _getColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: firstSeriesName),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: secondSeriesName)
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  // Method to update data source, title and name of the series based on the culture
  void _getDataSource() {
    if (model.locale == const Locale('en', 'US')) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: 'Monday', y: 1000, yValue: 890),
        ChartSampleData(x: 'Tuesday', y: 1655, yValue: 1892),
        ChartSampleData(x: 'Wednesday', y: 1423, yValue: 1790),
        ChartSampleData(x: 'Thursday', y: 2100, yValue: 2150),
        ChartSampleData(x: 'Friday', y: 1794, yValue: 1694)
      ];
      _title = 'Sales price comparison of products in a week';
      firstSeriesName = 'Product A';
      secondSeriesName = 'Product B';
    } else if (model.locale == const Locale('ar', 'AE')) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: 'الإثنين', y: 1000, yValue: 890),
        ChartSampleData(x: 'يوم الثلاثاء', y: 1655, yValue: 1892),
        ChartSampleData(x: 'الأربعاء', y: 1423, yValue: 1790),
        ChartSampleData(x: 'يوم الخميس', y: 2100, yValue: 2150),
        ChartSampleData(x: 'يوم الجمعة', y: 1794, yValue: 1694)
      ];
      _title = 'مقارنة أسعار مبيعات المنتجات في الأسبوع';
      firstSeriesName = 'المنتج أ';
      secondSeriesName = 'المنتج ب';
    } else if (model.locale == const Locale('fr', 'FR')) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: 'Lundi', y: 1000, yValue: 890),
        ChartSampleData(x: 'mardi', y: 1655, yValue: 1892),
        ChartSampleData(x: 'Mercredi', y: 1423, yValue: 1790),
        ChartSampleData(x: 'jeudi', y: 2100, yValue: 2150),
        ChartSampleData(x: 'vendredi', y: 1794, yValue: 1694)
      ];
      _title = 'Comparaison des prix de vente des produits en une semaine';
      firstSeriesName = 'Produit A';
      secondSeriesName = 'Produit B';
    } else if (model.locale == const Locale('zh', 'CN')) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '周一', y: 1000, yValue: 890),
        ChartSampleData(x: '周二', y: 1655, yValue: 1892),
        ChartSampleData(x: '周三', y: 1423, yValue: 1790),
        ChartSampleData(x: '周四', y: 2100, yValue: 2150),
        ChartSampleData(x: '星期五', y: 1794, yValue: 1694)
      ];
      _title = '一周内产品销售价格比较';
      firstSeriesName = '产品A';
      secondSeriesName = '产品B';
    } else {
      chartData = <ChartSampleData>[
        ChartSampleData(x: 'lunes', y: 1000, yValue: 890),
        ChartSampleData(x: 'martes', y: 1655, yValue: 1892),
        ChartSampleData(x: 'miércoles', y: 1423, yValue: 1790),
        ChartSampleData(x: 'jueves', y: 2100, yValue: 2150),
        ChartSampleData(x: 'viernes', y: 1794, yValue: 1694)
      ];
      _title = 'Comparación de precios de venta de productos en una semana';
      firstSeriesName = 'Producto A';
      secondSeriesName = 'Producto B';
    }
  }
}
