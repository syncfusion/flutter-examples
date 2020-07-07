/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with default selection option sample.
class DefaultSelection extends SampleView {
  const DefaultSelection(Key key) : super(key: key);

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState();
}

/// State class of the chart with default selection.
class _DefaultSelectionState extends SampleViewState {
  _DefaultSelectionState();
  bool enableMultiSelect = false;

  final List<String> _modeList =
      <String>['point', 'series', 'cluster'].toList();
  String _selectedMode = 'point';

  SelectionType _mode = SelectionType.point;

  @override
  void initState() {
    _selectedMode = 'point';
    _mode = SelectionType.point;
    enableMultiSelect = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getDefaultSelectionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Mode ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
                height: 50,
                width: 250,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedMode,
                          item: _modeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'point',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onModeTypeChange(value);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Enable multi-selection ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              HandCursor(
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: enableMultiSelect,
                  valueChanged: (dynamic value) {
                    setState(() {
                      enableMultiSelect = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the cartesian chart with default selection. 
  SfCartesianChart getDefaultSelectionChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Age distribution by country'),
      /// To specify the selection mode for chart.
      selectionType: _mode,
      selectionGesture: ActivationMode.singleTap,
      enableMultiSelection: enableMultiSelect,
      primaryXAxis: CategoryAxis(
          title: AxisTitle(text: isCardView ? '' : 'Countries'),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getDefaultSelectionSeries(),
    );
  }

  /// Returns the list of chart series which need to render on the cartesian chart.
  List<ColumnSeries<ChartSampleData, String>> getDefaultSelectionSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'CHN', y: 17, yValue2: 54, yValue3: 9),
      ChartSampleData(x: 'USA', y: 19, yValue2: 67, yValue3: 14),
      ChartSampleData(x: 'IDN', y: 29, yValue2: 65, yValue3: 6),
      ChartSampleData(x: 'JAP', y: 13, yValue2: 61, yValue3: 26),
      ChartSampleData(x: 'BRZ', y: 24, yValue2: 68, yValue3: 8)
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          // animationDuration: isTileView ? 0 : 1500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          selectionSettings:
              SelectionSettings(enable: true, unselectedOpacity: 0.5),
          name: 'Age 0-14'),
      ColumnSeries<ChartSampleData, String>(
          // animationDuration: isTileView ? 0 : 1500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          selectionSettings:
              SelectionSettings(enable: true, unselectedOpacity: 0.5),
          name: 'Age 15-64'),
      ColumnSeries<ChartSampleData, String>(
          // animationDuration: isTileView ? 0 : 1500,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          selectionSettings:
              SelectionSettings(enable: true, unselectedOpacity: 0.5),
          name: 'Age 65 & Above')
    ];
  }

  /// Method for updating the selected selectionType in the chart on chage.
  void onModeTypeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'point') {
      _mode = SelectionType.point;
    }
    if (_selectedMode == 'series') {
      _mode = SelectionType.series;
    }
    if (_selectedMode == 'cluster') {
      _mode = SelectionType.cluster;
    }
    setState(() {});
  }
}