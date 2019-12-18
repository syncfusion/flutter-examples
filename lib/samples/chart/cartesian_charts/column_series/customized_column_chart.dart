import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class ColumnVertical extends StatefulWidget {
  ColumnVertical({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ColumnVerticalState createState() => _ColumnVerticalState(sample);
}

class _ColumnVerticalState extends State<ColumnVertical> {
  _ColumnVerticalState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink = 'https://www.statista.com/statistics/263393/global-pc-shipments-since-1st-quarter-2009-by-vendor/';
    const String source = 'www.statista.com';
    return getScopedModel(getCustomizedColumnChart(false),sample,null, sourceLink,source);
  }
}

SfCartesianChart getCustomizedColumnChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'PC vendor shipments - 2015 Q1'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        title: AxisTitle(text: isTileView ? '' : 'Shipments in million'),
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getCustomizedColumnSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<CustomColumnSeries<ChartSampleData, String>> getCustomizedColumnSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x:'HP Inc', y:12.54, pointColor:const Color.fromARGB(53, 92, 125, 1)),
    ChartSampleData(x:'Lenovo', y:13.46, pointColor:const Color.fromARGB(192, 108, 132, 1)),
    ChartSampleData(x:'Dell', y:9.18, pointColor:const Color.fromARGB(246, 114, 128, 1)),
    ChartSampleData(x:'Apple', y:4.56, pointColor:const Color.fromARGB(248, 177, 149, 1)),
    ChartSampleData(x:'Asus', y:5.29, pointColor:const Color.fromARGB(116, 180, 155, 1)),
  ];
  return <CustomColumnSeries<ChartSampleData, String>>[
    CustomColumnSeries<ChartSampleData, String>(
      enableTooltip: true,
      isTrackVisible: false,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, labelAlignment: ChartDataLabelAlignment.middle),
      dataSource: chartData,
      width: 0.8,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
    )
  ];
}

class CustomColumnSeries<T, D> extends ColumnSeries<T, D> {
  CustomColumnSeries({
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> yValueMapper,
    @required ChartValueMapper<T, Color> pointColorMapper,
    String xAxisName,
    String yAxisName,
    Color color,
    double width,
    MarkerSettings markerSettings,
    EmptyPointSettings emptyPointSettings,
    DataLabelSettings dataLabelSettings,
    bool visible,
    bool enableTooltip,
    double animationDuration,
    Color trackColor,
    Color trackBorderColor,
    bool isTrackVisible,
  }) : super(
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            pointColorMapper: pointColorMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            isTrackVisible: isTrackVisible,
            trackColor: trackColor,
            trackBorderColor: trackBorderColor,
            width: width,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: visible,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration);

  @override
  ChartSegment createSegment() {
    return ColumnCustomPainter();
  }
}

class ColumnCustomPainter extends ColumnSegment {
  List<Color> colorList = <Color>[
    const Color.fromRGBO(53, 92, 125, 1),
    const Color.fromRGBO(192, 108, 132, 1),
    const Color.fromRGBO(246, 114, 128, 1),
    const Color.fromRGBO(248, 177, 149, 1),
    const Color.fromRGBO(116, 180, 155, 1)
  ];
  @override
  int get currentSegmentIndex => super.currentSegmentIndex;

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
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
    double x, y;
    x = segmentRect.center.dx;
    y = segmentRect.top;
    double width = 0;
    const double height = 20;
    width = segmentRect.width;
    final Paint paint = Paint();
    paint.color = getFillPaint().color;
    paint.style = PaintingStyle.fill;
    final Path path = Path();
    final dynamic factor = segmentRect.height * (1 - animationFactor);
    path.moveTo(x - width / 2, y + factor + height);
    path.lineTo(x, (segmentRect.top + factor + height) - height);
    path.lineTo(x + width / 2, y + factor + height);
    path.lineTo(x + width / 2, segmentRect.bottom + factor);
    path.lineTo(x - width / 2, segmentRect.bottom + factor);
    path.close();
    canvas.drawPath(path, paint);
  }
}

