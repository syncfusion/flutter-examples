import 'dart:async';
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

Timer timer;

//ignore: must_be_immutable
class CartesianDynamicAnimation extends StatefulWidget {
  CartesianDynamicAnimation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _CartesianDynamicAnimationState createState() =>
      _CartesianDynamicAnimationState(sample);
}

class _CartesianDynamicAnimationState extends State<CartesianDynamicAnimation> {
  _CartesianDynamicAnimationState(this.sample);
  final SubItem sample;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, DynamicFrontPanel(sample));
  }
}

SfCartesianChart getDynamicAnimationChart(bool isTileView,
    [String _selectedType, SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        interval: 20,
        maximum: 80,
        majorTickLines: MajorTickLines(size: 0)),
    series: getAnimationData(
        isTileView,
        isTileView
            ? 'Column'
            : isExistModel ? model.properties['SelectedType'] : _selectedType),
  );
}

List<ChartSeries<ChartSampleData, String>> getAnimationData(
    bool isTileView, String _selectedseriesType) {
  if (_selectedseriesType == 'Line') {
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
      )
    ];
  } else if (_selectedseriesType == 'Column') {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      )
    ];
  } else if (_selectedseriesType == 'Spline') {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
      )
    ];
  } else if (_selectedseriesType == 'Area') {
    return <AreaSeries<ChartSampleData, String>>[
      AreaSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.near,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'StepLine') {
    return <StepLineSeries<ChartSampleData, String>>[
      StepLineSeries<ChartSampleData, String>(
        dataSource: chartData,
        width: 2,
        color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'Bar') {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'Scatter') {
    return <ScatterSeries<ChartSampleData, String>>[
      ScatterSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        color: const Color.fromRGBO(0, 168, 181, 1),
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 10,
            width: 10,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  } else if (_selectedseriesType == 'Bubble') {
    return <BubbleSeries<ChartSampleData, String>>[
      BubbleSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(0, 168, 181, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        sizeValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            color: Colors.blue,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.auto,
            isVisible: false),
        markerSettings: MarkerSettings(
            isVisible: false,
            height: 5,
            width: 5,
            color: Colors.white,
            shape: DataMarkerType.circle,
            borderWidth: 3,
            borderColor: Colors.blue),
      )
    ];
  }

  return null;
}

List<ChartSampleData> chartData = <ChartSampleData>[
  ChartSampleData(x: '1', y: 45, pointColor: Colors.yellow),
  ChartSampleData(x: '2', y: 52, pointColor: Colors.teal),
  ChartSampleData(x: '3', y: 41, pointColor: Colors.blue),
  ChartSampleData(x: '4', y: 65, pointColor: Colors.orange),
  ChartSampleData(x: '5', y: 36, pointColor: Colors.pink),
  ChartSampleData(x: '6', y: 65, pointColor: Colors.brown[300]),
];

//ignore: must_be_immutable
class DynamicFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DynamicFrontPanel([this.sample]);
  SubItem sample;

  @override
  _DynamicFrontPanelState createState() => _DynamicFrontPanelState(sample);
}

class _DynamicFrontPanelState extends State<DynamicFrontPanel> {
  _DynamicFrontPanelState(this.sample);
  final SubItem sample;
  // List<ChartSampleData> chartData;
  int count = 0;
  final List<String> _seriesType = <String>[
    'Column',
    'Line',
    'Spline',
    'StepLine',
    'Scatter',
    'Bubble',
    'Bar',
    'Area'
  ].toList();

  String _selectedType = 'Column';

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  Widget sampleWidget(SampleModel model) =>
      getDynamicAnimationChart(false, null, model);

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
    _selectedType = 'Column';
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedType': _selectedType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    chartData = getChartData();
    timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        chartData = getChartData();
      });
    });
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                      child: Container(
                          child: getDynamicAnimationChart(
                              false, _selectedType, null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getDynamicAnimationChart(false, null, null)),
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
                                    'https://en.wikipedia.org/wiki/List_of_men%27s_footballers_with_500_or_more_goals'),
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

  void onSeriesTypeChange(String item, SampleModel model) {
    // setState(() {
    _selectedType = item;
    model.properties['SelectedType'] = _selectedType;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});

    // });
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
                    icon: Icon(Icons.close, color: model.textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
                ]),
            Container(
              child: Row(
                children: <Widget>[
                  Text('Chart type ',
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
                              value: model.properties['SelectedType'],
                              item: _seriesType.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'column',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              valueChanged: (dynamic value) {
                                onSeriesTypeChange(value.toString(), model);
                              }),
                        ),
                      )),
                ],
              ),
            ),
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
                              height: 150,
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
                                              Text('Chart type ',
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
                                                          value: _selectedType,
                                                          item: _seriesType.map(
                                                              (String value) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: (value !=
                                                                        null)
                                                                    ? value
                                                                    : 'column',
                                                                child: Text(
                                                                    '$value',
                                                                    style: TextStyle(
                                                                        color: model
                                                                            .textColor)));
                                                          }).toList(),
                                                          valueChanged:
                                                              (dynamic value) {
                                                            onSeriesTypeChange(
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

  List<ChartSampleData> getChartData() {
    if (count == 0) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '1', y: 76, pointColor: Colors.yellow),
        ChartSampleData(x: '2', y: 50, pointColor: Colors.teal),
        ChartSampleData(x: '3', y: 60, pointColor: Colors.blue),
        ChartSampleData(x: '4', y: 32, pointColor: Colors.orange),
        ChartSampleData(x: '5', y: 29, pointColor: Colors.pink),
        ChartSampleData(x: '6', y: 20, pointColor: Colors.brown[300]),
      ];
      count++;
    } else if (count == 1) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '1', y: 36, pointColor: Colors.yellow),
        ChartSampleData(x: '2', y: 10, pointColor: Colors.teal),
        ChartSampleData(x: '3', y: 20, pointColor: Colors.blue),
        ChartSampleData(x: '4', y: 50, pointColor: Colors.orange),
        ChartSampleData(x: '5', y: 19, pointColor: Colors.pink),
        ChartSampleData(x: '6', y: 67, pointColor: Colors.brown[300]),
      ];
      count++;
    } else if (count == 2) {
      chartData = <ChartSampleData>[
        ChartSampleData(x: '1', y: 40, pointColor: Colors.yellow),
        ChartSampleData(x: '2', y: 60, pointColor: Colors.teal),
        ChartSampleData(x: '3', y: 35, pointColor: Colors.blue),
        ChartSampleData(x: '4', y: 12, pointColor: Colors.orange),
        ChartSampleData(x: '5', y: 65, pointColor: Colors.pink),
        ChartSampleData(x: '6', y: 40, pointColor: Colors.brown[300]),
      ];
      count = 0;
    }
    if (timer != null) {
      timer.cancel();
    }
    return chartData;
  }
}
