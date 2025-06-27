/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Render the pie series chart with selection.
class DynamicCircularSelection extends SampleView {
  /// Creates the pie series chart with selection.
  const DynamicCircularSelection(Key key) : super(key: key);
  @override
  _CircularSelectionState createState() => _CircularSelectionState();
}

/// State class for the pie series chart with selection.
class _CircularSelectionState extends SampleViewState {
  _CircularSelectionState();
  late int _pointIndex;
  late List<ChartSampleData> _chartData;

  SelectionBehavior? _selectionBehavior;
  List<String>? _pointIndexList;

  @override
  void initState() {
    _pointIndex = 0;
    _selectionBehavior = SelectionBehavior(enable: true);
    _pointIndexList = <String>['0', '1', '2', '3', '4', '5', '6'].toList();
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Argentina', y: 505370),
      ChartSampleData(x: 'Belgium', y: 551500),
      ChartSampleData(x: 'Cuba', y: 312685),
      ChartSampleData(x: 'Dominican Republic', y: 350000),
      ChartSampleData(x: 'Egypt', y: 301000),
      ChartSampleData(x: 'Kazakhstan', y: 300000),
      ChartSampleData(x: 'Somalia', y: 357022),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[_buildPointIndexDropdown(), _buildSelectButton()],
    );
  }

  /// Builds the dropdown for selecting point index.
  Widget _buildPointIndexDropdown() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          children: <Widget>[
            Text(
              'Point index ',
              softWrap: false,
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _pointIndex.toString(),
                items: _pointIndexList!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : '0',
                    child: Text(
                      value,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  setState(() {
                    _pointIndex = int.parse(value);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the button for selecting the point index.
  Widget _buildSelectButton() {
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
              _selectionBehavior!.selectDataPoints(_pointIndex);
            },
            child: const Text('Select', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircularSelectionChart();
  }

  /// Returns a circular pie chart with selection.
  SfCircularChart _buildCircularSelectionChart() {
    return SfCircularChart(
      onSelectionChanged: (SelectionArgs args) {
        _pointIndex = args.pointIndex;
      },
      title: ChartTitle(
        text: isCardView ? '' : 'Various countries population density and area',
      ),
      series: _buildPieSeries(),
    );
  }

  /// Returns a circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        radius: '70%',
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,
        startAngle: 100,
        endAngle: 100,
        selectionBehavior: _selectionBehavior,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    _pointIndexList!.clear();
    super.dispose();
  }
}
