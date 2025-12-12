/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the Column Chart with Columns width and space change option.
class ColumnSpacing extends SampleView {
  const ColumnSpacing(Key key) : super(key: key);

  @override
  _ColumnSpacingState createState() => _ColumnSpacingState();
}

class _ColumnSpacingState extends SampleViewState {
  _ColumnSpacingState();

  List<ChartSampleData>? _chartData;
  late double _columnWidth;
  late double _columnSpacing;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Norway',
        y: 16,
        secondSeriesYValue: 8,
        thirdSeriesYValue: 13,
      ),
      ChartSampleData(
        x: 'USA',
        y: 8,
        secondSeriesYValue: 10,
        thirdSeriesYValue: 7,
      ),
      ChartSampleData(
        x: 'Germany',
        y: 12,
        secondSeriesYValue: 10,
        thirdSeriesYValue: 5,
      ),
      ChartSampleData(
        x: 'Canada',
        y: 4,
        secondSeriesYValue: 8,
        thirdSeriesYValue: 14,
      ),
      ChartSampleData(
        x: 'Netherlands',
        y: 8,
        secondSeriesYValue: 5,
        thirdSeriesYValue: 4,
      ),
    ];
    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
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
            Container(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: CustomDirectionalButtons(
                maxValue: 1,
                initialValue: _columnWidth,
                onChanged: (double val) {
                  setState(() {
                    _columnWidth = val;
                  });
                },
                step: 0.1,
                loop: true,
                iconColor: model.textColor,
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
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
              onChanged: (double val) {
                setState(() {
                  _columnSpacing = val;
                });
              },
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

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Winter olympic medals count - 2022',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        maximum: 20,
        minimum: 0,
        interval: 4,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,

        /// To apply the column width here.
        width: isCardView ? 0.8 : _columnWidth,

        /// To apply the spacing between two Columns here.
        spacing: isCardView ? 0.2 : _columnSpacing,
        color: const Color.fromRGBO(251, 193, 55, 1),
        name: 'Gold',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        width: isCardView ? 0.8 : _columnWidth,
        spacing: isCardView ? 0.2 : _columnSpacing,
        color: const Color.fromRGBO(177, 183, 188, 1),
        name: 'Silver',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        width: isCardView ? 0.8 : _columnWidth,
        spacing: isCardView ? 0.2 : _columnSpacing,
        color: const Color.fromRGBO(140, 92, 69, 1),
        name: 'Bronze',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
