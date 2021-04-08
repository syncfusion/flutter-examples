import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  int segmentedControlGroupValue = 0;
  int degree = 25;
  String day = 'Friday, 04:00 am';
  String _imageName = 'images/sunny_image.png';
  double _visibleMin = 0;
  double _visibleMax = 5;
  List<ChartSampleData> chartData = <ChartSampleData>[
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
    _calculateHeight();
    _containerHeight = orientation == Orientation.landscape
        ? model.isWebFullView
            ? 30
            : height * 0.075
        : 30;
    return Center(
        child: Column(children: [
      Container(
        width: _segmentedControlWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  margin: EdgeInsets.only(left: 5),
                  height: height * 0.085,
                  width: model.isWebFullView ? 50 : width * 0.08,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: ExactAssetImage(_imageName)))),
              Container(
                  height: height * 0.1,
                  child: Row(children: [
                    Container(
                        child: Text('$degree',
                            style: TextStyle(
                                fontSize: orientation == Orientation.landscape
                                    ? height * 0.08
                                    : height * 0.06))),
                    Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text('°C | °F', style: TextStyle(fontSize: 16))),
                  ]))
            ]),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
          visible: //model.isWebFullView
              //?
              height < 350 ? false : true,
          // : true,
          child: Container(
              padding:
                  orientation == Orientation.landscape && !model.isWebFullView
                      ? EdgeInsets.all(0)
                      : model.isWebFullView
                          ? EdgeInsets.fromLTRB(0, 16, 0, 16)
                          : EdgeInsets.fromLTRB(0, 8, 0, 8),
              // alignment: Alignment.center,
              width: _segmentedControlWidth,
              child: CupertinoSlidingSegmentedControl(
                  groupValue: segmentedControlGroupValue,
                  children: _getButtons(orientation),
                  onValueChanged: (int? i) {
                    setState(() {
                      if (i == 0) {
                        _loadZerothGroupValue();
                      } else if (i == 1) {
                        _loadFirstGroupValue();
                      } else if (i == 2) {
                        _loadSecondGroupValue();
                      } else if (i == 3) {
                        _loadThirdGroupValue();
                      } else if (i == 4) {
                        _loadFourthGroupValue();
                      }
                    });
                  })))
      //)
    ]));
  }

  /// Method to calculate widget height
  void _calculateHeight() {
    height = !model.isWebFullView ? height - 46 : height;
    height = model.isWebFullView && !kIsWeb ? height * 0.6 : height;
    if (kIsWeb &&
        model.webOutputContainerState != null &&
        model.webOutputContainerState.outputScaffoldKey != null &&
        (model.webOutputContainerState.outputScaffoldKey)
                .currentContext
                ?.size !=
            null) {
      height = (model.webOutputContainerState.outputScaffoldKey)
          .currentContext!
          .size!
          .height;

      if (diff == null) {
        diff = MediaQuery.of(context).size.height - height;
      } else {
        height = MediaQuery.of(context).size.height - diff!;
      }
    }
  }

  /// Returns the item of segmented control
  Map<int, Widget> _getButtons(Orientation _orientation) {
    _containerWidth = _segmentedControlWidth == double.infinity
        ? width / 5
        : _segmentedControlWidth / 5;
    final double fontSize = _orientation == Orientation.landscape
        ? model.isWebFullView
            ? 12
            : 10
        : 12;
    final Color color = model.currentThemeData?.brightness == Brightness.light
        ? const Color.fromRGBO(104, 104, 104, 1)
        : const Color.fromRGBO(242, 242, 242, 1);
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(getColor),
    );
    final Map<int, Widget> buttons = <int, Widget>{
      0: Container(
          width: _containerWidth,
          child: TextButton(
              onPressed: () => setState(() => _loadZerothGroupValue()),
              style: style,
              child: Column(
                children: <Widget>[
                  _getText('Fri', fontSize, color),
                  _getContainer('images/sunny_image.png'),
                  _getText('25°19°', fontSize, color),
                ],
              ))),
      1: Container(
          width: _containerWidth,
          child: TextButton(
              onPressed: () => setState(() => _loadFirstGroupValue()),
              style: style,
              child: Column(
                children: <Widget>[
                  _getText('Sat', fontSize, color),
                  _getContainer('images/sunny_image.png'),
                  _getText('25°20°', fontSize, color),
                ],
              ))),
      2: Container(
          width: _containerWidth,
          child: TextButton(
              onPressed: () => setState(() => _loadSecondGroupValue()),
              style: style,
              child: Column(
                children: <Widget>[
                  _getText('Sun', fontSize, color),
                  _getContainer('images/cloudy.png'),
                  _getText('24°18°', fontSize, color),
                ],
              ))),
      3: Container(
          width: _containerWidth,
          child: TextButton(
              onPressed: () => setState(() => _loadThirdGroupValue()),
              style: style,
              child: Column(
                children: <Widget>[
                  _getText('Mon', fontSize, color),
                  _getContainer('images/cloudy.png'),
                  _getText('19°14°', fontSize, color),
                ],
              ))),
      4: Container(
          width: _containerWidth,
          child: TextButton(
              onPressed: () => setState(() => _loadFourthGroupValue()),
              style: style,
              child: Column(
                children: <Widget>[
                  _getText('Tue', fontSize, color),
                  _getContainer('images/rainy.png'),
                  _getText('18°14°', fontSize, color),
                ],
              ))),
    };
    return buttons;
  }

  /// Returns the text widget
  Text _getText(String text, double fontSize, Color color) {
    return Text(text, style: TextStyle(fontSize: fontSize, color: color));
  }

  /// Return the image container
  Container _getContainer(String imageName) {
    return Container(
      height: _containerHeight,
      margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
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
          ? Color.fromRGBO(235, 235, 235, 1)
          : Color.fromRGBO(104, 104, 104, 1);
    } else if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed)) {
      return Color.fromRGBO(224, 224, 224, 1);
    } else {
      return null;
    }
  }

  /// Calls while performing the swipe operation
  void performSwipe(ChartSwipeDirection direction) {
    setState(() {
      if (direction == ChartSwipeDirection.end) {
        if (_visibleMin == 0 && _visibleMax == 5) {
          _loadFirstGroupValue();
        } else if (_visibleMin == 6 && _visibleMax == 11) {
          _loadSecondGroupValue();
        } else if (_visibleMin == 12 && _visibleMax == 17) {
          _loadThirdGroupValue();
        } else if (_visibleMin == 18 && _visibleMax == 23) {
          _loadFourthGroupValue();
        }
      } else {
        if (_visibleMin == 24 && _visibleMax == 29) {
          _loadThirdGroupValue();
        } else if (_visibleMin == 18 && _visibleMax == 23) {
          _loadSecondGroupValue();
        } else if (_visibleMin == 12 && _visibleMax == 17) {
          _loadFirstGroupValue();
        } else if (_visibleMin == 6 && _visibleMax == 11) {
          _loadZerothGroupValue();
        }
      }
    });
  }

  /// load the value when the zeroth segmented group value is selected
  void _loadZerothGroupValue() {
    _visibleMin = 0;
    _visibleMax = 5;
    segmentedControlGroupValue = 0;
    degree = 25;
    day = 'Friday, 04:00 am';
    _imageName = 'images/sunny_image.png';
  }

  /// load the value when the first segmented group value is selected
  void _loadFirstGroupValue() {
    _visibleMin = 6;
    _visibleMax = 11;
    segmentedControlGroupValue = 1;
    degree = 25;
    day = 'Saturday, 01:00 am';
    _imageName = 'images/sunny_image.png';
  }

  /// load the value when the second segmented group value is selected
  void _loadSecondGroupValue() {
    _visibleMin = 12;
    _visibleMax = 17;
    segmentedControlGroupValue = 2;
    degree = 24;
    day = 'Sunday, 01:00 am';
    _imageName = 'images/cloudy.png';
  }

  /// load the value when the third segmented group value is selected
  void _loadThirdGroupValue() {
    _visibleMin = 18;
    _visibleMax = 23;
    segmentedControlGroupValue = 3;
    degree = 19;
    day = 'Monday, 01:00 am';
    _imageName = 'images/cloudy.png';
  }

  /// load the value when the fourth segmented group value is selected
  void _loadFourthGroupValue() {
    _visibleMin = 24;
    _visibleMax = 29;
    segmentedControlGroupValue = 4;
    degree = 18;
    day = 'Tuesday, 01:00 am';
    _imageName = 'images/rainy.png';
  }

  /// Returns the cartesian chart
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      axisLabelFormatter: (AxisLabelRenderDetails details) {
        if (details.orientation == AxisOrientation.horizontal) {
          for (final ChartSampleData sampleData in chartData) {
            if (sampleData.xValue == details.actualText) {
              return ChartAxisLabel(sampleData.x, details.textStyle);
            }
          }
        }
        return ChartAxisLabel(details.text, details.textStyle);
      },
      primaryYAxis: NumericAxis(
        interval: 2,
        minimum: 0,
        maximum: 26,
        isVisible: false,
        anchorRangeToVisiblePoints: true,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      primaryXAxis: CategoryAxis(
          visibleMaximum: _visibleMax,
          visibleMinimum: _visibleMin,
          labelPlacement: LabelPlacement.onTicks,
          interval: 1,
          axisLine: AxisLine(width: 0, color: Colors.transparent),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0)),
      plotAreaBorderWidth: 0,
      series: getSeries(),
      onPlotAreaSwipe: (direction) => performSwipe(direction),
    );
  }

  /// Returns the chart series
  List<ChartSeries<ChartSampleData, String>> getSeries() {
    return <ChartSeries<ChartSampleData, String>>[
      SplineAreaSeries<ChartSampleData, String>(
        dataSource: chartData,
        borderColor: Color.fromRGBO(255, 204, 5, 1),
        borderWidth: 2,
        color: Color.fromRGBO(255, 245, 211, 1),
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.outer),
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}
