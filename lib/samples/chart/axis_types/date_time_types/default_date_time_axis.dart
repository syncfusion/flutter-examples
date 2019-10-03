import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DateTimeDefault extends StatefulWidget {
  final SubItemList sample;
  const DateTimeDefault(this.sample, {Key key}) : super(key: key);

  @override
  _DateTimeDefaultState createState() => _DateTimeDefaultState(sample);
}

class _DateTimeDefaultState extends State<DateTimeDefault> {
  final SubItemList sample;
  _DateTimeDefaultState(this.sample);
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
  void didUpdateWidget(DateTimeDefault oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_types/date_time_types/default_date_time_axis.dart');
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
                child: Container(child: getDefaultDateTimeAxisChart(false)),
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
                            'https://www.x-rates.com/graph/?from=USD&to=INR&amount=1'),
                        child: Row(
                          children: <Widget>[
                            Text('Source: ',
                                style: TextStyle(
                                    fontSize: 16, color: model.textColor)),
                            Text('www.x-rates.com',
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

SfCartesianChart getDefaultDateTimeAxisChart(bool isTileView) {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isTileView
              ? ''
              : 'Euro to USD monthly exchange rate - 2015 to 2018'),
      primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        minimum: 1,
        maximum: 1.35,
        interval: 0.05,
        labelFormat: '\${value}',
        title: AxisTitle(text: isTileView ? '' : 'Dollars'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: getLineSeries(isTileView),
      trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings:
              InteractiveTooltip(format: 'point.x : point.y', borderWidth: 0)));
}

List<LineSeries<_DateTimeData, DateTime>> getLineSeries(bool isTileView) {
  final List<_DateTimeData> chartData = <_DateTimeData>[
    _DateTimeData(DateTime(2015, 1, 1), 1.13),
    _DateTimeData(DateTime(2015, 2, 1), 1.12),
    _DateTimeData(DateTime(2015, 3, 1), 1.08),
    _DateTimeData(DateTime(2015, 4, 1), 1.12),
    _DateTimeData(DateTime(2015, 5, 1), 1.1),
    _DateTimeData(DateTime(2015, 6, 1), 1.12),
    _DateTimeData(DateTime(2015, 7, 1), 1.1),
    _DateTimeData(DateTime(2015, 8, 1), 1.12),
    _DateTimeData(DateTime(2015, 9, 1), 1.12),
    _DateTimeData(DateTime(2015, 10, 1), 1.1),
    _DateTimeData(DateTime(2015, 11, 1), 1.06),
    _DateTimeData(DateTime(2015, 12, 1), 1.09),
    _DateTimeData(DateTime(2016, 1, 1), 1.09),
    _DateTimeData(DateTime(2016, 2, 1), 1.09),
    _DateTimeData(DateTime(2016, 3, 1), 1.14),
    _DateTimeData(DateTime(2016, 4, 1), 1.14),
    _DateTimeData(DateTime(2016, 5, 1), 1.12),
    _DateTimeData(DateTime(2016, 6, 1), 1.11),
    _DateTimeData(DateTime(2016, 7, 1), 1.11),
    _DateTimeData(DateTime(2016, 8, 1), 1.11),
    _DateTimeData(DateTime(2016, 9, 1), 1.12),
    _DateTimeData(DateTime(2016, 10, 1), 1.1),
    _DateTimeData(DateTime(2016, 11, 1), 1.08),
    _DateTimeData(
        DateTime(
          2016,
          12,
        ),
        1.05),
    _DateTimeData(DateTime(2017, 1, 1), 1.08),
    _DateTimeData(DateTime(2017, 2, 1), 1.06),
    _DateTimeData(DateTime(2017, 3, 1), 1.07),
    _DateTimeData(DateTime(2017, 4, 1), 1.09),
    _DateTimeData(DateTime(2017, 5, 1), 1.12),
    _DateTimeData(DateTime(2017, 6, 1), 1.14),
    _DateTimeData(DateTime(2017, 7, 1), 1.17),
    _DateTimeData(DateTime(2017, 8, 1), 1.18),
    _DateTimeData(DateTime(2017, 9, 1), 1.18),
    _DateTimeData(DateTime(2017, 10, 1), 1.16),
    _DateTimeData(DateTime(2017, 11, 1), 1.18),
    _DateTimeData(DateTime(2017, 12, 1), 1.2),
    _DateTimeData(DateTime(2018, 1, 1), 1.25),
    _DateTimeData(DateTime(2018, 2, 1), 1.22),
    _DateTimeData(DateTime(2018, 3, 1), 1.23),
    _DateTimeData(DateTime(2018, 4, 1), 1.21),
    _DateTimeData(DateTime(2018, 5, 1), 1.17),
    _DateTimeData(DateTime(2018, 6, 1), 1.17),
    _DateTimeData(DateTime(2018, 7, 1), 1.17),
    _DateTimeData(DateTime(2018, 8, 1), 1.17),
    _DateTimeData(DateTime(2018, 9, 1), 1.16),
    _DateTimeData(DateTime(2018, 10, 1), 1.13),
    _DateTimeData(DateTime(2018, 11, 1), 1.14),
    _DateTimeData(DateTime(2018, 12, 1), 1.15)
  ];
  return <LineSeries<_DateTimeData, DateTime>>[
    LineSeries<_DateTimeData, DateTime>(
      dataSource: chartData,
      xValueMapper: (_DateTimeData data, _) => data.year,
      yValueMapper: (_DateTimeData data, _) => data.y,
      color: Color.fromRGBO(242, 117, 7, 1),
    )
  ];
}

class _DateTimeData {
  _DateTimeData(this.year, this.y);
  final DateTime year;
  final double y;
}
