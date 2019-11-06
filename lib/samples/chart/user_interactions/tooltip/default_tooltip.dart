import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultTooltip extends StatefulWidget {
  const DefaultTooltip(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;

  @override
  _DefaultTooltipState createState() => _DefaultTooltipState(sample);
}

class _DefaultTooltipState extends State<DefaultTooltip> {
  _DefaultTooltipState(this.sample);
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
  void didUpdateWidget(DefaultTooltip oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/user_interactions/tooltip/default_tooltip.dart');
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
  bool enableTooltip = false;
  bool enableMarker = false;
  bool enableDatalabel = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getDefaultTooltipChart(false)),
              ),
              floatingActionButton: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                      child: Container(
                        height: 50,
                        width: 250,
                        child: InkWell(
                          onTap: () => launch(
                              'https://www.indexmundi.com/g/g.aspx?v=72&c=gm&c=mx&l=en'),
                          child: Row(
                            children: <Widget>[
                              Text('Source: ',
                                  style: TextStyle(
                                      fontSize: 16, color: model.textColor)),
                              Text('www.indexmundi.com',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
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

SfCartesianChart getDefaultTooltipChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Labour force'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: NumericAxis(
        minimum: 2004,
        maximum: 2013,
        title: AxisTitle(text: isTileView ? '' : 'Year'),
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        minimum: 30,
        maximum: 60,
        axisLine: AxisLine(width: 0)),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<LineSeries<_TooltipData, num>> getLineSeries(bool isTileView) {
  final List<_TooltipData> chartData = <_TooltipData>[
    _TooltipData(2004, 42.630000, 34.730000),
    _TooltipData(2005, 43.320000, 43.400000),
    _TooltipData(2006, 43.660000, 38.090000),
    _TooltipData(2007, 43.540000, 44.710000),
    _TooltipData(2008, 43.600000, 45.320000),
    _TooltipData(2009, 43.500000, 46.200000),
    _TooltipData(2010, 43.350000, 46.990000),
    _TooltipData(2011, 43.620000, 49.170000),
    _TooltipData(2012, 43.930000, 50.640000),
    _TooltipData(2013, 44.200000, 51.480000),
  ];
  return <LineSeries<_TooltipData, num>>[
    LineSeries<_TooltipData, num>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_TooltipData sales, _) => sales.x,
        yValueMapper: (_TooltipData sales, _) => sales.y,
        width: 2,
        name: 'Germany',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_TooltipData, num>(
      enableTooltip: true,
      dataSource: chartData,
      width: 2,
      name: 'Mexico',
      xValueMapper: (_TooltipData sales, _) => sales.x,
      yValueMapper: (_TooltipData sales, _) => sales.y1,
      markerSettings: MarkerSettings(isVisible: true),
    )
  ];
}

class _TooltipData {
  _TooltipData(this.x, this.y, this.y1);
  final double x;
  final double y;
  final double y1;
}
