/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the funnel chart with smart data label
class FunnelSmartLabels extends SampleView {
  /// Creates the funnel chart eith legend
  const FunnelSmartLabels(Key key) : super(key: key);

  @override
  _FunnelSmartLabelState createState() => _FunnelSmartLabelState();
}

class _FunnelSmartLabelState extends SampleViewState {
  _FunnelSmartLabelState();
  final List<String> _labelPosition = <String>['outside', 'inside'].toList();
  ChartDataLabelPosition _selectedLabelPosition =
      ChartDataLabelPosition.outside;
  String _selectedPosition = 'outside';

  final List<String> _modeList = <String>['shift', 'none', 'hide'].toList();
  String _smartLabelMode = 'shift';
  SmartLabelMode _mode = SmartLabelMode.shift;

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
            title: Text('Label Position  ',
                style: TextStyle(color: model.textColor)),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.4 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _selectedPosition,
                  items: _labelPosition.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'outside',
                        child: Text(value,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onLabelPositionChange(value.toString());
                    stateSetter(() {});
                  }),
            ),
          ),
          ListTile(
            title: Text('Smart label mode',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.4 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _smartLabelMode,
                  items: _modeList.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'shift',
                        child: Text(value,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onSmartLabelModeChange(value.toString());
                    stateSetter(() {});
                  }),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildFunnelSmartLabelChart();
  }

  ///Get the funnel chart with smart data label
  SfFunnelChart _buildFunnelSmartLabelChart() {
    return SfFunnelChart(
      smartLabelMode: _mode,
      title: ChartTitle(text: isCardView ? '' : 'Tournament details'),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      series: _getFunnelSeries(),
    );
  }

  ///Get the funnel series with smart data label
  FunnelSeries<ChartSampleData, String> _getFunnelSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Finals', y: 2),
      ChartSampleData(x: 'Semifinals', y: 4),
      ChartSampleData(x: 'Quarter finals', y: 8),
      ChartSampleData(x: 'League matches', y: 16),
      ChartSampleData(x: 'Participated', y: 32),
      ChartSampleData(x: 'Eligible', y: 36),
      ChartSampleData(x: 'Applicants', y: 40),
    ];
    return FunnelSeries<ChartSampleData, String>(
        width: '60%',
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,

        /// To enable the data label for funnel chart.
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: isCardView
                ? ChartDataLabelPosition.outside
                : _selectedLabelPosition,
            useSeriesColor: true));
  }

  ///change the data label position
  void _onLabelPositionChange(String item) {
    _selectedPosition = item;
    if (_selectedPosition == 'inside') {
      _selectedLabelPosition = ChartDataLabelPosition.inside;
    } else if (_selectedPosition == 'outside') {
      _selectedLabelPosition = ChartDataLabelPosition.outside;
    }
    setState(() {
      /// update the label position type change
    });
  }

  ///Change the data label mode
  void _onSmartLabelModeChange(String item) {
    _smartLabelMode = item;
    if (_smartLabelMode == 'shift') {
      _mode = SmartLabelMode.shift;
    }
    if (_smartLabelMode == 'hide') {
      _mode = SmartLabelMode.hide;
    }
    if (_smartLabelMode == 'none') {
      _mode = SmartLabelMode.none;
    }
    setState(() {
      /// update the smart data label mode changes
    });
  }
}
