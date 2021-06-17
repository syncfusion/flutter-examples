/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the semi doughnut series.
class SemiDoughnutChart extends SampleView {
  /// Creates the semi doughnut series.
  const SemiDoughnutChart(Key key) : super(key: key);

  @override
  _SemiDoughnutChartState createState() => _SemiDoughnutChartState();
}

/// State class of semi doughunut series.
class _SemiDoughnutChartState extends SampleViewState {
  _SemiDoughnutChartState();
  int startAngle = 270;
  int endAngle = 90;
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
              Text('Start Angle  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: CustomDirectionalButtons(
                  minValue: 90,
                  maxValue: 270,
                  initialValue: startAngle.toDouble(),
                  onChanged: (double val) => setState(() {
                    startAngle = val.toInt();
                  }),
                  step: 10,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 20.0, color: model.textColor),
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
                child: Text('End Angle ',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: CustomDirectionalButtons(
                  minValue: 90,
                  maxValue: 270,
                  initialValue: endAngle.toDouble(),
                  onChanged: (double val) => setState(() {
                    endAngle = val.toInt();
                  }),
                  step: 10,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 20.0, color: model.textColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSemiDoughnutChart();
  }

  /// Returns the circular series with semi doughunut series.
  SfCircularChart _buildSemiDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
      legend: Legend(isVisible: !isCardView),
      centerY: isCardView ? '65%' : '60%',
      series: _getSemiDoughnutSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns  semi doughnut series.
  List<DoughnutSeries<ChartSampleData, String>> _getSemiDoughnutSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 45, text: 'David 45%'),
      ChartSampleData(x: 'Steve', y: 15, text: 'Steve 15%'),
      ChartSampleData(x: 'Jack', y: 21, text: 'Jack 21%'),
      ChartSampleData(x: 'Others', y: 19, text: 'Others 19%')
    ];
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          dataSource: chartData,
          innerRadius: '70%',
          radius: isCardView ? '100%' : '59%',
          startAngle: startAngle,
          endAngle: endAngle,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }
}
