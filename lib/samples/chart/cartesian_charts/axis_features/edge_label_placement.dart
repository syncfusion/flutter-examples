/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Renders the edge label placement chart sample.
class EdgeLabel extends SampleView {
  /// Creates the edge label placement chart sample.
  const EdgeLabel(Key key) : super(key: key);

  @override
  _EdgeLabelState createState() => _EdgeLabelState();
}

/// State class of the edge label placement chart.
class _EdgeLabelState extends SampleViewState {
  _EdgeLabelState();

  final List<String> _edgeList = <String>['hide', 'none', 'shift'].toList();
  late String _selectedType;
  late EdgeLabelPlacement _edgeLabelPlacement;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _selectedType = 'shift';
    _edgeLabelPlacement = EdgeLabelPlacement.shift;
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildEdgeLabelPlacementChart();
  }

  @override
  Widget buildSettings(BuildContext buildContext) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text('Edge label placement',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedType,
                      items: _edgeList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'hide',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onPositionTypeChange(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the spline with edge label placement chart.
  SfCartesianChart _buildEdgeLabelPlacementChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(text: isCardView ? '' : 'Fuel price in India'),
      legend: Legend(
          isVisible: isCardView ? false : true,
          position: LegendPosition.bottom),
      primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          minimum: DateTime(2006, 4, 1),
          interval: 2,
          dateFormat: DateFormat.y(),
          intervalType: DateTimeIntervalType.years,
          maximum: DateTime(2016, 4, 1),

          /// This is the API for x axis edge label placement.
          edgeLabelPlacement:
              isCardView ? EdgeLabelPlacement.shift : _edgeLabelPlacement),
      primaryYAxis: NumericAxis(
        majorTickLines: const MajorTickLines(width: 0.5),
        axisLine: const AxisLine(width: 0),
        labelFormat: '₹{value}',
        minimum: 20,
        maximum: 80,

        /// This is the API for y axis edge label placement.
        edgeLabelPlacement: _edgeLabelPlacement,
        title: AxisTitle(text: isCardView ? '' : 'Rupees per litre'),
      ),
      series: _getEdgeLabelPlacementSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart serires whcih need to render
  /// on the spline edge label placement chart.
  List<ChartSeries<ChartSampleData, DateTime>> _getEdgeLabelPlacementSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2005, 4, 1), y: 37.99, secondSeriesYValue: 28.22),
      ChartSampleData(
          x: DateTime(2006, 4, 1), y: 43.5, secondSeriesYValue: 30.45),
      ChartSampleData(
          x: DateTime(2007, 4, 1), y: 43, secondSeriesYValue: 30.25),
      ChartSampleData(
          x: DateTime(2008, 4, 1), y: 45.5, secondSeriesYValue: 31.76),
      ChartSampleData(
          x: DateTime(2009, 4, 1), y: 44.7, secondSeriesYValue: 30.86),
      ChartSampleData(x: DateTime(2010, 4, 1), y: 48, secondSeriesYValue: 38.1),
      ChartSampleData(
          x: DateTime(2011, 4, 1), y: 58.5, secondSeriesYValue: 37.75),
      ChartSampleData(
          x: DateTime(2012, 4, 1), y: 65.6, secondSeriesYValue: 40.91),
      ChartSampleData(
          x: DateTime(2013, 4, 1), y: 66.09, secondSeriesYValue: 48.63),
      ChartSampleData(
          x: DateTime(2014, 4, 1), y: 72.26, secondSeriesYValue: 55.48),
      ChartSampleData(
          x: DateTime(2015, 4, 1), y: 60.49, secondSeriesYValue: 49.71),
      ChartSampleData(
          x: DateTime(2016, 4, 1), y: 59.68, secondSeriesYValue: 48.33)
    ];
    return <ChartSeries<ChartSampleData, DateTime>>[
      SplineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: const MarkerSettings(
              isVisible: true, shape: DataMarkerType.pentagon),
          name: 'Petrol'),
      SplineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          markerSettings: const MarkerSettings(
              isVisible: true, shape: DataMarkerType.pentagon),
          name: 'Diesel')
    ];
  }

  /// Method for updating the change of edgelabel placement type.
  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'hide') {
      _edgeLabelPlacement = EdgeLabelPlacement.hide;
    }
    if (_selectedType == 'none') {
      _edgeLabelPlacement = EdgeLabelPlacement.none;
    }
    if (_selectedType == 'shift') {
      _edgeLabelPlacement = EdgeLabelPlacement.shift;
    }
    setState(() {
      /// update the edge label placement changes
    });
  }
}
