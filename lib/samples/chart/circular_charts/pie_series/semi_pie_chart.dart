/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Render the semi pie series.
class PieSemi extends SampleView {
  const PieSemi(Key key) : super(key: key);

  @override
  _PieSemiState createState() => _PieSemiState();
}

class _PieSemiState extends SampleViewState {
  _PieSemiState();
  int startAngle = 270;
  int endAngle = 90;

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Start Angle  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomButton(
                    minValue: 90,
                    maxValue: 270,
                    initialValue: startAngle.toDouble(),
                    onChanged: (dynamic val) => setState(() {
                      startAngle = val.toInt();
                    }),
                    step: 10,
                    horizontal: true,
                    loop: false,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: CustomButton(
                    minValue: 90,
                    maxValue: 270,
                    initialValue: endAngle.toDouble(),
                    onChanged: (dynamic val) => setState(() {
                      endAngle = val.toInt();
                    }),
                    step: 10,
                    horizontal: true,
                    loop: false,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
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
    return getSemiPieChart();
  }

/// Return the circular chart with semi pie series.
SfCircularChart getSemiPieChart() {
  return SfCircularChart(
    centerY: '60%',
    title: ChartTitle(
        text: isCardView ? '' : 'Rural population of various countries'),
    legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: getSemiPieSeries(isCardView, startAngle, endAngle, model),
    tooltipBehavior:
        TooltipBehavior(enable: true, format: 'point.x : point.y%'),
  );
}

/// Return the list of semi pie series.
List<PieSeries<ChartSampleData, String>> getSemiPieSeries(
    bool isCardView, int startAngle, int endAngle, SampleModel model) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Algeria', y: 28),
    ChartSampleData(x: 'Australia', y: 14),
    ChartSampleData(x: 'Bolivia', y: 31),
    ChartSampleData(x: 'Cambodia', y: 77),
    ChartSampleData(x: 'Canada', y: 19),
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        /// If we set start and end angle given below it will render as semi pie chart.
        startAngle:
            startAngle ??
                270,
        endAngle:
            endAngle ?? 90,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.inside))
  ];
}
}
