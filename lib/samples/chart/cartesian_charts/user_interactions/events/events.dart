/// Package import
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

///Renders default column chart sample
class Events extends SampleView {
  ///Renders default column chart sample
  const Events(Key key) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

// final GlobalKey consoleKey = GlobalKey<ConsoleState>();
final ScrollController _scrollController = ScrollController();

class _EventsState extends SampleViewState {
  _EventsState();
  List<String> actionsList = <String>[];
  final GlobalKey consoleKey = GlobalKey();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      animationDuration: 0,
      canShowMarker: false,
      enable: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.height >
            MediaQuery.of(context).size.width
        ? Column(children: <Widget>[
            Expanded(
              flex: 6,
              child: _buildDefaultEventChart(),
            ),
            if (isCardView)
              Container()
            else
              Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4))),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Event Trace',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))),
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              splashRadius: 25,
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                actionsList.clear();
                                                consoleKey.currentState
                                                    ?.setState(() {});
                                              },
                                            ))),
                                  ],
                                ))),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Console(actionsList, consoleKey),
                        ))
                      ],
                    ),
                  )),
          ])
        : Row(children: <Widget>[
            Expanded(
              flex: 6,
              child: _buildDefaultEventChart(),
            ),
            if (isCardView)
              Container()
            else
              Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4))),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Event Trace',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))),
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              splashRadius: 25,
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                actionsList.clear();
                                                consoleKey.currentState
                                                    ?.setState(() {});
                                              },
                                            ))),
                                  ],
                                ))),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Console(actionsList, consoleKey),
                        ))
                      ],
                    ),
                  )),
          ]);
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultEventChart() {
    return SfCartesianChart(
      axisLabelFormatter: (AxisLabelRenderDetails details) {
        if (!isCardView) {
          actionsList.insert(0, 'Axis label (${details.text}) was rendered');
        }
        return ChartAxisLabel(details.text, null);
      },
      onAxisLabelTapped: (AxisLabelTapArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Axis label (${args.text}) was tapped');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onDataLabelTapped: (DataLabelTapDetails args) {
        if (!isCardView) {
          actionsList.insert(0, 'Data label (${args.text}) was tapped');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onPointTapped: (PointTapArgs args) {
        if (!isCardView) {
          actionsList.insert(
              0, 'Point (${args.pointIndex.toString()}) was tapped');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Chart was tapped down');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onChartTouchInteractionMove: (ChartTouchInteractionArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Moved on chart area');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onLegendTapped: (LegendTapArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Legend was tapped');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onMarkerRender: (MarkerRenderArgs args) {
        if (!isCardView) {
          actionsList.insert(
              0, 'Marker (${args.pointIndex.toString()}) was rendered');
          if (args.pointIndex == 5) {
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              (consoleKey.currentState)?.setState(() {});
            });
          }
        }
      },
      onTooltipRender: (TooltipArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Tooltip (${args.text}) is showing');
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            (consoleKey.currentState)?.setState(() {});
          });
        }
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Chart was tapped up');
          (consoleKey.currentState)?.setState(() {});
        }
      },
      onLegendItemRender: (LegendRenderArgs args) {
        if (!isCardView) {
          actionsList.insert(0, 'Legend (${args.text}) was rendered');
        }
      },
      onDataLabelRender: (DataLabelRenderArgs args) {
        if (!isCardView) {
          actionsList.insert(
              0, 'Data label (${args.text.toString()}) was rendered');
        }
      },
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth of various countries'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(),
      legend: Legend(
          isVisible: isCardView ? false : true,
          position: LegendPosition.bottom),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'China', y: 0.541),
      ChartSampleData(x: 'Brazil', y: 0.818),
      ChartSampleData(x: 'Bolivia', y: 1.51),
      ChartSampleData(x: 'Mexico', y: 1.302),
      ChartSampleData(x: 'Egypt', y: 2.017),
      ChartSampleData(x: 'Mongolia', y: 1.683),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        animationDuration: 0,
        name: 'Population',
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    ];
  }
}

/// Renders the console for evets
class Console extends StatefulWidget {
  /// Creates the console for events
  const Console(this.actionsList, Key consoleKey) : super(key: consoleKey);

  /// collections of actions performed
  final List<String> actionsList;
  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  void scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    setState(() {});
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.4))),
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListView.separated(
            controller: _scrollController,
            separatorBuilder: (BuildContext context, int build) =>
                const Divider(
              color: Colors.grey,
              height: 4,
            ),
            itemCount: widget.actionsList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Text(widget.actionsList[index]),
              );
            },
          )),
    );
  }
}
