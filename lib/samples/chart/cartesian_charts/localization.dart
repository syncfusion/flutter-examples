/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Sample depicts the localization in cartesian chart
class LocalizationChart extends SampleView {
  ///Constructor for localization chart
  const LocalizationChart(Key key) : super(key: key);

  @override
  _LocalizationChartState createState() => _LocalizationChartState();
}

class _LocalizationChartState extends SampleViewState {
  _LocalizationChartState() : super();

  List<ChartSampleData>? chartData;
  String? _title;
  String? firstSeriesName, secondSeriesName;
  late TooltipBehavior tooltip;
  late List<Locale> _supportedLocales;
  late Locale? _locale;

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    _supportedLocales = <Locale>[
      const Locale('ar', 'AE'),
      const Locale('en', 'US'),
      const Locale('es', 'ES'),
      const Locale('fr', 'FR'),
      const Locale('zh', 'CN')
    ];
    _locale = const Locale('en', 'US');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLocalizationChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 250 : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.6 * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Language',
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
                color: model.textColor,
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              width: dropDownWidth,
              child: DropdownButton<Locale>(
                  focusColor: Colors.transparent,
                  isExpanded: true,
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _locale,
                  items: _supportedLocales.map((Locale value) {
                    String localeString = value.toString();
                    localeString = localeString.substring(0, 2) +
                        '-' +
                        localeString.substring(3, 5);
                    return DropdownMenuItem<Locale>(
                        value: value,
                        child: Text(localeString,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (Locale? value) {
                    setState(() {
                      stateSetter(() {
                        _locale = value;
                      });
                    });
                  })),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
      );
    });
  }

  Widget _buildLocalizationChart() {
    _getDataSource();
    return Directionality(
      textDirection: _locale == const Locale('ar', 'AE')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: (model.isWeb || model.isDesktop) ? 0 : 70.0),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          title: ChartTitle(
              text: _title!,
              textStyle: TextStyle(
                  fontSize: _locale == const Locale('ar', 'AE')
                      ? 17
                      : _locale == const Locale('es', 'ES')
                          ? 16.5
                          : _locale == const Locale('fr', 'FR')
                              ? 16
                              : _locale == const Locale('zh', 'CN')
                                  ? 14.5
                                  : 15.1)),
          legend: Legend(isVisible: true),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows,
              majorGridLines: const MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),

              // Formatted the axis labels based on the selected culture
              numberFormat: NumberFormat.compactSimpleCurrency(
                  locale: _locale == const Locale('ar', 'AE')
                      ? const Locale('ar', 'AE').toString()
                      : _locale == const Locale('en', 'US')
                          ? const Locale('en', 'US').toString()
                          : _locale == const Locale('es', 'ES')
                              ? const Locale('es', 'ES').toString()
                              : _locale == const Locale('fr', 'FR')
                                  ? const Locale('fr', 'FR').toString()
                                  : const Locale('zh', 'CN').toString()),
              maximum: 2500,
              minimum: 500,
              interval: 500,
              majorTickLines: const MajorTickLines(size: 0)),
          series: _getColumnSeries(),
          tooltipBehavior: tooltip,
        ),
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
        name: firstSeriesName,
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: secondSeriesName,
      )
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  // Method to update data source, title and name of the series based on the culture
  void _getDataSource() {
    if (_locale == const Locale('en', 'US')) {
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
    } else if (_locale == const Locale('ar', 'AE')) {
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
    } else if (_locale == const Locale('fr', 'BE')) {
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
    } else if (_locale == const Locale('zh', 'CN')) {
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
