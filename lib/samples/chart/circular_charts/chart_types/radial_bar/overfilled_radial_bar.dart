/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the radial series with legend.
class OverfilledRadialBar extends SampleView {
  /// Creates the radial series with legend.
  const OverfilledRadialBar(Key key) : super(key: key);

  @override
  _OverfilledRadialBarState createState() => _OverfilledRadialBarState();
}

/// State class of radial series with legend.
class _OverfilledRadialBarState extends SampleViewState {
  _OverfilledRadialBarState();
  TooltipBehavior? _tooltipBehavior;
  List<_ChartData>? chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = <_ChartData>[
      _ChartData(
          'Low \n3.5k/6k', 3500, const Color.fromRGBO(235, 97, 143, 1), 'Low'),
      _ChartData('Average \n7.2k/6k', 7200,
          const Color.fromRGBO(145, 132, 202, 1), 'Average'),
      _ChartData('High \n10.5k/6k', 10500,
          const Color.fromRGBO(69, 187, 161, 1), 'High'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAngleRadialBarChart();
  }

  /// Retunrs the circular charts with radial series.
  SfCircularChart _buildAngleRadialBarChart() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return SfCircularChart(
        key: GlobalKey(),
        legend: Legend(
            toggleSeriesVisibility: false,
            isVisible: !isCardView,
            iconHeight: 20,
            iconWidth: 20,
            overflowMode: LegendItemOverflowMode.wrap),
        title:
            ChartTitle(text: isCardView ? '' : 'Monthly steps count tracker'),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            angle: 0,
            radius: '0%',
            height: isCardView
                ? '45%'
                : model.isWeb
                    ? '30%'
                    : '35%',
            width: isCardView || orientation == Orientation.landscape
                ? '65%'
                : '55%',
            widget: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: model.isWeb || model.isDesktop
                            ? 5
                            : model.isWebFullView
                                ? 15
                                : 0),
                    child: Text('Goal -',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                model.isWeb || model.isDesktop ? 20 : 15))),
                Padding(
                    padding: EdgeInsets.only(
                        top: model.isAndroid &&
                                !isCardView &&
                                orientation == Orientation.landscape
                            ? 0
                            : isCardView || orientation == Orientation.landscape
                                ? 0
                                : 10)),
                Text('6k steps/day',
                    softWrap: false,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            isCardView || orientation == Orientation.landscape
                                ? 10
                                : 14))
              ],
            ),
          ),
        ],
        series: _getRadialBarSeries(),
        tooltipBehavior: _tooltipBehavior,
        onTooltipRender: (TooltipArgs args) {
          final NumberFormat numberFormat = NumberFormat.compactCurrency(
            decimalDigits: 2,
            symbol: '',
          );
          // ignore: cast_nullable_to_non_nullable
          args.text = chartData![args.pointIndex as int].text +
              ' : ' +
              numberFormat
                  // ignore: cast_nullable_to_non_nullable
                  .format(chartData![args.pointIndex as int].y);
        });
  }

  /// Returns radial bar series with legend.
  List<RadialBarSeries<_ChartData, String>> _getRadialBarSeries() {
    final List<RadialBarSeries<_ChartData, String>> list =
        <RadialBarSeries<_ChartData, String>>[
      RadialBarSeries<_ChartData, String>(
          maximumValue: 6000,
          radius: '100%',
          gap: '3%',
          dataSource: chartData,
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelMapper: (_ChartData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
    return list;
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color, this.text);

  final String x;
  final num? y;
  final Color color;
  final String text;
}
