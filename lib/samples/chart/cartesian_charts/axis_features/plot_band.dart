/// Package import.
import 'dart:math' as math;
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

  late List<String> _plotBandType;
  late bool isHorizontal;
  late bool isVertical;
  late String _selectedType;
  late bool isSegment;
  late bool isLine;
  late bool isCustom;
  late bool _shouldRenderAboveSeries;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _weatherReport;
  List<_ProductSalesComparisonData>? _productSalesComparisonData;

  @override
  void initState() {
    _plotBandType = <String>[
      'vertical',
      'horizontal',
      'segment',
      'line',
      'custom',
    ];

    isHorizontal = true;
    isVertical = false;
    _selectedType = _plotBandType.first;
    isSegment = false;
    isLine = false;
    isCustom = false;
    _shouldRenderAboveSeries = false;

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

    _productSalesComparisonData = <_ProductSalesComparisonData>[
      _ProductSalesComparisonData(DateTime(2017, 12, 22), 40),
      _ProductSalesComparisonData(DateTime(2017, 12, 26), 70),
      _ProductSalesComparisonData(DateTime(2017, 12, 27), 75),
      _ProductSalesComparisonData(DateTime(2018, 1, 2), 82),
      _ProductSalesComparisonData(DateTime(2018, 1, 3), 53),
      _ProductSalesComparisonData(DateTime(2018, 1, 4), 54),
    ];

    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildPlotBandTypeDropdown(stateSetter),
            // Show "Above series" checkbox only for custom, segment, and line types.
            if (isCustom || isSegment || isLine)
              _buildShouldRenderAboveSeries(stateSetter),
          ],
        );
      },
    );
  }

  Widget _buildPlotBandTypeDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Plot band type',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        DropdownButton<String>(
          dropdownColor: model.drawerBackgroundColor,
          focusColor: Colors.transparent,
          underline: Container(color: const Color(0xFFBDBDBD), height: 1),
          value: _selectedType,
          items: List<DropdownMenuItem<String>>.generate(_plotBandType.length, (
            int index,
          ) {
            final String value = _plotBandType[index];
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: model.textColor)),
            );
          }),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            _onPlotBandModeChange(value);
            stateSetter(() {});
          },
        ),
      ],
    );
  }

  Widget _buildShouldRenderAboveSeries(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Above series',
          style: TextStyle(color: model.textColor, fontSize: 16),
        ),
        SizedBox(
          width: 90,
          child: CheckboxListTile(
            activeColor: model.primaryColor,
            value: _shouldRenderAboveSeries,
            onChanged: (bool? value) {
              _shouldRenderAboveSeries = value ?? false;
              stateSetter(() {});
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  SfCartesianChart _buildCartesianChart() {
    return isCustom ? customPlotBandChart() : defaultPlotBandChart();
  }

  SfCartesianChart defaultPlotBandChart() {
    final Color yAxisPlotBandTextColor =
        ((isSegment || isLine) &&
            model != null &&
            model.themeData.colorScheme.brightness == Brightness.light)
        ? Colors.black54
        : const Color.fromRGBO(255, 255, 255, 1);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Weather report'),
      primaryXAxis: CategoryAxis(
        interval: 1,

        /// API for X axis plot band.
        /// It returns the multiple plot band to Chart.
        plotBands: <PlotBand>[
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: -0.5,
            end: 1.5,
            text: 'Winter',
            textStyle: const TextStyle(color: Colors.black, fontSize: 13),
            color: const Color.fromRGBO(101, 199, 209, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 4.5,
            end: 7.5,
            text: 'Summer',
            textStyle: const TextStyle(color: Colors.black, fontSize: 13),
            color: const Color.fromRGBO(254, 213, 2, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 1.5,
            end: 4.5,
            text: 'Spring',
            textStyle: const TextStyle(color: Colors.black, fontSize: 13),
            color: const Color.fromRGBO(140, 198, 62, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 7.5,
            end: 9.5,
            text: 'Autumn',
            textStyle: const TextStyle(color: Colors.black, fontSize: 13),
            color: const Color.fromRGBO(217, 112, 1, 1),
          ),
          PlotBand(
            isVisible: isCardView ? true : isHorizontal,
            start: 9.5,
            end: 10.5,
            text: 'Winter',
            textStyle: const TextStyle(color: Colors.black, fontSize: 13),
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
            textStyle: const TextStyle(color: Colors.white, fontSize: 17),
            shouldRenderAboveSeries: _shouldRenderAboveSeries,
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
            textStyle: const TextStyle(color: Colors.white, fontSize: 17),
            shouldRenderAboveSeries: _shouldRenderAboveSeries,
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
            textStyle: const TextStyle(color: Colors.white, fontSize: 17),
            shouldRenderAboveSeries: _shouldRenderAboveSeries,
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
            horizontalTextAlignment: isLine
                ? TextAnchor.start
                : TextAnchor.middle,
            verticalTextAlignment: isLine
                ? TextAnchor.start
                : TextAnchor.middle,
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
            textStyle:
                ((isSegment || isLine) &&
                    model != null &&
                    model.themeData.colorScheme.brightness == Brightness.light)
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
          PlotBand(
            isVisible: isCardView ? false : isVertical,
            start: isLine ? 30 : 20,
            end: 30,
            horizontalTextAlignment: isLine
                ? TextAnchor.start
                : TextAnchor.middle,
            verticalTextAlignment: isLine
                ? TextAnchor.start
                : TextAnchor.middle,
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
            verticalTextPadding: isLine ? '-7' : '',
            color: const Color.fromRGBO(224, 155, 0, 1),
            textStyle:
                ((isSegment || isLine) &&
                    model != null &&
                    model.themeData.colorScheme.brightness == Brightness.light)
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
          PlotBand(
            isVisible: isCardView ? false : isVertical,
            start: isLine ? 20 : 10,
            end: 20,
            horizontalTextAlignment: isLine
                ? TextAnchor.start
                : TextAnchor.middle,
            verticalTextAlignment: isLine
                ? TextAnchor.start
                : TextAnchor.middle,
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
            verticalTextPadding: isLine ? '-7' : '',
            color: const Color.fromRGBO(237, 195, 12, 1),
            textStyle:
                ((isSegment || isLine) &&
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

  SfCartesianChart customPlotBandChart() {
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Sales comparison with promotional periods',
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeCategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.multipleRows
            : AxisLabelIntersectAction.rotate45,
        plotBands: <PlotBand>[
          CustomPlotBand(
            start: DateTime(2017, 12, 22),
            end: DateTime(2017, 12, 27),
            textAngle: 0,
            verticalTextPadding: '-10%',
            verticalTextAlignment: TextAnchor.start,
            text: 'Christmas Sale\nDec 2017',
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            patternColor: const Color.fromRGBO(217, 112, 1, 1),
            stripeOpacity: _shouldRenderAboveSeries ? 0.75 : 0.55,
            stripeWidth: 2,
            stripeSpacing: 8,
            dashLength: 4,
            stripeAngle: 135,
            shouldRenderAboveSeries: _shouldRenderAboveSeries,
          ),
          CustomPlotBand(
            textAngle: 0,
            start: DateTime(2018, 1, 2),
            end: DateTime(2018, 1, 5),
            verticalTextPadding: '-10%',
            verticalTextAlignment: TextAnchor.start,
            text: 'New Year Sale\nJan 2018',
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            patternColor: const Color.fromRGBO(255, 100, 150, 1),
            stripeOpacity: _shouldRenderAboveSeries ? 0.75 : 0.55,
            stripeWidth: 2,
            stripeSpacing: 8,
            dashLength: 4,
            stripeAngle: 135,
            shouldRenderAboveSeries: _shouldRenderAboveSeries,
          ),
        ],
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}M',
        interval: 20,
        minimum: 0,
        maximum: 100,
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
      ),
      series: <ColumnSeries<_ProductSalesComparisonData, DateTime>>[
        ColumnSeries<_ProductSalesComparisonData, DateTime>(
          dataSource: _productSalesComparisonData,
          name: 'Sales',
          xValueMapper: (_ProductSalesComparisonData x, int index) => x.year,
          yValueMapper: (_ProductSalesComparisonData sales, int index) =>
              sales.sales,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          spacing: 0.15,
        ),
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<LineSeries<ChartSampleData, String>> _buildLineSeries() {
    final Color seriesColor =
        (isSegment || isLine) &&
            Theme.of(context).brightness == Brightness.light
        ? Colors.black54
        : Colors.white;
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
        dataSource: _weatherReport,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        color: seriesColor,
        name: 'Weather',
        width: 3,
        markerSettings: const MarkerSettings(
          height: 7,
          width: 7,
          isVisible: true,
          color: Color.fromRGBO(192, 108, 132, 1),
        ),
      ),
    ];
  }

  void _onPlotBandModeChange(String item) {
    _selectedType = item;

    if (_selectedType == 'horizontal') {
      isVertical = true;
      isHorizontal = false;
      isSegment = false;
      isLine = false;
      isCustom = false;
    } else if (_selectedType == 'vertical') {
      isHorizontal = true;
      isVertical = false;
      isSegment = false;
      isLine = false;
      isCustom = false;
    } else if (_selectedType == 'segment') {
      isHorizontal = false;
      isVertical = false;
      isSegment = true;
      isLine = false;
      isCustom = false;
    } else if (_selectedType == 'line') {
      isHorizontal = false;
      isVertical = true;
      isSegment = false;
      isLine = true;
      isCustom = false;
    } else if (_selectedType == 'custom') {
      isHorizontal = false;
      isVertical = false;
      isSegment = false;
      isLine = false;
      isCustom = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _plotBandType.clear();
    _weatherReport?.clear();
    _productSalesComparisonData?.clear();
    super.dispose();
  }
}

class _ProductSalesComparisonData {
  _ProductSalesComparisonData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class CustomPlotBand extends PlotBand {
  const CustomPlotBand({
    super.isVisible = true,
    super.start,
    super.end,
    super.associatedAxisStart,
    super.associatedAxisEnd,
    super.color = Colors.white,
    super.gradient,
    super.opacity = 1.0,
    super.borderColor = Colors.transparent,
    super.borderWidth = 0,
    super.dashArray = const <double>[0, 0],
    super.text,
    super.textStyle,
    super.textAngle,
    super.verticalTextPadding,
    super.horizontalTextPadding,
    super.verticalTextAlignment = TextAnchor.middle,
    super.horizontalTextAlignment = TextAnchor.middle,
    super.isRepeatable = false,
    super.repeatEvery = 1,
    super.repeatUntil,
    super.size,
    super.sizeType = DateTimeIntervalType.auto,
    super.shouldRenderAboveSeries = false,
    this.stripeAngle = 0,
    this.stripeWidth = 4.0,
    this.stripeSpacing = 4.0,
    this.patternColor = Colors.green,
    this.stripeOpacity = 1,
    this.dashLength = 8.0,
    this.gapLength = 4.0,
  });

  final int stripeAngle;
  final Color patternColor;
  final double stripeWidth;
  final double stripeSpacing;
  final double stripeOpacity;
  final double dashLength;
  final double gapLength;

  @override
  void drawRect(
    Canvas canvas,
    Rect rect,
    Paint fillPaint, [
    Paint? strokePaint,
  ]) {
    canvas.save();
    canvas.clipRect(rect);

    // Transparent background for custom pattern.
    fillPaint.color = Colors.transparent;
    canvas.drawRect(rect, fillPaint);

    // Draw diagonal dashed pattern.
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.rotate(stripeAngle * math.pi / 180);

    final double diagonal = math.sqrt(
      rect.width * rect.width + rect.height * rect.height,
    );

    final Paint dashPaint = Paint()
      ..color = patternColor.withValues(alpha: stripeOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stripeWidth
      ..strokeCap = StrokeCap.round;

    final double step = stripeWidth + stripeSpacing;

    // Draw dashed lines with gaps.
    for (double x = -diagonal; x < diagonal; x += step) {
      double y = -diagonal;
      while (y < diagonal) {
        // Draw dash segment from (x, y) to (x, dashEnd).
        final double dashEnd = y + dashLength;
        if (dashEnd <= diagonal) {
          canvas.drawLine(Offset(x, y), Offset(x, dashEnd), dashPaint);
          y = dashEnd + gapLength;
        } else {
          // Draw remaining portion.
          canvas.drawLine(Offset(x, y), Offset(x, diagonal), dashPaint);
          break;
        }
      }
    }

    canvas.restore();
  }
}

/// Sample data type used in the series.
class ChartSampleData {
  ChartSampleData({required this.xValue, required this.yValue});
  final String xValue;
  final num yValue;
}
