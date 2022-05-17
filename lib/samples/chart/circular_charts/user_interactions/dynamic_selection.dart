/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Render the pie series with selection.
class DynamicCircularSelection extends SampleView {
  /// Creates the pie series with selection.
  const DynamicCircularSelection(Key key) : super(key: key);
  @override
  _CircularSelectionState createState() => _CircularSelectionState();
}

class _CircularSelectionState extends SampleViewState {
  _CircularSelectionState();
  SelectionBehavior? selectionBehavior;
  List<String>? _pointIndexList;
  late int _pointIndex;
  @override
  void initState() {
    _pointIndex = 0;
    selectionBehavior = SelectionBehavior(enable: true);
    _pointIndexList = <String>['0', '1', '2', '3', '4', '5', '6'].toList();
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Row(
            children: <Widget>[
              Text('Point index ',
                  softWrap: false,
                  style: TextStyle(
                    color: model.textColor,
                    fontSize: 16,
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                  child: DropdownButton<String>(
                      focusColor: Colors.transparent,
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _pointIndex.toString(),
                      items: _pointIndexList!.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : '0',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          _pointIndex = int.parse(value);
                        });
                      })),
            ],
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(model.backgroundColor),
                  ),
                  onPressed: () {
                    selectionBehavior!.selectDataPoints(_pointIndex);
                  },
                  child: const Text('Select',
                      style: TextStyle(color: Colors.white)),
                ))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircularSelectionChart();
  }

  SfCircularChart _buildCircularSelectionChart() {
    return SfCircularChart(
      onSelectionChanged: (SelectionArgs args) {
        _pointIndex = args.pointIndex;
      },
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Various countries population density and area'),
      selectionGesture: ActivationMode.singleTap,
      series: getCircularSelectionSeries(),
    );
  }

  List<PieSeries<ChartSampleData, String>> getCircularSelectionSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Argentina', y: 505370),
            ChartSampleData(x: 'Belgium', y: 551500),
            ChartSampleData(x: 'Cuba', y: 312685),
            ChartSampleData(x: 'Dominican Republic', y: 350000),
            ChartSampleData(x: 'Egypt', y: 301000),
            ChartSampleData(x: 'Kazakhstan', y: 300000),
            ChartSampleData(x: 'Somalia', y: 357022)
          ],
          radius: '70%',
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          startAngle: 100,
          endAngle: 100,
          // dataLabelSettings: const DataLabelSettings(
          //     isVisible: true, labelPosition: ChartDataLabelPosition.outside),
          selectionBehavior: selectionBehavior)
    ];
  }

  @override
  void dispose() {
    _pointIndexList!.clear();
    super.dispose();
  }
}
