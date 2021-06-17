/// Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the inversed numeric axis sample.
class NumericInverse extends SampleView {
  /// Creates the inversed numeric axis sample.
  const NumericInverse(Key key) : super(key: key);

  @override
  _NumericInverseState createState() => _NumericInverseState();
}

/// State class of the inversed numeric axis.
class _NumericInverseState extends SampleViewState {
  _NumericInverseState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  bool? isYInversed = true, isXInversed = true;

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Row(
          children: <Widget>[
            Text('Inverse X axis', style: TextStyle(color: model.textColor)),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: model.backgroundColor,
                    value: isXInversed!,
                    onChanged: (bool value) {
                      setState(() {
                        isXInversed = value;
                        stateSetter(() {});
                      });
                    },
                  )),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Inverse Y axis', style: TextStyle(color: model.textColor)),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: model.backgroundColor,
                    value: isYInversed!,
                    onChanged: (bool value) {
                      setState(() {
                        isYInversed = value;
                        stateSetter(() {});
                      });
                    },
                  )),
            ),
          ],
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  /// Returns the Cartesian chart with inversed x and y axis.
  /// Can change the isInversed bool value by toggle the custom button
  /// presented in property panel.
  SfCartesianChart _buildChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Airports count in US'),
      primaryXAxis: NumericAxis(
          minimum: 2000,
          maximum: 2010,
          title: AxisTitle(text: isCardView ? '' : 'Year'),
          isInversed: isXInversed ?? true,
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 2),
      primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.decimalPattern(),
          axisLine: const AxisLine(width: 0),
          title: AxisTitle(text: isCardView ? '' : 'Count'),
          isInversed: isYInversed ?? true,
          majorTickLines: const MajorTickLines(size: 0)),
      series: getInversedNumericSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Chart series
  /// which need to render on the inversed numeric axis.
  List<LineSeries<ChartSampleData, num>> getInversedNumericSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(xValue: 2000, yValue: 14720),
      ChartSampleData(xValue: 2001, yValue: 14695),
      ChartSampleData(xValue: 2002, yValue: 14801),
      ChartSampleData(xValue: 2003, yValue: 14807),
      ChartSampleData(xValue: 2004, yValue: 14857),
      ChartSampleData(xValue: 2006, yValue: 14858),
      ChartSampleData(xValue: 2007, yValue: 14947),
      ChartSampleData(xValue: 2008, yValue: 14951),
      ChartSampleData(xValue: 2010, yValue: 15079),
    ];
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}
