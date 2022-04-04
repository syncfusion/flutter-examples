/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';

/// Renders the default pyramid chart
class PyramidDefault extends SampleView {
  /// Creates the default pyramid chart
  const PyramidDefault(Key key) : super(key: key);

  @override
  _PyramidDefaultState createState() => _PyramidDefaultState();
}

class _PyramidDefaultState extends SampleViewState {
  _PyramidDefaultState();
  List<String>? _pyramidMode;
  late PyramidMode _selectedPyramidMode;
  late String _selectedMode;
  late double gapRatio;
  late bool explode;

  @override
  void initState() {
    _selectedPyramidMode = PyramidMode.linear;
    _selectedMode = 'linear';
    gapRatio = 0;
    explode = false;
    _pyramidMode = <String>['linear', 'surface'].toList();
    super.initState();
  }

  @override
  void dispose() {
    _pyramidMode!.clear();
    super.dispose();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.7 * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
              Expanded(
                flex: 14,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                              model.isWebFullView
                                  ? 'Pyramid \nmode'
                                  : 'Pyramid mode',
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 16, color: model.textColor)),
                        ),
                        Flexible(
                          child: DropdownButton<String>(
                              focusColor: Colors.transparent,
                              isExpanded: true,
                              underline: Container(
                                  color: const Color(0xFFBDBDBD), height: 1),
                              value: _selectedMode,
                              items: _pyramidMode!.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'linear',
                                    child: Text(value,
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              onChanged: (dynamic value) {
                                _onPyramidModeChange(value.toString());
                                stateSetter(() {});
                              }),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Text('Gap ratio',
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 16, color: model.textColor)),
                        ),
                        Flexible(
                          flex: 4,
                          child: CustomDirectionalButtons(
                            maxValue: 0.5,
                            initialValue: gapRatio,
                            onChanged: (double val) => setState(() {
                              gapRatio = val;
                            }),
                            step: 0.1,
                            iconColor: model.textColor,
                            style: TextStyle(
                                fontSize: 20.0, color: model.textColor),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Explode',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(
                                  right: model.isMobile
                                      ? 0.29 * screenWidth
                                      : 0.37 * screenWidth),
                              width: dropDownWidth,
                              child: Checkbox(
                                  activeColor: model.backgroundColor,
                                  value: explode,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      explode = value!;
                                      stateSetter(() {});
                                    });
                                  })),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
            ],
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultPyramidChart();
  }

  ///Get the default pyramid chart
  SfPyramidChart _buildDefaultPyramidChart() {
    return SfPyramidChart(
      title: ChartTitle(text: isCardView ? '' : 'Comparison of calories'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _getPyramidSeries(),
    );
  }

  ///Get the default pyramid series
  PyramidSeries<ChartSampleData, String> _getPyramidSeries() {
    return PyramidSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Walnuts', y: 654),
          ChartSampleData(x: 'Almonds', y: 575),
          ChartSampleData(x: 'Soybeans', y: 446),
          ChartSampleData(x: 'Black beans', y: 341),
          ChartSampleData(x: 'Mushrooms', y: 296),
          ChartSampleData(x: 'Avacado', y: 160),
        ],
        height: '90%',
        explode: isCardView ? false : explode,
        gapRatio: isCardView ? 0 : gapRatio,
        pyramidMode: isCardView ? PyramidMode.linear : _selectedPyramidMode,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
        ));
  }

  /// Change the pyramid mode
  void _onPyramidModeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'linear') {
      _selectedPyramidMode = PyramidMode.linear;
    } else if (_selectedMode == 'surface') {
      _selectedPyramidMode = PyramidMode.surface;
    }
    setState(() {
      /// update the pyramid mode changes
    });
  }
}
