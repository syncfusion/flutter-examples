import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EdgeLabel extends StatefulWidget {
  final SubItemList sample;
  const EdgeLabel(this.sample, {Key key}) : super(key: key);

  @override
  _EdgeLabelState createState() => _EdgeLabelState(sample);
}

class _EdgeLabelState extends State<EdgeLabel> {
  final SubItemList sample;
  _EdgeLabelState(this.sample);
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
  void didUpdateWidget(EdgeLabel oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/axis_features/edge_label_placement/edgelabel_placement.dart');
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
  bool enableTooltip = false;
  bool enableMarker = false;
  bool enableDatalabel = false;
  final List<String> _edgeList = <String>['hide', 'none', 'shift'].toList();

  String _selectedType = 'shift';

  EdgeLabelPlacement _edgeLabelPlacement = EdgeLabelPlacement.shift;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
             backgroundColor:model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child:
                        getEdgeLabelPlacementChart(false, _edgeLabelPlacement)),
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
                              'https://www.mycarhelpline.com/index.php?option=com_easyblog&view=entry&id=808&Itemid=91'),
                          child: Row(
                            children: <Widget>[
                              Text('Source: ',
                                  style: TextStyle(
                                      fontSize: 16, color: model.textColor)),
                              Text('www.mycarhelpline.com',
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

  void onPositionTypeChange(String item, SampleListModel model) {
    setState(() {
      _selectedType = item;
      if (_selectedType == 'hide') {
        _edgeLabelPlacement = EdgeLabelPlacement.hide;
      }
      if (_selectedType == 'none') {
        _edgeLabelPlacement = EdgeLabelPlacement.none;
      }
      if (_selectedType == 'shift') {
        _edgeLabelPlacement = EdgeLabelPlacement.shift;
      }
    });
  }

  void _showSettingsPanel(SampleListModel model) {
    double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    showRoundedModalBottomSheet(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (context) => ScopedModelDescendant<SampleListModel>(
            rebuildOnChange: false,
            builder: (context, _, model) => Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                  child: ListView(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Edge label placement',
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
                                                width: 100,
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
                                                        item: _edgeList.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'hide',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onPositionTypeChange(
                                                              value.toString(),
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

SfCartesianChart getEdgeLabelPlacementChart(bool isTileView,
    [EdgeLabelPlacement _edgeLabelPlacement]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title: ChartTitle(text: isTileView ? '' : 'Fuel price in India'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: DateTime(2006, 4, 1),
        interval: 2,
        dateFormat: DateFormat.y(),
        intervalType: DateTimeIntervalType.years,
        maximum: DateTime(2016, 4, 1),
        edgeLabelPlacement:
            isTileView ? EdgeLabelPlacement.shift : _edgeLabelPlacement),
    primaryYAxis: NumericAxis(
      majorTickLines: MajorTickLines(width: 0.5),
      axisLine: AxisLine(width: 0),
      labelFormat: '₹{value}',
      minimum: 20,
      maximum: 80,
      edgeLabelPlacement: _edgeLabelPlacement,
      title: AxisTitle(text: isTileView ? '' : 'Rupees per litre'),
    ),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x : point.y'),
  );
}

List<ChartSeries<_ChartData, DateTime>> getLineSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(new DateTime(2005, 4, 1), 37.99, 28.22),
    _ChartData(new DateTime(2006, 4, 1), 43.5, 30.45),
    _ChartData(new DateTime(2007, 4, 1), 43, 30.25),
    _ChartData(new DateTime(2008, 4, 1), 45.5, 31.76),
    _ChartData(new DateTime(2009, 4, 1), 44.7, 30.86),
    _ChartData(new DateTime(2010, 4, 1), 48, 38.1),
    _ChartData(new DateTime(2011, 4, 1), 58.5, 37.75),
    _ChartData(new DateTime(2012, 4, 1), 65.6, 40.91),
    _ChartData(new DateTime(2013, 4, 1), 66.09, 48.63),
    _ChartData(new DateTime(2014, 4, 1), 72.26, 55.48),
    _ChartData(new DateTime(2015, 4, 1), 60.49, 49.71),
    _ChartData(new DateTime(2016, 4, 1), 59.68, 48.33)
  ];
  return <ChartSeries<_ChartData, DateTime>>[
    SplineSeries<_ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.year,
        yValueMapper: (_ChartData sales, _) => sales.y,
        markerSettings:
            MarkerSettings(isVisible: true, shape: DataMarkerType.pentagon),
        name: 'Petrol'),
    SplineSeries<_ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.year,
        yValueMapper: (_ChartData sales, _) => sales.y1,
        markerSettings:
            MarkerSettings(isVisible: true, shape: DataMarkerType.pentagon),
        name: 'Diesel')
  ];
}

class _ChartData {
  _ChartData(this.year, this.y, this.y1);
  final DateTime year;
  final double y;
  final double y1;
}
