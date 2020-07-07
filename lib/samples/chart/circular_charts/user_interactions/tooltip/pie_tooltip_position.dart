/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';

class PieTooltipPosition extends SampleView {
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
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Tooltip position',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
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
                          value: _selectedTooltipPosition,
                          item: _tooltipPositionList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'auto',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            setState(() {
                            onPositionTypeChange(value.toString(), model);
                            });
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
              Text('Hide delay      ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomButton(
                    minValue: 1,
                    maxValue: 10,
                    initialValue: duration,
                    onChanged: (dynamic val) => setState(() {
                      duration = val;
                    }),
                    step: 2,
                    horizontal: true,
                    loop: true,
                    iconUpRightColor: model.textColor,
                    iconDownLeftColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
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
    return getPieTooltipPositionChart();
  }

dynamic getPieTooltipPositionChart() {
  // final bool isExistModel = model != null && model.isWeb;
  return SfCircularChart(
    title: ChartTitle(
        text:
            isCardView ? '' : 'Various countries population density and area'),
    legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    series: _getPieSeries(isCardView),
    /// To enabe the tooltip and its behaviour.
    tooltipBehavior: TooltipBehavior(
      enable: true,
      tooltipPosition: _tooltipPosition,
      duration:
          (duration ??
                  2.0) *
              1000,
    ),
  );
}

List<PieSeries<ChartSampleData, String>> _getPieSeries(bool isCardView) {
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
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.x,
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside))
  ];
}
  void onPositionTypeChange(String item, SampleModel model) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    model.properties['SelectedPieTooltipPosition'] = _selectedTooltipPosition;
    model.properties['PieTooltipPosition'] = _tooltipPosition;
    // if (model.isWeb)
    //   model.sampleOutputContainer.outputKey.currentState.refresh();
    // else
      setState(() {});
  }

  }