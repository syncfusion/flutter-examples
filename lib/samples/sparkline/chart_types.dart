/// Package import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Chart import

/// Local import
import '../../model/sample_view.dart';

///Renders default line series chart
class SparklineSeriesTypes extends SampleView {
  ///Creates default line series chart
  const SparklineSeriesTypes(Key key) : super(key: key);

  @override
  _SparklineSeriesTypesState createState() => _SparklineSeriesTypesState();
}

class _SparklineSeriesTypesState extends SampleViewState {
  _SparklineSeriesTypesState();

  double _size = 150;
  bool _isVertical = false;

  @override
  Widget build(BuildContext context) {
    _isVertical =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    if (_isVertical) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 6
          : MediaQuery.of(context).size.height / 6;
      return model.isWebFullView && model.isMobileResolution
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5)),
                  _buildSparkLineChart(),
                  const Padding(padding: EdgeInsets.all(5)),
                  _buildSparkAreaChart(),
                  const Padding(padding: EdgeInsets.all(5)),
                  _buildSparkBarChart(),
                  const Padding(padding: EdgeInsets.all(5)),
                  _buildSparkWinlossChart(),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5)),
                  Expanded(child: _buildSparkLineChart()),
                  const Padding(padding: EdgeInsets.all(5)),
                  Expanded(child: _buildSparkAreaChart()),
                  const Padding(padding: EdgeInsets.all(5)),
                  Expanded(child: _buildSparkBarChart()),
                  const Padding(padding: EdgeInsets.all(5)),
                  Expanded(child: _buildSparkWinlossChart()),
                ],
              ),
            );
    } else {
      _size = MediaQuery.of(context).size.width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(5)),
            _buildSparkLineChart(),
            const Padding(padding: EdgeInsets.all(5)),
            _buildSparkAreaChart(),
            const Padding(padding: EdgeInsets.all(5)),
            _buildSparkBarChart(),
            const Padding(padding: EdgeInsets.all(5)),
            _buildSparkWinlossChart(),
          ],
        ),
      );
    }
  }

  Widget _buildSparkLineChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: _isVertical ? _size : _size * 0.7,
            width: _isVertical ? _size * 2 : _size,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SfSparkLineChart(
                    trackball: const SparkChartTrackball(),
                    marker: const SparkChartMarker(
                      borderWidth: 3,
                      displayMode: SparkChartMarkerDisplayMode.all,
                      color: Colors.blue,
                    ),
                    axisLineWidth: 0,
                    data: const <double>[
                      5,
                      6,
                      5,
                      7,
                      4,
                      3,
                      9,
                      5,
                      6,
                      5,
                      7,
                      8,
                      4,
                      5,
                      3,
                      4,
                      11,
                      10,
                      2,
                      12,
                      4,
                      7,
                      6,
                      8,
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text(
                  'Spark Line Chart',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSparkAreaChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: _isVertical ? _size : _size * 0.7,
            width: _isVertical ? _size * 2 : _size,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SfSparkAreaChart(
                    trackball: const SparkChartTrackball(),
                    data: const <double>[
                      34,
                      36,
                      32,
                      35,
                      40,
                      38,
                      33,
                      37,
                      34,
                      31,
                      30,
                      29,
                    ],
                    color: const Color.fromRGBO(68, 150, 236, 0.3),
                    axisLineWidth: 0,
                    borderWidth: 2,
                    borderColor: const Color.fromRGBO(68, 150, 236, 1),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text(
                  'Spark Area Chart',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Get the cartesian chart with default line series
  Widget _buildSparkBarChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: _isVertical ? _size : _size * 0.7,
            width: _isVertical ? _size * 2 : _size,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SfSparkBarChart(
                    axisLineWidth: 0,
                    highPointColor: const Color.fromRGBO(20, 170, 33, 1),
                    data: const <double>[
                      10,
                      6,
                      8,
                      -5,
                      11,
                      5,
                      -2,
                      7,
                      -3,
                      6,
                      8,
                      10,
                    ],
                    trackball: const SparkChartTrackball(),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text(
                  'Spark Bar Chart',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Get the cartesian chart with default line series
  Widget _buildSparkWinlossChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: _isVertical ? _size : _size * 0.7,
            width: _isVertical ? _size * 2 : _size,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SfSparkWinLossChart(
                    data: const <double>[
                      12,
                      15,
                      -10,
                      13,
                      15,
                      6,
                      -12,
                      17,
                      13,
                      0,
                      8,
                      -10,
                    ],
                    trackball: const SparkChartTrackball(),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text(
                  'Spark Win Loss Chart',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
