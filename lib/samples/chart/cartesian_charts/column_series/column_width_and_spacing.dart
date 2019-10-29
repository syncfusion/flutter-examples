import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ColumnSpacing extends StatefulWidget {
  const ColumnSpacing(this.sample, {Key key}) : super(key: key); 
  final SubItemList sample;

  @override
  _ColumnSpacingState createState() => _ColumnSpacingState(sample);
}

class _ColumnSpacingState extends State<ColumnSpacing> {

  _ColumnSpacingState(this.sample);
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
  void didUpdateWidget(ColumnSpacing oldWidget) {
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
                        icon: Image.asset(model.codeViewerIcon,
                            color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/cartesian_charts/column_series/column_width_and_spacing.dart');
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
                        icon: Image.asset(model.informationIcon,
                            color: Colors.white),
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
                    duration: Duration(milliseconds: 1000),
                    child: Text(sample.title.toString())),
                backLayer: BackPanel(sample),
                frontLayer: FrontPanel(sample),
                sideDrawer: null,
                headerClosingHeight: 350,
                titleVisibleOnPanelClosed: true,
                color:model.cardThemeColor,
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
  bool enableLegend = true;
  double columnWidth = 0.8;
  double columnSpacing = 0.2;
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
                child: Container(
                    child: getSpacingColumnChart(
                        false, columnWidth, columnSpacing)),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              ));
        });
  }

  void _showSettingsPanel(SampleListModel model) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => ScopedModelDescendant<SampleListModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleListModel model) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 170,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * height,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 40,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Settings',
                                        style: TextStyle(
                                            color: model.textColor,
                                            fontSize: 18,
                                            letterSpacing: 0.34,
                                            fontWeight: FontWeight.w500)),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: model.textColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 50, 0, 0),
                                child: ListView(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Width  ',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: model.textColor)),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 0,
                                                maxValue: 0.9,
                                                initialValue: columnWidth,
                                                onChanged: (dynamic val) =>
                                                    setState(() {
                                                      columnWidth = val;
                                                    }),
                                                step: 0.1,
                                                horizontal: true,
                                                loop: true,
                                                padding: 0,
                                                iconUp: Icons.keyboard_arrow_up,
                                                iconDown:
                                                    Icons.keyboard_arrow_down,
                                                iconLeft:
                                                    Icons.keyboard_arrow_left,
                                                iconRight:
                                                    Icons.keyboard_arrow_right,
                                                iconUpRightColor:
                                                    model.textColor,
                                                iconDownLeftColor:
                                                    model.textColor,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: model.textColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text('Spacing  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 0, 0),
                                              child: CustomButton(
                                                minValue: 0,
                                                maxValue: 1,
                                                initialValue: columnSpacing,
                                                onChanged: (dynamic val) =>
                                                    setState(() {
                                                      columnSpacing = val;
                                                    }),
                                                step: 0.1,
                                                horizontal: true,
                                                loop: true,
                                                padding: 5.0,
                                                iconUp: Icons.keyboard_arrow_up,
                                                iconDown:
                                                    Icons.keyboard_arrow_down,
                                                iconLeft:
                                                    Icons.keyboard_arrow_left,
                                                iconRight:
                                                    Icons.keyboard_arrow_right,
                                                iconUpRightColor:
                                                    model.textColor,
                                                iconDownLeftColor:
                                                    model.textColor,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: model.textColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ))));
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

SfCartesianChart getSpacingColumnChart(bool isTileView,
    [double columnWidth, double columnSpacing]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Winter olympic medals count'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        maximum: 150,
        minimum: 0,
        interval: 25,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultColumn(isTileView, columnWidth, columnSpacing),
    legend: Legend(isVisible: isTileView ? false : true),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ColumnSeries<_ChartData, String>> getDefaultColumn(bool isTileView,
    [double columnWidth, double columnSpacing]) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('Germany', 128, 129, 101),
    _ChartData('Russia', 123, 92, 93),
    _ChartData('Norway', 107, 106, 90),
    _ChartData('USA', 87, 95, 71),
  ];
  return <ColumnSeries<_ChartData, String>>[
    ColumnSeries<_ChartData, String>(
        enableTooltip: true,
        width: isTileView ? 0.8 : columnWidth,
        spacing: isTileView ? 0.2 : columnSpacing,
        dataSource: chartData,
        color: const Color.fromRGBO(252, 216, 20, 1),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        name: 'Gold'),
    ColumnSeries<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        width: isTileView ? 0.8 : columnWidth,
        spacing: isTileView ? 0.2 : columnSpacing,
        color: const Color.fromRGBO(169, 169, 169, 1),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
        name: 'Silver'),
    ColumnSeries<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        width: isTileView ? 0.8 : columnWidth,
        spacing: isTileView ? 0.2 : columnSpacing,
        color: const Color.fromRGBO(205, 127, 50, 1),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y3,
        name: 'Bronze')
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2, this.y3);
  final String x;
  final double y;
  final double y2;
  final double y3;
}
