import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultSelection extends StatefulWidget {
  const DefaultSelection(this.sample, {Key key}) : super(key: key);

  final SubItemList sample;

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState(sample);
}

class _DefaultSelectionState extends State<DefaultSelection> {
  _DefaultSelectionState(this.sample);
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
  void didUpdateWidget(DefaultSelection oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/user_interactions/selection/selection_modes.dart');
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
  bool enableMultiSelect = false;

  final List<String> _modeList =
      <String>['point', 'series', 'cluster'].toList();
  String _selectedMode = 'point';

  SelectionType _mode = SelectionType.point;

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
                    child: getDefaultSelectionChart(
                        false, _mode, enableMultiSelect)),
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
        builder: (BuildContext context) => ScopedModelDescendant<
                SampleListModel>(
            rebuildOnChange: false,
            builder: (BuildContext context, _, SampleListModel model) =>
                Padding(
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
                                        const EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    child: ListView(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('Mode ',
                                                  style: TextStyle(
                                                      color: model.textColor,
                                                      fontSize: 16,
                                                      letterSpacing: 0.34,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        150, 0, 0, 0),
                                                height: 50,
                                                width: 250,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                              canvasColor: model
                                                                  .bottomSheetBackgroundColor),
                                                      child: DropDown(
                                                          value: _selectedMode,
                                                          item: _modeList.map(
                                                              (String value) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: (value !=
                                                                        null)
                                                                    ? value
                                                                    : 'point',
                                                                child: Text(
                                                                    '$value',
                                                                    style: TextStyle(
                                                                        color: model
                                                                            .textColor)));
                                                          }).toList(),
                                                          valueChanged:
                                                              (dynamic value) {
                                                            onModeTypeChange(
                                                                value, model);
                                                          })),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('Enable multi-selection ',
                                                  style: TextStyle(
                                                      color: model.textColor,
                                                      fontSize: 16,
                                                      letterSpacing: 0.34,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              BottomSheetCheckbox(
                                                activeColor:
                                                    model.backgroundColor,
                                                switchValue: enableMultiSelect,
                                                valueChanged: (dynamic value) {
                                                  setState(() {
                                                    enableMultiSelect = value;
                                                  });
                                                },
                                              ),
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

  void onModeTypeChange(String item, SampleListModel model) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'point') {
        _mode = SelectionType.point;
      }
      if (_selectedMode == 'series') {
        _mode = SelectionType.series;
      }
      if (_selectedMode == 'cluster') {
        _mode = SelectionType.cluster;
      }
      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
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
  // ignore: prefer_const_constructors_in_immutables
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

SfCartesianChart getDefaultSelectionChart(bool isTileView,
    [SelectionType _mode, bool enableMultiSelect]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Age distribution by country'),
    selectionType: _mode,
    selectionGesture: ActivationMode.singleTap,
    enableMultiSelection: enableMultiSelect,
    primaryXAxis: CategoryAxis(
        title: AxisTitle(text: isTileView ? '' : 'Countries'),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(isTileView),
  );
}

List<ColumnSeries<_SelectionData, String>> getLineSeries(bool isTileView) {
  final List<_SelectionData> chartData = <_SelectionData>[
    _SelectionData('CHN', 17, 54, 9),
    _SelectionData('USA', 19, 67, 14),
    _SelectionData('IDN', 29, 65, 6),
    _SelectionData('JAP', 13, 61, 26),
    _SelectionData('BRZ', 24, 68, 8)
  ];
  return <ColumnSeries<_SelectionData, String>>[
    ColumnSeries<_SelectionData, String>(
        // animationDuration: isTileView ? 0 : 1500,
        dataSource: chartData,
        xValueMapper: (_SelectionData sales, _) => sales.x,
        yValueMapper: (_SelectionData sales, _) => sales.y1,
        selectionSettings:
            SelectionSettings(enable: true, unselectedOpacity: 0.5),
        name: 'Age 0-14'),
    ColumnSeries<_SelectionData, String>(
        // animationDuration: isTileView ? 0 : 1500,
        dataSource: chartData,
        xValueMapper: (_SelectionData sales, _) => sales.x,
        yValueMapper: (_SelectionData sales, _) => sales.y2,
        selectionSettings:
            SelectionSettings(enable: true, unselectedOpacity: 0.5),
        name: 'Age 15-64'),
    ColumnSeries<_SelectionData, String>(
        // animationDuration: isTileView ? 0 : 1500,
        dataSource: chartData,
        xValueMapper: (_SelectionData sales, _) => sales.x,
        yValueMapper: (_SelectionData sales, _) => sales.y3,
        selectionSettings:
            SelectionSettings(enable: true, unselectedOpacity: 0.5),
        name: 'Age 65 & Above')
  ];
}

class _SelectionData {
  _SelectionData(this.x, this.y1, this.y2, this.y3);
  final String x;
  final double y1;
  final double y2;
  final double y3;
}
