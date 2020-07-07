/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

class ColumnSpacing extends SampleView {
  const ColumnSpacing(Key key) : super(key: key);

  @override
  _ColumnSpacingState createState() => _ColumnSpacingState();
}

class _ColumnSpacingState extends SampleViewState {
  _ColumnSpacingState();
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
    return getSpacingColumnChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
   return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Width  ',
                  style: TextStyle(fontSize: 14.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomButton(
                    minValue: 0,
                    maxValue: 1,
                    initialValue: columnWidth,
                    onChanged: (dynamic val) {
                      setState(() {
                        columnWidth = val;
                      });
                    },
                    step: 0.1,
                    horizontal: true,
                    loop: true,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 16.0, color: model.textColor),
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
                child: Text('Spacing  ',
                    style: TextStyle(fontSize: 14.0, color: model.textColor)),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: CustomButton(
                    minValue: 0,
                    maxValue: 1,
                    initialValue: columnSpacing,
                    onChanged: (dynamic val) {
                      setState(() {
                        columnSpacing = val;
                      });
                    },
                    step: 0.1,
                    horizontal: true,
                    loop: true,
                    padding: 5.0,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 16.0, color: model.textColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  SfCartesianChart getSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Winter olympic medals count'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          maximum: 150,
          minimum: 0,
          interval: 25,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getDefaultColumn(),
      legend: Legend(isVisible: isCardView ? false : true),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<ColumnSeries<ChartSampleData, String>> getDefaultColumn() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Germany', y: 128, yValue2: 129, yValue3: 101),
      ChartSampleData(x: 'Russia', y: 123, yValue2: 92, yValue3: 93),
      ChartSampleData(x: 'Norway', y: 107, yValue2: 106, yValue3: 90),
      ChartSampleData(x: 'USA', y: 87, yValue2: 95, yValue3: 71),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          /// To apply the column width here.
          width: isCardView ? 0.8 : columnWidth,
          /// To apply the spacing betweeen to two columns here.
          spacing: isCardView ? 0.2 : columnSpacing,
          dataSource: chartData,
          color: const Color.fromRGBO(252, 216, 20, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Gold'),
      ColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          width: isCardView ? 0.8 : columnWidth,
          spacing: isCardView ? 0.2 : columnSpacing,
          color: const Color.fromRGBO(169, 169, 169, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: 'Silver'),
      ColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          width: isCardView ? 0.8 : columnWidth,
          spacing: isCardView ? 0.2 : columnSpacing,
          color: const Color.fromRGBO(205, 127, 50, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          name: 'Bronze')
    ];
  }
}
