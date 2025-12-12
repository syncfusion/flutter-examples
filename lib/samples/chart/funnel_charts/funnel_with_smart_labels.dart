/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// Renders the funnel series chart with smart data label.
class FunnelSmartLabels extends SampleView {
  /// Creates the funnel series chart with smart data label.
  const FunnelSmartLabels(Key key) : super(key: key);

  @override
  _FunnelSmartLabelState createState() => _FunnelSmartLabelState();
}

class _FunnelSmartLabelState extends SampleViewState {
  _FunnelSmartLabelState();
  late List<ChartSampleData> _chartData;
  late ChartDataLabelPosition _selectedLabelPosition;
  late String _selectedPosition;
  late String _labelIntersectAction;
  late LabelIntersectAction _intersectAction;
  late String _selectedOverflowMode;
  late OverflowMode _overflowMode;

  List<String>? _labelPosition;
  List<String>? _labelIntersectActionList;
  List<String>? _overflowModeList;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Finals', y: 2),
      ChartSampleData(x: 'Semifinals', y: 4),
      ChartSampleData(x: 'Quarter finals', y: 8),
      ChartSampleData(x: 'League matches', y: 16),
      ChartSampleData(x: 'Participated', y: 32),
      ChartSampleData(x: 'Eligible', y: 36),
      ChartSampleData(x: 'Applicants', y: 40),
    ];
    _selectedLabelPosition = ChartDataLabelPosition.inside;
    _intersectAction = LabelIntersectAction.shift;
    _labelIntersectAction = 'shift';
    _selectedPosition = 'inside';
    _selectedOverflowMode = 'none';
    _overflowMode = OverflowMode.none;
    _overflowModeList = <String>['shift', 'none', 'hide', 'trim'].toList();
    _labelPosition = <String>['inside', 'outside'].toList();
    _labelIntersectActionList = <String>['shift', 'none', 'hide'].toList();

    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    final double dropDownWidth = (model.isMobile ? 0.2 : 0.4) * screenWidth;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildMainRow(context, dropDownWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the main row layout containing settings controls.
  Widget _buildMainRow(
    BuildContext context,
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      children: <Widget>[
        Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
        Expanded(
          flex: 14,
          child: Column(
            children: <Widget>[
              _buildLabelPositionRow(dropDownWidth, stateSetter),
              _buildOverflowModeRow(dropDownWidth, stateSetter),
              _buildLabelIntersectActionRow(dropDownWidth, stateSetter),
            ],
          ),
        ),
        Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
      ],
    );
  }

  /// Builds the row for selecting the label position.
  Widget _buildLabelPositionRow(double dropDownWidth, StateSetter stateSetter) {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Label position',
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Flexible(
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedPosition,
            items: _labelPosition!.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'outside',
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _onLabelPositionChange(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the row for selecting the overflow mode.
  Widget _buildOverflowModeRow(double dropDownWidth, StateSetter stateSetter) {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Overflow mode',
          style: TextStyle(
            fontSize: 16,
            color: _selectedPosition != 'inside'
                ? model.textColor.withValues(alpha: 0.3)
                : model.textColor,
          ),
        ),
        Flexible(
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedOverflowMode,
            items: _selectedPosition != 'inside'
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
      ],
    );
  }

  /// Builds the row for selecting the label intersect action.
  Widget _buildLabelIntersectActionRow(
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Label intersect \naction',
          style: TextStyle(
            fontSize: 16,
            color:
                (_selectedOverflowMode != 'none' &&
                    _selectedPosition != 'outside')
                ? model.textColor.withValues(alpha: 0.3)
                : model.textColor,
          ),
        ),
        Flexible(
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _labelIntersectAction,
            items:
                (_selectedOverflowMode != 'none' &&
                    _selectedPosition != 'outside')
                ? null
                : _labelIntersectActionList!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'shift',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
            onChanged: (dynamic value) {
              _updateLabelIntersectAction(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFunnelSmartLabelChart();
  }

  /// Returns the funnel chart with smart data label.
  SfFunnelChart _buildFunnelSmartLabelChart() {
    return SfFunnelChart(
      title: ChartTitle(text: isCardView ? '' : 'Tournament details'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _buildFunnelSeries(),
    );
  }

  /// Returns the funnel series with smart data label.
  FunnelSeries<ChartSampleData, String> _buildFunnelSeries() {
    return FunnelSeries<ChartSampleData, String>(
      width: '60%',
      dataSource: _chartData,
      xValueMapper: (ChartSampleData data, int index) => data.x,
      yValueMapper: (ChartSampleData data, int index) => data.y,

      /// To enable the data label for funnel chart.
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelPosition: isCardView
            ? ChartDataLabelPosition.outside
            : _selectedLabelPosition,
        labelIntersectAction: _intersectAction,
        overflowMode: _overflowMode,
        useSeriesColor: true,
      ),
    );
  }

  /// Updates the selected label intersect action.
  void _onLabelPositionChange(String item) {
    _selectedPosition = item;
    if (_selectedPosition == 'inside') {
      _selectedLabelPosition = ChartDataLabelPosition.inside;
    } else if (_selectedPosition == 'outside') {
      _selectedLabelPosition = ChartDataLabelPosition.outside;
    }
    setState(() {
      /// Update the label position type change.
    });
  }

  /// Updates the selected overflow mode.
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
      /// Update the overflow mode.
    });
  }

  /// Updates the selected label intersect action.
  void _updateLabelIntersectAction(String item) {
    _labelIntersectAction = item;
    if (_labelIntersectAction == 'shift') {
      _intersectAction = LabelIntersectAction.shift;
    }
    if (_labelIntersectAction == 'hide') {
      _intersectAction = LabelIntersectAction.hide;
    }
    if (_labelIntersectAction == 'none') {
      _intersectAction = LabelIntersectAction.none;
    }
    setState(() {
      /// Update the label intersect action.
    });
  }

  @override
  void dispose() {
    _labelPosition!.clear();
    _labelIntersectActionList!.clear();
    _overflowModeList!.clear();
    super.dispose();
  }
}
