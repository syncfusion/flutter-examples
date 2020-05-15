import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore: must_be_immutable
class CartesianTooltipPosition extends StatefulWidget {
  CartesianTooltipPosition({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _TooltipPositionState createState() => _TooltipPositionState(sample);
}

class _TooltipPositionState extends State<CartesianTooltipPosition> {
  _TooltipPositionState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, ChartTooltipPositioningPanel(sample));
  }
}

dynamic getCartesianTooltipPositionChart(bool isTileView,
    [String chartType, TooltipPosition _tooltipPosition, SampleModel model]) {
  dynamic _chart;
  final bool isExistModel = model != null && model.isWeb;
  _chart = SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Age distribution'),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        tooltipPosition: isExistModel
            ? model.properties['TooltipPosition']
            : _tooltipPosition,
        canShowMarker: false),
    primaryXAxis: CategoryAxis(
        title: AxisTitle(text: isTileView ? '' : 'Years'),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: _getCartesianSeries(isTileView),
  );
  return _chart;
}

final List<_ChartData> chartData = <_ChartData>[
  _ChartData(
    '<5',
    5.55,
    const Color.fromRGBO(53, 92, 125, 1),
  ),
  _ChartData(
    '5-15',
    11.61,
    const Color.fromRGBO(192, 108, 132, 1),
  ),
  _ChartData(
    '15-24',
    12.87,
    const Color.fromRGBO(246, 114, 128, 1),
  ),
  _ChartData('25-64', 69.59, const Color.fromRGBO(248, 177, 149, 1)),
  _ChartData('>65', 28.92, const Color.fromRGBO(116, 180, 155, 1))
];
List<ChartSeries<_ChartData, String>> _getCartesianSeries(bool isTileView) {
  return <ColumnSeries<_ChartData, String>>[
    ColumnSeries<_ChartData, String>(
        dataSource: chartData,
        pointColorMapper: (_ChartData sales, _) => sales.color,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y1,
        name: 'Japan - 2010'),
  ];
}

List<PieSeries<_ChartData, String>> getPieSeries(bool isTileView) {
  return <PieSeries<_ChartData, String>>[
    PieSeries<_ChartData, String>(
        dataSource: chartData,
        xValueMapper: (_ChartData data, _) => data.x,
        yValueMapper: (_ChartData data, _) => data.y1,
        name: 'Japan - 2010'),
  ];
}

class _ChartData {
  _ChartData(this.x, this.y1, [this.color]);
  final String x;
  final double y1;
  final Color color;
}

//ignore: must_be_immutable
class ChartTooltipPositioningPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  ChartTooltipPositioningPanel([this.sample]);
  SubItem sample;

  @override
  _TooltipPositioningPanelState createState() =>
      _TooltipPositioningPanelState(sample);
}

class _TooltipPositioningPanelState
    extends State<ChartTooltipPositioningPanel> {
  _TooltipPositioningPanelState([this.sample]);
  final SubItem sample;

  // final List<String> _modeList =
  //     <String>['column', 'pie'].toList();
  String _selectedChartType = 'column';

  String _chartType = 'column';

  final List<String> _tooltipPositionList =
      <String>['auto', 'pointer'].toList();
  String _selectedTooltipPosition = 'auto';
  TooltipPosition _tooltipPosition = TooltipPosition.auto;

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getCartesianTooltipPositionChart(false, null, null, model);

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
    _selectedTooltipPosition = 'auto';
    _tooltipPosition = TooltipPosition.auto;
    _selectedChartType = 'column';
    _chartType = 'column';
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'SelectedTooltipPosition': _selectedTooltipPosition,
        'TooltipPosition': _tooltipPosition,
        'SelectedChartType': _selectedChartType,
        'ChartType': _chartType
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
                          child: getCartesianTooltipPositionChart(
                              false, _chartType, _tooltipPosition, null)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getCartesianTooltipPositionChart(
                              false, null, null, null)),
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
    // setState(() {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    model.properties['SelectedTooltipPosition'] = _selectedTooltipPosition;
    model.properties['TooltipPosition'] = _tooltipPosition;
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
                children: <Widget>[
                  Text('Tooltip position     ',
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
                              value:
                                  model.properties['SelectedTooltipPosition'],
                              item: _tooltipPositionList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'auto',
                                    child: Text('$value',
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              valueChanged: (dynamic value) {
                                onPositionTypeChange(value.toString(), model);
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
                                      const EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  child: ListView(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Tooltip position     ',
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

  void onChartTypeChange(String item, SampleModel model) {
    setState(() {
      _selectedChartType = item;
      if (_selectedChartType == 'column') {
        _chartType = 'column';
      }
      if (_selectedChartType == 'pie') {
        _chartType = 'pie';
      }
      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
    });
  }
}
