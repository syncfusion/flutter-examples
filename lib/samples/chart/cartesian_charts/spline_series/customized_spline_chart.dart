import 'dart:math';
import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SplineCustomization extends StatefulWidget {
  const SplineCustomization(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _SplineVerticalState createState() => _SplineVerticalState(sample);
}

class _SplineVerticalState extends State<SplineCustomization> {
  _SplineVerticalState(this.sample);
  final SubItemList sample;

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(SplineCustomization oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _, SampleListModel model) => SafeArea(
              child: Backdrop(
                frontHeaderHeight: 20,
                toggleFrontLayer: false,
                needCloseButton: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
                frontPanelOpenPercentage: 0.28,
                appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                appBarActions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(model.codeViewerIcon,
                            color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/spline_series/customized_spline_chart.dart');
                        },
                      ),
                    ),
                  ),
                ],
                appBarTitle: AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: Text(sample.title.toString())),
                backLayer: BackPanel(sample),
                frontLayer: FrontPanel(sample),
                sideDrawer: null,
                //frontHeader: model.panelTitle(context),
                headerClosingHeight: 350,
                titleVisibleOnPanelClosed: true,
                color: model.cardThemeColor,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
//ignore:prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItemList subItemList;

  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample);
  final SubItemList sample;
  bool enableLegend = true;
  double animaionDuration = 1500;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Container(child: getCustomizedSplineChart(false)),
          ));
        });
  }
}

class BackPanel extends StatefulWidget {
//ignore:prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItemList sample;

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItemList sample;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(dynamic _) {
    _getSizesAndPosition();
  }

  void _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final Size size = renderBoxRed.size;
    final Offset position = renderBoxRed.localToGlobal(Offset.zero);
    const double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleListModel model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

SfCartesianChart getCustomizedSplineChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Product sales prediction'),
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 1.2,
        maximum: 2.4,
        interval: 0.2),
    series: getSplineCustomizedSeries(isTileView),
  );
}

List<CustomSplineSeries<_ChartData, num>> getSplineCustomizedSeries(
    bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(2016, 2),
    _ChartData(2017, 1.5),
    _ChartData(2018, 2),
    _ChartData(2019, 1.75),
    _ChartData(2020, 1.5),
    _ChartData(2021, 2),
    _ChartData(2022, 1.5),
    _ChartData(2023, 2.2),
    _ChartData(2024, 1.9),
  ];
  return <CustomSplineSeries<_ChartData, num>>[
    CustomSplineSeries<_ChartData, num>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        dashArray: <double>[10, 5]),
  ];
}

class CustomSplineSeries<T, D> extends SplineSeries<T, D> {
  CustomSplineSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      double width,
      MarkerSettings marker,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabel,
      bool visible,
      bool enableToolTip,
      List<double> dashArray,
      double animationDuration})
      : super(
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width,
            markerSettings: marker,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabel,
            isVisible: visible,
            enableTooltip: enableToolTip,
            dashArray: dashArray,
            animationDuration: animationDuration);

  static Random randomNumber = Random();

  @override
  ChartSegment createSegment() {
    return SplineCustomPainter(randomNumber.nextInt(4));
  }
}

List<num> yValues;
List<num> xValues;

class SplineCustomPainter extends SplineSegment {
  SplineCustomPainter(int value) {
    //ignore: prefer_initializing_formals
    index = value;
    yValues = <num>[];
    xValues = <num>[];
  }

  double maximum, minimum;

  int index;

  List<Color> colors = <Color>[
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan
  ];

  @override
  int get currentSegmentIndex => super.currentSegmentIndex;

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.color = currentSegmentIndex < 4
       ? const Color.fromRGBO(0, 168, 181, 1)
        :const Color.fromRGBO(246, 114, 128, 1);
    customerStrokePaint.strokeWidth = 2;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
    customerFillPaint.color = Colors.amber;
    customerFillPaint.style = PaintingStyle.fill;
    return customerFillPaint;
  }

  @override
  void onPaint(Canvas canvas) {
    final double x1 = this.x1, y1 = this.y1, x2 = this.x2, y2 = this.y2;
    yValues.add(y1);
    yValues.add(y2);
    xValues.add(x1);
    xValues.add(x2);
    final Path path = Path();
    path.moveTo(x1, y1);
    path.cubicTo(
        startControlX, startControlY, endControlX, endControlY, x2, y2);
    currentSegmentIndex < 4
        ? canvas.drawPath(path, getStrokePaint())
        : drawDashedLine(canvas, series, strokePaint, path, true);

    if (currentSegmentIndex == series.segments.length - 1) {
      double maximum;
      maximum = yValues.reduce(max);
      const TextSpan span =  TextSpan(
        style: TextStyle(
            color: Color.fromRGBO(0, 168, 181, 1),
            fontSize: 12.0,
            fontFamily: 'Roboto'),
        text: 'Original data',
      );
      final TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(xValues[1], maximum + tp.size.height));
      const TextSpan span1 = TextSpan(
        style: TextStyle(
            color:  Color.fromRGBO(246, 114, 128, 1),
            fontSize: 12.0,
            fontFamily: 'Roboto'),
        text: 'Imaginary data',
      );
      final TextPainter tp1 =
          TextPainter(text: span1, textDirection: TextDirection.ltr);
      tp1.layout();
      tp1.paint(canvas, Offset(xValues[10], maximum + tp.size.height));
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final double x;
  final double y;
}

void drawDashedLine(Canvas canvas, CartesianSeries<dynamic, dynamic> series,
    Paint paint, Path path, bool isSeries,
    [List<Path> pathList, List<Color> colorList]) {
  bool even = false;
  for (int i = 1; i < series.dashArray.length; i = i + 2) {
    if (series.dashArray[i] == 0) {
      even = true;
    }
  }
  if (even == false) {
    paint.isAntiAlias = true;
    canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(
              isSeries ? series.dashArray : <double>[12, 3, 3, 3]),
        ),
        paint);
  } else
    canvas.drawPath(path, paint);
}

Path dashPath(
  Path source, {
  @required CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

class CircularIntervalList<T> {
  CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
