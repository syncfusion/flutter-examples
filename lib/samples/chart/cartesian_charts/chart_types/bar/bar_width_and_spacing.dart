/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the Bar Chart sample with Bars width and space changing option.
class BarSpacing extends SampleView {
  const BarSpacing(Key key) : super(key: key);

  @override
  _BarSpacingState createState() => _BarSpacingState();
}

class _BarSpacingState extends SampleViewState {
  _BarSpacingState();

  late double _columnWidth;
  late double _columnSpacing;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 2006, y: 16.219, secondSeriesYValue: 10.655),
      ChartSampleData(x: 2007, y: 16.461, secondSeriesYValue: 11.498),
      ChartSampleData(x: 2008, y: 17.427, secondSeriesYValue: 12.514),
      ChartSampleData(x: 2009, y: 13.754, secondSeriesYValue: 11.012),
      ChartSampleData(x: 2010, y: 15.743, secondSeriesYValue: 12.315),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Width  ', style: TextStyle(color: model.textColor)),
            CustomDirectionalButtons(
              maxValue: 1,
              initialValue: _columnWidth,
              onChanged: (double val) => setState(() {
                _columnWidth = val;
              }),
              step: 0.1,
              loop: true,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Spacing  ', style: TextStyle(color: model.textColor)),
            CustomDirectionalButtons(
              maxValue: 1,
              initialValue: _columnSpacing,
              onChanged: (double val) => setState(() {
                _columnSpacing = val;
              }),
              step: 0.1,
              loop: true,
              padding: 5.0,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ],
        ),
      ],
    );
  }

  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Exports & Imports of US'),
      primaryXAxis: const NumericAxis(
        minimum: 2005,
        maximum: 2011,
        interval: 1,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        title: AxisTitle(
          text: isCardView ? '' : 'Goods and services (% of GDP)',
        ),
      ),
      series: _buildBarSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Bar series.
  List<BarSeries<ChartSampleData, num>> _buildBarSeries() {
    return <BarSeries<ChartSampleData, num>>[
      BarSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'Import',

        /// To apply the Bar series width here.
        width: isCardView ? 0.8 : _columnWidth,

        /// To apply the spacing between to Bars here.
        spacing: isCardView ? 0.2 : _columnSpacing,
      ),
      BarSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'Export',
        width: isCardView ? 0.8 : _columnWidth,
        spacing: isCardView ? 0.2 : _columnSpacing,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
