/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the column series chart with default selection option sample.
class SelectionIndex extends SampleView {
  /// Creates a column series chart with default selection options.
  const SelectionIndex(Key key) : super(key: key);

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState();
}

/// State class for the column series chart with default selection options.
class _DefaultSelectionState extends SampleViewState {
  _DefaultSelectionState();
  late List<String> _seriesIndexList;
  late List<String> _pointIndexList;
  late int _seriesIndex;
  late int _pointIndex;
  late SelectionBehavior _selectionBehavior;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _seriesIndexList = <String>['0', '1', '2'].toList();
    _pointIndexList = <String>['0', '1', '2', '3', '4'].toList();
    _selectionBehavior = SelectionBehavior(enable: true);
    _seriesIndex = 0;
    _pointIndex = 0;
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Mexico',
        y: 32093000,
        secondSeriesYValue: 35079000,
        thirdSeriesYValue: 39291000,
      ),
      ChartSampleData(
        x: 'Italy',
        y: 50732000,
        secondSeriesYValue: 52372000,
        thirdSeriesYValue: 58253000,
      ),
      ChartSampleData(
        x: 'US',
        y: 77774000,
        secondSeriesYValue: 76407000,
        thirdSeriesYValue: 76941000,
      ),
      ChartSampleData(
        x: 'Spain',
        y: 68175000,
        secondSeriesYValue: 75315000,
        thirdSeriesYValue: 81786000,
      ),
      ChartSampleData(
        x: 'France',
        y: 84452000,
        secondSeriesYValue: 82682000,
        thirdSeriesYValue: 86861000,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultSelectionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildSeriesIndexDropdown(stateSetter),
            _buildPointIndexDropdown(stateSetter),
            _buildSelectDataPointButton(),
          ],
        );
      },
    );
  }

  /// Builds the dropdown for selecting the series index.
  Widget _buildSeriesIndexDropdown(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Series index',
          style: TextStyle(color: model.textColor, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(78, 0, 0, 0),
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _seriesIndex.toString(),
            items: _seriesIndexList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _updateSeriesIndex(value);
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the dropdown for selecting the point index.
  Widget _buildPointIndexDropdown(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Point index ',
          style: TextStyle(color: model.textColor, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _pointIndex.toString(),
            items: _pointIndexList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _updatePointIndex(value);
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the select button for data point selection.
  Widget _buildSelectDataPointButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                model.primaryColor,
              ),
            ),
            onPressed: () {
              _selectDataPoint(_seriesIndex, _pointIndex);
            },
            child: const Text('Select', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian chart with default selection option.
  SfCartesianChart _buildDefaultSelectionChart() {
    return SfCartesianChart(
      onSelectionChanged: (SelectionArgs args) {
        setState(() {
          _seriesIndex = args.seriesIndex;
          _pointIndex = args.pointIndex;
        });
      },
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Tourism - Number of arrivals'),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        numberFormat: NumberFormat.compact(),
      ),
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        selectionBehavior: _selectionBehavior,
        name: '2015',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        selectionBehavior: _selectionBehavior,
        name: '2016',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        selectionBehavior: _selectionBehavior,
        name: '2017',
      ),
    ];
  }

  void _updateSeriesIndex(String seriesIndex) {
    _seriesIndex = int.parse(seriesIndex);
    setState(() {
      /// Update the selection type changes.
    });
  }

  void _updatePointIndex(String pointIndex) {
    _pointIndex = int.parse(pointIndex);
    setState(() {
      /// Update the selection type changes.
    });
  }

  void _selectDataPoint(int seriesIndex, int pointIndex) {
    _selectionBehavior.selectDataPoints(pointIndex, seriesIndex);
  }

  @override
  void dispose() {
    _seriesIndexList.clear();
    _pointIndexList.clear();
    _chartData.clear();
    super.dispose();
  }
}
