import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BubbleDefault extends StatefulWidget {
  final SubItemList sample;
  const BubbleDefault(this.sample, {Key key}) : super(key: key);

  @override
  _BubbleDefaultState createState() => _BubbleDefaultState(sample);
}

class _BubbleDefaultState extends State<BubbleDefault> {
  final SubItemList sample;

  _BubbleDefaultState(this.sample);

  bool panelOpen;
  final frontPanelVisible = ValueNotifier<bool>(true);

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
  void didUpdateWidget(BubbleDefault oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (context, _, model) => SafeArea(
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/bubble_series/default_bubble_chart.dart');
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
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
  final SubItemList subItemList;
  FrontPanel(this.subItemList);

  @override
  _FrontPanelState createState() => _FrontPanelState(this.subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  final SubItemList sample;
  _FrontPanelState(this.sample);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Container(child: getDefaultBubbleChart(false)),
          ));
        });
  }
}

class BackPanel extends StatefulWidget {
  final SubItemList sample;

  BackPanel(this.sample);

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  final SubItemList sample;
  GlobalKey _globalKey = GlobalKey();
  _BackPanelState(this.sample);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizesAndPosition();
  }

  _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    final position = renderBoxRed.localToGlobal(Offset.zero);
    double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (context, _, model) {
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

SfCartesianChart getDefaultBubbleChart(bool isTileView) {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isTileView ? '' : 'World countries details'),
      primaryXAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          title: AxisTitle(text: isTileView ? '' : 'Literacy rate'),
          minimum: 60,
          maximum: 100),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          title: AxisTitle(text: isTileView ? '' : 'GDP growth rate')),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          textAlignment: ChartAlignment.near,
          header: '',
          canShowMarker: false,
          format:
              'point.x\nLiteracy rate : point.x%\nGDP growth rate : point.y\nPopulation : point.sizeB'),
      series: getBubbleSeries(isTileView));
}

List<BubbleSeries<_BubbleData, num>> getBubbleSeries(bool isTileView) {
  final List<_BubbleData> bubbleData = <_BubbleData>[
    _BubbleData('China', 92.2, 7.8, 1.347),
    _BubbleData('India', 74, 6.5, 1.241),
    _BubbleData('Indonesia', 90.4, 6.0, 0.238),
    _BubbleData('US', 99.4, 2.2, 0.312),
    _BubbleData('Germany', 99, 0.7, 0.0818),
    _BubbleData('Egypt', 72, 2.0, 0.0826),
    _BubbleData('Russia', 99.6, 3.4, 0.143),
    _BubbleData('Japan', 99, 0.2, 0.128),
    _BubbleData('Mexico', 86.1, 4.0, 0.115),
    _BubbleData('Philippines', 92.6, 6.6, 0.096),
    _BubbleData('Nigeria', 61.3, 1.45, 0.162),
    _BubbleData('Hong Kong', 82.2, 3.97, 0.7),
    _BubbleData('Netherland', 79.2, 3.9, 0.162),
    _BubbleData('Jordan', 72.5, 4.5, 0.7),
    _BubbleData('Australia', 81, 3.5, 0.21),
    _BubbleData('Mongolia', 66.8, 3.9, 0.028),
    _BubbleData('Taiwan', 78.4, 2.9, 0.231),
  ];
  return <BubbleSeries<_BubbleData, num>>[
    BubbleSeries<_BubbleData, num>(
      enableTooltip: true,
      opacity: 0.7,
      dataSource: bubbleData,
      xValueMapper: (_BubbleData sales, _) => sales.x,
      yValueMapper: (_BubbleData sales, _) => sales.y,
      sizeValueMapper: (_BubbleData sales, _) => sales.size,
    )
  ];
}

class _BubbleData {
  _BubbleData(this.text, this.x, [this.y, this.size]);
  final String text;
  final double x;
  final double y;
  final double size;
}
