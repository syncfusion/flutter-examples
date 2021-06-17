/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the bar chart sample with bars width and space changing option.
class BarSpacing extends SampleView {
  /// Creates the bar chart sample with bars width and space changing option.
  const BarSpacing(Key key) : super(key: key);

  @override
  _BarSpacingState createState() => _BarSpacingState();
}

class _BarSpacingState extends SampleViewState {
  _BarSpacingState();
  double columnWidth = 0.8;
  double columnSpacing = 0.2;

  @override
  void initState() {
    columnWidth = 0.8;
    columnSpacing = 0.2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSpacingBarChart();
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
                  initialValue: columnWidth,
                  onChanged: (double val) => setState(() {
                    columnWidth = val;
                  }),
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
                  initialValue: columnSpacing,
                  onChanged: (double val) => setState(() {
                    columnSpacing = val;
                  }),
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

  SfCartesianChart _buildSpacingBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Exports & Imports of US'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(
          minimum: 2005,
          maximum: 2011,
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        title:
            AxisTitle(text: isCardView ? '' : 'Goods and services (% of GDP)'),
      ),
      series: _getSpacingBarSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<BarSeries<ChartSampleData, num>> _getSpacingBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 2006, y: 16.219, secondSeriesYValue: 10.655),
      ChartSampleData(x: 2007, y: 16.461, secondSeriesYValue: 11.498),
      ChartSampleData(x: 2008, y: 17.427, secondSeriesYValue: 12.514),
      ChartSampleData(x: 2009, y: 13.754, secondSeriesYValue: 11.012),
      ChartSampleData(x: 2010, y: 15.743, secondSeriesYValue: 12.315),
    ];
    return <BarSeries<ChartSampleData, num>>[
      BarSeries<ChartSampleData, num>(

          /// To apply the bar series width here.
          width: isCardView ? 0.8 : columnWidth,

          /// To apply the spacing betweeen to bars here.
          spacing: isCardView ? 0.2 : columnSpacing,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Import'),
      BarSeries<ChartSampleData, num>(
          width: isCardView ? 0.8 : columnWidth,
          spacing: isCardView ? 0.2 : columnSpacing,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Export')
    ];
  }
}
