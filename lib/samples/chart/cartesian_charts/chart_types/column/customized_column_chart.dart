/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders customized Column Chart.
class ColumnVertical extends SampleView {
  const ColumnVertical(Key key) : super(key: key);

  @override
  _ColumnVerticalState createState() => _ColumnVerticalState();
}

class _ColumnVerticalState extends SampleViewState {
  _ColumnVerticalState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'HP Inc',
        y: 12.54,
        pointColor: const Color.fromARGB(53, 92, 125, 1),
      ),
      ChartSampleData(
        x: 'Lenovo',
        y: 13.46,
        pointColor: const Color.fromARGB(192, 108, 132, 1),
      ),
      ChartSampleData(
        x: 'Dell',
        y: 9.18,
        pointColor: const Color.fromARGB(246, 114, 128, 1),
      ),
      ChartSampleData(
        x: 'Apple',
        y: 4.56,
        pointColor: const Color.fromARGB(248, 177, 149, 1),
      ),
      ChartSampleData(
        x: 'Asus',
        y: 5.29,
        pointColor: const Color.fromARGB(116, 180, 155, 1),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView ? '' : 'PC vendor shipments - 2015 Q1',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        title: AxisTitle(text: isCardView ? '' : 'Shipments in million'),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, int index) => sales.x,
          yValueMapper: (ChartSampleData sales, int index) => sales.y,
          pointColorMapper: (ChartSampleData sales, int index) =>
              sales.pointColor,
          width: 0.8,
          onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
            return _CustomColumnSeriesRenderer(model.themeData);
          },
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.middle,
          ),
        ),
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chartData!.clear();
  }
}

class _CustomColumnSeriesRenderer<T, D> extends ColumnSeriesRenderer<T, D> {
  _CustomColumnSeriesRenderer(this.themeData);

  final ThemeData themeData;

  @override
  ColumnSegment<T, D> createSegment() {
    return _ColumnCustomPainter(themeData);
  }
}

class _ColumnCustomPainter<T, D> extends ColumnSegment<T, D> {
  _ColumnCustomPainter(this.themeData);

  final ThemeData themeData;

  List<Color> colorList = <Color>[
    const Color.fromRGBO(53, 92, 125, 1),
    const Color.fromRGBO(192, 108, 132, 1),
    const Color.fromRGBO(246, 114, 128, 1),
    const Color.fromRGBO(248, 177, 149, 1),
    const Color.fromRGBO(116, 180, 155, 1),
  ];
  List<Color> colorListM3Light = const [
    Color.fromRGBO(6, 174, 224, 1),
    Color.fromRGBO(99, 85, 199, 1),
    Color.fromRGBO(49, 90, 116, 1),
    Color.fromRGBO(255, 180, 0, 1),
    Color.fromRGBO(150, 60, 112, 1),
  ];
  List<Color> colorListM3Dark = const [
    Color.fromRGBO(255, 245, 0, 1),
    Color.fromRGBO(51, 182, 119, 1),
    Color.fromRGBO(218, 150, 70, 1),
    Color.fromRGBO(201, 88, 142, 1),
    Color.fromRGBO(77, 170, 255, 1),
  ];

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
    colorList = themeData.useMaterial3
        ? (themeData.brightness == Brightness.light
              ? colorListM3Light
              : colorListM3Dark)
        : colorList;
    customerFillPaint.isAntiAlias = false;
    customerFillPaint.color = colorList[currentSegmentIndex];
    customerFillPaint.style = PaintingStyle.fill;
    return customerFillPaint;
  }

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.isAntiAlias = false;
    customerStrokePaint.color = Colors.transparent;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  void onPaint(Canvas canvas) {
    if (segmentRect != null) {
      double x, y;
      x = segmentRect!.center.dx;
      y = segmentRect!.top;
      double width = 0;
      const double height = 20;
      width = segmentRect!.width;
      final Paint paint = Paint();
      paint.color = getFillPaint().color;
      paint.style = PaintingStyle.fill;
      final Path path = Path();
      final double factor = segmentRect!.height * (1 - animationFactor);
      path.moveTo(x - width / 2, y + factor + height);
      path.lineTo(x, (segmentRect!.top + factor + height) - height);
      path.lineTo(x + width / 2, y + factor + height);
      path.lineTo(x + width / 2, segmentRect!.bottom + factor);
      path.lineTo(x - width / 2, segmentRect!.bottom + factor);
      path.close();
      canvas.drawPath(path, paint);
    }
  }
}
