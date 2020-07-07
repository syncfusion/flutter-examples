import 'package:flutter/foundation.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class ColumnSpacing extends StatefulWidget {
  ColumnSpacing({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ColumnSpacingState createState() => _ColumnSpacingState(sample);
}

class _ColumnSpacingState extends State<ColumnSpacing> {
  _ColumnSpacingState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, ColumnSettingsFrontPanel(sample));
  }
}

SfCartesianChart getSpacingColumnChart(bool isTileView,
    [SampleModel sampleModel, double columnWidth, double columnSpacing]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Winter olympic medals count'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        maximum: 150,
        minimum: 0,
        interval: 25,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series:
        getDefaultColumn(isTileView, columnWidth, columnSpacing, sampleModel),
    legend: Legend(isVisible: isTileView ? false : true),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ColumnSeries<ChartSampleData, String>> getDefaultColumn(bool isTileView,
    [double columnWidth, double columnSpacing, SampleModel sampleModel]) {
  final bool isExistModel = sampleModel != null && sampleModel.isWeb;
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Germany', y: 128, yValue2: 129, yValue3: 101),
    ChartSampleData(x: 'Russia', y: 123, yValue2: 92, yValue3: 93),
    ChartSampleData(x: 'Norway', y: 107, yValue2: 106, yValue3: 90),
    ChartSampleData(x: 'USA', y: 87, yValue2: 95, yValue3: 71),
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        width: isExistModel
            ? sampleModel.properties['ColumnWidth']
            : isTileView ? 0.8 : columnWidth,
        spacing: isExistModel
            ? sampleModel.properties['ColumnSpacing']
            : isTileView ? 0.2 : columnSpacing,
        dataSource: chartData,
        color: const Color.fromRGBO(252, 216, 20, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Gold'),
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        width: isExistModel
            ? sampleModel.properties['ColumnWidth']
            : isTileView ? 0.8 : columnWidth,
        spacing: isExistModel
            ? sampleModel.properties['ColumnSpacing']
            : isTileView ? 0.2 : columnSpacing,
        color: const Color.fromRGBO(169, 169, 169, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Silver'),
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        width: isExistModel
            ? sampleModel.properties['ColumnWidth']
            : isTileView ? 0.8 : columnWidth,
        spacing: isExistModel
            ? sampleModel.properties['ColumnSpacing']
            : isTileView ? 0.2 : columnSpacing,
        color: const Color.fromRGBO(205, 127, 50, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Bronze')
  ];
}

//ignore: must_be_immutable
class ColumnSettingsFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  ColumnSettingsFrontPanel([this.sample]);
  SubItem sample;

  @override
  _ColumnSettingsFrontPanelState createState() =>
      _ColumnSettingsFrontPanelState(sample);
}

class _ColumnSettingsFrontPanelState extends State<ColumnSettingsFrontPanel> {
  _ColumnSettingsFrontPanelState(this.sample);
  SubItem sample;
  double columnWidth = 0.8;
  double columnSpacing = 0.2;
  TextEditingController editingController = TextEditingController();
  TextEditingController spacingEditingController = TextEditingController();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) => getSpacingColumnChart(false, model);

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
        'ColumnWidth': columnWidth,
        'ColumnSpacing': columnSpacing
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
                          child: getSpacingColumnChart(
                              false, null, columnWidth, columnSpacing)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child:
                              getSpacingColumnChart(false, null, null, null)),
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
                    style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
                        initialValue: model.properties['ColumnWidth'],
                        onChanged: (dynamic val) {
                          columnWidth = val;
                          model.properties['ColumnWidth'] = columnWidth = val;
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
                        initialValue: model.properties['ColumnSpacing'],
                        onChanged: (dynamic val) {
                          columnSpacing = val;
                          model.properties['ColumnSpacing'] =
                              columnSpacing = val;
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
                                                  maxValue: 0.9,
                                                  initialValue: columnWidth,
                                                  onChanged: (dynamic val) =>
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
                                                  maxValue: 1,
                                                  initialValue: columnSpacing,
                                                  onChanged: (dynamic val) =>
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
    return widget;
  }
}
