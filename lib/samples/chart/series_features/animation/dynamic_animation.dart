/// Dart imports
import 'dart:async';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/customDropDown.dart';


Timer timer;

/// Renders the Cartesian chart with dynamic animation sample.
class CartesianDynamicAnimation extends SampleView {
  const CartesianDynamicAnimation(Key key) : super(key: key);

  @override
  _CartesianDynamicAnimationState createState() =>
      _CartesianDynamicAnimationState();
}

/// State class of the Cartesian chart with dynamic animation.
class _CartesianDynamicAnimationState extends SampleViewState {
  _CartesianDynamicAnimationState();
  int count = 0;
  final List<String> _seriesType = <String>[
    'Column',
    'Line',
    'Spline',
    'StepLine',
    'Scatter',
    'Bubble',
    'Bar',
    'Area'
  ].toList();

  String _selectedType = 'Column';

  @override
  void initState() {
    _selectedType = 'Column';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    chartData = getChartData();
    timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        chartData = getChartData();
      });
    });
    return getDynamicAnimationChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Chart type ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedType,
                          item: _seriesType.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'column',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onSeriesTypeChange(value.toString(), model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the the Cartesian chart with dynamic animation.
  SfCartesianChart getDynamicAnimationChart(
      [String _selectedType, SampleModel model]) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          interval: 20,
          maximum: 80,
          majorTickLines: MajorTickLines(size: 0)),
      series: getAnimationData(),
    );
  }

  /// List of chart data for initial rendering.
  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: '1', y: 45, pointColor: Colors.yellow),
    ChartSampleData(x: '2', y: 52, pointColor: Colors.teal),
    ChartSampleData(x: '3', y: 41, pointColor: Colors.blue),
    ChartSampleData(x: '4', y: 65, pointColor: Colors.orange),
    ChartSampleData(x: '5', y: 36, pointColor: Colors.pink),
    ChartSampleData(x: '6', y: 65, pointColor: Colors.brown[300]),
  ];

  /// Returns the list of chart series which need to render on the 
  /// Cartesian chart with dynamic animation.
  List<ChartSeries<ChartSampleData, String>> getAnimationData() {
    if (_selectedType == 'Line') {
      return <LineSeries<ChartSampleData, String>>[
        LineSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: const Color.fromRGBO(0, 168, 181, 1),
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.near,
              isVisible: false),
        )
      ];
    } else if (_selectedType == 'Column') {
      return <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: const Color.fromRGBO(0, 168, 181, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.near,
              isVisible: false),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        )
      ];
    } else if (_selectedType == 'Spline') {
      return <SplineSeries<ChartSampleData, String>>[
        SplineSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: const Color.fromRGBO(0, 168, 181, 1),
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.near,
              isVisible: false),
        )
      ];
    } else if (_selectedType == 'Area') {
      return <AreaSeries<ChartSampleData, String>>[
        AreaSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: const Color.fromRGBO(0, 168, 181, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.near,
              isVisible: false),
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
        )
      ];
    } else if (_selectedType == 'StepLine') {
      return <StepLineSeries<ChartSampleData, String>>[
        StepLineSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 2,
          color: const Color.fromRGBO(0, 168, 181, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.center,
              labelAlignment: ChartDataLabelAlignment.auto,
              isVisible: false),
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
        )
      ];
    } else if (_selectedType == 'Bar') {
      return <BarSeries<ChartSampleData, String>>[
        BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: const Color.fromRGBO(0, 168, 181, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.center,
              labelAlignment: ChartDataLabelAlignment.auto,
              isVisible: false),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
        )
      ];
    } else if (_selectedType == 'Scatter') {
      return <ScatterSeries<ChartSampleData, String>>[
        ScatterSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          color: const Color.fromRGBO(0, 168, 181, 1),
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.center,
              labelAlignment: ChartDataLabelAlignment.auto,
              isVisible: false),
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 10,
              width: 10,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
        )
      ];
    } else if (_selectedType == 'Bubble') {
      return <BubbleSeries<ChartSampleData, String>>[
        BubbleSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: const Color.fromRGBO(0, 168, 181, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          sizeValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(
              color: Colors.blue,
              alignment: ChartAlignment.center,
              labelAlignment: ChartDataLabelAlignment.auto,
              isVisible: false),
          markerSettings: MarkerSettings(
              isVisible: false,
              height: 5,
              width: 5,
              color: Colors.white,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.blue),
        )
      ];
    }
    return null;
  }

  /// Method to get the chartdata for the cartesian chart in order to do dynmaic animation.
  List<ChartSampleData> getChartData() {
    if (count == 0) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '1', y: 76, pointColor: Colors.yellow),
        ChartSampleData(x: '2', y: 50, pointColor: Colors.teal),
        ChartSampleData(x: '3', y: 60, pointColor: Colors.blue),
        ChartSampleData(x: '4', y: 32, pointColor: Colors.orange),
        ChartSampleData(x: '5', y: 29, pointColor: Colors.pink),
        ChartSampleData(x: '6', y: 20, pointColor: Colors.brown[300]),
      ];
      count++;
    } else if (count == 1) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '1', y: 36, pointColor: Colors.yellow),
        ChartSampleData(x: '2', y: 10, pointColor: Colors.teal),
        ChartSampleData(x: '3', y: 20, pointColor: Colors.blue),
        ChartSampleData(x: '4', y: 50, pointColor: Colors.orange),
        ChartSampleData(x: '5', y: 19, pointColor: Colors.pink),
        ChartSampleData(x: '6', y: 67, pointColor: Colors.brown[300]),
      ];
      count++;
    } else if (count == 2) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '1', y: 40, pointColor: Colors.yellow),
        ChartSampleData(x: '2', y: 60, pointColor: Colors.teal),
        ChartSampleData(x: '3', y: 35, pointColor: Colors.blue),
        ChartSampleData(x: '4', y: 12, pointColor: Colors.orange),
        ChartSampleData(x: '5', y: 65, pointColor: Colors.pink),
        ChartSampleData(x: '6', y: 40, pointColor: Colors.brown[300]),
      ];
      count = 0;
    }
    if (timer != null) {
      timer.cancel();
    }
    return chartData;
  }


  /// Method to update the series type in the chart on change.
  void onSeriesTypeChange(String item, SampleModel model) {
    _selectedType = item;
    setState(() {});
  }
}