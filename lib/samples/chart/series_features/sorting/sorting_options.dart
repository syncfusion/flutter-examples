import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class SortingDefault extends StatefulWidget {
  SortingDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SortingDefaultState createState() => _SortingDefaultState(sample);
}

class _SortingDefaultState extends State<SortingDefault> {
  _SortingDefaultState(this.sample);
  final SubItem sample;
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
  void didUpdateWidget(SortingDefault oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, SortingFrontPanel(sample));
  }
}

SfCartesianChart getDefaultSortingChart(bool isTileView,
    [String _sortby, SortingOrder _sortingOrder, SampleModel model]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : "World's tallest buildings"),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: 500,
        maximum: 900,
        interval: 100,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultSortingSeries(isTileView, _sortby, _sortingOrder, model),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<BarSeries<ChartSampleData, String>> getDefaultSortingSeries(
    bool isTileView,
    [String _sortby,
    SortingOrder _sortingOrder,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Burj \n Khalifa', y: 828),
    ChartSampleData(x: 'Goldin \n Finance 117', y: 597),
    ChartSampleData(x: 'Makkah Clock \n Royal Tower', y: 601),
    ChartSampleData(x: 'Ping An \n Finance Center', y: 599),
    ChartSampleData(x: 'Shanghai \n Tower', y: 632),
  ];
  return <BarSeries<ChartSampleData, String>>[
    BarSeries<ChartSampleData, String>(
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      sortingOrder: isExistModel
          ? model.properties['SortingOrder'] != null
              ? model.properties['SortingOrder']
              : SortingOrder.none
          : _sortingOrder != null ? _sortingOrder : SortingOrder.none,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, labelAlignment: ChartDataLabelAlignment.auto),
      sortFieldValueMapper: (ChartSampleData sales, _) => isExistModel
          ? model.properties['SortBy'] == 'x' ? sales.x : sales.y
          : _sortby == 'x' ? sales.x : sales.y,
    )
  ];
}

//ignore: must_be_immutable
class SortingFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  SortingFrontPanel([this.sample]);
  SubItem sample;

  @override
  _SortingFrontPanelState createState() => _SortingFrontPanelState(sample);
}

class _SortingFrontPanelState extends State<SortingFrontPanel> {
  _SortingFrontPanelState(this.sample);
  final SubItem sample;
  bool isSorting = true;
  final List<String> _labelList = <String>['y', 'x'].toList();
  final List<String> _sortList =
      <String>['none', 'descending', 'ascending'].toList();
  String _selectedType = 'y';
  String _selectedSortType = 'none';
  SortingOrder _sortingOrder = SortingOrder.none;

  String _sortby = 'y';

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getDefaultSortingChart(false, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedType = 'y';
    _selectedSortType = 'none';
    _sortingOrder = SortingOrder.none;
    _sortby = 'y';
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedType': _selectedType,
        'SelectedSortType': _selectedSortType,
        'SortingOrder': _sortingOrder,
        'SortBy': _sortby
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 60),
                      child: Container(
                          child: getDefaultSortingChart(
                              false, _sortby, _sortingOrder, null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child:
                              getDefaultSortingChart(false, null, null, null)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : Stack(
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
                                    'https://www.emporis.com/statistics/worlds-tallest-buildings'),
                                child: Row(
                                  children: <Widget>[
                                    Text('Source: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: model.textColor)),
                                    const Text('www.emporis.com',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              _showSettingsPanel(model, false, context);
                            },
                            child: Icon(Icons.graphic_eq, color: Colors.white),
                            backgroundColor: model.backgroundColor,
                          ),
                        ),
                      ],
                    ));
        });
  }

  void onPositionTypeChange(String item, SampleModel model) {
    _selectedType = item;
    if (_selectedType == 'y') {
      _sortby = 'y';
    }
    if (_selectedType == 'x') {
      _sortby = 'x';
    }
    model.properties['SelectedType'] = _selectedType;
    model.properties['SortBy'] = _sortby;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  void onSortingTypeChange(String item, SampleModel model) {
    // setState(() {
    _selectedSortType = item;
    if (_selectedSortType == 'descending') {
      _sortingOrder = SortingOrder.descending;
    } else if (_selectedSortType == 'ascending') {
      _sortingOrder = SortingOrder.ascending;
    } else {
      _sortingOrder = SortingOrder.none;
    }
    model.properties['SelectedSortType'] = _selectedSortType;
    model.properties['SortingOrder'] = _sortingOrder;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    // ignore: unused_local_variable
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Properties',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  HandCursor(
                      child: IconButton(
                    icon: Icon(Icons.close, color: model.webIconColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
                ]),
            Container(
              child: Row(
                children: <Widget>[
                  Text('Sort by ',
                      style: TextStyle(
                          color: model.textColor,
                          fontSize: 14,
                          letterSpacing: 0.34,
                          fontWeight: FontWeight.normal)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      height: 50,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: model.bottomSheetBackgroundColor),
                          child: DropDown(
                              value: model.properties['SelectedType'],
                              item: _labelList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'y',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              valueChanged: (dynamic value) {
                                onPositionTypeChange(value.toString(), model);
                              }),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text('Sorting order ',
                      style: TextStyle(
                          color: model.textColor,
                          fontSize: 14,
                          letterSpacing: 0.34,
                          fontWeight: FontWeight.normal)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      height: 50,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: model.bottomSheetBackgroundColor),
                          child: DropDown(
                              value: model.properties['SelectedSortType'],
                              item: _sortList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'none',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              valueChanged: (dynamic value) {
                                onSortingTypeChange(value.toString(), model);
                              }),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      showRoundedModalBottomSheet<dynamic>(
          dismissOnTap: false,
          context: context,
          radius: 12.0,
          color: model.bottomSheetBackgroundColor,
          builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
              rebuildOnChange: false,
              builder: (BuildContext context, _, SampleModel model) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                      height: 170,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                              height: 220,
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
                                    child: ListView(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('Sort by ',
                                                  style: TextStyle(
                                                      color: model.textColor,
                                                      fontSize: 16,
                                                      letterSpacing: 0.34,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 0, 0, 0),
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
                                                          value: _selectedType,
                                                          item: _labelList.map(
                                                              (String value) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: (value !=
                                                                        null)
                                                                    ? value
                                                                    : 'y',
                                                                child: Text(
                                                                    '$value',
                                                                    style: TextStyle(
                                                                        color: model
                                                                            .textColor)));
                                                          }).toList(),
                                                          valueChanged:
                                                              (dynamic value) {
                                                            onPositionTypeChange(
                                                                value
                                                                    .toString(),
                                                                model);
                                                          }),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('Sorting order ',
                                                  style: TextStyle(
                                                      color: model.textColor,
                                                      fontSize: 16,
                                                      letterSpacing: 0.34,
                                                      fontWeight:
                                                          FontWeight.normal)),
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
                                                          value:
                                                              _selectedSortType,
                                                          item: _sortList.map(
                                                              (String value) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: (value !=
                                                                        null)
                                                                    ? value
                                                                    : 'none',
                                                                child: Text(
                                                                    '$value',
                                                                    style: TextStyle(
                                                                        color: model
                                                                            .textColor)));
                                                          }).toList(),
                                                          valueChanged:
                                                              (dynamic value) {
                                                            onSortingTypeChange(
                                                                value
                                                                    .toString(),
                                                                model);
                                                          }),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              )))))));
    }
    return widget ?? Container();
  }
}
