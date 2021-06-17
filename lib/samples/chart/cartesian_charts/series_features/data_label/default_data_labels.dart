/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the chart with default data labels sample.
class DataLabelDefault extends SampleView {
  /// Creates the chart with default data labels sample.
  const DataLabelDefault(Key key) : super(key: key);

  @override
  _DataLabelDefaultState createState() => _DataLabelDefaultState();
}

/// State class of the chart with default data labels.
class _DataLabelDefaultState extends SampleViewState {
  _DataLabelDefaultState();
  late bool _seriescolor;
  String _labelPos = 'top';
  String _labelAln = 'center';
  late ChartDataLabelAlignment _labelPosition;
  late ChartAlignment _chartAlignment;
  late double _horizontalPaddding;
  late double _verticalPaddding;
  late TooltipBehavior _tooltipBehavior;

  final List<String> _positionType =
      <String>['outer', 'top', 'bottom', 'middle'].toList();

  /// List the alignment type.
  final List<String> _chartAlign = <String>['near', 'far', 'center'].toList();
  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text('Use series color',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Container(
                      width: 90,
                      child: CheckboxListTile(
                          activeColor: model.backgroundColor,
                          value: _seriescolor,
                          onChanged: (bool? value) {
                            setState(() {
                              _seriescolor = value!;
                              stateSetter(() {});
                            });
                          })),
                ),
              ],
            ),
          ),
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label alignment',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                padding: const EdgeInsets.fromLTRB(52, 0, 0, 0),
                height: 50,
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _labelAln,
                    items: _chartAlign.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'center',
                          child: Text(value,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onAlignmentChange(value.toString());
                      stateSetter(() {});
                    }),
              ),
            ],
          )),
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label position',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                padding: const EdgeInsets.fromLTRB(67, 0, 0, 0),
                height: 50,
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _labelPos,
                    items: _positionType.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'top',
                          child: Text(value,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onPositionChange(value.toString());
                      stateSetter(() {});
                    }),
              ),
            ],
          )),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Horizontal padding',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: -50,
                    maxValue: 50,
                    initialValue: _horizontalPaddding,
                    onChanged: (double val) => setState(() {
                      _horizontalPaddding = val;
                    }),
                    step: 10,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Vertical padding',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: -50,
                    maxValue: 50,
                    initialValue: _verticalPaddding,
                    onChanged: (double val) => setState(() {
                      _verticalPaddding = val;
                    }),
                    step: 10,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataLabelDefaultChart();
  }

  /// Returns the chart with default data labels.
  SfCartesianChart _buildDataLabelDefaultChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Gross investments'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(
          minimum: 2006,
          maximum: 2010,
          title: AxisTitle(text: isCardView ? '' : 'Year'),
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1),
      primaryYAxis: NumericAxis(
          minimum: 15,
          maximum: 30,
          labelFormat: '{value}%',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDataLabelDefaultSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with default data labels.
  List<SplineSeries<ChartSampleData, num>> _getDataLabelDefaultSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 2006, y: 21.8, yValue: 18.2),
      ChartSampleData(x: 2007, y: 24.9, yValue: 21),
      ChartSampleData(x: 2008, y: 28.5, yValue: 22.1),
      ChartSampleData(x: 2009, y: 27.2, yValue: 21.5),
      ChartSampleData(x: 2010, y: 23.4, yValue: 18.9),
      ChartSampleData(x: 2011, y: 23.4, yValue: 21.3)
    ];
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
          legendIconType: LegendIconType.rectangle,
          dataSource: chartData,
          color: const Color.fromRGBO(140, 198, 64, 1),
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'Singapore',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: _seriescolor,
            alignment: _chartAlignment,
            labelAlignment: _labelPosition,
            offset: Offset(_horizontalPaddding, _verticalPaddding),
          )),
      SplineSeries<ChartSampleData, num>(
          legendIconType: LegendIconType.rectangle,
          color: const Color.fromRGBO(203, 164, 199, 1),
          dataSource: chartData,
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'Russia',

          /// To enable the data label for cartesian chart.
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: _seriescolor,
            alignment: _chartAlignment,
            labelAlignment: _labelPosition,
            offset: Offset(_horizontalPaddding, _verticalPaddding),
          ))
    ];
  }

  @override
  void initState() {
    _labelPosition = ChartDataLabelAlignment.top;
    _chartAlignment = ChartAlignment.center;
    _seriescolor = true;
    _horizontalPaddding = 0;
    _verticalPaddding = 0;
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  void _onAlignmentChange(String item) {
    _labelAln = item;
    if (_labelAln == 'far') {
      _chartAlignment = ChartAlignment.far;
    } else if (_labelAln == 'center') {
      _chartAlignment = ChartAlignment.center;
    } else if (_labelAln == 'near') {
      _chartAlignment = ChartAlignment.near;
    }
    setState(() {});
  }

  void _onPositionChange(String item) {
    _labelPos = item;
    if (_labelPos == 'top') {
      _labelPosition = ChartDataLabelAlignment.top;
    } else if (_labelPos == 'outer') {
      _labelPosition = ChartDataLabelAlignment.outer;
    } else if (_labelPos == 'bottom') {
      _labelPosition = ChartDataLabelAlignment.bottom;
    } else if (_labelPos == 'middle') {
      _labelPosition = ChartDataLabelAlignment.middle;
    }
    setState(() {});
  }
}
