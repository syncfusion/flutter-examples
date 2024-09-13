/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the line chart with plot offset change option
class PlotOffset extends SampleView {
  /// Creates the line chart with plot offset change option
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
  List<_ChartData>? chartData;
  bool? _isTransposed;

  @override
  void initState() {
    _plotOffsetX = null;
    _plotOffsetStartX = null;
    _plotOffsetEndX = null;
    _plotOffsetY = null;
    _plotOffsetStartY = null;
    _plotOffsetEndY = null;
    _isTransposed = false;
    chartData = <_ChartData>[
      _ChartData(2005, 21, 28),
      _ChartData(2006, 24, 44),
      _ChartData(2007, 36, 48),
      _ChartData(2008, 38, 50),
      _ChartData(2009, 54, 66),
      _ChartData(2010, 57, 78),
      _ChartData(2011, 70, 84)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0), child: _buildChart());
  }

  @override
  Widget buildSettings(BuildContext context) {
    const double height = 40;
    final TextStyle textStyle =
        TextStyle(fontSize: 16.0, color: model.textColor);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('X Axis',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: model.textColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: <Widget>[
              Text('PlotOffset', style: textStyle),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                height: height,
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: height,
                  alignment: Alignment.bottomLeft,
                  child: CustomDirectionalButtons(
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
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('PlotOffsetStart', style: textStyle),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                height: height,
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: height,
                  alignment: Alignment.bottomLeft,
                  child: CustomDirectionalButtons(
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
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('PlotOffsetEnd', style: textStyle),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                height: height,
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: height,
                  alignment: Alignment.bottomLeft,
                  child: CustomDirectionalButtons(
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
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Y Axis',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: model.textColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: <Widget>[
              Text('PlotOffset', style: textStyle),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                height: height,
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: height,
                  alignment: Alignment.bottomLeft,
                  child: CustomDirectionalButtons(
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
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('PlotOffsetStart', style: textStyle),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                height: height,
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: height,
                  alignment: Alignment.bottomLeft,
                  child: CustomDirectionalButtons(
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
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('PlotOffsetEnd', style: textStyle),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                height: height,
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: height,
                  alignment: Alignment.bottomLeft,
                  child: CustomDirectionalButtons(
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
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Inverse series',
                  style: TextStyle(
                    color: model.textColor,
                    fontSize: 16,
                  )),
              SizedBox(
                  width: 127,
                  child: CheckboxListTile(
                      activeColor: model.primaryColor,
                      value: _isTransposed,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTransposed = value;
                          stateSetter(() {});
                        });
                      }))
            ],
          ),
        ],
      );
    });
  }

  ///Get the cartesian chart widget
  SfCartesianChart _buildChart() {
    return SfCartesianChart(
      isTransposed: _isTransposed!,
      title: ChartTitle(text: isCardView ? '' : 'Inflation - Consumer price'),
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
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<_ChartData, num>> _buildLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, int index) => data.x,
          yValueMapper: (_ChartData data, int index) => data.y,
          name: 'Germany',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, num>(
          dataSource: chartData,
          name: 'England',
          xValueMapper: (_ChartData data, int index) => data.x,
          yValueMapper: (_ChartData data, int index) => data.y2,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}
