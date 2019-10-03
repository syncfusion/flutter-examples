import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DataLabelDefault extends StatefulWidget {
  final SubItemList sample;
  const DataLabelDefault(this.sample, {Key key}) : super(key: key);

  @override
  _DataLabelDefaultState createState() => _DataLabelDefaultState(sample);
}

class _DataLabelDefaultState extends State<DataLabelDefault> {
  final SubItemList sample;
  _DataLabelDefaultState(this.sample);
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
  void didUpdateWidget(DataLabelDefault oldWidget) {
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
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/series_features/data_label/default_datalabels.dart');
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
  bool performIntersectAction = true;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Container(
                child: getDataLabelDefaultChart(false, performIntersectAction)),
          ));
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

SfCartesianChart getDataLabelDefaultChart(bool isTileView,
    [bool performIntersectAction]) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Gross investments'),
    plotAreaBorderWidth: 0,
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: NumericAxis(
        minimum: 2006,
        maximum: 2010,
        title: AxisTitle(text: isTileView ? '' : 'Year'),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        minimum: 15,
        maximum: 30,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<SplineSeries<_LabelData, num>> getLineSeries(
  bool isTileView,
) {
  final List<_LabelData> chartData = <_LabelData>[
    _LabelData(2006, 21.8, 18.2),
    _LabelData(2007, 24.9, 21),
    _LabelData(2008, 28.5, 22.1),
    _LabelData(2009, 27.2, 21.5),
    _LabelData(2010, 23.4, 18.9),
    _LabelData(2011, 23.4, 21.3)
  ];
  return <SplineSeries<_LabelData, num>>[
    SplineSeries<_LabelData, num>(
        legendIconType: LegendIconType.rectangle,
        enableTooltip: true,
        dataSource: chartData,
        color: Color.fromRGBO(140, 198, 64, 1),
        width: 2,
        xValueMapper: (_LabelData sales, _) => sales.x,
        yValueMapper: (_LabelData sales, _) => sales.y1,
        markerSettings: MarkerSettings(isVisible: true),
        name: 'Singapore',
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            labelAlignment: ChartDataLabelAlignment.top)),
    SplineSeries<_LabelData, num>(
        legendIconType: LegendIconType.rectangle,
        enableTooltip: true,
        color: Color.fromRGBO(203, 164, 199, 1),
        dataSource: chartData,
        width: 2,
        xValueMapper: (_LabelData sales, _) => sales.x,
        yValueMapper: (_LabelData sales, _) => sales.y2,
        markerSettings: MarkerSettings(isVisible: true),
        name: 'Russia',
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            labelAlignment: ChartDataLabelAlignment.top))
  ];
}

class _LabelData {
  _LabelData(this.x, this.y1, this.y2);
  final double x;
  final double y1;
  final double y2;
}
