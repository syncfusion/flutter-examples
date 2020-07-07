/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';

class HiloChart extends SampleView {
  const HiloChart(Key key) : super(key: key);

  @override
  _HiloChartState createState() => _HiloChartState();
}

class _HiloChartState extends SampleViewState {
  _HiloChartState();
  bool toggleVisibility;

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Show indication for\nsame values ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: toggleVisibility,
                  valueChanged: (dynamic value) {
                    setState(() {
                      toggleVisibility = value;
                    });
                  },
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
    return getHilo();
  }

  SfCartesianChart getHilo() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.MMMd(),
          minimum: DateTime(2016, 01, 01),
          maximum: DateTime(2016, 07, 01),
          intervalType: DateTimeIntervalType.months,
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          interval: 20,
          minimum: 140,
          maximum: 60,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0)),
      series: getHiloSeries(isCardView, toggleVisibility),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<HiloSeries<ChartSampleData, DateTime>> getHiloSeries(
      bool isCardView, dynamic toggleVisibility) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2016, 01, 11),
          yValue2: 98.97,
          yValue: 101.19,
          y: 95.36,
          yValue3: 97.13),
      ChartSampleData(
          x: DateTime(2016, 01, 18),
          yValue2: 98.41,
          yValue: 101.46,
          y: 93.42,
          yValue3: 101.42),
      ChartSampleData(
          x: DateTime(2016, 01, 25),
          yValue2: 101.52,
          yValue: 101.53,
          y: 92.39,
          yValue3: 97.34),
      ChartSampleData(
          x: DateTime(2016, 02, 01),
          yValue2: 96.47,
          yValue: 97.33,
          y: 93.69,
          yValue3: 94.02),
      ChartSampleData(
          x: DateTime(2016, 02, 08),
          yValue2: 93.13,
          yValue: 96.35,
          y: 92.59,
          yValue3: 93.99),
      ChartSampleData(
          x: DateTime(2016, 02, 15),
          yValue2: 95.02,
          yValue: 98.89,
          y: 94.61,
          yValue3: 96.04),
      ChartSampleData(
          x: DateTime(2016, 02, 22),
          yValue2: 92.31,
          yValue: 94.0237,
          y: 94.0237,
          yValue3: 92.91),
      ChartSampleData(
          x: DateTime(2016, 02, 29),
          yValue2: 96.86,
          yValue: 103.75,
          y: 96.65,
          yValue3: 103.01),
      ChartSampleData(
          x: DateTime(2016, 03, 07),
          yValue2: 102.39,
          yValue: 102.83,
          y: 100.15,
          yValue3: 102.26),
      ChartSampleData(
          x: DateTime(2016, 03, 14),
          yValue2: 101.91,
          yValue: 106.5,
          y: 101.78,
          yValue3: 105.92),
      ChartSampleData(
          x: DateTime(2016, 03, 21),
          yValue2: 105.93,
          yValue: 107.65,
          y: 104.89,
          yValue3: 105.67),
      ChartSampleData(
          x: DateTime(2016, 03, 28),
          yValue2: 106,
          yValue: 110.42,
          y: 104.88,
          yValue3: 109.99),
      ChartSampleData(
          x: DateTime(2016, 04, 04),
          yValue2: 110.42,
          yValue: 112.19,
          y: 108.121,
          yValue3: 108.66),
      ChartSampleData(
          x: DateTime(2016, 04, 11),
          yValue2: 108.97,
          yValue: 112.39,
          y: 108.66,
          yValue3: 109.85),
      ChartSampleData(
          x: DateTime(2016, 04, 18),
          yValue2: 108.89,
          yValue: 108.95,
          y: 104.62,
          yValue3: 105.68),
      ChartSampleData(
          x: DateTime(2016, 04, 25),
          yValue2: 105,
          yValue: 105.65,
          y: 92.51,
          yValue3: 93.74),
      ChartSampleData(
          x: DateTime(2016, 05, 02),
          yValue2: 93.965,
          yValue: 95.9,
          y: 91.85,
          yValue3: 92.72),
      ChartSampleData(
          x: DateTime(2016, 05, 09),
          yValue2: 93,
          yValue: 93.77,
          y: 89.47,
          yValue3: 90.52),
      ChartSampleData(
          x: DateTime(2016, 05, 16),
          yValue2: 92.39,
          yValue: 95.43,
          y: 91.65,
          yValue3: 95.22),
      ChartSampleData(
          x: DateTime(2016, 05, 23),
          yValue2: 95.87,
          yValue: 100.73,
          y: 95.67,
          yValue3: 100.35),
      ChartSampleData(
          x: DateTime(2016, 05, 30),
          yValue2: 99.6,
          yValue: 100.4,
          y: 96.63,
          yValue3: 97.92),
      ChartSampleData(
          x: DateTime(2016, 06, 06),
          yValue2: 97.99,
          yValue: 101.89,
          y: 101.89,
          yValue3: 98.83),
      ChartSampleData(
          x: DateTime(2016, 06, 13),
          yValue2: 98.69,
          yValue: 99.12,
          y: 95.3,
          yValue3: 95.33),
      ChartSampleData(
          x: DateTime(2016, 06, 20),
          yValue2: 96,
          yValue: 96.89,
          y: 92.65,
          yValue3: 93.4),
      ChartSampleData(
          x: DateTime(2016, 06, 27),
          yValue2: 93,
          yValue: 96.465,
          y: 91.5,
          yValue3: 95.89),
    ];
    return <HiloSeries<ChartSampleData, DateTime>>[
      HiloSeries<ChartSampleData, DateTime>(
          enableTooltip: true,
          dataSource: chartData,
          color: const Color.fromRGBO(192, 108, 132, 1),
          name: 'AAPL',
          showIndicationForSameValues: isCardView ? true : toggleVisibility,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          /// High and low value mapper used to render the hilo series.
          lowValueMapper: (ChartSampleData sales, _) => sales.y,
          highValueMapper: (ChartSampleData sales, _) => sales.yValue,
          dataLabelSettings: DataLabelSettings(isVisible: false))
    ];
  }

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    toggleVisibility = true;

    if (sampleModel != null && init) {
      sampleModel.properties
          .addAll(<dynamic, dynamic>{'ToggleVisibility': toggleVisibility});
    }
  }
}
