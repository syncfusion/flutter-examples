import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DateTimeLabel extends StatefulWidget {
  final SubItemList sample;
  const DateTimeLabel(this.sample, {Key key}) : super(key: key);

  @override
  _DateTimeLabelState createState() => _DateTimeLabelState(sample);
}

class _DateTimeLabelState extends State<DateTimeLabel> {
  final SubItemList sample;
  _DateTimeLabelState(this.sample);
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
  void didUpdateWidget(DateTimeLabel oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_types/date_time_types/date_time_axis_with_label_format.dart');
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
                child: Container(child: getLabelDateTimeAxisChart(false)),
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
                            'https://en.wikipedia.org/wiki/List_of_earthquakes_in_Indonesia'),
                        child: Row(
                          children: <Widget>[
                            Text('Source: ',
                                style: TextStyle(
                                    fontSize: 16, color: model.textColor)),
                            Text('en.wikipedia.org',
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

SfCartesianChart getLabelDateTimeAxisChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Earthquakes in Indonesia'),
    primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.months,
        majorGridLines: MajorGridLines(width: 0),
        interval: 2,
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        dateFormat: DateFormat.yMd()),
    primaryYAxis: NumericAxis(
      axisLine: AxisLine(width: 0),
      majorTickLines: MajorTickLines(size: 0),
      minimum: 4,
      maximum: 8,
      title: AxisTitle(text: isTileView ? '' : 'Magnitude (Mw)'),
    ),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y Mw',
        header: '',
        canShowMarker: false),
  );
}

List<ScatterSeries<_DateTimeData, DateTime>> getLineSeries(bool isTileView) {
  final List<_DateTimeData> chartData = <_DateTimeData>[
    _DateTimeData(DateTime(2019, 4, 12), 6.8),
    _DateTimeData(DateTime(2019, 03, 17), 5.5),
    _DateTimeData(DateTime(2018, 11, 14), 5.6),
    _DateTimeData(DateTime(2018, 10, 10), 6.0),
    _DateTimeData(DateTime(2018, 09, 28), 7.5),
    _DateTimeData(DateTime(2018, 08, 19), 6.9),
    _DateTimeData(DateTime(2018, 08, 19), 6.3),
    _DateTimeData(DateTime(2018, 08, 09), 5.9),
    _DateTimeData(DateTime(2018, 08, 05), 6.9),
    _DateTimeData(DateTime(2018, 07, 29), 6.4),
    _DateTimeData(DateTime(2018, 07, 21), 5.2),
    _DateTimeData(DateTime(2018, 04, 18), 4.5),
    _DateTimeData(DateTime(2018, 01, 23), 6.0),
    _DateTimeData(DateTime(2017, 12, 15), 6.5),
    _DateTimeData(DateTime(2017, 10, 31), 6.3)
  ];
  return <ScatterSeries<_DateTimeData, DateTime>>[
    ScatterSeries<_DateTimeData, DateTime>(
        enableTooltip: true,
        opacity: 0.8,
        markerSettings: MarkerSettings(height: 15, width: 15),
        dataSource: chartData,
        xValueMapper: (_DateTimeData data, _) => data.year,
        yValueMapper: (_DateTimeData data, _) => data.y,
        color: Color.fromRGBO(232, 84, 84, 1))
  ];
}

class _DateTimeData {
  _DateTimeData(this.year, this.y);
  final DateTime year;
  final double y;
}
