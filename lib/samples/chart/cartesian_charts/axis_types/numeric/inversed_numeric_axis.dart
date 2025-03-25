/// Package imports.
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the inversed numeric axis sample.
class NumericInverse extends SampleView {
  const NumericInverse(Key key) : super(key: key);

  @override
  _NumericInverseState createState() => _NumericInverseState();
}

/// State class of the inversed numeric axis.
class _NumericInverseState extends SampleViewState {
  _NumericInverseState();

  List<ChartSampleData>? _airportsCountInUS;
  bool? _isYInversed, _isXInversed;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _airportsCountInUS = <ChartSampleData>[
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
    _isYInversed = true;
    _isXInversed = true;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Inverse X axis',
                  style: TextStyle(color: model.textColor),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeTrackColor: model.primaryColor,
                      value: _isXInversed!,
                      onChanged: (bool value) {
                        setState(() {
                          _isXInversed = value;
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Inverse Y axis',
                  style: TextStyle(color: model.textColor),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeTrackColor: model.primaryColor,
                      value: _isYInversed!,
                      onChanged: (bool value) {
                        setState(() {
                          _isYInversed = value;
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Airports count in US'),
      primaryXAxis: NumericAxis(
        minimum: 2000,
        maximum: 2010,
        title: AxisTitle(text: isCardView ? '' : 'Year'),
        isInversed: _isXInversed ?? true,
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 2,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern(),
        axisLine: const AxisLine(width: 0),
        title: AxisTitle(text: isCardView ? '' : 'Count'),
        isInversed: _isYInversed ?? true,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, num>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: _airportsCountInUS,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _airportsCountInUS!.clear();
    super.dispose();
  }
}
