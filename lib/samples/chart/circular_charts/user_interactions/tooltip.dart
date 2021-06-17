/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Render the pie series with tooltip position (auto/pointer).
class PieTooltipPosition extends SampleView {
  /// Creates the pie series with different tooltip position (auto/pointer).
  const PieTooltipPosition(Key key) : super(key: key);

  @override
  _PieTooltipPositionState createState() => _PieTooltipPositionState();
}

class _PieTooltipPositionState extends SampleViewState {
  _PieTooltipPositionState();
  final List<String> _tooltipPositionList =
      <String>['auto', 'pointer'].toList();
  String _selectedTooltipPosition = 'auto';
  TooltipPosition _tooltipPosition = TooltipPosition.auto;
  double duration = 2;
  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text('Tooltip position',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedTooltipPosition,
                      items: _tooltipPositionList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'auto',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          onPositionTypeChange(value.toString());
                          stateSetter(() {});
                        });
                      }),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Hide delay',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: 1,
                    maxValue: 10,
                    initialValue: duration,
                    onChanged: (double val) => setState(() {
                      duration = val;
                    }),
                    step: 2,
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPieTooltipPositionChart();
  }

  SfCircularChart _buildPieTooltipPositionChart() {
    return SfCircularChart(
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Various countries population density and area'),
      legend: Legend(
          isVisible: isCardView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap),
      series: _getPieSeries(),

      /// To enabe the tooltip and its behaviour.
      tooltipBehavior: TooltipBehavior(
        enable: true,
        tooltipPosition: _tooltipPosition,
        duration: duration * 1000,
      ),
    );
  }

  List<PieSeries<ChartSampleData, String>> _getPieSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
      ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
      ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
      ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
      ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
      ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
      ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%')
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          startAngle: 100,
          endAngle: 100,
          pointRadiusMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }

  void onPositionTypeChange(String item) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    setState(() {
      /// update the tooltip position changes
    });
  }
}
