import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore:must_be_immutable
class ButtonZooming extends StatefulWidget {
  ButtonZooming({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ButtonZoomingState createState() => _ButtonZoomingState(sample);
}

ZoomPanBehavior zoomPan;
final List<ChartSampleData> zoomData = <ChartSampleData>[
  ChartSampleData(x: 1.5, y: 21),
  ChartSampleData(x: 2.2, y: 24),
  ChartSampleData(x: 3.32, y: 36),
  ChartSampleData(x: 4.56, y: 38),
  ChartSampleData(x: 5.87, y: 54),
  ChartSampleData(x: 6.8, y: 57),
  ChartSampleData(x: 8.5, y: 70),
  ChartSampleData(x: 9.5, y: 21),
  ChartSampleData(x: 10.2, y: 24),
  ChartSampleData(x: 11.32, y: 36),
  ChartSampleData(x: 14.56, y: 38),
  ChartSampleData(x: 15.87, y: 54),
  ChartSampleData(x: 16.8, y: 57),
  ChartSampleData(x: 18.5, y: 23),
  ChartSampleData(x: 21.5, y: 21),
  ChartSampleData(x: 22.2, y: 24),
  ChartSampleData(x: 23.32, y: 36),
  ChartSampleData(x: 24.56, y: 32),
  ChartSampleData(x: 25.87, y: 54),
  ChartSampleData(x: 26.8, y: 12),
  ChartSampleData(x: 28.5, y: 54),
  ChartSampleData(x: 30.2, y: 24),
  ChartSampleData(x: 31.32, y: 36),
  ChartSampleData(x: 34.56, y: 38),
  ChartSampleData(x: 35.87, y: 14),
  ChartSampleData(x: 36.8, y: 57),
  ChartSampleData(x: 38.5, y: 70),
  ChartSampleData(x: 41.5, y: 21),
  ChartSampleData(x: 41.2, y: 24),
  ChartSampleData(x: 43.32, y: 36),
  ChartSampleData(x: 44.56, y: 21),
  ChartSampleData(x: 45.87, y: 54),
  ChartSampleData(x: 46.8, y: 57),
  ChartSampleData(x: 48.5, y: 54),
  ChartSampleData(x: 49.56, y: 38),
  ChartSampleData(x: 49.87, y: 14),
  ChartSampleData(x: 51.8, y: 57),
  ChartSampleData(x: 54.5, y: 32),
  ChartSampleData(x: 55.5, y: 21),
  ChartSampleData(x: 57.2, y: 24),
  ChartSampleData(x: 59.32, y: 36),
  ChartSampleData(x: 60.56, y: 21),
  ChartSampleData(x: 62.87, y: 54),
  ChartSampleData(x: 63.8, y: 23),
  ChartSampleData(x: 65.5, y: 54)
];

class _ButtonZoomingState extends State<ButtonZooming> {
  _ButtonZoomingState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    zoomPan = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    return getScopedModel(null, sample, ZoomingWithButtonFrontPanel(sample));
  }
}

SfCartesianChart getButtonZoomingChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getButtonZoomingSeries(isTileView),
    zoomPanBehavior: zoomPan,
  );
}

List<LineSeries<ChartSampleData, num>> getButtonZoomingSeries(bool isTileView) {
  return <LineSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
        dataSource: zoomData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2)
  ];
}

//ignore: must_be_immutable
class ZoomingWithButtonFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  ZoomingWithButtonFrontPanel([this.sample]);
  SubItem sample;

  @override
  _ZoomingWithButtonFrontPanelState createState() =>
      _ZoomingWithButtonFrontPanelState(sample);
}

class _ZoomingWithButtonFrontPanelState
    extends State<ZoomingWithButtonFrontPanel> {
  _ZoomingWithButtonFrontPanelState(this.sample);
  final SubItem sample;
  Widget sampleWidget(SampleModel model) => getButtonZoomingChart(false);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getButtonZoomingChart(false)),
              ),
              floatingActionButton: Container(
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 0),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_up,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_left,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_right,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: model.backgroundColor),
                                  onPressed: () {
                                    zoomPan.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ));
        });
  }
}
