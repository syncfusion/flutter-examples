/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the pie series chart with tooltip position (auto/pointer).
class PieTooltipPosition extends SampleView {
  /// Creates the pie series chart with different tooltip position (auto/pointer).
  const PieTooltipPosition(Key key) : super(key: key);

  @override
  _PieTooltipPositionState createState() => _PieTooltipPositionState();
}

/// Render the pie series chart with tooltip position (auto/pointer).
class _PieTooltipPositionState extends SampleViewState {
  _PieTooltipPositionState();
  late String _selectedTooltipPosition;
  late TooltipPosition _tooltipPosition;
  late double _duration;
  late List<ChartSampleData> _chartData;

  List<String>? _tooltipPositionList;

  @override
  void initState() {
    _selectedTooltipPosition = 'auto';
    _tooltipPosition = TooltipPosition.auto;
    _duration = 2;
    _tooltipPositionList = <String>['auto', 'pointer'].toList();
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
      ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
      ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
      ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
      ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
      ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
      ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%'),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildTooltipPosition(stateSetter),
            _buildHideDelay(stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the widget for selecting tooltip position.
  Widget _buildTooltipPosition(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Tooltip position',
          style: TextStyle(color: model.textColor, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          height: 50,
          alignment: Alignment.bottomLeft,
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedTooltipPosition,
            items: _tooltipPositionList!.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'auto',
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _updateTooltipPosition(value.toString());
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the widget for setting hide delay.
  Widget _buildHideDelay(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Hide delay',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: CustomDirectionalButtons(
            minValue: 1,
            maxValue: 10,
            initialValue: _duration,
            onChanged: (double val) => setState(() {
              _duration = val;
            }),
            step: 2,
            loop: true,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPieTooltipPositionChart();
  }

  /// Returns a circular pie chart with tooltip.
  SfCircularChart _buildPieTooltipPositionChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Various countries population density and area',
      ),
      legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: _buildPieSeries(),

      /// To enable the tooltip and its behavior.
      tooltipBehavior: TooltipBehavior(
        enable: true,
        tooltipPosition: _tooltipPosition,
        duration: _duration * 1000,
      ),
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
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
      ),
    ];
  }

  void _updateTooltipPosition(String item) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    setState(() {
      /// Update the tooltip position changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _tooltipPositionList!.clear();
    super.dispose();
  }
}
