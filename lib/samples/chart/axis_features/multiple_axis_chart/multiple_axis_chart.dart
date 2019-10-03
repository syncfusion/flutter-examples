import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MultipleAxis extends StatefulWidget {
  final SubItemList sample;
  const MultipleAxis(this.sample, {Key key}) : super(key: key);

  @override
  _MultipleAxisState createState() => _MultipleAxisState(sample);
}

class _MultipleAxisState extends State<MultipleAxis> {
  final SubItemList sample;
  _MultipleAxisState(this.sample);
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
  void didUpdateWidget(MultipleAxis oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_features/multiple_axis_chart/multiple_axis_chart.dart');
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
             backgroundColor:model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: getMultipleAxisLineChart(false)),
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
                            'https://www.accuweather.com/en/us/new-york-ny/10007/month/349727?monyr=5/01/2019'),
                        child: Row(
                          children: <Widget>[
                            Text('Source: ',
                                style: TextStyle(
                                    fontSize: 16, color: model.textColor)),
                            Text('www.accuweather.com',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ])
          );
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

SfCartesianChart getMultipleAxisLineChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(
        text: isTileView ? '' : 'Washington vs New York temperature'),
    legend: Legend(isVisible: isTileView ? false : true),
    axes: <ChartAxis>[
      NumericAxis(
          opposedPosition: true,
          name: 'yAxis1',
          majorGridLines: MajorGridLines(width: 0),
          labelFormat: '{value}°F',
          minimum: 40,
          maximum: 100,
          interval: 10)
    ],
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        title: AxisTitle(textStyle: ChartTextStyle(color: Colors.black))),
    primaryYAxis: NumericAxis(
      majorGridLines: MajorGridLines(width: 0),
      opposedPosition: false,
      minimum: 0,
      maximum: 50,
      interval: 10,
      labelFormat: '{value}°C',
    ),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

class _MultipleAxesData {
  _MultipleAxesData(this.x, this.y, this.y2);
  final DateTime x;
  final double y;
  final double y2;
}

List<ChartSeries<_MultipleAxesData, DateTime>> getLineSeries(bool isTileView) {
  final List<_MultipleAxesData> chartData = <_MultipleAxesData>[
    _MultipleAxesData(DateTime(2019, 5, 1), 13, 69.8),
    _MultipleAxesData(DateTime(2019, 5, 2), 26, 87.8),
    _MultipleAxesData(DateTime(2019, 5, 3), 13, 78.8),
    _MultipleAxesData(DateTime(2019, 5, 4), 22, 75.2),
    _MultipleAxesData(DateTime(2019, 5, 5), 14, 68),
    _MultipleAxesData(DateTime(2019, 5, 6), 23, 78.8),
    _MultipleAxesData(DateTime(2019, 5, 7), 21, 80.6),
    _MultipleAxesData(DateTime(2019, 5, 8), 22, 73.4),
    _MultipleAxesData(DateTime(2019, 5, 9), 16, 78.8),
  ];
  return <ChartSeries<_MultipleAxesData, DateTime>>[
    ColumnSeries<_MultipleAxesData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_MultipleAxesData sales, _) => sales.x,
        yValueMapper: (_MultipleAxesData sales, _) => sales.y,
        name: 'New York'),
    LineSeries<_MultipleAxesData, DateTime>(
        dataSource: chartData,
        yAxisName: 'yAxis1',
        xValueMapper: (_MultipleAxesData sales, _) => sales.x,
        yValueMapper: (_MultipleAxesData sales, _) => sales.y2,
        name: 'Washington')
  ];
}
