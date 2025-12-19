/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the Line Chart with plot offset change option.
class PlotOffset extends SampleView {
  const PlotOffset(Key key) : super(key: key);

  @override
  _PlotOffsetState createState() => _PlotOffsetState();
}

class _PlotOffsetState extends SampleViewState {
  _PlotOffsetState();

  double? _plotOffsetX;
  double? _plotOffsetStartX;
  double? _plotOffsetEndX;
  double? _plotOffsetY;
  double? _plotOffsetStartY;
  double? _plotOffsetEndY;
  bool? _isTransposed;
  TooltipBehavior? _tooltipBehavior;
  List<_InflationConsumerPriceData>? _inflationConsumerPriceData;

  @override
  void initState() {
    _plotOffsetX = null;
    _plotOffsetStartX = null;
    _plotOffsetEndX = null;
    _plotOffsetY = null;
    _plotOffsetStartY = null;
    _plotOffsetEndY = null;
    _isTransposed = false;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _inflationConsumerPriceData = <_InflationConsumerPriceData>[
      _InflationConsumerPriceData(2005, 21, 28),
      _InflationConsumerPriceData(2006, 24, 44),
      _InflationConsumerPriceData(2007, 36, 48),
      _InflationConsumerPriceData(2008, 38, 50),
      _InflationConsumerPriceData(2009, 54, 66),
      _InflationConsumerPriceData(2010, 57, 78),
      _InflationConsumerPriceData(2011, 70, 84),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: _buildCartesianChart(),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: model.textColor,
    );
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'X Axis',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: model.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('PlotOffset', style: textStyle),
                CustomDirectionalButtons(
                  maxValue: 50,
                  initialValue: _plotOffsetX ?? 0,
                  onChanged: (double val) {
                    setState(() {
                      _plotOffsetX = val;
                      if (val == 0) {
                        _plotOffsetX = null;
                      }
                    });
                  },
                  step: 5,
                  iconColor: model.textColor,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('PlotOffsetStart', style: textStyle),
                CustomDirectionalButtons(
                  maxValue: 50,
                  initialValue: _plotOffsetStartX ?? 0,
                  onChanged: (double val) {
                    setState(() {
                      _plotOffsetStartX = val;
                    });
                  },
                  step: 5,
                  iconColor: model.textColor,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('PlotOffsetEnd', style: textStyle),
                CustomDirectionalButtons(
                  maxValue: 50,
                  initialValue: _plotOffsetEndX ?? 0,
                  onChanged: (double val) {
                    setState(() {
                      _plotOffsetEndX = val;
                    });
                  },
                  step: 5,
                  iconColor: model.textColor,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Y Axis',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: model.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('PlotOffset', style: textStyle),
                CustomDirectionalButtons(
                  maxValue: 50,
                  initialValue: _plotOffsetY ?? 0,
                  onChanged: (double val) {
                    setState(() {
                      _plotOffsetY = val;
                      if (_plotOffsetY == 0) {
                        _plotOffsetY = null;
                      }
                    });
                  },
                  step: 5,
                  iconColor: model.textColor,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('PlotOffsetStart', style: textStyle),
                CustomDirectionalButtons(
                  maxValue: 50,
                  initialValue: _plotOffsetStartY ?? 0,
                  onChanged: (double val) {
                    setState(() {
                      _plotOffsetStartY = val;
                    });
                  },
                  step: 5,
                  iconColor: model.textColor,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('PlotOffsetEnd', style: textStyle),
                CustomDirectionalButtons(
                  maxValue: 50,
                  initialValue: _plotOffsetEndY ?? 0,
                  onChanged: (double val) {
                    setState(() {
                      _plotOffsetEndY = val;
                    });
                  },
                  step: 5,
                  iconColor: model.textColor,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Inverse series',
                    style: TextStyle(color: model.textColor, fontSize: 16),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 127,
                    child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: _isTransposed,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTransposed = value;
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

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Inflation - Consumer price'),
      isTransposed: _isTransposed!,
      primaryXAxis: NumericAxis(
        plotOffset: _plotOffsetX,
        plotOffsetStart: _plotOffsetStartX,
        plotOffsetEnd: _plotOffsetEndX,
        interval: 2,
      ),
      primaryYAxis: NumericAxis(
        plotOffset: _plotOffsetY,
        plotOffsetStart: _plotOffsetStartY,
        plotOffsetEnd: _plotOffsetEndY,
        maximum: 100,
        labelFormat: '{value}%',
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_InflationConsumerPriceData, num>> _buildLineSeries() {
    return <LineSeries<_InflationConsumerPriceData, num>>[
      LineSeries<_InflationConsumerPriceData, num>(
        dataSource: _inflationConsumerPriceData,
        xValueMapper: (_InflationConsumerPriceData data, int index) => data.x,
        yValueMapper: (_InflationConsumerPriceData data, int index) => data.y,
        name: 'Germany',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<_InflationConsumerPriceData, num>(
        dataSource: _inflationConsumerPriceData,
        name: 'England',
        xValueMapper: (_InflationConsumerPriceData data, int index) => data.x,
        yValueMapper: (_InflationConsumerPriceData data, int index) => data.y2,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _inflationConsumerPriceData!.clear();
    super.dispose();
  }
}

class _InflationConsumerPriceData {
  _InflationConsumerPriceData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}
