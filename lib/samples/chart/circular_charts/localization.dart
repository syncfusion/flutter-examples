/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders pie series chart with localization.
class LocalizationCircularChart extends LocalizationSampleView {
  /// Creates the pie series chart with localization.
  const LocalizationCircularChart(Key key) : super(key: key);

  @override
  _LocalizationCircularChartState createState() =>
      _LocalizationCircularChartState();
}

/// State class for the pie series chart with localization.
class _LocalizationCircularChartState extends LocalizationSampleViewState {
  _LocalizationCircularChartState();

  late List<ChartSampleData> _chartDataSource;
  late String _title;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget buildSample(BuildContext context) {
    return _buildPieChart();
  }

  /// Returns a circular pie chart with localization.
  Widget _buildPieChart() {
    _loadChartDataSource();
    return Padding(
      padding: EdgeInsets.only(
        bottom: (model.isWeb || model.isDesktop) ? 0 : 70.0,
      ),
      child: SfCircularChart(
        title: ChartTitle(text: _title),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: _buildDefaultPieSeries(),
        tooltipBehavior: _tooltip,
        onTooltipRender: (TooltipArgs args) {
          args.text = '${args.text}%';
        },
      ),
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildDefaultPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartDataSource,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }

  /// Method to update data source and title of the
  /// chart based on the culture.
  void _loadChartDataSource() {
    if (model.locale == const Locale('en', 'US')) {
      _chartDataSource = <ChartSampleData>[
        ChartSampleData(x: 'Chlorine', y: 55, text: '55%'),
        ChartSampleData(x: 'Sodium', y: 31, text: '31%'),
        ChartSampleData(x: 'Magnesium', y: 7.7, text: '7.7%'),
        ChartSampleData(x: 'Sulfur', y: 3.7, text: '3.7%'),
        ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%'),
        ChartSampleData(x: 'Others', y: 1.4, text: '1.4%'),
      ];
      _title = 'Composition of ocean water';
    } else if (model.locale == const Locale('ar', 'AE')) {
      _chartDataSource = <ChartSampleData>[
        ChartSampleData(x: 'الكلور', y: 55, text: '55%'),
        ChartSampleData(x: 'صوديوم', y: 31, text: '31%'),
        ChartSampleData(x: 'المغنيسيوم', y: 7.7, text: '7.7%'),
        ChartSampleData(x: 'كبريت', y: 3.7, text: '3.7%'),
        ChartSampleData(x: 'الكالسيوم', y: 1.2, text: '1.2%'),
        ChartSampleData(x: 'آحرون', y: 1.4, text: '1.4%'),
      ];
      _title = 'تكوين مياه المحيطات';
    } else if (model.locale == const Locale('fr', 'FR')) {
      _chartDataSource = <ChartSampleData>[
        ChartSampleData(x: 'Chlore', y: 55, text: '55%'),
        ChartSampleData(x: 'Sodium', y: 31, text: '31%'),
        ChartSampleData(x: 'Magnésium', y: 7.7, text: '7.7%'),
        ChartSampleData(x: 'Soufre', y: 3.7, text: '3.7%'),
        ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%'),
        ChartSampleData(x: 'Les autres', y: 1.4, text: '1.4%'),
      ];
      _title = "Composition de l'eau de mer";
    } else if (model.locale == const Locale('zh', 'CN')) {
      _chartDataSource = <ChartSampleData>[
        ChartSampleData(x: '氯', y: 55, text: '55%'),
        ChartSampleData(x: '钠', y: 31, text: '31%'),
        ChartSampleData(x: '镁', y: 7.7, text: '7.7%'),
        ChartSampleData(x: '硫', y: 3.7, text: '3.7%'),
        ChartSampleData(x: '钙', y: 1.2, text: '1.2%'),
        ChartSampleData(x: '其他', y: 1.4, text: '1.4%'),
      ];
      _title = '海水的组成';
    } else if (model.locale == const Locale('es', 'ES')) {
      _chartDataSource = <ChartSampleData>[
        ChartSampleData(x: 'Cloro', y: 55, text: '55%'),
        ChartSampleData(x: 'Sodio', y: 31, text: '31%'),
        ChartSampleData(x: 'Magnesio', y: 7.7, text: '7.7%'),
        ChartSampleData(x: 'Azufre', y: 3.7, text: '3.7%'),
        ChartSampleData(x: 'Calcio', y: 1.2, text: '1.2%'),
        ChartSampleData(x: 'Otras', y: 1.4, text: '1.4%'),
      ];
      _title = 'Composición del agua del océano';
    }
  }
}
