/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the chart with sorting options sample.
class ChartMaximumLabelWidth extends SampleView {
  /// Creates the chart with sorting options sample.
  const ChartMaximumLabelWidth(Key key) : super(key: key);

  @override
  _ChartMaximumLabelWidthState createState() => _ChartMaximumLabelWidthState();
}

/// State class the chart with sorting options.
class _ChartMaximumLabelWidthState extends SampleViewState {
  _ChartMaximumLabelWidthState();
  double _xMaximumLabelWidth = 80;
  double _xLabelsExtent = 80;
  bool _isEnableLabelExtend = false;
  // ignore: unused_field
  bool _isEnableMaximumLabelWidth = true;
  // ignore: unused_field
  late List<bool> _isSelected;
  String _selectedType = 'Maximum label width';
  //ignore: unused_field
  final List<String> _typeList = <String>[
    'Maximum label width',
    'Labels extent'
  ];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _isSelected = <bool>[true, false];
    _tooltipBehavior =
        TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildmaximumLabelWidthChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text('Maximum label\nwidth',
                      style: TextStyle(color: model.textColor)),
                ),
                Container(
                  padding: !model.isWebFullView
                      ? const EdgeInsets.fromLTRB(32, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(42, 0, 0, 0),
                  child: CustomDirectionalButtons(
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
                )
              ],
            ),
          ),
          Container(
              child: Row(
            children: <Widget>[
              Text('Enable label extent',
                  style: TextStyle(color: model.textColor)),
              Container(
                  width: 75,
                  child: CheckboxListTile(
                      activeColor: model.backgroundColor,
                      value: _isEnableLabelExtend,
                      onChanged: (bool? value) {
                        setState(() {
                          _isEnableLabelExtend = value!;
                          stateSetter(() {});
                        });
                      }))
            ],
          )),
          Container(
            child: Visibility(
                visible: _isEnableLabelExtend,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Labels extent',
                        style: TextStyle(color: model.textColor)),
                    Container(
                      padding: !model.isWebFullView
                          ? const EdgeInsets.fromLTRB(40, 0, 0, 0)
                          : const EdgeInsets.fromLTRB(50, 0, 0, 0),
                      child: CustomDirectionalButtons(
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
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      );
    });
  }

  /// Returns the Cartesian chart with sorting options.
  SfCartesianChart _buildmaximumLabelWidthChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text = args.dataPoints[args.pointIndex].y.toString() + ' m';
      },
      onTooltipRender: (TooltipArgs args) {
        args.text = args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            args.dataPoints![args.pointIndex!.toInt()].y.toString() +
            ' m';
      },
      primaryXAxis: CategoryAxis(
          labelsExtent: _isEnableLabelExtend ? _xLabelsExtent : null,
          maximumLabelWidth: _xMaximumLabelWidth,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Height (meters)'),
          minimum: 500,
          maximum: 900,
          interval: 100,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSortingSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with sorting options.
  List<CartesianSeries<ChartSampleData, String>> _getDefaultSortingSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Goldin Finance 117', y: 597),
      ChartSampleData(x: 'Ping An Finance Center', y: 599),
      ChartSampleData(x: 'Makkah Clock Royal Tower', y: 601),
      ChartSampleData(x: 'Shanghai Tower', y: 632),
      ChartSampleData(x: 'Burj Khalifa', y: 828)
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings:
            DataLabelSettings(isVisible: true, offset: const Offset(-5, 0)),
      )
    ];
  }

  void onTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'Maximum label width') {
      _isEnableMaximumLabelWidth = true;
      _isEnableLabelExtend = false;
    }
    if (_selectedType == 'Labels extent') {
      _isEnableLabelExtend = true;
      _isEnableMaximumLabelWidth = false;
    }
    setState(() {});
  }
}
