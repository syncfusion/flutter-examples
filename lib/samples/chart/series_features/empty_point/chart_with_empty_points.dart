import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class EmptyPoints extends StatefulWidget {
  EmptyPoints({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _EmptyPointsState createState() => _EmptyPointsState(sample);
}

class _EmptyPointsState extends State<EmptyPoints> {
  _EmptyPointsState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, EmptyPointsFrontPanel(sample));
  }
}

SfCartesianChart getEmptyPointChart(bool isTileView,
    [EmptyPointMode _selectedEmptyPointMode, SampleModel model]) {
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
    series: getEmptyPointSeries(isTileView, _selectedEmptyPointMode, model),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ColumnSeries<ChartSampleData, String>> getEmptyPointSeries(bool isTileView,
    [EmptyPointMode _selectedEmptyPointMode, SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'China', y: 0.541),
    ChartSampleData(x: 'Brazil', y: null),
    ChartSampleData(x: 'Bolivia', y: 1.51),
    ChartSampleData(x: 'Mexico', y: 1.302),
    ChartSampleData(x: 'Egypt', y: null),
    ChartSampleData(x: 'Mongolia', y: 1.683),
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
      enableTooltip: true,
      dataSource: chartData,
      emptyPointSettings: EmptyPointSettings(
          mode: isExistModel
              ? model.properties['SelectedEmptyPointMode']
              : isTileView ? EmptyPointMode.gap : _selectedEmptyPointMode,
          color: Colors.grey),
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, textStyle: ChartTextStyle(fontSize: 10)),
    )
  ];
}

//ignore: must_be_immutable
class EmptyPointsFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  EmptyPointsFrontPanel([this.sample]);
  SubItem sample;

  @override
  _EmptyPointsFrontPanelState createState() =>
      _EmptyPointsFrontPanelState(sample);
}

class _EmptyPointsFrontPanelState extends State<EmptyPointsFrontPanel> {
  _EmptyPointsFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _emptyPointMode =
      <String>['gap', 'zero', 'average', 'drop'].toList();
  EmptyPointMode _selectedEmptyPointMode = EmptyPointMode.gap;
  String _selectedMode;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getEmptyPointChart(false, null, model);

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
    _selectedMode = 'zero';
    _selectedEmptyPointMode = EmptyPointMode.gap;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedMode': _selectedMode,
        'SelectedEmptyPointMode': _selectedEmptyPointMode
      });
    }
  }

  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();

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
                          child: getEmptyPointChart(
                              false, _selectedEmptyPointMode, null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getEmptyPointChart(false, null, null)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : Stack(
                      children: <Widget>[
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

  void onEmptyPointModeChange(String item, SampleModel model) {
    // setState(() {
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
    model.properties['SelectedMode'] = _selectedMode;
    model.properties['SelectedEmptyPointMode'] = _selectedEmptyPointMode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});

    // });
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Empty point mode  ',
                      style: TextStyle(fontSize: 14.0, color: model.textColor)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      height: 50,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                          data: ThemeData(
                              brightness: model.themeData.brightness,
                              primaryColor: model.webSampleBackgroundColor),
                          child: DropDown(
                              value: model.properties['SelectedMode'],
                              item: _emptyPointMode.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'zero',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              valueChanged: (dynamic value) {
                                onEmptyPointModeChange(value.toString(), model);
                              }),
                        ),
                      ))
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
                      height: 120,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                              height:
                                  MediaQuery.of(context).size.height * height,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 5),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 50, 0, 0),
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
                                                              .map((String
                                                                  value) {
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
                                                                value
                                                                    .toString(),
                                                                model);
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
    return widget ?? Container();
  }
}
