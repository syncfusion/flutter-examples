/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/widgets/customDropDown.dart';
import '../../../../model/sample_view.dart';

/// Renders the cartesian chart with tooltip position option sample.
class CartesianTooltipPosition extends SampleView {
  const CartesianTooltipPosition(Key key) : super(key: key);

  @override
  _TooltipPositionState createState() => _TooltipPositionState();
}

/// State class of the cartesian chart with tooltip position option.
class _TooltipPositionState extends SampleViewState {
  _TooltipPositionState();
  final List<String> _tooltipPositionList =
      <String>['auto', 'pointer'].toList();
  String _selectedTooltipPosition = 'auto';
  TooltipPosition _tooltipPosition = TooltipPosition.auto;

  @override
  void initState() {
    _selectedTooltipPosition = 'auto';
    _tooltipPosition = TooltipPosition.auto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getCartesianTooltipPositionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Tooltip position     ',
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
                            onPositionTypeChange(value.toString());
                          }),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the cartesian chart with tooltip position option.
  SfCartesianChart getCartesianTooltipPositionChart() {
    dynamic _chart;
    _chart = SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Age distribution'),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          /// To specify the tooltip position, whethter its auto or pointer.
          tooltipPosition: _tooltipPosition,
          canShowMarker: false),
      primaryXAxis: CategoryAxis(
          title: AxisTitle(text: isCardView ? '' : 'Years'),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}M',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getCartesianSeries(),
    );
    return _chart;
  }

  /// list of chart series data points.
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(
      '<5',
      5.55,
      const Color.fromRGBO(53, 92, 125, 1),
    ),
    _ChartData(
      '5-15',
      11.61,
      const Color.fromRGBO(192, 108, 132, 1),
    ),
    _ChartData(
      '15-24',
      12.87,
      const Color.fromRGBO(246, 114, 128, 1),
    ),
    _ChartData('25-64', 69.59, const Color.fromRGBO(248, 177, 149, 1)),
    _ChartData('>65', 28.92, const Color.fromRGBO(116, 180, 155, 1))
  ];

  ///Returns the list of chart series which need to render on the cartesian chart.
  List<ChartSeries<_ChartData, String>> _getCartesianSeries() {
    return <ColumnSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (_ChartData sales, _) => sales.color,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y1,
          name: 'Japan - 2010'),
    ];
  }

  /// Method to update the tooltip position in the chart on change.
  void onPositionTypeChange(String item) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    setState(() {});
  }
}

/// Private class for storing the chart series data point.
class _ChartData {
  _ChartData(this.x, this.y1, [this.color]);
  final String x;
  final double y1;
  final Color color;
}