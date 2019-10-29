import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DoughnutCustomization extends StatefulWidget {
  const DoughnutCustomization(this.sample, {Key key}) : super(key: key);  
  final SubItemList sample;

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState(sample);
}

class _DoughnutDefaultState extends State<DoughnutCustomization> {
  _DoughnutDefaultState(this.sample);
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
  void didUpdateWidget(DoughnutCustomization oldWidget) {
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
                toggleFrontLayer: false,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/circular_charts/doughnut_series/doughnut_with_color_mapping.dart');
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
            child: Container(child: getDoughnutCustomizationChart(false)),
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

SfCircularChart getDoughnutCustomizationChart(bool isTileView) {
  return SfCircularChart(
    annotations: <CircularChartAnnotation>[
      CircularChartAnnotation(
          widget: Container(
              child: Text('90%',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 25))))
    ],
    title: ChartTitle(
        text: isTileView ? '' : 'Work progress',
        textStyle: ChartTextStyle(fontSize: 20)),
    series: getDoughnutSeries(isTileView),
  );
}

List<DoughnutSeries<_ChartData, String>> getDoughnutSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('A', 10, const Color.fromRGBO(255, 4, 0, 1)),
    _ChartData('B', 10, const Color.fromRGBO(255, 15, 0, 1)),
    _ChartData('C', 10, const Color.fromRGBO(255, 31, 0, 1)),
    _ChartData('D', 10, const Color.fromRGBO(255, 60, 0, 1)),
    _ChartData('E', 10, const Color.fromRGBO(255, 90, 0, 1)),
    _ChartData('F', 10, const Color.fromRGBO(255, 115, 0, 1)),
    _ChartData('G', 10, const Color.fromRGBO(255, 135, 0, 1)),
    _ChartData('H', 10, const Color.fromRGBO(255, 155, 0, 1)),
    _ChartData('I', 10, const Color.fromRGBO(255, 175, 0, 1)),
    _ChartData('J', 10, const Color.fromRGBO(255, 188, 0, 1)),
    _ChartData('K', 10, const Color.fromRGBO(255, 188, 0, 1)),
    _ChartData('L', 10, const Color.fromRGBO(251, 188, 2, 1)),
    _ChartData('M', 10, const Color.fromRGBO(245, 188, 6, 1)),
    _ChartData('N', 10, const Color.fromRGBO(233, 188, 12, 1)),
    _ChartData('O', 10, const Color.fromRGBO(220, 187, 19, 1)),
    _ChartData('P', 10, const Color.fromRGBO(208, 187, 26, 1)),
    _ChartData('Q', 10, const Color.fromRGBO(193, 187, 34, 1)),
    _ChartData('R', 10, const Color.fromRGBO(177, 186, 43, 1)),
    _ChartData('S', 10, const Color.fromRGBO(230, 230, 230, 1)),
    _ChartData('T', 10, const Color.fromRGBO(230, 230, 230, 1))
  ];
  return <DoughnutSeries<_ChartData, String>>[
    DoughnutSeries<_ChartData, String>(
      dataSource: chartData,
      radius: '100%',
      strokeColor: Colors.white,
      strokeWidth: 2,
      xValueMapper: (_ChartData data, _) => data.xVal,
      yValueMapper: (_ChartData data, _) => data.yVal,
      pointColorMapper: (_ChartData data, _) => data.color,
      dataLabelMapper: (_ChartData data, _) => data.xVal,
    ),
  ];
}

class _ChartData {
  _ChartData(this.xVal, this.yVal, [this.color]);
  final String xVal;
  final int yVal;
  final Color color;
}
