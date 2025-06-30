/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the pie series chart with smart data labels.
class PieDataLabels extends SampleView {
  /// Creates the pie series chart with smart data labels.
  const PieDataLabels(Key key) : super(key: key);

  @override
  _PieDataLabelsState createState() => _PieDataLabelsState();
}

/// State class for pie series chart with smart data labels.
class _PieDataLabelsState extends SampleViewState {
  _PieDataLabelsState();
  late String _selectedDataLabelPosition;
  late String _connectorLineType;
  late bool _isZeroVisible;
  late ChartDataLabelPosition _labelPosition;
  late ConnectorType _connectorType;
  late String _selectedOverflowMode;
  late OverflowMode _overflowMode;
  late List<ChartSampleData> _chartData;

  List<String>? _positionList;
  List<String>? _connectorLineList;
  List<String>? _overflowModeList;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _selectedDataLabelPosition = 'outside';
    _connectorLineType = 'curve';
    _isZeroVisible = false;
    _positionList = <String>['outside', 'inside'].toList();
    _connectorLineList = <String>['curve', 'line'].toList();
    _labelPosition = ChartDataLabelPosition.outside;
    _connectorType = ConnectorType.curve;
    _selectedOverflowMode = 'none';
    _overflowMode = OverflowMode.none;
    _overflowModeList = <String>['shift', 'none', 'hide', 'trim'].toList();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Food', y: 23),
      ChartSampleData(x: 'Loan due', y: 0),
      ChartSampleData(x: 'Medical', y: 23),
      ChartSampleData(x: 'Movies', y: 0),
      ChartSampleData(x: 'Travel', y: 32),
      ChartSampleData(x: 'Savings', y: 7),
      ChartSampleData(x: 'Others', y: 15),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    final double dropDownWidth = (model.isMobile ? 0.25 : 0.4) * screenWidth;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 14,
                  child: Column(
                    children: <Widget>[
                      _buildLabelPositionDropdown(dropDownWidth, stateSetter),
                      _buildOverflowModeDropdown(dropDownWidth, stateSetter),
                      _buildConnectorLineTypeDropdown(
                        dropDownWidth,
                        stateSetter,
                      ),
                      _buildZeroValueCheckbox(screenWidth, stateSetter),
                    ],
                  ),
                ),
                Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the dropdown for selecting the label position.
  Widget _buildLabelPositionDropdown(
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Label position',
            style: TextStyle(color: model.textColor, fontSize: 16),
          ),
        ),
        Flexible(
          child: SizedBox(
            width: dropDownWidth,
            child: DropdownButton<String>(
              dropdownColor: model.drawerBackgroundColor,
              focusColor: Colors.transparent,
              isExpanded: true,
              underline: Container(color: const Color(0xFFBDBDBD), height: 1),
              value: _selectedDataLabelPosition,
              items: _positionList!.map((String value) {
                return DropdownMenuItem<String>(
                  value: (value != null) ? value : 'outside',
                  child: Text(value, style: TextStyle(color: model.textColor)),
                );
              }).toList(),
              onChanged: (dynamic value) {
                _updateLabelPosition(value.toString());
                stateSetter(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the dropdown for selecting the overflow mode.
  Widget _buildOverflowModeDropdown(
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Overflow mode',
            softWrap: false,
            style: TextStyle(
              fontSize: 16,
              color: _selectedDataLabelPosition != 'inside'
                  ? model.textColor.withValues(alpha: 0.3)
                  : model.textColor,
            ),
          ),
        ),
        Flexible(
          child: SizedBox(
            height: 50,
            width: dropDownWidth,
            child: DropdownButton<String>(
              dropdownColor: model.drawerBackgroundColor,
              focusColor: Colors.transparent,
              isExpanded: true,
              underline: Container(color: const Color(0xFFBDBDBD), height: 1),
              value: _selectedOverflowMode,
              items: _selectedDataLabelPosition != 'inside'
                  ? null
                  : _overflowModeList!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'none',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
              onChanged: (dynamic value) {
                _updateOverflowMode(value.toString());
                stateSetter(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the dropdown for selecting the connector line type.
  Widget _buildConnectorLineTypeDropdown(
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Connector line type',
            style: TextStyle(color: model.textColor, fontSize: 16),
          ),
        ),
        Flexible(
          child: SizedBox(
            width: dropDownWidth,
            child: DropdownButton<String>(
              dropdownColor: model.drawerBackgroundColor,
              focusColor: Colors.transparent,
              isExpanded: true,
              underline: Container(color: const Color(0xFFBDBDBD), height: 1),
              value: _connectorLineType,
              items: _connectorLineList!.map((String value) {
                return DropdownMenuItem<String>(
                  value: (value != null) ? value : 'line',
                  child: Text(value, style: TextStyle(color: model.textColor)),
                );
              }).toList(),
              onChanged: (dynamic value) {
                _updateConnectorLineType(value.toString());
                stateSetter(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the checkbox for hiding labels for zero values.
  Widget _buildZeroValueCheckbox(double screenWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Hide label for 0 value',
            style: TextStyle(color: model.textColor, fontSize: 16),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
              left: model.isWeb ? (0.05 * screenWidth) : (0.13 * screenWidth),
            ),
            width: 0.5 * screenWidth,
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: model.primaryColor,
              value: _isZeroVisible,
              onChanged: (bool? value) {
                setState(() {
                  _isZeroVisible = value!;
                  stateSetter(() {});
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSmartLabelPieChart();
  }

  /// Returns a circular pie chart with smart data labels.
  SfCircularChart _buildSmartLabelPieChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Monthly expenditure of an individual',
      ),
      series: _buildPieSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,
        radius: '55%',
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          overflowMode: _overflowMode,
          showZeroValue: !isCardView && !_isZeroVisible ? true : false,
          labelPosition: !isCardView
              ? _labelPosition
              : ChartDataLabelPosition.outside,
          connectorLineSettings: ConnectorLineSettings(
            type: !isCardView ? _connectorType : ConnectorType.curve,
          ),
        ),
      ),
    ];
  }

  /// Method for changing the connector type in pie series.
  void _updateConnectorLineType(String item) {
    setState(() {
      _connectorLineType = item;
      if (_connectorLineType == 'curve') {
        _connectorType = ConnectorType.curve;
      }
      if (_connectorLineType == 'line') {
        _connectorType = ConnectorType.line;
      }
    });
  }

  /// Method to change the overflow mode.
  void _updateOverflowMode(String item) {
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
      /// update the overflow mode.
    });
  }

  /// Method for changing the data label position.
  void _updateLabelPosition(String item) {
    setState(() {
      _selectedDataLabelPosition = item;
      if (_selectedDataLabelPosition == 'outside') {
        _labelPosition = ChartDataLabelPosition.outside;
      }
      if (_selectedDataLabelPosition == 'inside') {
        _labelPosition = ChartDataLabelPosition.inside;
      }
    });
  }

  @override
  void dispose() {
    _positionList!.clear();
    _chartData.clear();
    _connectorLineList!.clear();
    _overflowModeList!.clear();
    super.dispose();
  }
}
