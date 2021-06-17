/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the pie series with smart labels.
class PieSmartLabels extends SampleView {
  /// Creates the pie series with smart labels.
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
  late ChartDataLabelPosition _labelPosition;
  late ConnectorType _connectorType;
  late TooltipBehavior _tooltipBehavior;

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
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
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _selectedPosition,
                        items: _positionList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'outside',
                              child: Text(value,
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onPositionTypeChange(value.toString());
                          stateSetter(() {});
                        })),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Enable smart label    ',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                    width: 75,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: isSmartLabelMode,
                        onChanged: (bool? value) {
                          setState(() {
                            isSmartLabelMode = value!;
                            stateSetter(() {});
                          });
                        })),
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
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _connectorLine,
                        items: _connectorLineList.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'line',
                              child: Text(value,
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onLineTypeChange(value.toString());
                        })),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Hide label for 0 value',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                    width: 75,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: isZeroVisible,
                        onChanged: (bool? value) {
                          setState(() {
                            isZeroVisible = value!;
                            stateSetter(() {});
                          });
                        })),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildSmartLabelPieChart();
  }

  /// Returns the circular charts with pie series.
  SfCircularChart _buildSmartLabelPieChart() {
    return SfCircularChart(
      title: ChartTitle(
          text: isCardView ? '' : 'Monthly expenditure of an individual'),
      series: _gettSmartLabelPieSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the pie series with smart data labels.
  List<PieSeries<ChartSampleData, String>> _gettSmartLabelPieSeries() {
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
      ChartSampleData(x: 'Tax', y: 3),
      ChartSampleData(x: 'PF', y: 4),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          radius: '55%',

          /// By using this property we can enable the smart label mode.
          enableSmartLabels: !isCardView ? isSmartLabelMode : true,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              showZeroValue: !isCardView && !isZeroVisible ? true : false,
              labelPosition:
                  !isCardView ? _labelPosition : ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                  type: !isCardView ? _connectorType : ConnectorType.curve)))
    ];
  }

  @override
  void initState() {
    _labelPosition = ChartDataLabelPosition.outside;
    _connectorType = ConnectorType.curve;
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  /// Method for changeing the connector line in pie series.
  void _onLineTypeChange(String item) {
    setState(() {
      _connectorLine = item;
      if (_connectorLine == 'curve') {
        _connectorType = ConnectorType.curve;
      }
      if (_connectorLine == 'line') {
        _connectorType = ConnectorType.line;
      }
    });
  }

  /// Method for changing the data label position.
  void _onPositionTypeChange(String item) {
    setState(() {
      _selectedPosition = item;
      if (_selectedPosition == 'outside') {
        _labelPosition = ChartDataLabelPosition.outside;
      }
      if (_selectedPosition == 'inside') {
        _labelPosition = ChartDataLabelPosition.inside;
      }
    });
  }
}
