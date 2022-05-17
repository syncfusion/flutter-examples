import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../model/sample_view.dart';

/// Renders the pagination sample
class Pagination extends SampleView {
  /// Creates the pagination chart
  const Pagination(Key key) : super(key: key);

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends SampleViewState {
  late double height, width, _segmentedControlWidth;
  late double _containerWidth, _containerHeight;
  double? diff;
  late int segmentedControlGroupValue;
  late int degree;
  late String day;
  late String _imageName;
  late double _visibleMin;
  late double _visibleMax;
  late List<String> _daysWithTime;
  late List<String> _temperatue;
  late List<String> _images;
  late List<String> _days;
  late List<double> _minValues;
  late List<double> _maxValues;
  late List<int> _degrees;

  late List<ChartSampleData> chartData;

  @override
  void initState() {
    segmentedControlGroupValue = 0;
    degree = 25;
    day = 'Friday, 01:00 am';
    _imageName = 'images/sunny_image.png';
    _visibleMin = 0;
    _visibleMax = 5;
    _daysWithTime = const <String>[
      'Friday, 01:00 am',
      'Saturday, 01:00 am',
      'Sunday, 01:00 am',
      'Monday, 01:00 am',
      'Tuesday, 01:00 am'
    ];
    _temperatue = const <String>[
      '25°19°',
      '25°20°',
      '24°18°',
      '19°14°',
      '18°14°'
    ];
    _images = const <String>[
      'sunny_image.png',
      'sunny_image.png',
      'cloudy.png',
      'cloudy.png',
      'rainy.png'
    ];
    _days = const <String>['Fri', 'Sat', 'Sun', 'Mon', 'Tue'];
    _minValues = const <double>[0, 6, 12, 18, 24];
    _maxValues = const <double>[5, 11, 17, 23, 29];
    _degrees = const <int>[25, 25, 24, 19, 18];
    chartData = <ChartSampleData>[
      ChartSampleData(xValue: '0', x: '1 am', y: 20),
      ChartSampleData(xValue: '1', x: '4 am', y: 20),
      ChartSampleData(xValue: '2', x: '7 am', y: 20),
      ChartSampleData(xValue: '3', x: '10 am', y: 21),
      ChartSampleData(xValue: '4', x: '1 pm', y: 21),
      ChartSampleData(xValue: '5', x: '4 pm', y: 24),
      ChartSampleData(xValue: '6', x: '1 am', y: 19),
      ChartSampleData(xValue: '7', x: '4 am', y: 20),
      ChartSampleData(xValue: '8', x: '7 am', y: 20),
      ChartSampleData(xValue: '9', x: '10 am', y: 21),
      ChartSampleData(xValue: '10', x: '1 pm', y: 24),
      ChartSampleData(xValue: '11', x: '4 pm', y: 24),
      ChartSampleData(xValue: '12', x: '1 am', y: 21),
      ChartSampleData(xValue: '13', x: '4 am', y: 21),
      ChartSampleData(xValue: '14', x: '7 am', y: 21),
      ChartSampleData(xValue: '15', x: '10 am', y: 22),
      ChartSampleData(xValue: '16', x: '1 pm', y: 23),
      ChartSampleData(xValue: '17', x: '4 pm', y: 24),
      ChartSampleData(xValue: '18', x: '1 am', y: 20),
      ChartSampleData(xValue: '19', x: '4 am', y: 19),
      ChartSampleData(xValue: '20', x: '7 am', y: 19),
      ChartSampleData(xValue: '21', x: '10 am', y: 18),
      ChartSampleData(xValue: '22', x: '1 pm', y: 19),
      ChartSampleData(xValue: '23', x: '4 pm', y: 19),
      ChartSampleData(xValue: '24', x: '1 am', y: 16),
      ChartSampleData(xValue: '25', x: '4 am', y: 15),
      ChartSampleData(xValue: '26', x: '7 am', y: 14),
      ChartSampleData(xValue: '27', x: '10 am', y: 15),
      ChartSampleData(xValue: '28', x: '1 pm', y: 16),
      ChartSampleData(xValue: '29', x: '4 pm', y: 18),
    ];
    super.initState();
  }

  @override
  void dispose() {
    chartData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    _segmentedControlWidth = width > 500
        ? model.isWebFullView
            ? width * 0.5
            : width * 0.7
        : double.infinity;
    height = MediaQuery.of(context).size.height;
    height = !model.isWebFullView ? height - 46 : height;
    height = model.isWebFullView && !kIsWeb ? height * 0.6 : height * 0.65;
    _containerHeight = 30;
    return Center(
        child: Column(children: <Widget>[
      SizedBox(
        width: _segmentedControlWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: height * 0.085,
                  width: model.isWebFullView ? 50 : width * 0.08,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: ExactAssetImage(_imageName)))),
              SizedBox(
                  height: height * 0.1,
                  child: Row(children: <Widget>[
                    SizedBox(
                        child: Text('$degree',
                            style: TextStyle(
                                fontSize: orientation == Orientation.landscape
                                    ? height * 0.08
                                    : height * 0.06))),
                    Container(
                        padding: const EdgeInsets.only(right: 30),
                        child: const Text('°C | °F',
                            style: TextStyle(fontSize: 16))),
                  ]))
            ]),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('USA, Texas',
                          style: TextStyle(fontSize: height * 0.045)),
                      Text(day, style: TextStyle(fontSize: height * 0.025)),
                    ]))
          ],
        ),
      ),
      Expanded(
          child: Container(
              alignment: Alignment.center,
              width: _segmentedControlWidth,
              child: _buildCartesianChart())),
      Visibility(
          visible: height < 350 ? false : true,
          child: Container(
              padding: model.isWebFullView
                  ? const EdgeInsets.fromLTRB(0, 16, 0, 16)
                  : const EdgeInsets.fromLTRB(0, 8, 0, 8),
              width: _segmentedControlWidth,
              child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: segmentedControlGroupValue,
                  children: _getButtons(orientation),
                  onValueChanged: (int? i) => _loadGroupValue(i!))))
    ]));
  }

  /// Returns the item of segmented control
  Map<int, Widget> _getButtons(Orientation orientation) {
    _containerWidth = _segmentedControlWidth == double.infinity
        ? width / 5
        : _segmentedControlWidth / 5;
    final Color color = model.currentThemeData?.brightness == Brightness.light
        ? const Color.fromRGBO(104, 104, 104, 1)
        : const Color.fromRGBO(242, 242, 242, 1);
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(getColor),
    );
    final Map<int, Widget> buttons = <int, Widget>{};
    for (int i = 0; i <= 4; i++) {
      buttons.putIfAbsent(
        i,
        () => SizedBox(
            width: _containerWidth,
            child: TextButton(
                onPressed: () => _loadGroupValue(i),
                style: style,
                child: Column(
                  children: <Widget>[
                    Text(_days[i],
                        style: TextStyle(fontSize: 12, color: color)),
                    _getContainer('images/' + _images[i]),
                    Text(_temperatue[i],
                        style: TextStyle(fontSize: 12, color: color)),
                  ],
                ))),
      );
    }

    return buttons;
  }

  /// Return the image container
  Container _getContainer(String imageName) {
    return Container(
      height: _containerHeight,
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(imageName),
        ),
      ),
    );
  }

  /// Returns color for the button based on interaction performed
  Color? getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return model.currentThemeData?.brightness == Brightness.light
          ? const Color.fromRGBO(235, 235, 235, 1)
          : const Color.fromRGBO(104, 104, 104, 1);
    } else if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed)) {
      return const Color.fromRGBO(224, 224, 224, 1);
    } else {
      return null;
    }
  }

  /// Calls while performing the swipe operation
  void performSwipe(ChartSwipeDirection direction) {
    int? index;
    if (_visibleMin == 0 && _visibleMax == 5) {
      index = direction == ChartSwipeDirection.end ? 1 : null;
    } else if (_visibleMin == 6 && _visibleMax == 11) {
      index = direction == ChartSwipeDirection.end ? 2 : 0;
    } else if (_visibleMin == 12 && _visibleMax == 17) {
      index = direction == ChartSwipeDirection.end ? 3 : 1;
    } else if (_visibleMin == 18 && _visibleMax == 23) {
      index = direction == ChartSwipeDirection.end ? 4 : 2;
    } else if (_visibleMin == 24 && _visibleMax == 29) {
      index = direction == ChartSwipeDirection.end ? null : 3;
    }

    if (index != null) {
      _loadGroupValue(index);
    }
  }

  /// load the values based on the provided index
  void _loadGroupValue(int index) {
    setState(() {
      _visibleMin = _minValues[index];
      _visibleMax = _maxValues[index];
      segmentedControlGroupValue = index;
      degree = _degrees[index];
      day = _daysWithTime[index];
      _imageName = 'images/' + _images[index];
    });
  }

  /// Returns the cartesian chart
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      primaryYAxis: NumericAxis(
        interval: 2,
        minimum: 0,
        maximum: 26,
        isVisible: false,
        anchorRangeToVisiblePoints: true,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
      ),
      primaryXAxis: CategoryAxis(
          visibleMaximum: _visibleMax,
          visibleMinimum: _visibleMin,
          labelPlacement: LabelPlacement.onTicks,
          interval: 1,
          name: 'primaryXAxis',
          axisLine: const AxisLine(width: 0, color: Colors.transparent),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            if (details.axis.name == 'primaryXAxis') {
              for (final ChartSampleData sampleData in chartData) {
                if (sampleData.xValue == details.text) {
                  return ChartAxisLabel(sampleData.x, details.textStyle);
                }
              }
            }
            return ChartAxisLabel(details.text, details.textStyle);
          }),
      plotAreaBorderWidth: 0,
      series: getSeries(),
      onPlotAreaSwipe: (ChartSwipeDirection direction) =>
          performSwipe(direction),
    );
  }

  /// Returns the chart series
  List<ChartSeries<ChartSampleData, String>> getSeries() {
    return <ChartSeries<ChartSampleData, String>>[
      SplineAreaSeries<ChartSampleData, String>(
        dataSource: chartData,
        borderColor: const Color.fromRGBO(255, 204, 5, 1),
        borderWidth: 2,
        color: const Color.fromRGBO(255, 245, 211, 1),
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.outer),
        xValueMapper: (ChartSampleData sales, _) => sales.xValue as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}
