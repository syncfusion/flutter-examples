/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';
import '../../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../../widgets/shared/web.dart';

/// Renders the arrange by index category axis chart sample.
class CategoryIndexed extends SampleView {
  const CategoryIndexed(Key key) : super(key: key);

  @override
  _CategoryIndexedState createState() => _CategoryIndexedState();
}

/// State class of arrange by index chart.
class _CategoryIndexedState extends SampleViewState {
  _CategoryIndexedState();
  bool isIndexed = true;

  @override
  void initState() {
    isIndexed = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getIndexedCategoryAxisChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Arrange by index',
                style: TextStyle(
                    color: model.textColor,
                    fontSize: 16,
                    letterSpacing: 0.34,
                    fontWeight: FontWeight.normal)),
            HandCursor(
              child: BottomSheetCheckbox(
                activeColor: model.backgroundColor,
                switchValue: isIndexed,
                valueChanged: (dynamic value) {
                  setState(() {
                    isIndexed = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns the column chart with arranged index.
  SfCartesianChart getIndexedCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Real GDP growth'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: CategoryAxis(
          arrangeByIndex: isIndexed ?? true,
          majorGridLines: MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          interval: isCardView ? 2 : 1,
          title: AxisTitle(text: isCardView ? '' : 'GDP growth rate'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getIndexedCategoryAxisSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, String>> getIndexedCategoryAxisSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Myanmar', yValue: 7.3),
      ChartSampleData(x: 'India', yValue: 7.9),
      ChartSampleData(x: 'Bangladesh', yValue: 6.8)
    ];
    final List<ChartSampleData> chartData1 = <ChartSampleData>[
      ChartSampleData(x: 'Poland', yValue: 2.7),
      ChartSampleData(x: 'Australia', yValue: 2.5),
      ChartSampleData(x: 'Singapore', yValue: 2.0)
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          name: '2015'),
      ColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData1,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.yValue,
          name: '2016')
    ];
  }
}

// //ignore: must_be_immutable
// class IndexedFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   IndexedFrontPanel([this.sample]);
//   SubItem sample;

//   @override
//   _IndexedFrontPanelState createState() => _IndexedFrontPanelState(sample);
// }

// class _IndexedFrontPanelState extends State<IndexedFrontPanel> {
//   _IndexedFrontPanelState(this.sample);
//   final SubItem sample;
//   bool isIndexed = true;

//   Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
//       _showSettingsPanel(model, init, context);
//   Widget sampleWidget(SampleModel model) =>
//       getIndexedCategoryAxisChart(false, null, model);

//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     isIndexed = true;
//     if (sampleModel != null && init) {
//       sampleModel.properties.addAll(<dynamic, dynamic>{'indexed': isIndexed});
//     }
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
//                           child: getIndexedCategoryAxisChart(false, isIndexed)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child:
//                               getIndexedCategoryAxisChart(false, null, model)),
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
//                       icon: Icon(Icons.close, color: model.webIconColor),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ))
//                   ]),
//               Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Text('Arrange by index',
//                           style: TextStyle(
//                               color: model.textColor,
//                               fontSize: 14,
//                               letterSpacing: 0.34,
//                               fontWeight: FontWeight.normal)),
//                       const Padding(
//                         padding: EdgeInsets.only(left: 5),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
//                         child: BottomSheetCheckbox(
//                           activeColor: model.backgroundColor,
//                           switchValue: model.properties['indexed'],
//                           valueChanged: (dynamic value) {
//                             model.properties['indexed'] = value;
//                             model.sampleOutputContainer.outputKey.currentState
//                                 .refresh();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
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
//                                 Text('Arrange by index',
//                                     style: TextStyle(
//                                         color: model.textColor,
//                                         fontSize: 16,
//                                         letterSpacing: 0.34,
//                                         fontWeight: FontWeight.normal)),
//                                 BottomSheetCheckbox(
//                                   activeColor: model.backgroundColor,
//                                   switchValue: isIndexed,
//                                   valueChanged: (dynamic value) {
//                                     setState(() {
//                                       isIndexed = value;
//                                     });
//                                   },
//                                 ),
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
