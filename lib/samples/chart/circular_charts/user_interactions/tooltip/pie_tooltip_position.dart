import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class PieTooltipPosition extends StatefulWidget {
  PieTooltipPosition({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _PieTooltipPositionState createState() => _PieTooltipPositionState(sample);
}

class _PieTooltipPositionState extends State<PieTooltipPosition> {
  _PieTooltipPositionState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, TooltipPositioningPanel(sample));
  }
}

dynamic getPieTooltipPositionChart(bool isTileView,
    [TooltipPosition _tooltipPosition, double duration, SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCircularChart(
    title: ChartTitle(
        text:
            isTileView ? '' : 'Various countries population density and area'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: _getPieSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
      enable: true,
      tooltipPosition: isExistModel
          ? model.properties['PieTooltipPosition']
          : _tooltipPosition,
      duration:
          ((isExistModel ? model.properties['PieTooltipDelay'] : duration) ??
                  2.0) *
              1000,
    ),
  );
}

List<PieSeries<ChartSampleData, String>> _getPieSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
    ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
    ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
    ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
    ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
    ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
    ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%')
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}

//ignore: must_be_immutable
class TooltipPositioningPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  TooltipPositioningPanel([this.sample]);
  SubItem sample;

  @override
  _TooltipPositioningPanelState createState() =>
      _TooltipPositioningPanelState(sample);
}

class _TooltipPositioningPanelState extends State<TooltipPositioningPanel> {
  _TooltipPositioningPanelState(this.sample);
  final SubItem sample;

  final List<String> _tooltipPositionList =
      <String>['auto', 'pointer'].toList();
  String _selectedTooltipPosition = 'auto';
  TooltipPosition _tooltipPosition = TooltipPosition.auto;
  double duration = 2;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getPieTooltipPositionChart(false, null, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedTooltipPosition = 'auto';
    _tooltipPosition = TooltipPosition.auto;
    duration = 2;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'PieTooltipDelay': duration,
        'SelectedPieTooltipPosition': _selectedTooltipPosition,
        'PieTooltipPosition': _tooltipPosition
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
                          child: getPieTooltipPositionChart(
                              false, _tooltipPosition, duration)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getPieTooltipPositionChart(
                              false, null, null, model)),
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

  void onPositionTypeChange(String item, SampleModel model) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    model.properties['SelectedPieTooltipPosition'] = _selectedTooltipPosition;
    model.properties['PieTooltipPosition'] = _tooltipPosition;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
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
                      Text('Hide duration',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: CustomButton(
                          minValue: 1,
                          maxValue: 10,
                          step: 2,
                          initialValue: model.properties['PieTooltipDelay'],
                          onChanged: (dynamic val) => setState(() {
                            model.properties['PieTooltipDelay'] = val;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          }),
                          horizontal: true,
                          loop: true,
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
                      Text('Tooltip Position',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          height: 50,
                          width: 135,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor:
                                      model.bottomSheetBackgroundColor),
                              child: DropDown(
                                  value: model
                                      .properties['SelectedPieTooltipPosition'],
                                  item:
                                      _tooltipPositionList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null) ? value : 'auto',
                                        child: Text('$value',
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  valueChanged: (dynamic value) {
                                    onPositionTypeChange(
                                        value.toString(), model);
                                  }),
                            ),
                          )),
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
                                          children: <Widget>[
                                            Text('Tooltip position',
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
                                                            _selectedTooltipPosition,
                                                        item:
                                                            _tooltipPositionList
                                                                .map((String
                                                                    value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'auto',
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
                                                ))
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
                                            Text('Hide delay      ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        40, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 1,
                                                  maxValue: 10,
                                                  initialValue: duration,
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                    duration = val;
                                                  }),
                                                  step: 2,
                                                  horizontal: true,
                                                  loop: true,
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
                              ],
                            ),
                          ),
                        )),
                  ))));
    }
    return widget ?? Container();
  }
}
