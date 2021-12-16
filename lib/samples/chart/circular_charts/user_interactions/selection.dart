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
  SelectionBehavior? selectionBehavior;

  late bool enableMultiSelect;
  late bool _toggleSelection;

  @override
  void initState() {
    enableMultiSelect = false;
    _toggleSelection = true;
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                      model.isWebFullView
                          ? 'Enable multi-\nselection'
                          : 'Enable multi-selection',
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 16,
                        color: model.textColor,
                      )),
                ),
                Container(
                    padding: EdgeInsets.only(left: 0.01 * screenWidth),
                    width: 0.4 * screenWidth,
                    child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: model.backgroundColor,
                        value: enableMultiSelect,
                        onChanged: (bool? value) {
                          setState(() {
                            enableMultiSelect = value!;
                            stateSetter(() {});
                          });
                        }))
              ]),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                        model.isWebFullView
                            ? 'Toggle \nselection'
                            : 'Toggle selection',
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 16,
                          color: model.textColor,
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 0.01 * screenWidth),
                      width: 0.4 * screenWidth,
                      child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: model.backgroundColor,
                          value: _toggleSelection,
                          onChanged: (bool? value) {
                            setState(() {
                              _toggleSelection = value!;
                              stateSetter(() {});
                            });
                          }))
                ]),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    selectionBehavior =
        SelectionBehavior(enable: true, toggleSelection: _toggleSelection);
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
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
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
          ],
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
