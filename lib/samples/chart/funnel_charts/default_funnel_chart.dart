import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class FunnelDefault extends StatefulWidget {
  FunnelDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _FunnelDefaultState createState() => _FunnelDefaultState(sample);
}

class _FunnelDefaultState extends State<FunnelDefault> {
  _FunnelDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, DefaultFunnelFrontPanel(sample));
  }
}

SfFunnelChart getDefaultFunnelChart(bool isTileView,
    [double gapRatio, int neckWidth, int neckHeight, bool explode,
    SampleModel model]) {  
  final bool isExistModel = model != null && model.isWeb;
  gapRatio = (isExistModel
                    ? model.properties['FunnelGapRatio']
                    : gapRatio) ?? 0;
  neckWidth = (isExistModel
                    ? model.properties['FunnelNeckWidth']
                    : neckWidth) ?? 20;
  neckHeight = (isExistModel
                    ? model.properties['FunnelNeckHeight']
                    : neckHeight) ?? 20;
  explode = (isExistModel
                    ? model.properties['FunnelExplode']
                    : explode) ?? true;
  return SfFunnelChart(
    smartLabelMode: SmartLabelMode.shift,
    title: ChartTitle(text: isTileView ? '' : 'Website conversion rate'),
    tooltipBehavior: TooltipBehavior(enable: true),
    series:
        _getFunnelSeries(isTileView, gapRatio, neckWidth, neckHeight, explode),
  );
}

FunnelSeries<ChartSampleData, String> _getFunnelSeries(bool isTileView,
    [double _gapRatio, int _neckWidth, int _neckHeight, bool _explode]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Purchased ', y: 150),
    ChartSampleData(x: 'Requested price list', y: 300),
    ChartSampleData(x: 'Downloaded trail', y: 600),
    ChartSampleData(x: 'Visit download page', y: 1500),
    ChartSampleData(x: 'Watched demo', y: 2600),
    ChartSampleData(x: 'Website visitors', y: 3000)
  ];
  return FunnelSeries<ChartSampleData, String>(
      dataSource: pieData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      explode: isTileView ? false : _explode,
      gapRatio: isTileView ? 0 : _gapRatio,
      neckHeight: isTileView ? '20%' : _neckHeight.toString() + '%',
      neckWidth: isTileView ? '20%' : _neckWidth.toString() + '%',
      dataLabelSettings: DataLabelSettings(isVisible: true));
}

//ignore: must_be_immutable
class DefaultFunnelFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DefaultFunnelFrontPanel([this.sample]);
  SubItem sample;

  @override
  _DefaultFunnelFrontPanelState createState() =>
      _DefaultFunnelFrontPanelState(sample);
}

class _DefaultFunnelFrontPanelState extends State<DefaultFunnelFrontPanel> {
  _DefaultFunnelFrontPanelState(this.sample);
  final SubItem sample;
  double gapRatio = 0;
  int neckWidth = 20;
  int neckHeight = 20;
  bool explode = false;
   Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getDefaultFunnelChart(false, null, null, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
     gapRatio = 0;
   neckWidth = 20;
   neckHeight = 20;
   explode = false;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'FunnelGapRatio': gapRatio,
        'FunnelNeckWidth': neckWidth,
        'FunnelNeckHeight': neckHeight,
        'FunnelExplode': explode
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
              body: !model.isWeb? Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getDefaultFunnelChart(
                        false, gapRatio, neckWidth, neckHeight, explode)),
              ) : Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Container(
                        child: getDefaultFunnelChart(
                            false, null, null, null, null, model)),
                  ),
              floatingActionButton: model.isWeb
                  ? null
                  : Stack(children: <Widget>[
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
                    ]));
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
                      Text('Gap Ratio   ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: CustomButton(
                          minValue: 0,
                          maxValue: 0.5,
                          step: 0.1,
                          initialValue: model.properties['FunnelGapRatio'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['FunnelGapRatio'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          iconUpRightColor: model.textColor,
                          iconDownLeftColor: model.textColor,
                          style:
                              TextStyle(fontSize: 15.0, color: model.textColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Neck height  ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: CustomButton(
                          minValue: 0,
                          maxValue: 50,
                          initialValue: model.properties['FunnelNeckHeight'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['FunnelNeckHeight'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          step: 10,
                          iconUpRightColor: model.textColor,
                          iconDownLeftColor: model.textColor,
                          style:
                              TextStyle(fontSize: 15.0, color: model.textColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Neck Width  ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: CustomButton(
                          minValue: 0,
                          maxValue: 50,
                          initialValue: model.properties['FunnelNeckWidth'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['FunnelNeckWidth'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          step:10,
                          iconUpRightColor: model.textColor,
                          iconDownLeftColor: model.textColor,
                          style:
                              TextStyle(fontSize: 15.0, color: model.textColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Explode   ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: BottomSheetCheckbox(
                          activeColor: model.backgroundColor,
                          switchValue: model.properties['FunnelExplode'],
                          valueChanged: (dynamic value) {
                            model.properties['FunnelExplode'] = value;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          },
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Gap ratio  ',
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
                                                  maxValue: 0.5,
                                                  initialValue: gapRatio,
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    gapRatio = val;
                                                  }),
                                                  step: 0.1,
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
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Neck height  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        25, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 0,
                                                  maxValue: 50,
                                                  initialValue:
                                                      neckHeight.toDouble(),
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    neckHeight = val.toInt();
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
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Neck width',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        35, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 0,
                                                  maxValue: 50,
                                                  initialValue:
                                                      neckWidth.toDouble(),
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    neckWidth = val.toInt();
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
                                          children: <Widget>[
                                            Text('Explode',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 0, 0)),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
                                              switchValue: explode,
                                              valueChanged: (dynamic value) {
                                                setState(() {
                                                  explode = value;
                                                });
                                              },
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
