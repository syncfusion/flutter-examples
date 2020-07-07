/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/model/model.dart';

class CircularSelection extends SampleView {
  const CircularSelection(Key key) : super(key: key);

  @override
  _CircularSelectionState createState() => _CircularSelectionState();
}

class _CircularSelectionState extends SampleViewState {
  _CircularSelectionState();
  bool enableMultiSelect = false;

   Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Enable multi-selection ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              BottomSheetCheckbox(
                activeColor: model.backgroundColor,
                switchValue: enableMultiSelect,
                valueChanged: (dynamic value) {
                  setState(() {
                    enableMultiSelect = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getCircularSelectionChart();
  }


SfCircularChart getCircularSelectionChart() {
  return SfCircularChart(
    title: ChartTitle(
        text: isCardView ? '' : 'Age distribution by country - 5 to 50 years'),
    selectionGesture: ActivationMode.singleTap,
    enableMultiSelection: enableMultiSelect ?? false,
    series: getCircularSelectionSeries(isCardView),
  );
}

List<PieSeries<ChartSampleData, String>> getCircularSelectionSeries(
    bool isCardView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: 'CHN', y: 17, yValue2: 54, yValue3: 9, text: 'CHN : 54M'),
    ChartSampleData(
        x: 'USA', y: 19, yValue2: 67, yValue3: 14, text: 'USA : 67M'),
    ChartSampleData(
        x: 'IDN', y: 29, yValue2: 65, yValue3: 6, text: 'IDN : 65M'),
    ChartSampleData(
        x: 'JAP', y: 13, yValue2: 61, yValue3: 26, text: 'JAP : 61M'),
    ChartSampleData(x: 'BRZ', y: 24, yValue2: 68, yValue3: 8, text: 'BRZ : 68M')
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
      dataSource: chartData,
      radius: '70%',
      startAngle: 30,
      endAngle: 30,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
      dataLabelMapper: (ChartSampleData sales, _) => sales.text,
      dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: isCardView
              ? ChartDataLabelPosition.outside
              : ChartDataLabelPosition.inside),
      /// To enable the selection settings and its functionalities.
      selectionSettings:
          SelectionSettings(enable: true, unselectedOpacity: 0.5),
    )
  ];
}
}
// //ignore: must_be_immutable
// class SelectionFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   SelectionFrontPanel([this.sample]);

//   SubItem sample;

//   @override
//   _SelectionFrontPanelState createState() => _SelectionFrontPanelState(sample);
// }

// class _SelectionFrontPanelState extends State<SelectionFrontPanel> {
//   _SelectionFrontPanelState(this.sample);
//   final SubItem sample;
  
//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     enableMultiSelect = false;
//     if (sampleModel != null && init) {
//       sampleModel.properties
//           .addAll(<dynamic, dynamic>{'CircularMultiSelect': enableMultiSelect});
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
//                           child: getCircularSelectionChart(
//                               false, enableMultiSelect)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child: getCircularSelectionChart(false, null, model)),
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

 
// }
