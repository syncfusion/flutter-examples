/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/model/model.dart';

class PyramidDefault extends SampleView {
  const PyramidDefault(Key key) : super(key: key);

  @override
  _PyramidDefaultState createState() => _PyramidDefaultState();
}

class _PyramidDefaultState extends SampleViewState {
  _PyramidDefaultState();
  final List<String> _pyramidMode = <String>['Linear', 'Surface'].toList();
  PyramidMode _selectedPyramidMode = PyramidMode.linear;
  String _selectedMode;
  double gapRatio = 0;
  bool explode = false;

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Pyramid mode',
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
                          value: _selectedMode,
                          item: _pyramidMode.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'Linear',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onPyramidModeChange(value.toString(), model);
                          }),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Gap ratio    ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                  child: CustomButton(
                    minValue: 0,
                    maxValue: 0.5,
                    initialValue: gapRatio,
                    onChanged: (dynamic val) => setState(() {
                      gapRatio = val;
                    }),
                    step: 0.1,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconUp: Icons.keyboard_arrow_up,
                    iconDown: Icons.keyboard_arrow_down,
                    iconLeft: Icons.keyboard_arrow_left,
                    iconRight: Icons.keyboard_arrow_right,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Explode',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              const Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0)),
              BottomSheetCheckbox(
                activeColor: model.backgroundColor,
                switchValue: explode,
                valueChanged: (dynamic value) {
                  setState(() {
                    explode = value;
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
    return getDefaultPyramidChart();
  }

SfPyramidChart getDefaultPyramidChart() {
  final bool isExistModel = model != null && model.isWeb;
  return SfPyramidChart(
    smartLabelMode: SmartLabelMode.shift,
    title: ChartTitle(text: isCardView ? '' : 'Comparison of calories'),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: _getPyramidSeries(
        isCardView,
        isExistModel ? model.properties['PyramidMode'] : _selectedPyramidMode,
        (isExistModel ? model.properties['PyramidGapRatio'] : gapRatio) ?? 0,
        isExistModel ? model.properties['PyramidExplode'] : explode),
  );
}

PyramidSeries<ChartSampleData, String> _getPyramidSeries(bool isCardView,
    [PyramidMode selectedPyramidMode, double gapRatio, bool explode]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x: 'Walnuts', y: 654),
    ChartSampleData(x: 'Almonds', y: 575),
    ChartSampleData(x: 'Soybeans', y: 446),
    ChartSampleData(x: 'Black beans', y: 341),
    ChartSampleData(x: 'Mushrooms', y: 296),
    ChartSampleData(x: 'Avacado', y: 160),
  ];
  return PyramidSeries<ChartSampleData, String>(
      dataSource: pieData,
      height: '90%',
      explode: isCardView ? false : explode,
      gapRatio: isCardView ? 0 : gapRatio,
      pyramidMode: isCardView ? PyramidMode.linear : selectedPyramidMode,
      xValueMapper: (ChartSampleData data, _) => data.x,
      yValueMapper: (ChartSampleData data, _) => data.y,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
      ));
}

//ignore: must_be_immutable
// class DefaultPyramidFrontPanel extends StatefulWidget {
//   //ignore: prefer_const_constructors_in_immutables
//   DefaultPyramidFrontPanel([this.sample]);
//   SubItem sample;

//   @override
//   _DefaultPyramidFrontPanelState createState() =>
//       _DefaultPyramidFrontPanelState(sample);
// }

// class _DefaultPyramidFrontPanelState extends State<DefaultPyramidFrontPanel> {
//   _DefaultPyramidFrontPanelState(this.sample);
//   final SubItem sample;
  
//   Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
//       _showSettingsPanel(model, init, context);
//   Widget sampleWidget(SampleModel model) =>
//       getDefaultPyramidChart(false, null, null, null, model);

//   @override
//   void initState() {
//     initProperties();
//     super.initState();
//   }

//   void initProperties([SampleModel sampleModel, bool init]) {
//     explode = false;
//     gapRatio = 0;
//     _selectedMode = _pyramidMode.first;
//     _selectedPyramidMode = PyramidMode.linear;
//     if (sampleModel != null && init) {
//       sampleModel.properties.addAll(<dynamic, dynamic>{
//         'PyramidGapRatio': gapRatio,
//         'PyramidMode': _selectedPyramidMode,
//         'SelectedPyramidMode': _selectedMode,
//         'PyramidExplode': explode
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
//                           child: getDefaultPyramidChart(
//                               false, _selectedPyramidMode, gapRatio, explode)),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Container(
//                           child: getDefaultPyramidChart(
//                               false, null, null, null, model)),
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

  void onPyramidModeChange(String item, SampleModel model) {
    _selectedMode = item;
    if (_selectedMode == 'Linear') {
      _selectedPyramidMode = PyramidMode.linear;
    } else if (_selectedMode == 'Surface') {
      _selectedPyramidMode = PyramidMode.surface;
    }
    model.properties['SelectedPyramidMode'] = _selectedMode;
    model.properties['PyramidMode'] = _selectedPyramidMode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }
}
