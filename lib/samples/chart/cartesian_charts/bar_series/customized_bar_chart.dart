import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BarCustomization extends StatefulWidget {
  const BarCustomization(this.sample, {Key key}) : super(key: key); 
  final SubItemList sample;

  @override
  _BarCustomizationState createState() => _BarCustomizationState(sample);
}

ui.Image image;
bool isImageloaded = false;

List<num> values;

class _BarCustomizationState extends State<BarCustomization> {
  _BarCustomizationState(this.sample);
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
  void didUpdateWidget(BarCustomization oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (BuildContext context, _, SampleListModel model) => SafeArea(
              child: Backdrop(
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart');
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(model.informationIcon,
                            color: Colors.white),
                        onPressed: () {
                          if (frontPanelVisible.value)
                            frontPanelVisible.value = false;
                          else
                            frontPanelVisible.value = true;
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
  void initState() {
    super.initState();
  }

  final SubItemList sample;
  

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: getCustomizedBarChart(false)),
            ),
            floatingActionButton: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Container(
                  height: 50,
                  width: 250,
                  child: InkWell(
                    onTap: () => launch(
                        'https://www.makeuseof.com/tag/most-popular-android-apps/'),
                    child: Row(
                      children: <Widget>[
                        Text('Source: ',
                            style: TextStyle(
                                fontSize: 16, color: model.textColor)),
                        Text('www.makeuseof.com',
                            style: TextStyle(fontSize: 14, color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
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

SfCartesianChart getCustomizedBarChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(
        text:
            isTileView ? '' : 'Popular Android apps in the Google play store'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Downloads in Billion'),
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getVerticalData(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<CustomBarSeries<_ChartData, String>> getVerticalData(bool isTileView) {
  final dynamic chartData = <_ChartData>[
    _ChartData('Facebook', 4.119, Colors.redAccent),
    _ChartData('FB Messenger', 3.408, Colors.indigo),
    _ChartData('WhatsApp', 2.979, Colors.grey),
    _ChartData('Instagram', 1.843, Colors.orange),
    _ChartData('Skype', 1.039, Colors.green),
    _ChartData('Subway Surfers', 1.025, Colors.yellow),
  ];
  return <CustomBarSeries<_ChartData, String>>[
    CustomBarSeries<_ChartData, String>(
      enableTooltip: true,
      isTrackVisible: false,
      dataLabelSettings: DataLabelSettings(isVisible: true),
      dataSource: chartData,
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y,
    )
  ];
}

class CustomBarSeries<T, D> extends BarSeries<T, D> {
  CustomBarSeries({
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> yValueMapper,
    ChartValueMapper<T, Color> pointColorMapper,
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
    return CustomPainter();
  }
}

class CustomPainter extends BarSegment {
  List<num> values = <num>[];

  @override
  void onPaint(Canvas canvas) {
    final Float64List deviceTransform = Float64List(16)
      ..[0] = 0.05
      ..[5] = 0.05
      ..[10] = 1.0
      ..[15] = 2.0;

    final Paint linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 40
      ..shader = ImageShader(
          image, TileMode.repeated, TileMode.repeated, deviceTransform);

    final double devicePixelRatio = ui.window.devicePixelRatio;

    if (isImageloaded && devicePixelRatio > 0) {
      super.onPaint(canvas);
      final Rect rect = Rect.fromLTRB(segmentRect.left, segmentRect.top,
          segmentRect.right * animationFactor, segmentRect.bottom);
      canvas.drawRect(rect, linePaint);
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.colors);
  final String x;
  final double y;
  final Color colors;
}
