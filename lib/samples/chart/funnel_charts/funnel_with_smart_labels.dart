/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';

class FunnelSmartLabels extends SampleView {
  const FunnelSmartLabels(Key key) : super(key: key);

  @override
  _FunnelSmartLabelState createState() => _FunnelSmartLabelState();
}

class _FunnelSmartLabelState extends SampleViewState {
  _FunnelSmartLabelState();
  final List<String> _labelPosition = <String>['outside', 'inside'].toList();
  ChartDataLabelPosition _selectedLabelPosition =
      ChartDataLabelPosition.outside;
  String _selectedPosition = 'outside';

  final List<String> _modeList = <String>['shift', 'none', 'hide'].toList();
  String _smartLabelMode = 'shift';
  SmartLabelMode _mode = SmartLabelMode.shift;

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label Position          ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
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
                          value: _selectedPosition,
                          item: _labelPosition.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'outside',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onLabelPositionChange(value.toString(), model);
                          }),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Smart label mode',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
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
                          value: _smartLabelMode,
                          item: _modeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'shift',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onSmartLabelModeChange(value.toString(), model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return getFunnelSmartLabelChart();
  }

SfFunnelChart getFunnelSmartLabelChart() {
  // final bool isExistModel = sampleModel != null && sampleModel.isWeb;
  return SfFunnelChart(
    smartLabelMode: _mode ?? SmartLabelMode.shift,
    title: ChartTitle(text: isCardView ? '' : 'Tournament details'),
    tooltipBehavior: TooltipBehavior(
      enable: true,
    ),
    series: _getFunnelSeries(
      isCardView,
      _selectedPosition != null 
      ? _selectedPosition.contains('outside') 
        ? ChartDataLabelPosition.outside
        : ChartDataLabelPosition.inside
      : ChartDataLabelPosition.inside,
    ),
  );
}

FunnelSeries<ChartSampleData, String> _getFunnelSeries(bool isCardView,
    [ChartDataLabelPosition _labelPosition]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Finals', y: 2),
    ChartSampleData(x: 'Semifinals', y: 4),
    ChartSampleData(x: 'Quarter finals', y: 8),
    ChartSampleData(x: 'League matches', y: 16),
    ChartSampleData(x: 'Participated', y: 32),
    ChartSampleData(x: 'Eligible', y: 36),
    ChartSampleData(x: 'Applicants', y: 40),
  ];
  return FunnelSeries<ChartSampleData, String>(
      width: '60%',
      dataSource: pieData,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      /// To enable the data label for funnel chart.
      dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition:
              isCardView ? ChartDataLabelPosition.outside : _labelPosition,
          useSeriesColor: true));
}

//ignore: must_be_immutable
// class FunnelSmartLabelFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   FunnelSmartLabelFrontPanel([this.sample]);
//   SubItem sample;

//   @override
//   _FunnelSmartLabelFrontPanelState createState() =>
//       _FunnelSmartLabelFrontPanelState(sample);
// }

// class _FunnelSmartLabelFrontPanelState
//     extends State<FunnelSmartLabelFrontPanel> {
//   _FunnelSmartLabelFrontPanelState(this.sample);
//   final SubItem sample;
//   final List<String> _labelPosition = <String>['outside', 'inside'].toList();
//   ChartDataLabelPosition _selectedLabelPosition =
//       ChartDataLabelPosition.outside;
//   String _selectedPosition = 'outside';

//   final List<String> _modeList = <String>['shift', 'none', 'hide'].toList();
//   String _smartLabelMode = 'shift';
//   SmartLabelMode _mode = SmartLabelMode.shift;

//   // Widget sampleWidget(SampleModel model) => getLabelIntersectActionChart(false);
//   // Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
//   //     _showSettingsPanel(model, init, context);
//   // Widget sampleWidget(SampleModel model) =>
//   //     getFunnelSmartLabelChart(false,null, null, model);

//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     _selectedPosition = 'outside';
//     _selectedLabelPosition = ChartDataLabelPosition.outside;
//     _smartLabelMode = 'shift';
//     _mode = SmartLabelMode.shift;
//     if (sampleModel != null && init) {
//       sampleModel.properties.addAll(<dynamic, dynamic>{
//         'SelectedFunnelSmartLabelMode': _smartLabelMode,
//         'FunnelSmartLabelMode': _mode,
//         'SelectedFunnelLabelPosition': _selectedPosition,
//         'FunnelLabelPosition': _selectedLabelPosition,
//       });
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
//                           child: getFunnelSmartLabelChart(
//                               false, _selectedLabelPosition, _mode)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child: getFunnelSmartLabelChart(
//                               false, null, null, model)),
//                     ),
//               floatingActionButton: model.isWeb
//                   ? null
//                   : Stack(children: <Widget>[
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: FloatingActionButton(
//                           heroTag: null,
//                           onPressed: () {
//                             _showSettingsPanel(model, false, context);
//                           },
//                           child: Icon(Icons.graphic_eq, color: Colors.white),
//                           backgroundColor: model.backgroundColor,
//                         ),
//                       ),
//                     ]));
//         });
//   }

  void onLabelPositionChange(String item, SampleModel model) {
    _selectedPosition = item;
    if (_selectedPosition == 'inside') {
      _selectedLabelPosition = ChartDataLabelPosition.inside;
    } else if (_selectedPosition == 'outside') {
      _selectedLabelPosition = ChartDataLabelPosition.outside;
    }
    model.properties['SelectedFunnelLabelPosition'] = _selectedPosition;
    model.properties['FunnelLabelPosition'] = _selectedLabelPosition;
      setState(() {});
  }

  void onSmartLabelModeChange(String item, SampleModel model) {
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
    model.properties['SelectedFunnelSmartLabelMode'] = _smartLabelMode;
    model.properties['FunnelSmartLabelMode'] = _mode;
      setState(() {});
  }
}
