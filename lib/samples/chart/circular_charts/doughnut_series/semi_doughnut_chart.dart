/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Render the semi doughnut series.
class DoughnutSemi extends SampleView {
  const DoughnutSemi(Key key) : super(key: key);

  @override
  _DoughnutSemiState createState() => _DoughnutSemiState();
}

/// State class of semi doughunut series.
class _DoughnutSemiState extends SampleViewState {
  _DoughnutSemiState();
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
                    padding: 0,
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
    return getSemiDoughnutChart(isCardView,startAngle,endAngle);
  }

/// Returns the circular series with semi doughunut series.
SfCircularChart getSemiDoughnutChart(bool isCardView,
    [int startAngle, int endAngle, SampleModel model]) {
  return SfCircularChart(
    title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
    legend: Legend(isVisible: isCardView ? false : true),
    centerY: isCardView ? '65%' : '60%',
    series: getSemiDoughnutSeries(isCardView, startAngle, endAngle, model),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

/// Returns the list of semi doughnut series.
List<DoughnutSeries<ChartSampleData, String>> getSemiDoughnutSeries(
    bool isCardView, int startAngle, int endAngle, SampleModel model) {
  final bool isExistModel = model != null && model.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'David', y: 75, text: 'David 74%'),
    ChartSampleData(x: 'Steve', y: 35, text: 'Steve 35%'),
    ChartSampleData(x: 'Jack', y: 39, text: 'Jack 39%'),
    ChartSampleData(x: 'Others', y: 75, text: 'Others 75%')
  ];
  return <DoughnutSeries<ChartSampleData, String>>[
    DoughnutSeries<ChartSampleData, String>(
        dataSource: chartData,
        innerRadius: '70%',
        radius: isCardView ? '100%' : '59%',
        startAngle: (isExistModel
                ? model.properties['DoughnutStartAngle']
                : startAngle) ??
            270,
        endAngle:
            (isExistModel ? model.properties['DoughnutEndAngle'] : endAngle) ??
                90,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}
}