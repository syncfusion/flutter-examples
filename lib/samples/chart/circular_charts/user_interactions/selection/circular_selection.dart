import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';

//ignore:must_be_immutable
class CircularSelection extends StatefulWidget {
  CircularSelection({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _CircularSelectionState createState() => _CircularSelectionState(sample);
}

class _CircularSelectionState extends State<CircularSelection> {
  _CircularSelectionState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, SelectionFrontPanel(sample));
  }
}

SfCircularChart getCircularSelectionChart(bool isTileView,
    [bool enableMultiSelect, SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return SfCircularChart(
    title: ChartTitle(
        text: isTileView ? '' : 'Age distribution by country - 5 to 50 years'),
    selectionGesture: ActivationMode.singleTap,
    enableMultiSelection: (isExistModel
            ? model.properties['CircularMultiSelect']
            : enableMultiSelect) ??
        false,
    series: getCircularSelectionSeries(isTileView),
  );
}

List<PieSeries<ChartSampleData, String>> getCircularSelectionSeries(
    bool isTileView) {
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
          labelPosition: isTileView
              ? ChartDataLabelPosition.outside
              : ChartDataLabelPosition.inside),
      selectionSettings:
          SelectionSettings(enable: true, unselectedOpacity: 0.5),
    )
  ];
}

//ignore: must_be_immutable
class SelectionFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  SelectionFrontPanel([this.sample]);

  SubItem sample;

  @override
  _SelectionFrontPanelState createState() => _SelectionFrontPanelState(sample);
}

class _SelectionFrontPanelState extends State<SelectionFrontPanel> {
  _SelectionFrontPanelState(this.sample);
  final SubItem sample;
  bool enableMultiSelect = false;
  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);
  Widget sampleWidget(SampleModel model) =>
      getCircularSelectionChart(false, null, model);

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    enableMultiSelect = false;
    if (sampleModel != null && init) {
      sampleModel.properties
          .addAll(<dynamic, dynamic>{'CircularMultiSelect': enableMultiSelect});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: !model.isWeb
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                      child: Container(
                          child: getCircularSelectionChart(
                              false, enableMultiSelect)),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                          child: getCircularSelectionChart(false, null, model)),
                    ),
              floatingActionButton: model.isWeb
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        _showSettingsPanel(model, false, context);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ));
        });
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.4
            : 0.5;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Properties',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    HandCursor(
                        child: IconButton(
                      icon: Icon(Icons.close, color: model.webIconColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Multi-Selection',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 14,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: BottomSheetCheckbox(
                          activeColor: model.backgroundColor,
                          switchValue: model.properties['CircularMultiSelect'],
                          valueChanged: (dynamic value) {
                            model.properties['CircularMultiSelect'] = value;
                            model.sampleOutputContainer.outputKey.currentState
                                .refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ));
    } else {
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
                            child: Stack(
                              children: <Widget>[
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
                                            Text('Enable multi-selection ',
                                                style: TextStyle(
                                                    color: model.textColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.34,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            BottomSheetCheckbox(
                                              activeColor:
                                                  model.backgroundColor,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ))));
    }
    return widget ?? Container();
  }
}
