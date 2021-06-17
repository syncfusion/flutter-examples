/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the pie series with grouping datapoints.
class PiePointRenderMode extends SampleView {
  /// Creates the pie series with grouping datapoints.
  const PiePointRenderMode(Key key) : super(key: key);

  @override
  _PiePointRenderModeState createState() => _PiePointRenderModeState();
}

class _PiePointRenderModeState extends SampleViewState {
  _PiePointRenderModeState();
  final List<String> _modeList = <String>['gradient', 'segment'].toList();
  String _selectedMode = 'gradient';
  PointRenderMode _mode = PointRenderMode.segment;
  @override
  void initState() {
    _selectedMode = 'gradient';
    _mode = PointRenderMode.gradient;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGroupingPieChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 60,
                child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      ListTile(
                        title: Text('Point rendering mode',
                            style: TextStyle(
                              color: model.textColor,
                            )),
                        trailing: Container(
                          padding: EdgeInsets.only(left: 0.07 * screenWidth),
                          width: 0.5 * screenWidth,
                          height: 50,
                          alignment: Alignment.bottomLeft,
                          child: DropdownButton<String>(
                              underline: Container(
                                  color: const Color(0xFFBDBDBD), height: 1),
                              value: _selectedMode,
                              items: _modeList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value:
                                        (value != null) ? value : 'Render mode',
                                    child: Text(value,
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  onModeTypeChange(value);
                                  stateSetter(() {});
                                });
                              }),
                        ),
                      ),
                    ]));
          }),
        ],
      );
    });
  }

  /// Return the circular charts with pie series.
  SfCircularChart _buildGroupingPieChart() {
    return SfCircularChart(
      title: ChartTitle(
          text: isCardView ? '' : 'Monthly expenditure of an individual'),
      series: _getGroupingPieSeries(),
    );
  }

  /// Return the pie series which need to be grouping.
  List<PieSeries<ChartSampleData, String>> _getGroupingPieSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Food', y: 15, text: 'Food\n15%', pointColor: null),
      ChartSampleData(
          x: 'Medical', y: 28, text: 'Medical\n28%', pointColor: null),
      ChartSampleData(
          x: 'Travel', y: 15, text: 'Travel\n15%', pointColor: null),
      ChartSampleData(
          x: 'Shopping', y: 17, text: 'Shopping\n17%', pointColor: null),
      ChartSampleData(
          x: 'Others',
          y: 25,
          text: 'Others\n25%',
          pointColor: const Color.fromRGBO(198, 201, 207, 1))
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          radius: isCardView ? '70%' : '58%',
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside),
          dataSource: pieData,
          pointRenderMode: _mode,

          /// To enable and specify the group mode for pie chart.
          groupMode: CircularChartGroupMode.value,
          groupTo: 7,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y)
    ];
  }

  void onModeTypeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'segment') {
      _mode = PointRenderMode.segment;
    }
    if (_selectedMode == 'gradient') {
      _mode = PointRenderMode.gradient;
    }
    setState(() {
      /// update the trackball display type changes
    });
  }
}
