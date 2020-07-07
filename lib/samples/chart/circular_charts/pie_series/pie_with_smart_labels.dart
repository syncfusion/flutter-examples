/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';
import '../../../../widgets/customDropDown.dart';

/// Render the pie series with smart labels.
class PieSmartLabels extends SampleView {
  const PieSmartLabels(Key key) : super(key: key);

  @override
  _PieSmartLabelsState createState() => _PieSmartLabelsState();
}

/// State class of pie series with smart labels.
class _PieSmartLabelsState extends SampleViewState {
  _PieSmartLabelsState();
  final List<String> _positionList = <String>['outside', 'inside'].toList();
  final List<String> _connectorLineList = <String>['curve', 'line'].toList();
  String _selectedPosition = 'outside';
  String _connectorLine = 'curve';
  bool isZeroVisible = false;
  bool isSmartLabelMode = true;
  ChartDataLabelPosition _labelPosition;
  ConnectorType _connectorType;

  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label position          ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                value: (value != null) ? value : 'outside',
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
              Text('Enable smart label     ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: isSmartLabelMode,
                  valueChanged: (dynamic value) {
                    setState(() {
                      isSmartLabelMode = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Connector line type',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _connectorLine,
                          item: _connectorLineList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'line',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onLineTypeChange(value.toString(), model);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Hide label for 0 value ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: isZeroVisible,
                  valueChanged: (dynamic value) {
                    setState(() {
                      isZeroVisible = value;
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
    return getSmartLabelPieChart();
  }

/// Returns the circular charts with pie series.
  SfCircularChart getSmartLabelPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Monthly expenditure of an individual'),
      series: gettSmartLabelPieSeries(isCardView, _labelPosition,
          _connectorType, isZeroVisible, isSmartLabelMode, model),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

/// Returns the list of pie series which need to be labeled.
  List<PieSeries<ChartSampleData, String>> gettSmartLabelPieSeries(
      bool isCardView,
      ChartDataLabelPosition labelPosition,
      ConnectorType connectorType,
      bool zeroVisibility,
      bool smartLabel,
      SampleModel model) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Food', y: 38),
      ChartSampleData(x: 'Loan due', y: 0),
      ChartSampleData(x: 'Medical', y: 24),
      ChartSampleData(x: 'Movies', y: 0),
      ChartSampleData(x: 'Travel', y: 27),
      ChartSampleData(x: 'Shopping', y: 19),
      ChartSampleData(x: 'Savings', y: 9),   
      ChartSampleData(x: 'Others', y: 5),
      ChartSampleData(x: 'Rent', y: 5),
      ChartSampleData(x: 'Insurance', y: 4),
      ChartSampleData(x: 'Tax', y:3),
      ChartSampleData(x: 'PF', y:4),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x,
          radius: '55%',
          // startAngle: 105,
          // endAngle: 105,
          /// By using this property we can enable the smart label mode.
          enableSmartLabels: !isCardView ? smartLabel : true,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              showZeroValue: !isCardView && !zeroVisibility ? true : false,
              labelPosition:
                  !isCardView ? labelPosition : ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                  type: !isCardView ? connectorType : ConnectorType.curve)))
    ];
  }

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _labelPosition = ChartDataLabelPosition.outside;
    _connectorType = ConnectorType.curve;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'LabelPosition': _labelPosition,
        'ConnectorLineType': _connectorLine
      });
    }
  }

/// Method for changeing the connector line in pie series.
  void onLineTypeChange(String item, SampleModel model) {
    setState(() {
      _connectorLine = item;
      if (_connectorLine == 'curve') {
        _connectorType = ConnectorType.curve;
      }
      if (_connectorLine == 'line') {
        _connectorType = ConnectorType.line;
      }
    });
    model.properties['LineType'] = _connectorLine;
    // if (model.isWeb)
    //   model.sampleOutputContainer.outputKey.currentState.refresh();
    // else
    //   setState(() {
    //     // ignore: invalid_use_of_protected_member
    //     model.notifyListeners();
    //   });
  }

/// Method for changing the data label position.
  void onPositionTypeChange(String item, SampleModel model) {
    setState(() {
      _selectedPosition = item;
      if (_selectedPosition == 'outside') {
        _labelPosition = ChartDataLabelPosition.outside;
      }
      if (_selectedPosition == 'inside') {
        _labelPosition = ChartDataLabelPosition.inside;
      }
    });
    model.properties['LabelPosition'] = _selectedPosition;
    // if (model.isWeb)
    //   model.sampleOutputContainer.outputKey.currentState.refresh();
    // else
    //   setState(() {
    //     // ignore: invalid_use_of_protected_member
    //     model.notifyListeners();
    //   });
  }
}
