import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnotationWatermark extends StatefulWidget {
  const AnnotationWatermark(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _AnnotationWatermarkState createState() => _AnnotationWatermarkState(sample);
}

class _AnnotationWatermarkState extends State<AnnotationWatermark> {
  _AnnotationWatermarkState(this.sample);
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
  void didUpdateWidget(AnnotationWatermark oldWidget) {
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
                        icon:
                            Image.asset('images/code.png', color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/series_features/annotation/chart_with_annotation.dart');
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
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
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
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItemList subItemList;
  
  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample);
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
              child: Container(child: getWatermarkAnnotationChart(false)),
            ),
          );
        });
  }
}

class BackPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
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

SfCartesianChart getWatermarkAnnotationChart(bool isTileView) {
  return SfCartesianChart(
      title: ChartTitle(
          text: isTileView ? '' : 'UK social media reach, by platform'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          isVisible: false,
          labelFormat: '{value}%',
          minimum: 0,
          maximum: 120,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0)),
      series: getLineSeries(isTileView),
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
            widget: Container(
                height: isTileView ? 100 : 150,
                width: isTileView ? 100 : 150,
                child: SfCircularChart(
                  series: <PieSeries<_ChartData, String>>[
                    PieSeries<_ChartData, String>(
                        radius: '90%',
                        enableSmartLabels: false,
                        dataSource: <_ChartData>[
                          _ChartData('Facebook', 90, '90%',
                              const Color.fromRGBO(0, 63, 92, 1)),
                          _ChartData('Twitter', 60, '60%',
                              const Color.fromRGBO(242, 117, 7, 1)),
                          _ChartData('Instagram', 51, '51%',
                              const Color.fromRGBO(89, 59, 84, 1)),
                          _ChartData('Snapchat', 50, '50%',
                              const Color.fromRGBO(217, 67, 80, 1)),
                        ],
                        dataLabelMapper: (_ChartData data, _) => data.text,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelIntersectAction: LabelIntersectAction.none,
                            textStyle: ChartTextStyle(
                                color: Colors.white,
                                fontSize: isTileView ? 10 : 12)),
                        pointColorMapper: (_ChartData data, _) => data.color)
                  ],
                )),
            coordinateUnit: CoordinateUnit.point,
            region: AnnotationRegion.chart,
            x: 'Instagram',
            y: isTileView ? 85 : 80)
      ]);
}

List<ColumnSeries<_ChartData, String>> getLineSeries(bool isTileView) {
  final dynamic chartData = <_ChartData>[
    _ChartData('Facebook', 90, '90', const Color.fromRGBO(0, 63, 92, 1)),
    _ChartData('Twitter', 60, '60', const Color.fromRGBO(242, 117, 7, 1)),
    _ChartData('Instagram', 51, '51', const Color.fromRGBO(89, 59, 84, 1)),
    _ChartData('Snapchat', 50, '50', const Color.fromRGBO(217, 67, 80, 1)),
  ];
  return <ColumnSeries<_ChartData, String>>[
    ColumnSeries<_ChartData, String>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        pointColorMapper: (_ChartData sales, _) => sales.color,
        width: 0.8,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: ChartTextStyle(
                color: Colors.white, fontSize: isTileView ? 10 : 12),
            labelAlignment: ChartDataLabelAlignment.top)),
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.text, this.color);
  final String x;
  final double y;
  final String text;
  final Color color;
}
