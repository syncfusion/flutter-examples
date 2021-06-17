/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the line chart with category label placement sample.
class CategoryTicks extends SampleView {
  /// Creates the arrange by index category axis chart sample.
  const CategoryTicks(Key key) : super(key: key);

  @override
  _CategoryTicksState createState() => _CategoryTicksState();
}

/// State class of the line chart with category label placement.
class _CategoryTicksState extends SampleViewState {
  _CategoryTicksState();
  final List<String> _labelPosition =
      <String>['betweenTicks', 'onTicks'].toList();
  late String _selectedType;
  late LabelPlacement _labelPlacement;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _selectedType = 'betweenTicks';
    _labelPlacement = LabelPlacement.betweenTicks;
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTicksCategoryAxisChart();
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
              Text('Label placement ',
                  style: TextStyle(
                    color: model.textColor,
                    fontSize: 16,
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                height: 50,
                alignment: Alignment.bottomCenter,
                child: DropdownButton<String>(
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _selectedType,
                    items: _labelPosition.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'betweenTicks',
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
        ],
      );
    });
  }

  /// Returns the line chart with category label placement.
  SfCartesianChart _buildTicksCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Employees task count'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelPlacement: _labelPlacement),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          minimum: 7,
          maximum: 12,
          interval: 1),
      series: _getTicksCategoryAxisSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the line chart.
  List<LineSeries<ChartSampleData, String>> _getTicksCategoryAxisSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'John', yValue: 10),
      ChartSampleData(x: 'Parker', yValue: 11),
      ChartSampleData(x: 'David', yValue: 9),
      ChartSampleData(x: 'Peter', yValue: 10),
      ChartSampleData(x: 'Antony', yValue: 11),
      ChartSampleData(x: 'Brit', yValue: 10)
    ];
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  /// Method for changing the label placement
  /// for the category axis in the line chart.
  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'betweenTicks') {
      _labelPlacement = LabelPlacement.betweenTicks;
    }
    if (_selectedType == 'onTicks') {
      _labelPlacement = LabelPlacement.onTicks;
    }
    setState(() {
      /// update the label placement type change
    });
  }
}
