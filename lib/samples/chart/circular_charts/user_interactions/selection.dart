/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Render the pie series with selection.
class CircularSelection extends SampleView {
  /// Creates the pie series with selection.
  const CircularSelection(Key key) : super(key: key);

  @override
  _CircularSelectionState createState() => _CircularSelectionState();
}

class _CircularSelectionState extends SampleViewState {
  _CircularSelectionState();
  late SelectionBehavior selectionBehavior;

  bool enableMultiSelect = false;

  @override
  void initState() {
    selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Enable multi-selection ',
              style: TextStyle(
                color: model.textColor,
                fontSize: 16,
              )),
          Container(
              width: 90,
              child: CheckboxListTile(
                  activeColor: model.backgroundColor,
                  value: enableMultiSelect,
                  onChanged: (bool? value) {
                    setState(() {
                      enableMultiSelect = value!;
                      stateSetter(() {});
                    });
                  }))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircularSelectionChart();
  }

  SfCircularChart _buildCircularSelectionChart() {
    return SfCircularChart(
      title: ChartTitle(
          text:
              isCardView ? '' : 'Age distribution by country - 5 to 50 years'),
      selectionGesture: ActivationMode.singleTap,
      enableMultiSelection: enableMultiSelect,
      series: getCircularSelectionSeries(),
    );
  }

  List<PieSeries<ChartSampleData, String>> getCircularSelectionSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'CHN',
          y: 17,
          secondSeriesYValue: 54,
          thirdSeriesYValue: 9,
          text: 'CHN : 54M'),
      ChartSampleData(
          x: 'USA',
          y: 19,
          secondSeriesYValue: 67,
          thirdSeriesYValue: 14,
          text: 'USA : 67M'),
      ChartSampleData(
          x: 'IDN',
          y: 29,
          secondSeriesYValue: 65,
          thirdSeriesYValue: 6,
          text: 'IDN : 65M'),
      ChartSampleData(
          x: 'JAP',
          y: 13,
          secondSeriesYValue: 61,
          thirdSeriesYValue: 26,
          text: 'JAP : 61M'),
      ChartSampleData(
          x: 'BRZ',
          y: 24,
          secondSeriesYValue: 68,
          thirdSeriesYValue: 8,
          text: 'BRZ : 68M')
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: chartData,
          radius: '70%',
          startAngle: 30,
          endAngle: 30,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          dataLabelMapper: (ChartSampleData sales, _) => sales.text,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: isCardView
                  ? ChartDataLabelPosition.outside
                  : ChartDataLabelPosition.inside),

          /// To enable the selection settings and its functionalities.
          selectionBehavior: selectionBehavior)
    ];
  }
}
