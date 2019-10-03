import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NumericOpposed extends StatefulWidget {
  final SubItemList sample;
  const NumericOpposed(this.sample, {Key key}) : super(key: key);

  @override
  _NumericOpposedState createState() => _NumericOpposedState(sample);
}

class _NumericOpposedState extends State<NumericOpposed> {
  final SubItemList sample;
  _NumericOpposedState(this.sample);
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
  void didUpdateWidget(NumericOpposed oldWidget) {
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
                toggleFrontLayer: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_features/opposed_axes/opposed_axes.dart');
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
                color:model.cardThemeColor,
                titleVisibleOnPanelClosed: true,
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
  bool enableTooltip = false;
  bool enableMarker = false;
  bool enableDatalabel = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
             backgroundColor:model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getOpposedNumericAxisChart(false)),
              ),
              floatingActionButton: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: Container(
                      height: 50,
                      width: 200,
                      child: InkWell(
                        onTap: () => launch(
                            'https://www.statista.com/statistics/199983/us-vehicle-sales-since-1951/'),
                        child: Row(
                          children: <Widget>[
                            Text('Source: ',
                                style: TextStyle(
                                    fontSize: 16, color: model.textColor)),
                            Text('www.statista.com',
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

SfCartesianChart getOpposedNumericAxisChart(bool isTileView) {
  return SfCartesianChart(
    title:
        ChartTitle(text: isTileView ? '' : 'Light vehicle retail sales in US'),
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
        minimum: 1974,
        maximum: 2022,
        majorGridLines: MajorGridLines(width: 0),
        opposedPosition: true,
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Sales in thousands'),
        opposedPosition: true,
        numberFormat: NumberFormat.decimalPattern(),
        minimum: 8000,
        interval: 2000,
        maximum: 20000,
        majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ColumnSeries<_ChartNumeric, num>> getLineSeries(bool isTileView) {
  final List<_ChartNumeric> chartData = <_ChartNumeric>[
    _ChartNumeric(1978, 14981),
    _ChartNumeric(1983, 12107.1),
    _ChartNumeric(1988, 15443.2),
    _ChartNumeric(1993, 13882.7),
    _ChartNumeric(1998, 15543),
    _ChartNumeric(2003, 16639.1),
    _ChartNumeric(2008, 13198.8),
    _ChartNumeric(2013, 15530.1),
    _ChartNumeric(2018, 17213.5),
  ];
  return <ColumnSeries<_ChartNumeric, num>>[
    ColumnSeries<_ChartNumeric, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (_ChartNumeric sales, _) => sales.x,
      yValueMapper: (_ChartNumeric sales, _) => sales.y,
    )
  ];
}

class _ChartNumeric {
  _ChartNumeric(this.x, this.y);
  final double x;
  final double y;
}
