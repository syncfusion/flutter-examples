/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Render the default plot band.
class PlotBandDefault extends SampleView {
  const PlotBandDefault(Key key) : super(key: key);

  @override
  _PlotBandDefaultState createState() => _PlotBandDefaultState();
}

/// State class of default plot band.
class _PlotBandDefaultState extends SampleViewState {
  _PlotBandDefaultState();

  List<String>? _plotBandType;
  late bool isHorizontal;
  late bool isVertical;
  late String _selectedType;
  late bool isSegment;
  late bool isLine;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _weatherReport;

  @override
  void initState() {
    _plotBandType =
        <String>['vertical', 'horizontal', 'segment', 'line'].toList();
    isHorizontal = true;
    isVertical = false;
    _selectedType = _plotBandType!.first;
    isSegment = false;
    isLine = false;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
    _weatherReport = <ChartSampleData>[
      ChartSampleData(xValue: 'Jan', yValue: 23),
      ChartSampleData(xValue: 'Feb', yValue: 24),
      ChartSampleData(xValue: 'Mar', yValue: 23),
      ChartSampleData(xValue: 'Apr', yValue: 22),
      ChartSampleData(xValue: 'May', yValue: 21),
      ChartSampleData(xValue: 'Jun', yValue: 27),
      ChartSampleData(xValue: 'Jul', yValue: 33),
      ChartSampleData(xValue: 'Aug', yValue: 36),
      ChartSampleData(xValue: 'Sep', yValue: 23),
      ChartSampleData(xValue: 'Oct', yValue: 25),
      ChartSampleData(xValue: 'Nov', yValue: 22),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              'Plot band type',
              style: TextStyle(
                fontSize: 16.0,
                color: model.textColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(
                  color: const Color(0xFFBDBDBD),
                  height: 1,
                ),
                value: _selectedType,
                items: _plotBandType!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : 'horizontal',
                    child: Text(
                      value,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  _onPlotBandModeChange(value.toString());
                  stateSetter(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    final Color yAxisPlotBandTextColor = ((isSegment || isLine) &&
            model != null &&
            model.themeData.colorScheme.brightness == Brightness.light)
        ? Colors.black54
        : const Color.fromRGBO(255, 255, 255, 1);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Weather report',
      ),
      primaryXAxis: CategoryAxis(
        interval: 1,

        /// API for Y axis plot band.
        /// It returns the multiple plot band to Chart.
        plotBands: <PlotBand>[
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: -0.5,
            end: 1.5,
            text: 'Winter',
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            color: const Color.fromRGBO(101, 199, 209, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 4.5,
            end: 7.5,
            text: 'Summer',
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            color: const Color.fromRGBO(254, 213, 2, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 1.5,
            end: 4.5,
            text: 'Spring',
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            color: const Color.fromRGBO(140, 198, 62, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 7.5,
            end: 9.5,
            text: 'Autumn',
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            color: const Color.fromRGBO(217, 112, 1, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 9.5,
            end: 10.5,
            text: 'Winter',
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            color: const Color.fromRGBO(101, 199, 209, 1),
          ),
          PlotBand(
            size: 2,
            start: -0.5,
            end: 4.5,
            textAngle: 0,
            associatedAxisStart: 20.5,
            text: 'Average',
            associatedAxisEnd: 27.5,
            isVisible: isCardView ? false : isSegment,
            color: const Color.fromRGBO(224, 155, 0, 1),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          PlotBand(
            start: 7.5,
            end: 10.5,
            size: 3,
            associatedAxisStart: 20.5,
            text: 'Average',
            associatedAxisEnd: 27.5,
            textAngle: 0,
            isVisible: isCardView ? false : isSegment,
            color: const Color.fromRGBO(224, 155, 0, 1),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          PlotBand(
            start: 4.5,
            end: 7.5,
            size: 2,
            associatedAxisStart: 32.5,
            text: 'High',
            associatedAxisEnd: 37.5,
            textAngle: 0,
            isVisible: isCardView ? false : isSegment,
            color: const Color.fromRGBO(207, 85, 7, 1),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 10,
        maximum: 41,
        interval: 5,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        labelFormat: '{value} °C',
        rangePadding: ChartRangePadding.none,

        /// API for Y axis plot band.
        /// It returns the multiple plot band to Chart.
        plotBands: <PlotBand>[
          PlotBand(
            isVisible: isCardView ? false : isVertical,
            start: isLine ? 40 : 30,
            end: isLine ? 40 : 41,
            horizontalTextAlignment:
                isLine ? TextAnchor.start : TextAnchor.middle,
            verticalTextAlignment:
                isLine ? TextAnchor.start : TextAnchor.middle,
            // Padding for plotBand text.
            verticalTextPadding: isLine ? '-7' : '',
            borderWidth: isCardView
                ? 0
                : isLine
                    ? 2
                    : 0,
            borderColor: isCardView
                ? Colors.black
                : isLine
                    ? const Color.fromRGBO(207, 85, 7, 1)
                    : Colors.black,
            text: 'High Temperature',
            color: const Color.fromRGBO(207, 85, 7, 1),
            textStyle: ((isSegment || isLine) &&
                    model != null &&
                    model.themeData.colorScheme.brightness == Brightness.light)
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
          PlotBand(
            isVisible: isCardView ? false : isVertical,
            start: isLine ? 30 : 20,
            end: 30,
            horizontalTextAlignment:
                isLine ? TextAnchor.start : TextAnchor.middle,
            verticalTextAlignment:
                isLine ? TextAnchor.start : TextAnchor.middle,
            borderWidth: isCardView
                ? 0
                : isLine
                    ? 2
                    : 0,
            borderColor: isCardView
                ? Colors.black
                : isLine
                    ? const Color.fromRGBO(224, 155, 0, 1)
                    : Colors.black,
            text: 'Average Temperature',
            // Padding for plotBand text.
            verticalTextPadding: isLine ? '-7' : '',
            color: const Color.fromRGBO(224, 155, 0, 1),
            textStyle: ((isSegment || isLine) &&
                    model != null &&
                    model.themeData.colorScheme.brightness == Brightness.light)
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
          PlotBand(
            isVisible: isCardView ? false : isVertical,
            start: isLine ? 20 : 10,
            end: 20,
            horizontalTextAlignment:
                isLine ? TextAnchor.start : TextAnchor.middle,
            verticalTextAlignment:
                isLine ? TextAnchor.start : TextAnchor.middle,
            borderWidth: isCardView
                ? 0
                : isLine
                    ? 2
                    : 0,
            borderColor: isCardView
                ? Colors.black
                : isLine
                    ? const Color.fromRGBO(237, 195, 12, 1)
                    : Colors.black,
            text: 'Low Temperature',
            // padding for plotBand text.
            verticalTextPadding: isLine ? '-7' : '',
            color: const Color.fromRGBO(237, 195, 12, 1),
            textStyle: ((isSegment || isLine) &&
                    model != null &&
                    model.themeData.colorScheme.brightness == Brightness.light)
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ],
      ),
      series: _buildLineSeries(),
      onMarkerRender: (MarkerRenderArgs markerArgs) {
        markerArgs.color = yAxisPlotBandTextColor;
      },
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, String>> _buildLineSeries() {
    final Color seriesColor = (isSegment || isLine) &&
            model != null &&
            model.themeData.colorScheme.brightness == Brightness.light
        ? Colors.black54
        : Colors.white;
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
        dataSource: _weatherReport,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        color: seriesColor,
        name: 'Weather',
        markerSettings: const MarkerSettings(
          height: 5,
          width: 5,
          isVisible: true,
          color: Color.fromRGBO(192, 108, 132, 1),
        ),
      ),
    ];
  }

  /// Method for updating plot band type in the Chart on change.
  void _onPlotBandModeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'horizontal') {
      isVertical = true;
      isHorizontal = false;
      isSegment = false;
      isLine = false;
    }
    if (_selectedType == 'vertical') {
      isHorizontal = true;
      isVertical = false;
      isSegment = false;
      isLine = false;
    }
    if (_selectedType == 'segment') {
      isHorizontal = false;
      isVertical = false;
      isSegment = true;
      isLine = false;
    }
    if (_selectedType == 'line') {
      isHorizontal = false;
      isVertical = true;
      isSegment = false;
      isLine = true;
    }
    setState(() {
      /// Update the plat band mode changes.
    });
  }

  @override
  void dispose() {
    _plotBandType!.clear();
    _weatherReport!.clear();
    super.dispose();
  }
}
