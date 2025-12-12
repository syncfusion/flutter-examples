/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the pie series chart with grouping data points.
class PiePointRenderMode extends SampleView {
  /// Creates the pie series chart with grouping data points.
  const PiePointRenderMode(Key key) : super(key: key);

  @override
  _PiePointRenderModeState createState() => _PiePointRenderModeState();
}

class _PiePointRenderModeState extends SampleViewState {
  _PiePointRenderModeState();
  late String _selectedMode;
  late PointRenderMode _mode;
  late List<ChartSampleData> _chartData;

  List<String>? _modeList;

  @override
  void initState() {
    _modeList = <String>['gradient', 'segment'].toList();
    _selectedMode = 'gradient';
    _mode = PointRenderMode.gradient;
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Food', y: 15, text: 'Food\n15%'),
      ChartSampleData(x: 'Medical', y: 28, text: 'Medical\n28%'),
      ChartSampleData(x: 'Travel', y: 15, text: 'Travel\n15%'),
      ChartSampleData(x: 'Shopping', y: 17, text: 'Shopping\n17%'),
      ChartSampleData(
        x: 'Others',
        y: 25,
        text: 'Others\n25%',
        pointColor: const Color.fromRGBO(198, 201, 207, 1),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGroupingPieChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildPointRenderingSettingsUI(screenWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the point rendering settings UI.
  Widget _buildPointRenderingSettingsUI(
    double screenWidth,
    StateSetter stateSetter,
  ) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              model.isWebFullView
                  ? 'Point \nrendering \nmode'
                  : 'Point rendering mode',
              softWrap: false,
              style: TextStyle(fontSize: 16, color: model.textColor),
            ),
            _buildPointRenderModeDropdown(screenWidth, stateSetter),
          ],
        ),
      ],
    );
  }

  /// Builds the dropdown menu for point rendering mode selection.
  Widget _buildPointRenderModeDropdown(
    double screenWidth,
    StateSetter stateSetter,
  ) {
    return DropdownButton<String>(
      dropdownColor: model.drawerBackgroundColor,
      focusColor: Colors.transparent,
      underline: Container(color: const Color(0xFFBDBDBD), height: 1),
      value: _selectedMode,
      items: _modeList!.map((String value) {
        return DropdownMenuItem<String>(
          value: (value != null) ? value : 'Render mode',
          child: Text(value, style: TextStyle(color: model.textColor)),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          _onPointRenderModeChange(value);
          stateSetter(() {});
        });
      },
    );
  }

  /// Returns the circular pie chart with rendering mode selection.
  SfCircularChart _buildGroupingPieChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Monthly expenditure of an individual',
      ),
      series: _buildPieSeries(),
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        radius: isCardView ? '70%' : '58%',
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
        pointRenderMode: _mode,

        /// Enables and specifies the group mode for the pie chart.
        groupMode: CircularChartGroupMode.value,
        groupTo: 7,
      ),
    ];
  }

  void _onPointRenderModeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'segment') {
      _mode = PointRenderMode.segment;
    }
    if (_selectedMode == 'gradient') {
      _mode = PointRenderMode.gradient;
    }
    setState(() {
      /// Update the point rendering mode type changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _modeList!.clear();
    super.dispose();
  }
}
