/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Render the defauld plotband.
class PlotBandDefault extends SampleView {
  /// Creates the defauld plotband.
  const PlotBandDefault(Key key) : super(key: key);

  @override
  _PlotBandDefaultState createState() => _PlotBandDefaultState();
}

/// State class of default plotband.
class _PlotBandDefaultState extends SampleViewState {
  _PlotBandDefaultState();
  final List<String> _plotBandType =
      <String>['vertical', 'horizontal', 'segment', 'line'].toList();
  bool isHorizontal = true;
  bool isVertical = false;
  bool isSegment = false;
  bool isLine = false;
  late TooltipBehavior _tooltipBehavior;

  late String _selectedType;
  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Plot band type',
              style: TextStyle(fontSize: 16.0, color: model.textColor)),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            height: 50,
            alignment: Alignment.bottomLeft,
            child: DropdownButton<String>(
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedType,
                items: _plotBandType.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'horizontal',
                      child: Text(value,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (dynamic value) {
                  _onPlotBandModeChange(value.toString());
                  stateSetter(() {});
                }),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlotBandChart();
  }

  /// Return the types of plotbands.
  SfCartesianChart _buildPlotBandChart() {
    final Color plotbandYAxisTextColor = ((isSegment || isLine) &&
            model != null &&
            model.themeData.brightness == Brightness.light)
        ? Colors.black54
        : const Color.fromRGBO(255, 255, 255, 1);
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Weather report'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          interval: 1,

          /// API for Y axis plot band.
          /// It returns the multiple plot band to chart.
          plotBands: <PlotBand>[
            PlotBand(
                isVisible: isCardView ? true : isHorizontal,
                start: -0.5,
                end: 1.5,
                text: 'Winter',
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                color: const Color.fromRGBO(101, 199, 209, 1)),
            PlotBand(
                isVisible: isCardView ? true : isHorizontal,
                start: 4.5,
                end: 7.5,
                text: 'Summer',
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                color: const Color.fromRGBO(254, 213, 2, 1)),
            PlotBand(
                isVisible: isCardView ? true : isHorizontal,
                start: 1.5,
                end: 4.5,
                text: 'Spring',
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                color: const Color.fromRGBO(140, 198, 62, 1)),
            PlotBand(
                isVisible: isCardView ? true : isHorizontal,
                start: 7.5,
                end: 9.5,
                text: 'Autumn',
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                color: const Color.fromRGBO(217, 112, 1, 1)),
            PlotBand(
                isVisible: isCardView ? true : isHorizontal,
                start: 9.5,
                end: 10.5,
                text: 'Winter',
                textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                shouldRenderAboveSeries: false,
                color: const Color.fromRGBO(101, 199, 209, 1)),
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
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.white, fontSize: 17)),
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
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.white, fontSize: 17)),
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
                shouldRenderAboveSeries: false,
                textStyle: const TextStyle(color: Colors.white, fontSize: 17)),
          ],
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        minimum: 10,
        maximum: 41,
        interval: 5,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        labelFormat: '{value} °C',
        rangePadding: ChartRangePadding.none,

        /// API for Y axis plot band.
        /// It returns the multiple plot band to chart.
        plotBands: <PlotBand>[
          PlotBand(
              isVisible: isCardView ? false : isVertical,
              start: isLine ? 40 : 30,
              end: isLine ? 40 : 41,
              horizontalTextAlignment:
                  isLine ? TextAnchor.start : TextAnchor.middle,
              verticalTextAlignment:
                  isLine ? TextAnchor.start : TextAnchor.middle,
              // padding for plotband text
              verticalTextPadding: '-7',
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
              shouldRenderAboveSeries: false,
              color: const Color.fromRGBO(207, 85, 7, 1),
              textStyle: ((isSegment || isLine) &&
                      model != null &&
                      model.themeData.brightness == Brightness.light)
                  ? const TextStyle(color: Colors.black)
                  : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
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
              // padding for plotband text
              verticalTextPadding: '-7',
              shouldRenderAboveSeries: false,
              color: const Color.fromRGBO(224, 155, 0, 1),
              textStyle: ((isSegment || isLine) &&
                      model != null &&
                      model.themeData.brightness == Brightness.light)
                  ? const TextStyle(color: Colors.black)
                  : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
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
              // padding for plotband text
              verticalTextPadding: '-7',
              shouldRenderAboveSeries: false,
              color: const Color.fromRGBO(237, 195, 12, 1),
              textStyle: ((isSegment || isLine) &&
                      model != null &&
                      model.themeData.brightness == Brightness.light)
                  ? const TextStyle(color: Colors.black)
                  : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
        ],
      ),
      series: _getPlotBandSeries(),
      tooltipBehavior: _tooltipBehavior,
      onMarkerRender: (MarkerRenderArgs markerargs) {
        markerargs.color = plotbandYAxisTextColor;
      },
    );
  }

  List<XyDataSeries<ChartSampleData, String>> _getPlotBandSeries() {
    final List<ChartSampleData> lineData = <ChartSampleData>[
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
      ChartSampleData(xValue: 'Nov', yValue: 22)
    ];
    final Color seriesColor = (isSegment || isLine) &&
            model != null &&
            model.themeData.brightness == Brightness.light
        ? Colors.black54
        : Colors.white;
    return <XyDataSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
          dataSource: lineData,
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          color: seriesColor,
          name: 'Weather',
          width: 2,
          markerSettings: const MarkerSettings(
              height: 5,
              width: 5,
              isVisible: true,
              color: Color.fromRGBO(192, 108, 132, 1)))
    ];
  }

  @override
  void initState() {
    _selectedType = _plotBandType.first;
    isHorizontal = true;
    isVertical = false;
    isSegment = false;
    isLine = false;
    _tooltipBehavior =
        TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
  }

  /// Method for updating plotband type in the chart on change.
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
      /// update the platband mode changes
    });
  }
}
