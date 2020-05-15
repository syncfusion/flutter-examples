import 'package:flutter/foundation.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class PieSemi extends StatefulWidget {
  PieSemi({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PieSemiState createState() => _PieSemiState(sample);
}

class _PieSemiState extends State<PieSemi> {
  _PieSemiState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, SemiPieFrontPanel(sample));
  }
}

SfCircularChart getSemiPieChart(bool isTileView,
    [int startAngle, int endAngle, SampleModel model]) {
  return SfCircularChart(
    centerY: '60%',
    title: ChartTitle(
        text: isTileView ? '' : 'Rural population of various countries'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: getSemiPieSeries(isTileView, startAngle, endAngle, model),
    tooltipBehavior:
        TooltipBehavior(enable: true, format: 'point.x : point.y%'),
  );
}

List<PieSeries<ChartSampleData, String>> getSemiPieSeries(
    bool isTileView, int startAngle, int endAngle, SampleModel model) {
  final bool isExistModel = model != null && model.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Algeria', y: 28),
    ChartSampleData(x: 'Australia', y: 14),
    ChartSampleData(x: 'Bolivia', y: 31),
    ChartSampleData(x: 'Cambodia', y: 77),
    ChartSampleData(x: 'Canada', y: 19),
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        startAngle:
            (isExistModel ? model.properties['PieStartAngle'] : startAngle) ??
                270,
        endAngle:
            (isExistModel ? model.properties['PieEndAngle'] : endAngle) ?? 90,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.inside))
  ];
}

//ignore: must_be_immutable
class SemiPieFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  SemiPieFrontPanel([this.sample]);
  SubItem sample;

  @override
  _SemiPieFrontPanelState createState() => _SemiPieFrontPanelState(sample);
}

class _SemiPieFrontPanelState extends State<SemiPieFrontPanel> {
  _SemiPieFrontPanelState(this.sample);
  final SubItem sample;
  int startAngle = 270;
  int endAngle = 90;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getSemiPieChart(false, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    startAngle = 270;
    endAngle = 90;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'PieStartAngle': startAngle,
        'PieEndAngle': endAngle
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
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                      child: Container(
                          child: getSemiPieChart(false, startAngle, endAngle)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getSemiPieChart(false, null, null, model)),
                    ),
              floatingActionButton: model.isWeb
                  ? Container()
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
                                    'https://data.worldbank.org/indicator/sp.rur.totl.zs'),
                                child: Row(
                                  children: <Widget>[
                                    Text('Source: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: model.textColor)),
                                    const Text('data.worldbank.org',
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

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    HandCursor(
                        child: IconButton(
                      icon: Icon(Icons.close, color: model.webIconColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Start Angle',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                       CustomButton(
                          minValue: 90,
                          maxValue: 270,
                          initialValue: model.properties['PieStartAngle'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['PieStartAngle'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          loop: false,
                          step: 10,
                          iconUpRightColor: model.textColor,
                          iconDownLeftColor: model.textColor,
                          style:
                              TextStyle(fontSize: 15.0, color: model.textColor),
                        ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('End Angle',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: CustomButton(
                          minValue: 90,
                          maxValue: 270,
                          initialValue: model.properties['PieEndAngle'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['PieEndAngle'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          loop: false,
                          step: 10,
                          iconUpRightColor: model.textColor,
                          iconDownLeftColor: model.textColor,
                          style:
                              TextStyle(fontSize: 15.0, color: model.textColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ));
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
                              height:
                                  MediaQuery.of(context).size.height * height,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Start Angle  ',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: model.textColor)),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 0),
                                                  child: CustomButton(
                                                    minValue: 90,
                                                    maxValue: 270,
                                                    initialValue:
                                                        startAngle.toDouble(),
                                                    onChanged: (dynamic val) =>
                                                        setState(() {
                                                      startAngle = val.toInt();
                                                    }),
                                                    step: 10,
                                                    horizontal: true,
                                                    loop: false,
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 15, 0, 0),
                                                child: Text('End Angle ',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color:
                                                            model.textColor)),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          50, 0, 0, 0),
                                                  child: CustomButton(
                                                    minValue: 90,
                                                    maxValue: 270,
                                                    initialValue:
                                                        endAngle.toDouble(),
                                                    onChanged: (dynamic val) =>
                                                        setState(() {
                                                      endAngle = val.toInt();
                                                    }),
                                                    step: 10,
                                                    horizontal: true,
                                                    loop: false,
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
                                      ],
                                    ),
                                  ),
                                ]),
                              )))))));
    }
    return widget ?? Container();
  }
}
