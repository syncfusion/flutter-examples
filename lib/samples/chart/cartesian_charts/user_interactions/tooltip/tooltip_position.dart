/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders a column series chart with tooltip position options.
class CartesianTooltipPosition extends SampleView {
  /// Creates a column series chart with tooltip position options.
  const CartesianTooltipPosition(Key key) : super(key: key);

  @override
  _TooltipPositionState createState() => _TooltipPositionState();
}

/// State class for the column series chart with tooltip position options.
class _TooltipPositionState extends SampleViewState {
  _TooltipPositionState();
  late List<String> _tooltipPositionList;
  late String _selectedTooltipPosition;
  late TooltipPosition _tooltipPosition;
  late List<_ChartData> _chartData;

  @override
  void initState() {
    _tooltipPositionList = <String>['auto', 'pointer'].toList();
    _selectedTooltipPosition = 'auto';
    _tooltipPosition = TooltipPosition.auto;
    _chartData = <_ChartData>[
      _ChartData('<5', 5.55, const Color.fromRGBO(53, 92, 125, 1)),
      _ChartData('5-15', 11.61, const Color.fromRGBO(192, 108, 132, 1)),
      _ChartData('15-24', 12.87, const Color.fromRGBO(246, 114, 128, 1)),
      _ChartData('25-64', 69.59, const Color.fromRGBO(248, 177, 149, 1)),
      _ChartData('>65', 28.92, const Color.fromRGBO(116, 180, 155, 1)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianTooltipPositionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Tooltip position',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedTooltipPosition,
                    items: _tooltipPositionList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'auto',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _updateTooltipPosition(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Returns a cartesian column chart with tooltip position option.
  SfCartesianChart _buildCartesianTooltipPositionChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Age distribution'),
      tooltipBehavior: TooltipBehavior(
        enable: true,

        /// To specify the tooltip position, whether its auto or pointer.
        tooltipPosition: _tooltipPosition,
        canShowMarker: false,
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: isCardView ? '' : 'Years'),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}M',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of cartesian column series.
  List<CartesianSeries<_ChartData, String>> _buildColumnSeries() {
    return <ColumnSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y1,
        pointColorMapper: (_ChartData data, int index) => data.color,
        name: 'Japan - 2010',
      ),
    ];
  }

  /// Method to update the tooltip position in the chart on change.
  void _updateTooltipPosition(String item) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    setState(() {
      /// Update the tooltip position changes.
    });
  }

  @override
  void dispose() {
    _tooltipPositionList.clear();
    _chartData.clear();
    super.dispose();
  }
}

/// Private class for storing the chart series data points.
class _ChartData {
  _ChartData(this.x, this.y1, [this.color]);
  final String x;
  final double y1;
  final Color? color;
}
