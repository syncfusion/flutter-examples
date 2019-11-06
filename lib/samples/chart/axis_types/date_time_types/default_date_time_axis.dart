import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DateTimeDefault extends StatefulWidget {
  const DateTimeDefault(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _DateTimeDefaultState createState() => _DateTimeDefaultState(sample);
}

class _DateTimeDefaultState extends State<DateTimeDefault> {
  _DateTimeDefaultState(this.sample);
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
  void didUpdateWidget(DateTimeDefault oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_types/date_time_types/default_date_time_axis.dart');
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
      color: const Color.fromRGBO(242, 117, 7, 1),
    )
  ];
}

class _DateTimeData {
  _DateTimeData(this.year, this.y);
  final DateTime year;
  final double y;
}
