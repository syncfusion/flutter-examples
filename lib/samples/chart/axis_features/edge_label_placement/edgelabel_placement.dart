import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class EdgeLabel extends StatefulWidget {
  EdgeLabel({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _EdgeLabelState createState() => _EdgeLabelState(sample);
}

class _EdgeLabelState extends State<EdgeLabel> {
  _EdgeLabelState(this.sample);

  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, EdgeLabelPlaceFrontPanel(sample));
  }
}

SfCartesianChart getEdgeLabelPlacementChart(bool isTileView,
    [EdgeLabelPlacement _edgeLabelPlacement]) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title: ChartTitle(text: isTileView ? '' : 'Fuel price in India'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: DateTime(2006, 4, 1),
        interval: 2,
        dateFormat: DateFormat.y(),
        intervalType: DateTimeIntervalType.years,
        maximum: DateTime(2016, 4, 1),
        edgeLabelPlacement:
            isTileView ? EdgeLabelPlacement.shift : _edgeLabelPlacement),
    primaryYAxis: NumericAxis(
      majorTickLines: MajorTickLines(width: 0.5),
      axisLine: AxisLine(width: 0),
      labelFormat: '₹{value}',
      minimum: 20,
      maximum: 80,
      edgeLabelPlacement: _edgeLabelPlacement,
      title: AxisTitle(text: isTileView ? '' : 'Rupees per litre'),
    ),
    series: getEdgeLabelPlacementSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x : point.y'),
  );
}

List<ChartSeries<ChartSampleData, DateTime>> getEdgeLabelPlacementSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2005, 4, 1), y: 37.99, yValue2: 28.22),
    ChartSampleData(x: DateTime(2006, 4, 1), y: 43.5, yValue2: 30.45),
    ChartSampleData(x: DateTime(2007, 4, 1), y: 43, yValue2: 30.25),
    ChartSampleData(x: DateTime(2008, 4, 1), y: 45.5, yValue2: 31.76),
    ChartSampleData(x: DateTime(2009, 4, 1), y: 44.7, yValue2: 30.86),
    ChartSampleData(x: DateTime(2010, 4, 1), y: 48, yValue2: 38.1),
    ChartSampleData(x: DateTime(2011, 4, 1), y: 58.5, yValue2: 37.75),
    ChartSampleData(x: DateTime(2012, 4, 1), y: 65.6, yValue2: 40.91),
    ChartSampleData(x: DateTime(2013, 4, 1), y: 66.09, yValue2: 48.63),
    ChartSampleData(x: DateTime(2014, 4, 1), y: 72.26, yValue2: 55.48),
    ChartSampleData(x: DateTime(2015, 4, 1), y: 60.49, yValue2: 49.71),
    ChartSampleData(x: DateTime(2016, 4, 1), y: 59.68, yValue2: 48.33)
  ];
  return <ChartSeries<ChartSampleData, DateTime>>[
    SplineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings:
            MarkerSettings(isVisible: true, shape: DataMarkerType.pentagon),
        name: 'Petrol'),
    SplineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        markerSettings:
            MarkerSettings(isVisible: true, shape: DataMarkerType.pentagon),
        name: 'Diesel')
  ];
}

class EdgeLabelPlaceFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  EdgeLabelPlaceFrontPanel(this.subItemList);

  final SubItem subItemList;

  @override
  _EdgeLabelPlaceFrontPanelState createState() =>
      _EdgeLabelPlaceFrontPanelState(subItemList);
}

class _EdgeLabelPlaceFrontPanelState extends State<EdgeLabelPlaceFrontPanel> {
  _EdgeLabelPlaceFrontPanelState(this.sample);

  final SubItem sample;
  final List<String> _edgeList = <String>['hide', 'none', 'shift'].toList();

  String _selectedType = 'shift';

  EdgeLabelPlacement _edgeLabelPlacement = EdgeLabelPlacement.shift;

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
                    child:
                        getEdgeLabelPlacementChart(false, _edgeLabelPlacement)),
              ),
              floatingActionButton: Stack(
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
                              'https://www.mycarhelpline.com/index.php?option=com_easyblog&view=entry&id=808&Itemid=91'),
                          child: Row(
                            children: <Widget>[
                              Text('Source: ',
                                  style: TextStyle(
                                      fontSize: 16, color: model.textColor)),
                              Text('www.mycarhelpline.com',
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
        _edgeLabelPlacement = EdgeLabelPlacement.hide;
      }
      if (_selectedType == 'none') {
        _edgeLabelPlacement = EdgeLabelPlacement.none;
      }
      if (_selectedType == 'shift') {
        _edgeLabelPlacement = EdgeLabelPlacement.shift;
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
                    height: 120,
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
                                          children: <Widget>[
                                            Text('Edge label placement',
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
                                                width: 100,
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
                                                        item: _edgeList.map(
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
