/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the spline series chart with default
/// data labels sample.
class DataLabelDefault extends SampleView {
  /// Creates the spline series chart with default
  /// data labels sample.
  const DataLabelDefault(Key key) : super(key: key);

  @override
  _DataLabelDefaultState createState() => _DataLabelDefaultState();
}

/// State class for spline series chart with default
/// data labels sample.
class _DataLabelDefaultState extends SampleViewState {
  _DataLabelDefaultState();
  late bool _useSeriesColor;
  late String _labelPosition;
  late String _labelAlignment;
  late double _horizontalPadding;
  late double _verticalPadding;

  List<String>? _positionType;
  List<String>? _chartAlign;
  List<ChartSampleData>? _chartData;

  ChartDataLabelAlignment? _chartDataLabelAlignment;
  ChartAlignment? _chartAlignment;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _labelPosition = 'top';
    _labelAlignment = 'center';
    _chartDataLabelAlignment = ChartDataLabelAlignment.top;
    _chartAlignment = ChartAlignment.center;
    _useSeriesColor = true;
    _horizontalPadding = 0;
    _verticalPadding = 0;
    _chartAlign = <String>['near', 'far', 'center'].toList();
    _positionType = <String>['outer', 'top', 'bottom', 'middle'].toList();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 2006, y: 21.8, yValue: 18.2),
      ChartSampleData(x: 2007, y: 24.9, yValue: 21),
      ChartSampleData(x: 2008, y: 28.5, yValue: 22.1),
      ChartSampleData(x: 2009, y: 27.2, yValue: 21.5),
      ChartSampleData(x: 2010, y: 23.4, yValue: 18.9),
      ChartSampleData(x: 2011, y: 23.4, yValue: 21.3),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            buildSeriesColorCheckbox(stateSetter),
            buildLabelAlignmentDropdown(stateSetter),
            buildLabelPositionDropdown(stateSetter),
            buildHorizontalPaddingSlider(),
            buildVerticalPaddingSlider(),
          ],
        );
      },
    );
  }

  /// Builds the checkbox for using series color.
  Widget buildSeriesColorCheckbox(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Use series color',
          style: TextStyle(color: model.textColor, fontSize: 16),
        ),
        SizedBox(
          width: 90,
          child: CheckboxListTile(
            activeColor: model.primaryColor,
            value: _useSeriesColor,
            onChanged: (bool? value) {
              setState(() {
                _useSeriesColor = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the dropdown for label alignment settings.
  Widget buildLabelAlignmentDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Label alignment',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        DropdownButton<String>(
          dropdownColor: model.drawerBackgroundColor,
          focusColor: Colors.transparent,
          underline: Container(color: const Color(0xFFBDBDBD), height: 1),
          value: _labelAlignment,
          items: _chartAlign!.map((String value) {
            return DropdownMenuItem<String>(
              value: (value != null) ? value : 'center',
              child: Text(value, style: TextStyle(color: model.textColor)),
            );
          }).toList(),
          onChanged: (dynamic value) {
            _onAlignmentChange(value.toString());
            stateSetter(() {});
          },
        ),
      ],
    );
  }

  /// Builds the dropdown for label position settings.
  Widget buildLabelPositionDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Label position',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        DropdownButton<String>(
          dropdownColor: model.drawerBackgroundColor,
          focusColor: Colors.transparent,
          underline: Container(color: const Color(0xFFBDBDBD), height: 1),
          value: _labelPosition,
          items: _positionType!.map((String value) {
            return DropdownMenuItem<String>(
              value: (value != null) ? value : 'top',
              child: Text(value, style: TextStyle(color: model.textColor)),
            );
          }).toList(),
          onChanged: (dynamic value) {
            _onPositionChange(value.toString());
            stateSetter(() {});
          },
        ),
      ],
    );
  }

  /// Builds the slider for horizontal padding settings.
  Widget buildHorizontalPaddingSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Horizontal padding',
            style: TextStyle(fontSize: 16.0, color: model.textColor),
          ),
        ),
        CustomDirectionalButtons(
          minValue: -50,
          maxValue: 50,
          initialValue: _horizontalPadding,
          onChanged: (double value) => setState(() {
            _horizontalPadding = value;
          }),
          step: 10,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 20.0, color: model.textColor),
        ),
      ],
    );
  }

  /// Builds the slider for vertical padding settings.
  Widget buildVerticalPaddingSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Vertical padding',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        CustomDirectionalButtons(
          minValue: -50,
          maxValue: 50,
          initialValue: _verticalPadding,
          onChanged: (double val) => setState(() {
            _verticalPadding = val;
          }),
          step: 10,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 20.0, color: model.textColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataLabelDefaultChart();
  }

  /// Returns a cartesian spline chart with default data labels.
  SfCartesianChart _buildDataLabelDefaultChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Gross investments'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(
        minimum: 2006,
        maximum: 2010,
        title: AxisTitle(text: isCardView ? '' : 'Year'),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 1,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 15,
        maximum: 30,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildSplineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian spline series.
  List<SplineSeries<ChartSampleData, num>> _buildSplineSeries() {
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        color: const Color.fromRGBO(140, 198, 64, 1),
        markerSettings: const MarkerSettings(isVisible: true),
        legendIconType: LegendIconType.rectangle,
        name: 'Singapore',
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          useSeriesColor: _useSeriesColor,
          alignment: _chartAlignment!,
          labelAlignment: _chartDataLabelAlignment!,
          offset: Offset(_horizontalPadding, _verticalPadding),
        ),
      ),
      SplineSeries<ChartSampleData, num>(
        legendIconType: LegendIconType.rectangle,
        color: const Color.fromRGBO(203, 164, 199, 1),
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Russia',

        /// To enable the data label for cartesian chart.
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          useSeriesColor: _useSeriesColor,
          alignment: _chartAlignment!,
          labelAlignment: _chartDataLabelAlignment!,
          offset: Offset(_horizontalPadding, _verticalPadding),
        ),
      ),
    ];
  }

  void _onAlignmentChange(String item) {
    _labelAlignment = item;
    if (_labelAlignment == 'far') {
      _chartAlignment = ChartAlignment.far;
    } else if (_labelAlignment == 'center') {
      _chartAlignment = ChartAlignment.center;
    } else if (_labelAlignment == 'near') {
      _chartAlignment = ChartAlignment.near;
    }
    setState(() {});
  }

  void _onPositionChange(String item) {
    _labelPosition = item;
    if (_labelPosition == 'top') {
      _chartDataLabelAlignment = ChartDataLabelAlignment.top;
    } else if (_labelPosition == 'outer') {
      _chartDataLabelAlignment = ChartDataLabelAlignment.outer;
    } else if (_labelPosition == 'bottom') {
      _chartDataLabelAlignment = ChartDataLabelAlignment.bottom;
    } else if (_labelPosition == 'middle') {
      _chartDataLabelAlignment = ChartDataLabelAlignment.middle;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _positionType!.clear();
    _chartAlign!.clear();
    _chartData!.clear();
    super.dispose();
  }
}
