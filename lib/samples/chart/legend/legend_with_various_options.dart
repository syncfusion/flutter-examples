/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';

class LegendOptions extends SampleView {
  const LegendOptions(Key key) : super(key: key);

  @override
  _LegendOptionsState createState() => _LegendOptionsState();
}

class _LegendOptionsState extends SampleViewState {
  _LegendOptionsState();
  bool toggleVisibility = true;
  final List<String> _positionList =
      <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
  String _selectedPosition = 'auto';
  LegendPosition _position = LegendPosition.auto;

  final List<String> _modeList = <String>['wrap', 'scroll', 'none'].toList();
  String _selectedMode = 'wrap';
  LegendItemOverflowMode _overflowMode = LegendItemOverflowMode.wrap;
  
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Position    ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(75, 0, 0, 0),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedPosition,
                          item: _positionList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'auto',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onPositionTypeChange(value.toString(), model);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Overflow mode',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedMode,
                          item: _modeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'wrap',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onModeTypeChange(value, model);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Toggle visibility   ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: toggleVisibility,
                  valueChanged: (dynamic value) {
                    setState(() {
                      toggleVisibility = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getLegendOptionsChart();
  }

SfCircularChart getLegendOptionsChart() {
  // final bool isExistModel = sampleModel != null && sampleModel.isWeb;
  return SfCircularChart(
    title: ChartTitle(text: isCardView ? '' : 'Expenses by category'),
    legend: Legend(
        isVisible: true,
        position: /*isExistModel ? sampleModel.properties['Position'] :*/ _position,
        overflowMode: 
        // isExistModel
        //     ? sampleModel.properties['OverflowMode']
             _overflowMode,
        toggleSeriesVisibility: 
        // isExistModel
        //     ? sampleModel.properties['ToggleVisibility']
             toggleVisibility),
    series: getLegendOptionsSeries(isCardView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<PieSeries<ChartSampleData, String>> getLegendOptionsSeries(
    bool isCardView) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Tution Fees', y: 21),
    ChartSampleData(x: 'Entertainment', y: 21),
    ChartSampleData(x: 'Private Gifts', y: 8),
    ChartSampleData(x: 'Local Revenue', y: 21),
    ChartSampleData(x: 'Federal Revenue', y: 16),
    ChartSampleData(x: 'Others', y: 8)
  ];
  return <PieSeries<ChartSampleData, String>>[
    PieSeries<ChartSampleData, String>(
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        startAngle: 90,
        endAngle: 90,
        dataLabelSettings: DataLabelSettings(isVisible: true)),
  ];
}

//ignore: must_be_immutable
// class LegendWithOptionsFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   LegendWithOptionsFrontPanel([this.sample]);
//   SubItem sample;

//   @override
//   _LegendWithOptionsFrontPanelState createState() =>
//       _LegendWithOptionsFrontPanelState(sample);
// }

// class _LegendWithOptionsFrontPanelState
//     extends State<LegendWithOptionsFrontPanel> {
//   _LegendWithOptionsFrontPanelState(this.sample);
//   final SubItem sample;
  
//   Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
//       _showSettingsPanel(model, init, context);
//   Widget sampleWidget(SampleModel model) =>
//       getLegendOptionsChart(false, null, null, null, model);

//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     toggleVisibility = true;
//     _selectedPosition = 'auto';
//     _position = LegendPosition.auto;
//     _selectedMode = 'wrap';
//     _overflowMode = LegendItemOverflowMode.wrap;
//     if (sampleModel != null && init) {
//       sampleModel.properties.addAll(<dynamic, dynamic>{
//         'SelectedPosition': _selectedPosition,
//         'Position': _position,
//         'SelectedMode': _selectedMode,
//         'OverflowMode': _overflowMode,
//         'ToggleVisibility': toggleVisibility
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
//                           child: getLegendOptionsChart(false, _position,
//                               _overflowMode, toggleVisibility, null)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child: getLegendOptionsChart(
//                               false, null, null, null, null)),
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



  void onPositionTypeChange(String item, SampleModel model) {
    setState(() {
    _selectedPosition = item;
    if (_selectedPosition == 'auto') {
      _position = LegendPosition.auto;
    }
    if (_selectedPosition == 'bottom') {
      _position = LegendPosition.bottom;
    }
    if (_selectedPosition == 'right') {
      _position = LegendPosition.right;
    }
    if (_selectedPosition == 'left') {
      _position = LegendPosition.left;
    }
    if (_selectedPosition == 'top') {
      _position = LegendPosition.top;
    }
    model.properties['SelectedPosition'] = _selectedPosition;
    model.properties['Position'] = _position;
    });
  }

  void onModeTypeChange(String item, SampleModel model) {
    setState(() {
    _selectedMode = item;
    if (_selectedMode == 'wrap') {
      _overflowMode = LegendItemOverflowMode.wrap;
    }
    if (_selectedMode == 'scroll') {
      _overflowMode = LegendItemOverflowMode.scroll;
    }
    if (_selectedMode == 'none') {
      _overflowMode = LegendItemOverflowMode.none;
    }
    model.properties['SelectedMode'] = _selectedMode;
    model.properties['OverflowMode'] = _overflowMode;
    });
  }
}
