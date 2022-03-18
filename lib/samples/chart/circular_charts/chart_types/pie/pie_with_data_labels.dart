/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the pie series with smart labels.
class PieDataLabels extends SampleView {
  /// Creates the pie series with smart labels.
  const PieDataLabels(Key key) : super(key: key);

  @override
  _PieDataLabelsState createState() => _PieDataLabelsState();
}

/// State class of pie series with smart labels.
class _PieDataLabelsState extends SampleViewState {
  _PieDataLabelsState();
  List<String>? _positionList;
  List<String>? _connectorLineList;
  late String _selectedPosition;
  late String _connectorLine;
  late bool isZeroVisible;
  late ChartDataLabelPosition _labelPosition;
  late ConnectorType _connectorType;
  late String _selectedOverflowMode;
  late OverflowMode _overflowMode;
  List<String>? _overflowModeList;
  TooltipBehavior? _tooltipBehavior;

  @override
  void dispose() {
    _positionList!.clear();
    _connectorLineList!.clear();
    _overflowModeList!.clear();
    super.dispose();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    final double dropDownWidth = (model.isMobile ? 0.25 : 0.4) * screenWidth;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
              Expanded(
                flex: 14,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Label position',
                              style: TextStyle(
                                color: model.textColor,
                                fontSize: 16,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<String>(
                                  focusColor: Colors.transparent,
                                  isExpanded: true,
                                  underline: Container(
                                      color: const Color(0xFFBDBDBD),
                                      height: 1),
                                  value: _selectedPosition,
                                  items: _positionList!.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value:
                                            (value != null) ? value : 'outside',
                                        child: Text(value,
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  onChanged: (dynamic value) {
                                    _onPositionTypeChange(value.toString());
                                    stateSetter(() {});
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Overflow mode',
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedPosition != 'inside'
                                      ? model.textColor.withOpacity(0.3)
                                      : model.textColor)),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            width: dropDownWidth,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedOverflowMode,
                                items: _selectedPosition != 'inside'
                                    ? null
                                    : _overflowModeList!.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: (value != null)
                                                ? value
                                                : 'none',
                                            child: Text(value,
                                                style: TextStyle(
                                                    color: model.textColor)));
                                      }).toList(),
                                onChanged: (dynamic value) {
                                  _changeOverflowMode(value.toString());
                                  stateSetter(() {});
                                }),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Connector line type',
                              style: TextStyle(
                                color: model.textColor,
                                fontSize: 16,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: dropDownWidth,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _connectorLine,
                                items: _connectorLineList!.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'line',
                                      child: Text(value,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                onChanged: (dynamic value) {
                                  _onLineTypeChange(value.toString());
                                  stateSetter(() {});
                                }),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Hide label for 0 value',
                              style: TextStyle(
                                color: model.textColor,
                                fontSize: 16,
                              )),
                        ),
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: model.isWeb
                                      ? (0.05 * screenWidth)
                                      : (0.13 * screenWidth)),
                              width: 0.5 * screenWidth,
                              child: CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: model.backgroundColor,
                                  value: isZeroVisible,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isZeroVisible = value!;
                                      stateSetter(() {});
                                    });
                                  })),
                        ),
                        const SizedBox(width: 10)
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
            ],
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
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Food', y: 23),
            ChartSampleData(x: 'Loan due', y: 0),
            ChartSampleData(x: 'Medical', y: 23),
            ChartSampleData(x: 'Movies', y: 0),
            ChartSampleData(x: 'Travel', y: 32),
            ChartSampleData(x: 'Savings', y: 7),
            ChartSampleData(x: 'Others', y: 15),
            // ChartSampleData(x: 'Shopping', y: 12),
            // ChartSampleData(x: 'Rent', y: 5),
            // ChartSampleData(x: 'Insurance', y: 4),
            // ChartSampleData(x: 'Tax', y: 3),
            // ChartSampleData(x: 'PF', y: 4),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          radius: '55%',
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelIntersectAction: LabelIntersectAction.none,
              overflowMode: _overflowMode,
              showZeroValue: !isCardView && !isZeroVisible ? true : false,
              labelPosition:
                  !isCardView ? _labelPosition : ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                  type: !isCardView ? _connectorType : ConnectorType.curve)))
    ];
  }

  @override
  void initState() {
    _selectedPosition = 'outside';
    _connectorLine = 'curve';
    isZeroVisible = false;
    _positionList = <String>['outside', 'inside'].toList();
    _connectorLineList = <String>['curve', 'line'].toList();
    _labelPosition = ChartDataLabelPosition.outside;
    _connectorType = ConnectorType.curve;
    _selectedOverflowMode = 'none';
    _overflowMode = OverflowMode.none;
    _overflowModeList = <String>['shift', 'none', 'hide', 'trim'].toList();
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
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

  /// Change the overflow mode
  void _changeOverflowMode(String item) {
    _selectedOverflowMode = item;
    if (_selectedOverflowMode == 'shift') {
      _overflowMode = OverflowMode.shift;
    }
    if (_selectedOverflowMode == 'hide') {
      _overflowMode = OverflowMode.hide;
    }
    if (_selectedOverflowMode == 'none') {
      _overflowMode = OverflowMode.none;
    }
    if (_selectedOverflowMode == 'trim') {
      _overflowMode = OverflowMode.trim;
    }
    setState(() {
      /// update the overflow mode
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
