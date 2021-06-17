/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the column chart with columns width and space change option
class ColumnSpacing extends SampleView {
  /// Creates the column chart with columns width and space change option
  const ColumnSpacing(Key key) : super(key: key);

  @override
  _ColumnSpacingState createState() => _ColumnSpacingState();
}

class _ColumnSpacingState extends SampleViewState {
  _ColumnSpacingState();
  double _columnWidth = 0.8;
  double _columnSpacing = 0.2;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSpacingColumnChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child:
                    Text('Spacing  ', style: TextStyle(color: model.textColor)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: CustomDirectionalButtons(
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
              )
            ],
          ),
        ),
      ],
    );
  }

  ///Get the cartesian chart widget
  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Winter olympic medals count'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          maximum: 150,
          minimum: 0,
          interval: 25,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumn() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Germany',
          y: 128,
          secondSeriesYValue: 129,
          thirdSeriesYValue: 101),
      ChartSampleData(
          x: 'Russia', y: 123, secondSeriesYValue: 92, thirdSeriesYValue: 93),
      ChartSampleData(
          x: 'Norway', y: 107, secondSeriesYValue: 106, thirdSeriesYValue: 90),
      ChartSampleData(
          x: 'USA', y: 87, secondSeriesYValue: 95, thirdSeriesYValue: 71),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(

          /// To apply the column width here.
          width: isCardView ? 0.8 : _columnWidth,

          /// To apply the spacing betweeen to two columns here.
          spacing: isCardView ? 0.2 : _columnSpacing,
          dataSource: chartData,
          color: const Color.fromRGBO(252, 216, 20, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Gold'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: isCardView ? 0.8 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: const Color.fromRGBO(169, 169, 169, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Silver'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: isCardView ? 0.8 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: const Color.fromRGBO(205, 127, 50, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Bronze')
    ];
  }
}
