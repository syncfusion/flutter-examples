/// Package import.
// ignore_for_file: cast_nullable_to_non_nullable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the radial bar series chart showing overfilled data with a legend.
class OverfilledRadialBar extends SampleView {
  /// Creates the radial bar series chart showing overfilled data with a legend.
  const OverfilledRadialBar(Key key) : super(key: key);

  @override
  _OverfilledRadialBarState createState() => _OverfilledRadialBarState();
}

/// State class for the radial bar series chart showing overfilled data with a legend.
class _OverfilledRadialBarState extends SampleViewState {
  _OverfilledRadialBarState();
  TooltipBehavior? _tooltipBehavior;
  List<_ChartData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <_ChartData>[
      _ChartData(
        'Low \n3.5k/6k',
        3500,
        const Color.fromRGBO(235, 97, 143, 1),
        'Low',
      ),
      _ChartData(
        'Average \n7.2k/6k',
        7200,
        const Color.fromRGBO(145, 132, 202, 1),
        'Average',
      ),
      _ChartData(
        'High \n10.5k/6k',
        10500,
        const Color.fromRGBO(69, 187, 161, 1),
        'High',
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAngleRadialBarChart();
  }

  /// Builds an overfilled radial bar chart with a legend.
  SfCircularChart _buildAngleRadialBarChart() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return SfCircularChart(
      key: GlobalKey(),
      legend: Legend(
        toggleSeriesVisibility: false,
        isVisible: !isCardView,
        iconHeight: 20,
        iconWidth: 20,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      title: ChartTitle(text: isCardView ? '' : 'Steps Goal Tracker'),
      annotations: [_buildGoalAnnotation(orientation)], // Moved annotation here
      series: _buildRadialBarSeries(),
      tooltipBehavior: _tooltipBehavior,
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat numberFormat = NumberFormat.compactCurrency(
          decimalDigits: 2,
          symbol: '',
        );
        args.text =
            _chartData![args.pointIndex as int].text +
            ' : ' +
            numberFormat.format(_chartData![args.pointIndex as int].y);
      },
    );
  }

  /// Builds the annotation for the goal.
  CircularChartAnnotation _buildGoalAnnotation(Orientation orientation) {
    return CircularChartAnnotation(
      height: isCardView
          ? '45%'
          : model.isWeb
          ? '30%'
          : '35%',
      width: isCardView || orientation == Orientation.landscape ? '65%' : '55%',
      widget: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: model.isWeb || model.isDesktop
                  ? 5
                  : model.isWebFullView
                  ? 15
                  : 0,
            ),
            child: Text(
              'Goal -',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: model.isWeb || model.isDesktop ? 20 : 15,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top:
                  model.isAndroid &&
                      !isCardView &&
                      orientation == Orientation.landscape
                  ? 0
                  : isCardView || orientation == Orientation.landscape
                  ? 0
                  : 10,
            ),
          ),
          Text(
            '6k steps/day',
            softWrap: false,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isCardView || orientation == Orientation.landscape
                  ? 10
                  : 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the circular radial bar series.
  List<RadialBarSeries<_ChartData, String>> _buildRadialBarSeries() {
    final List<RadialBarSeries<_ChartData, String>> list =
        <RadialBarSeries<_ChartData, String>>[
          RadialBarSeries<_ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (_ChartData data, int index) => data.x,
            yValueMapper: (_ChartData data, int index) => data.y,
            pointColorMapper: (_ChartData data, int index) => data.color,
            dataLabelMapper: (_ChartData data, int index) => data.text,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            maximumValue: 6000,
            radius: '100%',
            gap: '3%',
            cornerStyle: CornerStyle.bothCurve,
          ),
        ];
    return list;
  }

  @override
  void dispose() {
    _chartData!.clear();
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
