/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';

/// Render the pie series with selection.
class CircularSelection extends SampleView {
  /// Creates the pie series with selection.
  const CircularSelection(Key key) : super(key: key);

  @override
  _CircularSelectionState createState() => _CircularSelectionState();
}

class _CircularSelectionState extends SampleViewState {
  SelectionBehavior selectionBehavior = SelectionBehavior(enable: true);
  _CircularSelectionState();
  bool enableMultiSelect = false;

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Enable multi-selection ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              CustomCheckBox(
                activeColor: model.backgroundColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return getCircularSelectionChart();
  }

  SfCircularChart getCircularSelectionChart() {
    return SfCircularChart(
      title: ChartTitle(
          text:
              isCardView ? '' : 'Age distribution by country - 5 to 50 years'),
      selectionGesture: ActivationMode.singleTap,
      enableMultiSelection: enableMultiSelect ?? false,
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
          xValueMapper: (ChartSampleData sales, _) => sales.x,
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
