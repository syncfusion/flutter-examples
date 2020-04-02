import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class LabelAction extends StatefulWidget {
  LabelAction({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LabelActionState createState() => _LabelActionState(sample);
}

class _LabelActionState extends State<LabelAction> {
  _LabelActionState(this.sample);

  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, LabelCollisionFrontPanel(sample));
  }
}

SfCartesianChart getLabelIntersectActionChart(bool isTileView,
    [AxisLabelIntersectAction _labelIntersectAction]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title:
        ChartTitle(text: isTileView ? '' : 'Football players with most goals'),
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelIntersectAction: _labelIntersectAction),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        interval: 40,
        majorTickLines: MajorTickLines(size: 0)),
    series: getLabelIntersectActionSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y Goals',
        header: '',
        canShowMarker: false),
  );
}

List<ColumnSeries<ChartSampleData, String>> getLabelIntersectActionSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Josef Bican', y: 805),
    ChartSampleData(x: 'Romário', y: 772),
    ChartSampleData(x: 'Pelé', y: 761),
    ChartSampleData(x: 'Ferenc Puskás', y: 746),
    ChartSampleData(x: 'Gerd Müller', y: 735),
    ChartSampleData(x: 'Ronaldo', y: 707),
    ChartSampleData(x: 'Messi', y: 698)
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top))
  ];
}
//ignore: must_be_immutable
class LabelCollisionFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  LabelCollisionFrontPanel([this.sample]);

  SubItem sample;

  @override
  _LabelCollisionFrontPanelState createState() =>
      _LabelCollisionFrontPanelState(sample);
}

class _LabelCollisionFrontPanelState extends State<LabelCollisionFrontPanel> {
  _LabelCollisionFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _labelList = <String>[
    'hide',
    'none',
    'multipleRows',
    'rotate45',
    'rotate90',
    'wrap'
  ].toList();

  String _selectedType = 'hide';

  AxisLabelIntersectAction _labelIntersectAction =
      AxisLabelIntersectAction.hide;

  Widget sampleWidget(SampleModel model) => getLabelIntersectActionChart(false);

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
                    child: getLabelIntersectActionChart(
                        false, _labelIntersectAction)),
              ),
              floatingActionButton: model.isWeb ? null :
              Stack(
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
                          child: Row(
                            children: <Widget>[
                              Text('Source: ',
                                  style: TextStyle(
                                      fontSize: 16, color: model.textColor)),
                              const Text('en.wikipedia.org',
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
                ],
              ));
        });
  }

  void onPositionTypeChange(String item, SampleModel model) {
    setState(() {
      _selectedType = item;
      if (_selectedType == 'hide') {
        _labelIntersectAction = AxisLabelIntersectAction.hide;
      }
      if (_selectedType == 'none') {
        _labelIntersectAction = AxisLabelIntersectAction.none;
      }
      if (_selectedType == 'multipleRows') {
        _labelIntersectAction = AxisLabelIntersectAction.multipleRows;
      }
      if (_selectedType == 'rotate45') {
        _labelIntersectAction = AxisLabelIntersectAction.rotate45;
      }
      if (_selectedType == 'rotate90') {
        _labelIntersectAction = AxisLabelIntersectAction.rotate90;
      }
      if (_selectedType == 'wrap') {
        _labelIntersectAction = AxisLabelIntersectAction.wrap;
      }
    });
  }

  void _showSettingsPanel(SampleModel model) {
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
                                            Text('Intersect action ',
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
                                                        item: _labelList.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'hide',
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
