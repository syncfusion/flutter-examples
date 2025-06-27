/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the box and whisker series chart sample.
class BoxWhisker extends SampleView {
  /// Creates the box and whisker series chart.
  const BoxWhisker(Key key) : super(key: key);

  @override
  _BoxWhiskerState createState() => _BoxWhiskerState();
}

class _BoxWhiskerState extends SampleViewState {
  _BoxWhiskerState();
  late String _selectMode;
  late bool _mean;
  Color? _boxWhiskerColor;

  List<String>? _modeType;
  List<SalesData>? _salesData;
  BoxPlotMode? _boxMode;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _salesData = _buildSalesData();
    _selectMode = 'normal';
    _mean = true;
    _boxMode = BoxPlotMode.normal;
    _modeType = <String>['normal', 'exclusive', 'inclusive'].toList();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize box and whisker color based on the current theme
    _boxWhiskerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  List<SalesData> _buildSalesData() {
    return [
      SalesData('Development', <int>[
        22,
        22,
        23,
        25,
        25,
        25,
        26,
        27,
        27,
        28,
        28,
        29,
        30,
        32,
        34,
        32,
        34,
        36,
        35,
        38,
      ]),
      SalesData('HR', <int>[
        22,
        24,
        25,
        30,
        32,
        34,
        36,
        38,
        39,
        41,
        35,
        36,
        40,
        56,
      ]),
      SalesData('Finance  ', <int>[26, 27, 28, 30, 32, 34, 35, 37, 35, 37, 45]),
      SalesData('Inventory', <int>[21, 23, 24, 25, 26, 27, 28, 30, 34, 36, 38]),
      SalesData('Sales', <int>[27, 26, 28, 29, 29, 29, 32, 35, 32, 38, 53]),
      SalesData('R&D', <int>[
        26,
        27,
        29,
        32,
        34,
        35,
        36,
        37,
        38,
        39,
        41,
        43,
        58,
      ]),
      SalesData('Graphics', <int>[26, 28, 29, 30, 32, 33, 35, 36, 52]),
    ];
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildBoxPlotModeDropdown(stateSetter),
            _buildMeanCheckbox(stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the dropdown for selecting box plot mode.
  Widget _buildBoxPlotModeDropdown(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Box plot mode ',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectMode,
            items: _modeType!.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'normal',
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _onModeChange(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the checkbox for the mean setting.
  Widget _buildMeanCheckbox(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text('Mean', style: TextStyle(color: model.textColor, fontSize: 16)),
        Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
          child: SizedBox(
            width: 90,
            child: CheckboxListTile(
              activeColor: model.primaryColor,
              value: _mean,
              onChanged: (bool? value) {
                setState(() {
                  _mean = value!;
                  stateSetter(() {});
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: model.isWebFullView || !isCardView ? 0 : 50,
      ),
      child: _buildDefaultWhiskerChart(),
    );
  }

  /// Returns a cartesian box and whisker chart.
  SfCartesianChart _buildDefaultWhiskerChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: const ChartTitle(
        text: 'Employees age group in various departments',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: const NumericAxis(
        name: 'Age',
        minimum: 10,
        maximum: 60,
        interval: 10,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildBoxWhiskerSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian box and whisker series.
  List<BoxAndWhiskerSeries<SalesData, dynamic>> _buildBoxWhiskerSeries() {
    return <BoxAndWhiskerSeries<SalesData, dynamic>>[
      BoxAndWhiskerSeries<SalesData, dynamic>(
        dataSource: _salesData,
        xValueMapper: (SalesData data, int index) => data.x,
        yValueMapper: (SalesData data, int index) => data.y,
        showMean: _mean,
        opacity: 0.9,
        boxPlotMode: _boxMode!,
        borderColor: _boxWhiskerColor,
        name: 'Department',
      ),
    ];
  }

  void _onModeChange(String item) {
    setState(() {
      _selectMode = item;
      if (_selectMode == 'normal') {
        _boxMode = BoxPlotMode.normal;
      } else if (_selectMode == 'inclusive') {
        _boxMode = BoxPlotMode.inclusive;
      } else if (_selectMode == 'exclusive') {
        _boxMode = BoxPlotMode.exclusive;
      }
    });
  }

  @override
  void dispose() {
    _salesData!.clear();
    _modeType!.clear();
    super.dispose();
  }
}
