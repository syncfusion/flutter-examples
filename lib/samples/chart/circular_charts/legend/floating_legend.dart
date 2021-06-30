/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/custom_button.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the stacked area chart sample.
class CircularFloatingLegend extends SampleView {
  /// Creates the stacked area chart sample.
  const CircularFloatingLegend(Key key) : super(key: key);

  @override
  _CircularFloatingLegendState createState() => _CircularFloatingLegendState();
}

/// State class of the stacked  area chart.
class _CircularFloatingLegendState extends SampleViewState {
  _CircularFloatingLegendState();

  final List<String> _position =
      <String>['left', 'right', 'top', 'bottom', 'center'].toList();
  late String _selectedPosition;
  late double _xValue;
  late double _yValue;
  @override
  void initState() {
    _selectedPosition = 'left';
    _xValue = 100;
    _yValue = 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircularChart();
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
          ListTile(
              title: Text('Position',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.4 * screenWidth,
                height: 50,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                    isExpanded: true,
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _selectedPosition,
                    items: _position.map((String value) {
                      return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'left',
                          child: Text(value,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (dynamic value) {
                      _selectedPosition = value.toString();
                      stateSetter(() {});
                    }),
              )),
          ListTile(
              title: Text('X offset',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
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
                  ))),
          ListTile(
              title: Text('Y offset',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
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
                  ))),
        ],
      );
    });
  }

  /// Returns the cartesian stacked area chart.
  SfCircularChart _buildCircularChart() {
    return SfCircularChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      title: ChartTitle(
          text: isCardView ? '' : 'Sales comparision of fruits in a shop'),
      series: _getStackedAreaSeries(),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Container(
              height: 80,
              width: 80,
              child: const Text(
                'Floating',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  /// Returns the list of chart series which need to render
  /// on the stacked area chart.
  List<PieSeries<ChartSampleData, String>> _getStackedAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Medical Care', y: 8.49),
      ChartSampleData(x: 'Housing', y: 2.40),
      ChartSampleData(x: 'Transportation', y: 4.44),
      ChartSampleData(x: 'Education', y: 3.11),
      ChartSampleData(x: 'Electronics', y: 3.06),
      ChartSampleData(x: 'Other Personal', y: 78.4),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          animationDuration: 2500,
          startAngle: 120,
          endAngle: 120,
          explodeAll: true,
          explodeOffset: '3%',
          dataSource: chartData,
          enableSmartLabels: false,
          explode: true,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y),
    ];
  }
}
