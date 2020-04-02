import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class PyramidSmartLabels extends StatefulWidget {
  PyramidSmartLabels({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _PyramidSmartLabelState createState() => _PyramidSmartLabelState(sample);
}

class _PyramidSmartLabelState extends State<PyramidSmartLabels> {
  _PyramidSmartLabelState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, PyramidSmartLabelsFrontPanel(sample));
  }
}

SfPyramidChart getPyramidSmartLabelChart(bool isTileView,
    [ChartDataLabelPosition _labelPosition, SmartLabelMode _mode]) {
  return SfPyramidChart(
    onTooltipRender: (TooltipArgs args) {
      final NumberFormat format = NumberFormat.decimalPattern();
      args.text = format.format(args.dataPoints[args.pointIndex].y).toString();
    },
    title:
        ChartTitle(text: isTileView ? '' : 'Top 10 populated countries - 2019'),
    tooltipBehavior: TooltipBehavior(enable: true),
    smartLabelMode: isTileView ? SmartLabelMode.shift : _mode,
    series: _getPyramidSeries(
      isTileView,
      _labelPosition,
    ),
  );
}

PyramidSeries<ChartSampleData, String> _getPyramidSeries(bool isTileView,
    [ChartDataLabelPosition _labelPosition,
    LabelIntersectAction _labelIntersectAction]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(
        x: 'Mexico',
        y: 127575529,
        text: null,
        pointColor: const Color.fromRGBO(238, 238, 238, 1)),
    ChartSampleData(
        x: 'Russia ',
        y: 145872256,
        text: null,
        pointColor: const Color.fromRGBO(255, 240, 219, 1)),
    ChartSampleData(
        x: 'Bangladesh',
        y: 163046161,
        text: null,
        pointColor: const Color.fromRGBO(255, 205, 96, 1)),
    ChartSampleData(
        x: 'Nigeria ',
        y: 200963599,
        text: null,
        pointColor: const Color.fromRGBO(73, 76, 162, 1)),
    ChartSampleData(
        x: 'Brazil',
        y: 211049527,
        text: null,
        pointColor: const Color.fromRGBO(0, 168, 181, 1)),
    ChartSampleData(
        x: 'Pakistan ',
        y: 216565318,
        text: null,
        pointColor: const Color.fromRGBO(116, 180, 155, 1)),
    ChartSampleData(
        x: 'Indonesia',
        y: 270625568,
        text: null,
        pointColor: const Color.fromRGBO(248, 177, 149, 1)),
    ChartSampleData(
        x: 'US',
        y: 329064917,
        text: null,
        pointColor: const Color.fromRGBO(246, 114, 128, 1)),
    ChartSampleData(
        x: 'India',
        y: 1366417754,
        text: null,
        pointColor: const Color.fromRGBO(192, 108, 132, 1)),
    ChartSampleData(
        x: 'China',
        y: 1433783686,
        text: null,
        pointColor: const Color.fromRGBO(53, 92, 125, 1)),
  ];
  return PyramidSeries<ChartSampleData, String>(
      width: '60%',
      dataSource: pieData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      textFieldMapper: (ChartSampleData data, _) => data.x,
      pointColorMapper: (ChartSampleData data, _) => data.pointColor,
      dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition:
              isTileView ? ChartDataLabelPosition.outside : _labelPosition,
          useSeriesColor: true));
}

//ignore: must_be_immutable
class PyramidSmartLabelsFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  PyramidSmartLabelsFrontPanel([this.sample]);
  SubItem sample;
  
  @override
  _PyramidSmartLabelsFrontPanelState createState() => _PyramidSmartLabelsFrontPanelState(sample);
}

class _PyramidSmartLabelsFrontPanelState extends State<PyramidSmartLabelsFrontPanel> {
  _PyramidSmartLabelsFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _labelPositon = <String>['outside', 'inside'].toList();
  ChartDataLabelPosition _selectedLabelPosition = ChartDataLabelPosition.outside;
  String _selectedPosition;

  final List<String> _modeList = <String>['shift', 'none', 'hide'].toList();
  String _smartLabelMode = 'shift';
  SmartLabelMode _mode = SmartLabelMode.shift;
Widget sampleWidget(SampleModel model) => getPyramidSmartLabelChart(false);
  @override
  void initState() {
    super.initState();
    _selectedPosition = _labelPositon.first;
    _selectedLabelPosition = ChartDataLabelPosition.outside;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(
                    child: getPyramidSmartLabelChart(
                        false, _selectedLabelPosition, _mode)),
              ),
              floatingActionButton: model.isWeb ? null :
              Stack(children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: Container(
                      height: 50,
                      width: 250,
                      child: InkWell(
                        onTap: () => launch(
                            'https://www.worldometers.info/world-population/population-by-country/'),
                        child: Row(
                          children: <Widget>[
                            Text('Source: ',
                                style: TextStyle(
                                    fontSize: 16, color: model.textColor)),
                            const Text('worldometers.com',
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
              ]));
        });
  }

  void onLabelPositionChange(String item) {
    setState(() {
      _selectedPosition = item;
      if (_selectedPosition == 'inside') {
        _selectedLabelPosition = ChartDataLabelPosition.inside;
      } else if (_selectedPosition == 'outside') {
        _selectedLabelPosition = ChartDataLabelPosition.outside;
      }
    });
  }

  void onSmartLabelModeChange(String item, SampleModel model) {
    setState(() {
      _smartLabelMode = item;
      if (_smartLabelMode == 'shift') {
        _mode = SmartLabelMode.shift;
      }
      if (_smartLabelMode == 'hide') {
        _mode = SmartLabelMode.hide;
      }
      if (_smartLabelMode == 'none') {
        _mode = SmartLabelMode.none;
      }
    });
  }

  void _showSettingsPanel(SampleModel model) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
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
                                            Text('Label position         ',
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
                                                        value:
                                                            _selectedPosition,
                                                        item: _labelPositon.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'outside',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onLabelPositionChange(
                                                              value.toString());
                                                        }),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Smart label mode ',
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
                                                        value: _smartLabelMode,
                                                        item: _modeList.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'shift',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onSmartLabelModeChange(
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