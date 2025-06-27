/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';

/// Renders the default pyramid series chart.
class PyramidDefault extends SampleView {
  /// Creates the default pyramid series chart.
  const PyramidDefault(Key key) : super(key: key);

  @override
  _PyramidDefaultState createState() => _PyramidDefaultState();
}

class _PyramidDefaultState extends SampleViewState {
  _PyramidDefaultState();
  late List<ChartSampleData> _chartData;
  late PyramidMode _selectedPyramidMode;
  late String _selectedMode;
  late double _gapRatio;
  late bool _explode;

  List<String>? _pyramidMode;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Walnuts', y: 654),
      ChartSampleData(x: 'Almonds', y: 575),
      ChartSampleData(x: 'Soybeans', y: 446),
      ChartSampleData(x: 'Black beans', y: 341),
      ChartSampleData(x: 'Mushrooms', y: 296),
      ChartSampleData(x: 'Avacado', y: 160),
    ];
    _selectedPyramidMode = PyramidMode.linear;
    _selectedMode = 'linear';
    _gapRatio = 0;
    _explode = false;
    _pyramidMode = <String>['linear', 'surface'].toList();
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.7 * screenWidth;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildSettingsRow(screenWidth, dropDownWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the main row containing all the settings components.
  Widget _buildSettingsRow(
    double screenWidth,
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      children: <Widget>[
        Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
        Expanded(
          flex: 14,
          child: Column(
            children: <Widget>[
              _buildPyramidModeRow(dropDownWidth, stateSetter),
              _buildGapRatioRow(stateSetter),
              _buildExplodeRow(screenWidth, dropDownWidth, stateSetter),
            ],
          ),
        ),
        Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
      ],
    );
  }

  /// Builds the row for selecting the pyramid mode.
  Widget _buildPyramidModeRow(double dropDownWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            model.isWebFullView ? 'Pyramid \nmode' : 'Pyramid mode',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedMode,
            items: _pyramidMode!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _onPyramidModeChange(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the row for adjusting the gap ratio
  /// with directional buttons.
  Widget _buildGapRatioRow(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            'Gap ratio',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          flex: 4,
          child: CustomDirectionalButtons(
            maxValue: 0.5,
            initialValue: _gapRatio,
            onChanged: (double val) => setState(() {
              _gapRatio = val;
            }),
            step: 0.1,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the row containing the checkbox to
  /// toggle the explode property.
  Widget _buildExplodeRow(
    double screenWidth,
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Explode',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
              right: model.isMobile ? 0.29 * screenWidth : 0.37 * screenWidth,
            ),
            width: dropDownWidth,
            child: Checkbox(
              activeColor: model.primaryColor,
              value: _explode,
              onChanged: (bool? value) {
                setState(() {
                  _explode = value!;
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
    return _buildDefaultPyramidChart();
  }

  /// Returns the default pyramid series chart.
  SfPyramidChart _buildDefaultPyramidChart() {
    return SfPyramidChart(
      title: ChartTitle(text: isCardView ? '' : 'Comparison of calories'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _buildPyramidSeries(),
    );
  }

  /// Returns the default pyramid series.
  PyramidSeries<ChartSampleData, String> _buildPyramidSeries() {
    return PyramidSeries<ChartSampleData, String>(
      dataSource: _chartData,
      xValueMapper: (ChartSampleData data, int index) => data.x,
      yValueMapper: (ChartSampleData data, int index) => data.y,
      height: '90%',
      explode: isCardView ? false : _explode,
      gapRatio: isCardView ? 0 : _gapRatio,
      pyramidMode: isCardView ? PyramidMode.linear : _selectedPyramidMode,
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    );
  }

  /// Updates the selected pyramid display mode.
  void _onPyramidModeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'linear') {
      _selectedPyramidMode = PyramidMode.linear;
    } else if (_selectedMode == 'surface') {
      _selectedPyramidMode = PyramidMode.surface;
    }
    setState(() {
      /// Update the pyramid mode changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _pyramidMode!.clear();
    super.dispose();
  }
}
