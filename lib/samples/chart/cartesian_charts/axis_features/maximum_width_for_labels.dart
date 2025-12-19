/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the Chart with sorting options sample.
class ChartMaximumLabelWidth extends SampleView {
  const ChartMaximumLabelWidth(Key key) : super(key: key);

  @override
  ChartMaximumLabelWidthState createState() => ChartMaximumLabelWidthState();
}

/// State class the Chart with sorting options.
class ChartMaximumLabelWidthState extends SampleViewState {
  ChartMaximumLabelWidthState();

  late double _xMaximumLabelWidth;
  late double _xLabelsExtent;
  late bool _isEnableLabelExtend;
  late String _selectedType;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _worldTallestBuildingsData;

  @override
  void initState() {
    _xMaximumLabelWidth = 80;
    _xLabelsExtent = 80;
    _isEnableLabelExtend = false;
    _selectedType = 'Maximum label width';
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
    _worldTallestBuildingsData = <ChartSampleData>[
      ChartSampleData(x: 'Golden Finance 117', y: 597),
      ChartSampleData(x: 'Ping An Finance Center', y: 599),
      ChartSampleData(x: 'Makkah Clock Royal Tower', y: 601),
      ChartSampleData(x: 'Shanghai Tower', y: 632),
      ChartSampleData(x: 'Burj Khalifa', y: 828),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    'Maximum label\nwidth',
                    style: TextStyle(color: model.textColor),
                  ),
                ),
                CustomDirectionalButtons(
                  maxValue: 120,
                  minValue: 1,
                  initialValue: _xMaximumLabelWidth,
                  onChanged: (double val) {
                    setState(() {
                      _xMaximumLabelWidth = val;
                    });
                  },
                  step: 10,
                  loop: true,
                  padding: 5.0,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Enable label extent',
                    style: TextStyle(color: model.textColor),
                  ),
                  SizedBox(
                    width: 75,
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: model.primaryColor,
                      value: _isEnableLabelExtend,
                      onChanged: (bool? value) {
                        setState(() {
                          _isEnableLabelExtend = value!;
                          stateSetter(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isEnableLabelExtend,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Labels extent',
                    style: TextStyle(color: model.textColor),
                  ),
                  CustomDirectionalButtons(
                    maxValue: 200,
                    minValue: 1,
                    initialValue: _xLabelsExtent,
                    onChanged: (double val) {
                      setState(() {
                        _xLabelsExtent = val;
                      });
                    },
                    step: 10,
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 16.0, color: model.textColor),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : "World's tallest buildings"),
      primaryXAxis: CategoryAxis(
        labelsExtent: _isEnableLabelExtend ? _xLabelsExtent : null,
        maximumLabelWidth: _xMaximumLabelWidth,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Height (meters)'),
        minimum: 500,
        maximum: 900,
        interval: 100,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildBarSeries(),
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text = args.dataPoints[args.pointIndex].y.toString() + ' m';
      },
      onTooltipRender: (TooltipArgs args) {
        args.text =
            args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            args.dataPoints![args.pointIndex!.toInt()].y.toString() +
            ' m';
      },
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Bar series.
  List<CartesianSeries<ChartSampleData, String>> _buildBarSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: _worldTallestBuildingsData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }

  /// Method called when the type is changed.
  void onTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'Maximum label width') {
      _isEnableLabelExtend = false;
    }
    if (_selectedType == 'Labels extent') {
      _isEnableLabelExtend = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _worldTallestBuildingsData!.clear();
  }
}
