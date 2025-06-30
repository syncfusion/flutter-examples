/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the pie series chart with selection.
class CircularSelection extends SampleView {
  /// Creates the pie series chart with selection.
  const CircularSelection(Key key) : super(key: key);

  @override
  _CircularSelectionState createState() => _CircularSelectionState();
}

/// State class for the pie series chart with selection.
class _CircularSelectionState extends SampleViewState {
  _CircularSelectionState();
  late bool _enableMultiSelect;
  late bool _toggleSelection;
  late List<ChartSampleData> _chartData;

  SelectionBehavior? _selectionBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'CHN',
        y: 17,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 9,
        text: 'CHN : 54M',
      ),
      ChartSampleData(
        x: 'USA',
        y: 19,
        secondSeriesYValue: 67,
        thirdSeriesYValue: 14,
        text: 'USA : 67M',
      ),
      ChartSampleData(
        x: 'IDN',
        y: 29,
        secondSeriesYValue: 65,
        thirdSeriesYValue: 6,
        text: 'IDN : 65M',
      ),
      ChartSampleData(
        x: 'JAP',
        y: 13,
        secondSeriesYValue: 61,
        thirdSeriesYValue: 26,
        text: 'JAP : 61M',
      ),
      ChartSampleData(
        x: 'BRZ',
        y: 24,
        secondSeriesYValue: 68,
        thirdSeriesYValue: 8,
        text: 'BRZ : 68M',
      ),
    ];
    _enableMultiSelect = false;
    _toggleSelection = true;
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildMultiSelect(screenWidth, stateSetter),
            _buildToggleSelection(screenWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the widget for enabling multi-selection.
  Widget _buildMultiSelect(double screenWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          model.isWebFullView
              ? 'Enable multi-\nselection'
              : 'Enable multi-selection',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          padding: EdgeInsets.only(left: 0.01 * screenWidth),
          width: 0.4 * screenWidth,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: model.primaryColor,
            value: _enableMultiSelect,
            onChanged: (bool? value) {
              setState(() {
                _enableMultiSelect = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the widget for toggling selection.
  Widget _buildToggleSelection(double screenWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          model.isWebFullView ? 'Toggle \nselection' : 'Toggle selection',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          padding: EdgeInsets.only(left: 0.01 * screenWidth),
          width: 0.4 * screenWidth,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: model.primaryColor,
            value: _toggleSelection,
            onChanged: (bool? value) {
              setState(() {
                _toggleSelection = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectionBehavior = SelectionBehavior(
      enable: true,
      toggleSelection: _toggleSelection,
    );
    return _buildCircularSelectionChart();
  }

  /// Returns a circular pie chart with selection.
  SfCircularChart _buildCircularSelectionChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Age distribution by country - 5 to 50 years',
      ),
      enableMultiSelection: _enableMultiSelect,
      series: _buildPieSeries(),
    );
  }

  /// Returns a circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        radius: '70%',
        startAngle: 30,
        endAngle: 30,
        dataLabelMapper: (ChartSampleData sales, int index) => sales.text,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: isCardView
              ? ChartDataLabelPosition.outside
              : ChartDataLabelPosition.inside,
        ),

        /// To enable the selection settings and its functionalities.
        selectionBehavior: _selectionBehavior,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
