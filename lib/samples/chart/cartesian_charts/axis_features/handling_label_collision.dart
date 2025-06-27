/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the label intersect action Chart.
class LabelAction extends SampleView {
  const LabelAction(Key key) : super(key: key);

  @override
  _LabelActionState createState() => _LabelActionState();
}

/// State class of the label intersect action Chart.
class _LabelActionState extends SampleViewState {
  _LabelActionState();

  List<String>? _labelList;
  AxisLabelIntersectAction? _labelIntersectAction;
  late String _selectedType;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _footballPlayersGoalsData;
  List<ChartSampleData>? _footballPlayersGoalsData1;
  List<ChartSampleData>? _footballPlayersGoalsData2;

  @override
  void initState() {
    _labelList = <String>[
      'hide',
      'none',
      'multipleRows',
      'rotate45',
      'rotate90',
      'wrap',
      'trim',
    ].toList();
    _labelIntersectAction = AxisLabelIntersectAction.hide;
    _selectedType = 'hide';
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y Goals',
      header: '',
      canShowMarker: false,
    );
    _footballPlayersGoalsData1 = <ChartSampleData>[
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
      ChartSampleData(x: 'Eusébio', y: 552),
    ];
    _footballPlayersGoalsData2 = <ChartSampleData>[
      ChartSampleData(x: 'Josef Bican', y: 805),
      ChartSampleData(x: 'Romário', y: 772),
      ChartSampleData(x: 'Pelé', y: 767),
      ChartSampleData(x: 'Ferenc Puskás', y: 746),
      ChartSampleData(x: 'Gerd Müller', y: 735),
      ChartSampleData(x: 'Ronaldo', y: 725),
      ChartSampleData(x: 'Messi', y: 730),
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              model.isWebFullView ? 'Intersect \naction' : 'Intersect action ',
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedType,
                items: _labelList!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : 'hide',
                    child: Text(
                      value,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  _onPositionTypeChange(value.toString());
                  stateSetter(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Football players with most goals',
      ),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: _labelIntersectAction!,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        interval: model.isMobile
            ? model.isCardView
                  ? 20
                  : 10
            : 100,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    _footballPlayersGoalsData = model.isWebFullView
        ? _footballPlayersGoalsData1
        : _footballPlayersGoalsData2;
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _footballPlayersGoalsData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
    ];
  }

  /// Method for updating the axis label intersect action type in the Chart.
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
    if (_selectedType == 'trim') {
      _labelIntersectAction = AxisLabelIntersectAction.trim;
    }
    setState(() {
      /// Update the axis label intersection action changes.
    });
  }

  @override
  void dispose() {
    _labelList!.clear();
    _footballPlayersGoalsData!.clear();
    super.dispose();
  }
}
