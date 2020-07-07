/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/customDropDown.dart';

/// Renders the line chart with category label placement sample.
class CategoryTicks extends SampleView {
  const CategoryTicks(Key key) : super(key: key);

  @override
  _CategoryTicksState createState() => _CategoryTicksState();
}

/// State class of the line chart with category label placement.
class _CategoryTicksState extends SampleViewState {
  _CategoryTicksState();
  final List<String> _labelPosition =
      <String>['betweenTicks', 'onTicks'].toList();
  String _selectedType;
  LabelPlacement _labelPlacement;

  @override
  void initState() {
    _selectedType = 'betweenTicks';
    _labelPlacement = LabelPlacement.betweenTicks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getTicksCategoryAxisChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Label placement ',
                style: TextStyle(
                    color: model.textColor,
                    fontSize: 16,
                    letterSpacing: 0.34,
                    fontWeight: FontWeight.normal)),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                height: 50,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: DropDown(
                        value: _selectedType,
                        item: _labelPosition.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'betweenTicks',
                              child: Text('$value',
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        valueChanged: (dynamic value) {
                          onPositionTypeChange(value.toString(), model);
                        }),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  /// Returns the line chart with category label placement.
  SfCartesianChart getTicksCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Employees task count'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelPlacement: _labelPlacement),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          minimum: 7,
          maximum: 12,
          interval: 1),
      series: getTicksCategoryAxisSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the line chart.
  List<LineSeries<ChartSampleData, String>> getTicksCategoryAxisSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'John', yValue: 10),
      ChartSampleData(x: 'Parker', yValue: 11),
      ChartSampleData(x: 'David', yValue: 9),
      ChartSampleData(x: 'Peter', yValue: 10),
      ChartSampleData(x: 'Antony', yValue: 11),
      ChartSampleData(x: 'Brit', yValue: 10)
    ];
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }

  /// Method for changing the label placement for the category axis in the line chart.
  void onPositionTypeChange(String item, SampleModel model) {
    _selectedType = item;
    if (_selectedType == 'betweenTicks') {
      _labelPlacement = LabelPlacement.betweenTicks;
    }
    if (_selectedType == 'onTicks') {
      _labelPlacement = LabelPlacement.onTicks;
    }
    setState(() {});
  }
}

// //ignore: must_be_immutable
// class LabelPlacementFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   LabelPlacementFrontPanel([this.sample]);
//   SubItem sample;

//   @override
//   _LabelPlacementFrontPanelState createState() =>
//       _LabelPlacementFrontPanelState(sample);
// }

// class _LabelPlacementFrontPanelState extends State<LabelPlacementFrontPanel> {
//   _LabelPlacementFrontPanelState(this.sample);
//   final SubItem sample;
//   final List<String> _labelPosition =
//       <String>['betweenTicks', 'onTicks'].toList();
//   String _selectedType;
//   LabelPlacement _labelPlacement;

//   Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
//       _showSettingsPanel(model, init, context);
//   Widget sampleWidget(SampleModel model) =>
//       getTicksCategoryAxisChart(false, null, model);

//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     _selectedType = 'betweenTicks';
//     _labelPlacement = LabelPlacement.betweenTicks;
//     if (sampleModel != null && init) {
//       sampleModel.properties.addAll(<dynamic, dynamic>{
//         'SeletedLabelPlacementType': _selectedType,
//         'LabelPlacement': _labelPlacement
//       });
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<SampleModel>(
//         rebuildOnChange: true,
//         builder: (BuildContext context, _, SampleModel model) {
//           return Scaffold(
//               backgroundColor: model.cardThemeColor,
//               body: !model.isWeb
//                   ? Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
//                       child: Container(
//                           child: getTicksCategoryAxisChart(
//                               false, _labelPlacement, null)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child: getTicksCategoryAxisChart(false, null, null)),
//                     ),
//               floatingActionButton: model.isWeb
//                   ? null
//                   : FloatingActionButton(
//                       onPressed: () {
//                         _showSettingsPanel(model, false, context);
//                       },
//                       child: Icon(Icons.graphic_eq, color: Colors.white),
//                       backgroundColor: model.backgroundColor,
//                     ));
//         });
//   }

//   Widget _showSettingsPanel(SampleModel model,
//       [bool init, BuildContext context]) {
//     Widget widget;
//     if (model.isWeb) {
//       initProperties(model, init);
//       widget = Padding(
//           padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//           child: ListView(
//             children: <Widget>[
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     const Text(
//                       'Properties',
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     HandCursor(
//                         child: IconButton(
//                       icon: Icon(Icons.close, color: model.textColor),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ))
//                   ]),
//               Row(
//                 children: <Widget>[
//                   Text('Label placement ',
//                       style: TextStyle(
//                           color: model.textColor,
//                           fontSize: 14,
//                           letterSpacing: 0.34,
//                           fontWeight: FontWeight.normal)),
//                   Container(
//                       padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                       height: 50,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Theme(
//                           data: Theme.of(context).copyWith(
//                               canvasColor: model.bottomSheetBackgroundColor),
//                           child: DropDown(
//                               value:
//                                   model.properties['SeletedLabelPlacementType'],
//                               item: _labelPosition.map((String value) {
//                                 return DropdownMenuItem<String>(
//                                     value: (value != null)
//                                         ? value
//                                         : 'betweenTicks',
//                                     child: Text('$value',
//                                         style:
//                                             TextStyle(color: model.textColor)));
//                               }).toList(),
//                               valueChanged: (dynamic value) {
//                                 onPositionTypeChange(value.toString(), model);
//                               }),
//                         ),
//                       )),
//                 ],
//               ),
//             ],
//           ));
//     } else {
//       showRoundedModalBottomSheet<dynamic>(
//           dismissOnTap: false,
//           context: context,
//           radius: 12.0,
//           color: model.bottomSheetBackgroundColor,
//           builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
//               rebuildOnChange: false,
//               builder: (BuildContext context, _, SampleModel model) =>
//                   Container(
//                     height: 120,
//                     padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
//                     child: Stack(children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text('Settings',
//                               style: TextStyle(
//                                   color: model.textColor,
//                                   fontSize: 18,
//                                   letterSpacing: 0.34,
//                                   fontWeight: FontWeight.w500)),
//                           IconButton(
//                             icon: Icon(
//                               Icons.close,
//                               color: model.textColor,
//                             ),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
//                         child: ListView(
//                           children: <Widget>[
//                             Row(
//                               children: <Widget>[
//                                 Text('Label placement ',
//                                     style: TextStyle(
//                                         color: model.textColor,
//                                         fontSize: 16,
//                                         letterSpacing: 0.34,
//                                         fontWeight: FontWeight.normal)),
//                                 Container(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                                     height: 50,
//                                     child: Align(
//                                       alignment: Alignment.bottomCenter,
//                                       child: Theme(
//                                         data: Theme.of(context).copyWith(
//                                             canvasColor: model
//                                                 .bottomSheetBackgroundColor),
//                                         child: DropDown(
//                                             value: _selectedType,
//                                             item: _labelPosition
//                                                 .map((String value) {
//                                               return DropdownMenuItem<String>(
//                                                   value: (value != null)
//                                                       ? value
//                                                       : 'betweenTicks',
//                                                   child: Text('$value',
//                                                       style: TextStyle(
//                                                           color: model
//                                                               .textColor)));
//                                             }).toList(),
//                                             valueChanged: (dynamic value) {
//                                               onPositionTypeChange(
//                                                   value.toString(), model);
//                                             }),
//                                       ),
//                                     )),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ]),
//                   )));
//     }
//     return widget ?? Container();
//   }
// }
