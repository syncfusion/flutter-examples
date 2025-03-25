/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Column Chart with default category axis.
class CategoryDefault extends SampleView {
  const CategoryDefault(Key key) : super(key: key);

  @override
  _CategoryDefaultState createState() => _CategoryDefaultState();
}

/// State class of the Column Chart with default category x-axis.
class _CategoryDefaultState extends SampleViewState {
  _CategoryDefaultState();

  List<ChartSampleData>? _internetUsersDataIn2016;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _internetUsersDataIn2016 = <ChartSampleData>[
      ChartSampleData(
        x: 'South\nKorea',
        yValue: 39,
        pointColor: Colors.teal[300],
      ),
      ChartSampleData(
        x: 'India',
        yValue: 20,
        pointColor: const Color.fromRGBO(53, 124, 210, 1),
      ),
      ChartSampleData(x: 'South\nAfrica', yValue: 61, pointColor: Colors.pink),
      ChartSampleData(x: 'China', yValue: 65, pointColor: Colors.orange),
      ChartSampleData(x: 'France', yValue: 45, pointColor: Colors.green),
      ChartSampleData(
        x: 'Saudi\nArabia',
        yValue: 10,
        pointColor: Colors.pink[300],
      ),
      ChartSampleData(x: 'Japan', yValue: 16, pointColor: Colors.purple[300]),
      ChartSampleData(
        x: 'Mexico',
        yValue: 31,
        pointColor: const Color.fromRGBO(127, 132, 232, 1),
      ),
    ];
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

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Internet Users - 2016'),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 80,
        isVisible: false,
        labelFormat: '{value}M',
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _internetUsersDataIn2016,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _internetUsersDataIn2016!.clear();
    super.dispose();
  }
}
