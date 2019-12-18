import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart'; 

//ignore: must_be_immutable
class PyramidDefault extends StatefulWidget {
  PyramidDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;
  
  @override
  _PyramidDefaultState createState() => _PyramidDefaultState(sample);
}

class _PyramidDefaultState extends State<PyramidDefault> {
  _PyramidDefaultState(this.sample);
  final SubItem sample;
  
  @override
  Widget build(BuildContext context) {
     return getScopedModel(null, sample, DefaultPyramidFrontPanel(sample));
  }
}

SfPyramidChart getDefaultPyramidChart(bool isTileView, [PyramidMode _selectedPyramidMode, double gapRatio, bool explode]) {
  return SfPyramidChart(    
    smartLabelMode: SmartLabelMode.shift,
    title: ChartTitle(text: isTileView ? '' : 'Comparison of calories'),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: _getPyramidSeries(isTileView, _selectedPyramidMode, gapRatio, explode),
  );
}

PyramidSeries<ChartSampleData, String> _getPyramidSeries(bool isTileView, [PyramidMode selectedPyramidMode, double gapRatio, bool explode]) {
  final List<ChartSampleData> pieData = <ChartSampleData>[
    ChartSampleData(x:'Walnuts', y:654),
    ChartSampleData(x:'Almonds', y:575),
    ChartSampleData(x:'Soybeans',y: 446),
    ChartSampleData(x:'Black beans',y: 341),
    ChartSampleData(x:'Mushrooms', y:296),
    ChartSampleData(x:'Avacado', y:160),
  ];
  return PyramidSeries<ChartSampleData, String>(
        dataSource: pieData,
        height: '90%',
        explode: isTileView ? false : explode,
        gapRatio: isTileView ? 0 : gapRatio,
        pyramidMode: isTileView ? PyramidMode.linear : selectedPyramidMode,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(isVisible: true,));
}


class DefaultPyramidFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DefaultPyramidFrontPanel(this.subItemList);
  final SubItem subItemList;
  
  @override
  _DefaultPyramidFrontPanelState createState() => _DefaultPyramidFrontPanelState(subItemList);
}

class _DefaultPyramidFrontPanelState extends State<DefaultPyramidFrontPanel> {
  _DefaultPyramidFrontPanelState(this.sample);
  final SubItem sample;
  final List<String> _pyramidMode =
      <String>['Linear', 'Surface'].toList();
  PyramidMode _selectedPyramidMode = PyramidMode.linear;
  String _selectedMode;
  double gapRatio = 0;
  bool explode = false;
   @override
  void initState() {
    super.initState();
    gapRatio = 0;
    _selectedMode = _pyramidMode.first; 
    _selectedPyramidMode = PyramidMode.linear;
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
            child: Container(child: getDefaultPyramidChart(false, _selectedPyramidMode, gapRatio, explode)),
          ),
          floatingActionButton: Stack(
                children: <Widget>[
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
  void onPyramidModeChange(String item) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'Linear') {
        _selectedPyramidMode = PyramidMode.linear;
      }
      else if (_selectedMode == 'Surface') {
        _selectedPyramidMode = PyramidMode.surface;
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
                                            Text('Pyramid mode  ',
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
                                                        value: _selectedMode,
                                                        item: _pyramidMode
                                                            .map(
                                                                (String value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: (value !=
                                                                      null)
                                                                  ? value
                                                                  : 'Linear',
                                                              child: Text(
                                                                  '$value',
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        }).toList(),
                                                        valueChanged:
                                                            (dynamic value) {
                                                          onPyramidModeChange(
                                                              value.toString());
                                                        }),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Gap ratio  ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: model.textColor)),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        40, 0, 0, 0),
                                                child: CustomButton(
                                                  minValue: 0,
                                                  maxValue: 0.5,
                                                  initialValue:
                                                      gapRatio,
                                                  onChanged: (dynamic val) =>
                                                      setState(() {
                                                        gapRatio = val;
                                                      }),
                                                  step: 0.1,
                                                  horizontal: true,
                                                  loop: false,
                                                  padding: 0,
                                                  iconUp:
                                                      Icons.keyboard_arrow_up,
                                                  iconDown:
                                                      Icons.keyboard_arrow_down,
                                                  iconLeft:
                                                      Icons.keyboard_arrow_left,
                                                  iconRight: Icons
                                                      .keyboard_arrow_right,
                                                  iconUpRightColor:
                                                      model.textColor,
                                                  iconDownLeftColor:
                                                      model.textColor,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: model.textColor),
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
                                                    fontWeight:
                                                        FontWeight.normal)),
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(40, 0, 0, 0)
                                                        ),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
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
                                  ),
                                ),
                              ]),
                            )))))));
  }
}
