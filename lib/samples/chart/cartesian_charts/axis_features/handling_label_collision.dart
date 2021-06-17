/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the label intersect action chart.
class LabelAction extends SampleView {
  /// Creates the label intersect action chart.
  const LabelAction(Key key) : super(key: key);

  @override
  _LabelActionState createState() => _LabelActionState();
}

/// State class of the label intersect action chart.
class _LabelActionState extends SampleViewState {
  _LabelActionState();
  final List<String> _labelList = <String>[
    'hide',
    'none',
    'multipleRows',
    'rotate45',
    'rotate90',
    'wrap'
  ].toList();
  String _selectedType = 'hide';
  late AxisLabelIntersectAction _labelIntersectAction =
      AxisLabelIntersectAction.hide;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _selectedType = 'hide';
    _labelIntersectAction = AxisLabelIntersectAction.hide;
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        format: 'point.x : point.y Goals',
        header: '',
        canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLabelIntersectActionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Intersect action ',
              style: TextStyle(
                color: model.textColor,
                fontSize: 16,
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: DropdownButton<String>(
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedType,
                items: _labelList.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'hide',
                      child: Text(value,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (String? value) {
                  _onPositionTypeChange(value.toString());
                  stateSetter(() {});
                }),
          ),
        ],
      );
    });
  }

  /// Returns the column chart with label intersect action option.
  SfCartesianChart _buildLabelIntersectActionChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Football players with most goals'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: _labelIntersectAction,
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interval: 40,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getLabelIntersectActionSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, String>> _getLabelIntersectActionSeries() {
    final List<ChartSampleData> chartData = model.isWebFullView
        ? <ChartSampleData>[
            ChartSampleData(x: 'Josef Bican', y: 805),
            ChartSampleData(x: 'Romário', y: 772),
            ChartSampleData(x: 'Pelé', y: 767),
            ChartSampleData(x: 'Ferenc Puskás', y: 746),
            ChartSampleData(x: 'Gerd Müller', y: 735),
            ChartSampleData(x: 'Ronaldo', y: 725),
            ChartSampleData(x: 'Messi', y: 730),
            ChartSampleData(x: 'Ferenc Deák', y: 576),
            ChartSampleData(x: 'Uwe Seeler', y: 575),
            ChartSampleData(x: 'Túlio Maravilha', y: 575),
            ChartSampleData(x: 'Arthur Friedenreich', y: 557),
            ChartSampleData(x: 'Ernst Wilimowski', y: 554),
            ChartSampleData(x: 'Eusébio', y: 552)
          ]
        : <ChartSampleData>[
            ChartSampleData(x: 'Josef Bican', y: 805),
            ChartSampleData(x: 'Romário', y: 772),
            ChartSampleData(x: 'Pelé', y: 767),
            ChartSampleData(x: 'Ferenc Puskás', y: 746),
            ChartSampleData(x: 'Gerd Müller', y: 735),
            ChartSampleData(x: 'Ronaldo', y: 725),
            ChartSampleData(x: 'Messi', y: 730)
          ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelAlignment: ChartDataLabelAlignment.top))
    ];
  }

  /// Method for updating the axis label intersect action type
  /// in the chart on change.
  void _onPositionTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'hide') {
      _labelIntersectAction = AxisLabelIntersectAction.hide;
    }
    if (_selectedType == 'none') {
      _labelIntersectAction = AxisLabelIntersectAction.none;
    }
    if (_selectedType == 'multipleRows') {
      _labelIntersectAction = AxisLabelIntersectAction.multipleRows;
    }
    if (_selectedType == 'rotate45') {
      _labelIntersectAction = AxisLabelIntersectAction.rotate45;
    }
    if (_selectedType == 'rotate90') {
      _labelIntersectAction = AxisLabelIntersectAction.rotate90;
    }
    if (_selectedType == 'wrap') {
      _labelIntersectAction = AxisLabelIntersectAction.wrap;
    }
    setState(() {
      /// update the axis label intersection action changes
    });
  }
}
