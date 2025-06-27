/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the pie series chart with floating legend.
class CircularFloatingLegend extends SampleView {
  /// Creates the pie series chart with floating legend.
  const CircularFloatingLegend(Key key) : super(key: key);

  @override
  _CircularFloatingLegendState createState() => _CircularFloatingLegendState();
}

/// State class for the pie series chart with floating legend.
class _CircularFloatingLegendState extends SampleViewState {
  _CircularFloatingLegendState();
  late String _selectedPosition;
  late double _xValue;
  late double _yValue;
  late List<ChartSampleData> _chartData;

  List<String>? _position;

  @override
  void initState() {
    _position = <String>['left', 'right', 'top', 'bottom', 'center'].toList();
    _selectedPosition = 'left';
    _xValue = 100;
    _yValue = 100;
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Medical Care', y: 8.49),
      ChartSampleData(x: 'Housing', y: 2.40),
      ChartSampleData(x: 'Transportation', y: 4.44),
      ChartSampleData(x: 'Education', y: 3.11),
      ChartSampleData(x: 'Electronics', y: 3.06),
      ChartSampleData(x: 'Other Personal', y: 78.4),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircularChart();
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
            _buildPositionDropdown(screenWidth, stateSetter),
            _buildXOffsetControl(screenWidth),
            _buildYOffsetControl(screenWidth),
          ],
        );
      },
    );
  }

  /// Builds a dropdown menu for selecting the legend position.
  Widget _buildPositionDropdown(double screenWidth, StateSetter stateSetter) {
    return ListTile(
      title: Text('Position', style: TextStyle(color: model.textColor)),
      trailing: Container(
        padding: EdgeInsets.only(left: 0.07 * screenWidth),
        width: 0.4 * screenWidth,
        height: 50,
        alignment: Alignment.center,
        child: DropdownButton<String>(
          dropdownColor: model.drawerBackgroundColor,
          focusColor: Colors.transparent,
          isExpanded: true,
          underline: Container(color: const Color(0xFFBDBDBD), height: 1),
          value: _selectedPosition,
          items: _position!.map((String value) {
            return DropdownMenuItem<String>(
              value: (value != null) ? value : 'left',
              child: Text(value, style: TextStyle(color: model.textColor)),
            );
          }).toList(),
          onChanged: (dynamic value) {
            _selectedPosition = value.toString();
            stateSetter(() {});
          },
        ),
      ),
    );
  }

  /// Builds the control for adjusting the X offset of the legend.
  Widget _buildXOffsetControl(double screenWidth) {
    return ListTile(
      title: Text('X offset', style: TextStyle(color: model.textColor)),
      trailing: SizedBox(
        width: 0.4 * screenWidth,
        child: CustomDirectionalButtons(
          minValue: 100,
          maxValue: 300,
          initialValue: _xValue,
          onChanged: (double val) => setState(() {
            _xValue = val;
          }),
          step: 10,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 20.0, color: model.textColor),
        ),
      ),
    );
  }

  /// Builds the control for adjusting the Y offset of the legend.
  Widget _buildYOffsetControl(double screenWidth) {
    return ListTile(
      title: Text('Y offset', style: TextStyle(color: model.textColor)),
      trailing: SizedBox(
        width: 0.4 * screenWidth,
        child: CustomDirectionalButtons(
          minValue: 100,
          maxValue: 300,
          initialValue: _yValue,
          onChanged: (double val) => setState(() {
            _yValue = val;
          }),
          step: 10,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 20.0, color: model.textColor),
        ),
      ),
    );
  }

  /// Returns the circular pie chart with floating legend.
  SfCircularChart _buildCircularChart() {
    return SfCircularChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      title: ChartTitle(
        text: isCardView ? '' : 'Sales comparison of fruits in a shop',
      ),
      series: _buildPieSeries(),
      annotations: const <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: SizedBox(
            height: 80,
            width: 80,
            child: Text(
              'Floating',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        startAngle: 120,
        endAngle: 120,
        explodeAll: true,
        explodeOffset: '3%',
        explode: true,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    _position!.clear();
    super.dispose();
  }
}
