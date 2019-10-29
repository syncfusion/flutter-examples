import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EmptyPoints extends StatefulWidget {
  const EmptyPoints(this.sample, {Key key}) : super(key: key);
  final SubItemList sample;
  
  @override
  _EmptyPointsState createState() => _EmptyPointsState(sample);
}

class _EmptyPointsState extends State<EmptyPoints> {
  _EmptyPointsState(this.sample);
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
  void didUpdateWidget(EmptyPoints oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/series_features/empty_point/chart_with_empty_points.dart');
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
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel(this.subItemList);
  final SubItemList subItemList;
  
  @override
  _FrontPanelState createState() => _FrontPanelState(subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sample);
  final SubItemList sample;
  final List<String> _emptyPointMode =
      <String>['gap', 'zero', 'average', 'drop'].toList();
  EmptyPointMode _selectedEmptyPointMode = EmptyPointMode.gap;
  String _selectedMode;
  @override
  void initState() {
    super.initState();
    _selectedMode = _emptyPointMode.first; 
    _selectedEmptyPointMode = EmptyPointMode.gap;
  }

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
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                child: Container(
                    child: getEmptyPointChart(false, _selectedEmptyPointMode)),
              ),
              floatingActionButton: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        _showSettingsPanel(model);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ),
                  ),
                ],
              ));
        });
  }

  void onEmptyPointModeChange(String item) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'gap') {
        _selectedEmptyPointMode = EmptyPointMode.gap;
      }
      if (_selectedMode == 'zero') {
        _selectedEmptyPointMode = EmptyPointMode.zero;
      }
      if (_selectedMode == 'average') {
        _selectedEmptyPointMode = EmptyPointMode.average;
      }
      if (_selectedMode == 'drop') {
        _selectedEmptyPointMode = EmptyPointMode.drop;
      }
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
                    height: 120,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                            height: MediaQuery.of(context).size.height * height,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                                child: Stack(children: <Widget>[
                                  Container(
                                    height: 40,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                    child: ListView(children: <Widget>[
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Empty point mode  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 0, 0, 0),
                                                height: 50,
                                                width: 150,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            canvasColor: model
                                                                .bottomSheetBackgroundColor),
                                                    child: DropDown(
                                                        value: _selectedMode,
                                                        item: _emptyPointMode
                                                            .map(
                                                                (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'gap',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onEmptyPointModeChange(
                                                              value.toString());
                                                        }),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                ]))))))));
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

SfCartesianChart getEmptyPointChart(bool isTileView,
    [EmptyPointMode _selectedEmptyPointMode]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Population growth of various countries'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}%',
        majorTickLines: MajorTickLines(size: 0)),
    series: getColumnSeries(isTileView, _selectedEmptyPointMode),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ColumnSeries<_ChartData, String>> getColumnSeries(bool isTileView,
    [EmptyPointMode _selectedEmptyPointMode]) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('China', 0.541),
    _ChartData('Brazil', null),
    _ChartData('Bolivia', 1.51),
    _ChartData('Mexico', 1.302),
    _ChartData('Egypt', null),
    _ChartData('Mongolia', 1.683),
  ];
  return <ColumnSeries<_ChartData, String>>[
    ColumnSeries<_ChartData, String>(
      enableTooltip: true,
      dataSource: chartData,
      emptyPointSettings: EmptyPointSettings(
          mode: isTileView ? EmptyPointMode.gap : _selectedEmptyPointMode,
          color: Colors.grey),
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, textStyle: ChartTextStyle(fontSize: 10)),
    )
  ];
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
