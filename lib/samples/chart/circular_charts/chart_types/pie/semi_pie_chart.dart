/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the semi pie series.
class SemiPieChart extends SampleView {
  /// Creates the semi pie series.
  const SemiPieChart(Key key) : super(key: key);

  @override
  _SemiPieChartState createState() => _SemiPieChartState();
}

class _SemiPieChartState extends SampleViewState {
  _SemiPieChartState();
  late int _startAngle;
  late int _endAngle;
  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _startAngle = 270;
    _endAngle = 90;
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Start angle  ',
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
            Container(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: CustomDirectionalButtons(
                minValue: 90,
                maxValue: 270,
                initialValue: _startAngle.toDouble(),
                onChanged: (double val) => setState(() {
                  _startAngle = val.toInt();
                }),
                step: 10,
                iconColor: model.textColor,
                style: TextStyle(fontSize: 20.0, color: model.textColor),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text('End angle ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: CustomDirectionalButtons(
                minValue: 90,
                maxValue: 270,
                initialValue: _endAngle.toDouble(),
                onChanged: (double val) => setState(() {
                  _endAngle = val.toInt();
                }),
                step: 10,
                iconColor: model.textColor,
                style: TextStyle(fontSize: 20.0, color: model.textColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSemiPieChartChart();
  }

  /// Return the circular chart with semi pie series.
  SfCircularChart _buildSemiPieChartChart() {
    return SfCircularChart(
      centerY: '60%',
      title: ChartTitle(
          text: isCardView ? '' : 'Rural population of various countries'),
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      series: _getSemiPieChartSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Return the semi pie series.
  List<PieSeries<ChartSampleData, String>> _getSemiPieChartSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Algeria', y: 28),
            ChartSampleData(x: 'Australia', y: 14),
            ChartSampleData(x: 'Bolivia', y: 31),
            ChartSampleData(x: 'Cambodia', y: 77),
            ChartSampleData(x: 'Canada', y: 19),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,

          /// If we set start and end angle given below
          /// it will render as semi pie chart.
          startAngle: _startAngle,
          endAngle: _endAngle,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }
}
