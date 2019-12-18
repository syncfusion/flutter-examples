import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PieSmartLabels extends StatefulWidget {
  PieSmartLabels({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PieSmartLabelsState createState() => _PieSmartLabelsState(sample);
}

class _PieSmartLabelsState extends State<PieSmartLabels> {
  _PieSmartLabelsState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getSmartLabelPieChart(false), sample);
  }
}

SfCircularChart getSmartLabelPieChart(bool isTileView) {
  return SfCircularChart(
    title: ChartTitle(text: isTileView ? '' : 'Largest islands in the world'),
    series: gettSmartLabelPieSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<PieSeries<ChartSampleData, String>> gettSmartLabelPieSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Greenland', y: 2130800),
    ChartSampleData(x: 'New\nGuinea', y: 785753),
    ChartSampleData(x: 'Borneo', y: 743330),
    ChartSampleData(x: 'Madagascar', y: 587713),
    ChartSampleData(x: 'Baffin\nIsland', y: 507451),
    ChartSampleData(x: 'Sumatra', y: 443066),
    ChartSampleData(x: 'Honshu', y: 225800),
    ChartSampleData(x: 'Victoria\nIsland', y: 217291),
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        radius: '65%',
        startAngle: 80,
        endAngle: 80,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings:
                ConnectorLineSettings(type: ConnectorType.curve)))
  ];
}
