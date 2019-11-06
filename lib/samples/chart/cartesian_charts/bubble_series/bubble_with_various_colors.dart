import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BubblePointColor extends StatefulWidget {
 const BubblePointColor(this.sample, {Key key}) : super(key: key); 
  final SubItemList sample;

  @override
  _BubblePointColorState createState() => _BubblePointColorState(sample);
}

class _BubblePointColorState extends State<BubblePointColor> {
 _BubblePointColorState(this.sample); 
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
  void didUpdateWidget(BubblePointColor oldWidget) {
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
                toggleFrontLayer: false,
                frontPanelOpenPercentage: 0.28,
                appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                appBarActions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(model.codeViewerIcon,
                            color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/bubble_series/bubble_with_various_colors.dart');
                        },
                      ),
                    ),
                  ),
                ],
                appBarTitle: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
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
            child: Container(child: getPointColorBubbleChart(false)),
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

SfCartesianChart getPointColorBubbleChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Countries by area'),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.rotate45),
    primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(text: isTileView ? '' : 'Area(km²)'),
        axisLine: AxisLine(width: 0),
        minimum: 650000,
        maximum: 1500000,
        rangePadding: ChartRangePadding.additional,
        majorTickLines: MajorTickLines(size: 0)),
    series: getBubbleSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        textAlignment: ChartAlignment.near,
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'Country : point.x\nArea : point.y km²'),
  );
}

List<BubbleSeries<_BubbleColors, String>> getBubbleSeries(bool isTileView) {
  final List<_BubbleColors> chartData = <_BubbleColors>[
    _BubbleColors(
        'Namibia', 825615, 0.37, const Color.fromRGBO(123, 180, 235, 1)),
    _BubbleColors(
        'Angola', 1246700, 0.84, const Color.fromRGBO(53, 124, 210, 1)),
    _BubbleColors(
        'Tanzania', 945087, 0.64, const Color.fromRGBO(221, 138, 189, 1)),
    _BubbleColors(
        'Egypt', 1002450, 0.68, const Color.fromRGBO(248, 184, 131, 1)),
    _BubbleColors(
        'Nigeria', 923768, 0.62, const Color.fromRGBO(112, 173, 71, 1)),
    _BubbleColors('Peru', 1285216, 0.87, const Color.fromRGBO(0, 189, 174, 1)),
    _BubbleColors(
        'Ethiopia', 1104300, 0.74, const Color.fromRGBO(229, 101, 144, 1)),
    _BubbleColors(
        'Venezuela', 916445, 0.62, const Color.fromRGBO(127, 132, 232, 1)),
    _BubbleColors(
        'Niger', 1267000, 0.85, const Color.fromRGBO(160, 81, 149, 1)),
    _BubbleColors(
        'Turkey', 783562, 0.53, const Color.fromRGBO(234, 122, 87, 1)),
  ];
  return <BubbleSeries<_BubbleColors, String>>[
    BubbleSeries<_BubbleColors, String>(
      dataSource: chartData,
      opacity: 0.8,
      xValueMapper: (_BubbleColors sales, _) => sales.text,
      yValueMapper: (_BubbleColors sales, _) => sales.growth,
      pointColorMapper: (_BubbleColors sales, _) => sales.pointColorMapper,
      sizeValueMapper: (_BubbleColors sales, _) => sales.bubbleSize,
    )
  ];
}

class _BubbleColors {
  _BubbleColors(this.text, this.growth,
      [this.bubbleSize, this.pointColorMapper]);
  final String text;
  final num growth;
  final num bubbleSize;
  final Color pointColorMapper;
}
