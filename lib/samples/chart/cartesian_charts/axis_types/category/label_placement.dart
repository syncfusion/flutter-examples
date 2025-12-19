/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Line Chart with category label placement sample.
class CategoryTicks extends SampleView {
  const CategoryTicks(Key key) : super(key: key);

  @override
  _CategoryTicksState createState() => _CategoryTicksState();
}

/// State class of the Line Chart with category label placement.
class _CategoryTicksState extends SampleViewState {
  _CategoryTicksState();

  List<ChartSampleData>? _employeesTaskData;
  List<String>? _labelPosition;
  late String _selectedType;
  late LabelPlacement _labelPlacement;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _employeesTaskData = <ChartSampleData>[
      ChartSampleData(x: 'John', yValue: 10),
      ChartSampleData(x: 'Parker', yValue: 11),
      ChartSampleData(x: 'David', yValue: 9),
      ChartSampleData(x: 'Peter', yValue: 10),
      ChartSampleData(x: 'Antony', yValue: 11),
      ChartSampleData(x: 'Brit', yValue: 10),
    ];
    _labelPosition = <String>['betweenTicks', 'onTicks'].toList();
    _selectedType = 'betweenTicks';
    _labelPlacement = LabelPlacement.betweenTicks;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Label \nplacement ',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedType,
                  items: _labelPosition!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'betweenTicks',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onPositionTypeChange(value.toString());
                    stateSetter(() {});
                  },
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
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Employees task count'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelPlacement: _labelPlacement,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        minimum: 7,
        maximum: 12,
        interval: 1,
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, String>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
        dataSource: _employeesTaskData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  /// Method for changing the label placement for category axis in Line Chart.
  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'betweenTicks') {
      _labelPlacement = LabelPlacement.betweenTicks;
    }
    if (_selectedType == 'onTicks') {
      _labelPlacement = LabelPlacement.onTicks;
    }
    setState(() {
      /// Update the label placement type change.
    });
  }

  @override
  void dispose() {
    _labelPosition!.clear();
    _employeesTaskData!.clear();
    super.dispose();
  }
}
