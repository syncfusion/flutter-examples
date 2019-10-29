import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RangeBarChart extends StatefulWidget {
  const RangeBarChart(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _RangeBarChartState createState() => _RangeBarChartState(sample);
}

class _RangeBarChartState extends State<RangeBarChart> {
  _RangeBarChartState(this.sample);
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
  void didUpdateWidget(RangeBarChart oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/rangecolumn_series/vertical_rangecolumn_chart.dart');
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
                color: model.cardThemeColor,
                titleVisibleOnPanelClosed: true,
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
  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getRangeBarChart(false)),
              ),
              floatingActionButton: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: Container(
                      height: 50,
                      width: 250,
                      child: InkWell(
                        onTap: () => launch(
                            'https://www.holiday-weather.com/sydney/averages/'),
                        child: Row(
                          children: <Widget>[
                            Text('Source: ',
                                style: TextStyle(
                                    fontSize: 16, color: model.textColor)),
                            Text('holiday-weather.com',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]));
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

SfCartesianChart getRangeBarChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title: ChartTitle(
        text: isTileView ? '' : 'Temperature variation – Sydney vs Melbourne'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    legend: Legend(isVisible: !isTileView),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}°F',
        minimum: 40,
        maximum: 80),
    series: getRangeColumnSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
    isTransposed: true,
  );
}

List<RangeColumnSeries<_ChartData, String>> getRangeColumnSeries(
    bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('Jul', 46, 63, 43, 57),
    _ChartData('Aug', 48, 64, 45, 59),
    _ChartData('Sep', 54, 68, 48, 63),
    _ChartData('Oct', 57, 72, 50, 68),
    _ChartData('Nov', 61, 75, 54, 72),
    _ChartData('Dec', 64, 79, 57, 75),
  ];
  return <RangeColumnSeries<_ChartData, String>>[
    RangeColumnSeries<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        lowValueMapper: (_ChartData sales, _) => sales.lowSyd,
        highValueMapper: (_ChartData sales, _) => sales.highSyd,
        name: 'Sydney',
        dataLabelSettings: DataLabelSettings(
            isVisible: !isTileView, labelAlignment: ChartDataLabelAlignment.top)),
    RangeColumnSeries<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        lowValueMapper: (_ChartData sales, _) => sales.lowMel,
        highValueMapper: (_ChartData sales, _) => sales.highMel,
        name: 'Melbourne',
        dataLabelSettings: DataLabelSettings(
            isVisible: !isTileView, labelAlignment: ChartDataLabelAlignment.top))
  ];
}

class _ChartData {
  _ChartData(this.x, this.lowSyd, this.highSyd, this.lowMel, this.highMel);
  final String x;
  final int lowSyd;
  final int highSyd;
  final int lowMel;
  final int highMel;
}
