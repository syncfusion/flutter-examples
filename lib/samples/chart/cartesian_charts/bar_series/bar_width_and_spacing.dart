import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BarSpacing extends StatefulWidget {
  BarSpacing({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BarSpacingState createState() => _BarSpacingState(sample);
}

class _BarSpacingState extends State<BarSpacing> {
  _BarSpacingState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, BarSettingsFrontPanel(sample));
  }
}

SfCartesianChart getSpacingBarChart(bool isTileView,
    [double columnWidth, double columnSpacing, SampleModel model]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Exports & Imports of US'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: NumericAxis(
        minimum: 2005,
        maximum: 2011,
        interval: 1,
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
      labelFormat: '{value}%',
      title: AxisTitle(text: isTileView ? '' : 'Goods and services (% of GDP)'),
    ),
    series: getSpacingBarSeries(isTileView, columnWidth, columnSpacing, model),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<BarSeries<ChartSampleData, num>> getSpacingBarSeries(bool isTileView,
    double columnWidth, double columnSpacing, SampleModel model) {
  final bool isExistModel = model != null && model.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2006, y: 16.219, yValue2: 10.655),
    ChartSampleData(x: 2007, y: 16.461, yValue2: 11.498),
    ChartSampleData(x: 2008, y: 17.427, yValue2: 12.514),
    ChartSampleData(x: 2009, y: 13.754, yValue2: 11.012),
    ChartSampleData(x: 2010, y: 15.743, yValue2: 12.315),
  ];
  return <BarSeries<ChartSampleData, num>>[
    BarSeries<ChartSampleData, num>(
        enableTooltip: true,
        width: isExistModel
            ? model.properties['BarWidth']
            : isTileView ? 0.8 : columnWidth,
        spacing: isExistModel
            ? model.properties['BarSpacing']
            : isTileView ? 0.2 : columnSpacing,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Import'),
    BarSeries<ChartSampleData, num>(
        enableTooltip: true,
        width: isExistModel
            ? model.properties['BarWidth']
            : isTileView ? 0.8 : columnWidth,
        spacing: isExistModel
            ? model.properties['BarSpacing']
            : isTileView ? 0.2 : columnSpacing,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Export')
  ];
}

//ignore:must_be_immutable
class BarSettingsFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  BarSettingsFrontPanel([this.sample]);
  SubItem sample;

  @override
  _BarSettingsFrontPanelState createState() =>
      _BarSettingsFrontPanelState(sample);
}

class _BarSettingsFrontPanelState extends State<BarSettingsFrontPanel> {
  _BarSettingsFrontPanelState(this.sample);
  final SubItem sample;
  double columnWidth = 0.8;
  double columnSpacing = 0.2;
  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getSpacingBarChart(false, null, null, model);

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
    columnWidth = 0.8;
    columnSpacing = 0.2;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'BarWidth': columnWidth,
        'BarSpacing': columnSpacing
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
                          child: getSpacingBarChart(
                              false, columnWidth, columnSpacing, null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getSpacingBarChart(false, null, null, null)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        _showSettingsPanel(model, false, context);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ));
        });
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
                  Text('Width  ',
                      style: TextStyle(fontSize: 14.0, color: model.textColor)),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: CustomButton(
                        minValue: 0,
                        maxValue: 0.9,
                        initialValue: model.properties['BarWidth'],
                        onChanged: (dynamic val) {
                          columnWidth = val;
                          model.properties['BarWidth'] = columnWidth = val;
                          if (model.isWeb)
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          else
                            setState(() {});
                        },
                        step: 0.1,
                        horizontal: true,
                        loop: true,
                        padding: 0,
                        iconUp: Icons.keyboard_arrow_up,
                        iconDown: Icons.keyboard_arrow_down,
                        iconLeft: Icons.keyboard_arrow_left,
                        iconRight: Icons.keyboard_arrow_right,
                        iconUpRightColor: model.textColor,
                        iconDownLeftColor: model.textColor,
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text('Spacing  ',
                        style:
                            TextStyle(fontSize: 14.0, color: model.textColor)),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: CustomButton(
                        minValue: 0,
                        maxValue: 1,
                        initialValue: model.properties['BarSpacing'],
                        onChanged: (dynamic val) {
                          columnSpacing = val;
                          model.properties['BarSpacing'] = columnSpacing = val;
                          if (model.isWeb)
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          else
                            setState(() {});
                        },
                        step: 0.1,
                        horizontal: true,
                        loop: true,
                        padding: 5.0,
                        iconUp: Icons.keyboard_arrow_up,
                        iconDown: Icons.keyboard_arrow_down,
                        iconLeft: Icons.keyboard_arrow_left,
                        iconRight: Icons.keyboard_arrow_right,
                        iconUpRightColor: model.textColor,
                        iconDownLeftColor: model.textColor,
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  )
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
                                                  maxValue: 1,
                                                  initialValue: columnWidth,
                                                  onChanged: (double val) =>
                                                      setState(() {
                                                    columnWidth = val;
                                                  }),
                                                  step: 0.1,
                                                  horizontal: true,
                                                  loop: true,
                                                  padding: 0,
                                                  iconUp:
                                                      Icons.keyboard_arrow_up,
                                                  iconDown:
                                                      Icons.keyboard_arrow_down,
                                                  iconLeft:
                                                      Icons.keyboard_arrow_left,
                                                  iconRight: Icons
                                                      .keyboard_arrow_right,
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
                                                  maxValue: 0.9,
                                                  initialValue: columnSpacing,
                                                  onChanged: (double val) =>
                                                      setState(() {
                                                    columnSpacing = val;
                                                  }),
                                                  step: 0.1,
                                                  horizontal: true,
                                                  loop: true,
                                                  padding: 5.0,
                                                  iconUp:
                                                      Icons.keyboard_arrow_up,
                                                  iconDown:
                                                      Icons.keyboard_arrow_down,
                                                  iconLeft:
                                                      Icons.keyboard_arrow_left,
                                                  iconRight: Icons
                                                      .keyboard_arrow_right,
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
    return widget ?? Container();
  }
}
