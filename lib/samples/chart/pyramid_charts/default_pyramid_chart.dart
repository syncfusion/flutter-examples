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
  final List<String> _pyramidMode = <String>['Linear', 'Surface'].toList();
  PyramidMode _selectedPyramidMode = PyramidMode.linear;
  String _selectedMode = 'Linear';
  double gapRatio = 0;
  bool explode = false;

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
            title:
                Text('Pyramid mode', style: TextStyle(color: model.textColor)),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.5 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _selectedMode,
                  items: _pyramidMode.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'Linear',
                        child: Text(value,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onPyramidModeChange(value.toString());
                    stateSetter(() {});
                  }),
            ),
          ),
          ListTile(
            title: Text('Gap ratio', style: TextStyle(color: model.textColor)),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
              width: 0.5 * screenWidth,
              child: CustomDirectionalButtons(
                maxValue: 0.5,
                initialValue: gapRatio,
                onChanged: (double val) => setState(() {
                  gapRatio = val;
                }),
                step: 0.1,
                iconColor: model.textColor,
                style: TextStyle(fontSize: 20.0, color: model.textColor),
              ),
            ),
          ),
          ListTile(
            title: Text('Explode',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.05 * screenWidth),
                width: 0.5 * screenWidth,
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: model.backgroundColor,
                    value: explode,
                    onChanged: (bool? value) {
                      setState(() {
                        explode = value!;
                        stateSetter(() {});
                      });
                    })),
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
      smartLabelMode: SmartLabelMode.shift,
      title: ChartTitle(text: isCardView ? '' : 'Comparison of calories'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _getPyramidSeries(),
    );
  }

  ///Get the default pyramid series
  PyramidSeries<ChartSampleData, String> _getPyramidSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Walnuts', y: 654),
      ChartSampleData(x: 'Almonds', y: 575),
      ChartSampleData(x: 'Soybeans', y: 446),
      ChartSampleData(x: 'Black beans', y: 341),
      ChartSampleData(x: 'Mushrooms', y: 296),
      ChartSampleData(x: 'Avacado', y: 160),
    ];
    return PyramidSeries<ChartSampleData, String>(
        dataSource: pieData,
        height: '90%',
        explode: isCardView ? false : explode,
        gapRatio: isCardView ? 0 : gapRatio,
        pyramidMode: isCardView ? PyramidMode.linear : _selectedPyramidMode,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
        ));
  }

  /// Change the pyramid mode
  void _onPyramidModeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'Linear') {
      _selectedPyramidMode = PyramidMode.linear;
    } else if (_selectedMode == 'Surface') {
      _selectedPyramidMode = PyramidMode.surface;
    }
    setState(() {
      /// update the pyramid mode changes
    });
  }
}
