/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default column series chart that
/// tracks interactive events.
class Events extends SampleView {
  /// Creates the default column series chart for event tracking.
  const Events(Key key) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

final ScrollController _scrollController = ScrollController();

/// State class for the default column chart that handles events.
class _EventsState extends SampleViewState {
  _EventsState();
  late List<String> _actionsList;
  late GlobalKey _consoleKey;
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _actionsList = <String>[];
    _consoleKey = GlobalKey();
    _tooltipBehavior = TooltipBehavior(
      animationDuration: 0,
      canShowMarker: false,
      enable: true,
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'China', y: 0.541),
      ChartSampleData(x: 'Brazil', y: 0.818),
      ChartSampleData(x: 'Bolivia', y: 1.51),
      ChartSampleData(x: 'Mexico', y: 1.302),
      ChartSampleData(x: 'Egypt', y: 2.017),
      ChartSampleData(x: 'Mongolia', y: 1.683),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.height >
            MediaQuery.of(context).size.width
        ? _buildVerticalLayout()
        : _buildHorizontalLayout();
  }

  /// Builds the vertical layout of the widget.
  Widget _buildVerticalLayout() {
    return Column(
      children: <Widget>[
        Expanded(flex: 6, child: _buildDefaultColumnChart()),
        if (isCardView)
          Container()
        else
          Expanded(flex: 4, child: _buildEventTrace()),
      ],
    );
  }

  /// Builds the horizontal layout of the widget.
  Widget _buildHorizontalLayout() {
    return Row(
      children: <Widget>[
        Expanded(flex: 6, child: _buildDefaultColumnChart()),
        if (isCardView)
          Container()
        else
          Expanded(flex: 4, child: _buildEventTrace()),
      ],
    );
  }

  /// Builds the event trace section.
  Widget _buildEventTrace() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Event Trace',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      splashRadius: 25,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _actionsList.clear();
                        _consoleKey.currentState?.setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Console(_actionsList, _consoleKey),
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian chart with default column series.
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      onAxisLabelTapped: (AxisLabelTapArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Axis label (${args.text}) was tapped');
          _consoleKey.currentState?.setState(() {});
        }
      },
      onDataLabelTapped: (DataLabelTapDetails args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Data label (${args.text}) was tapped');
          _consoleKey.currentState?.setState(() {});
        }
      },
      onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Chart was tapped down');
          _consoleKey.currentState?.setState(() {});
        }
      },
      onChartTouchInteractionMove: (ChartTouchInteractionArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Moved on chart area');
          _consoleKey.currentState?.setState(() {});
        }
      },
      onLegendTapped: (LegendTapArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Legend was tapped');
          _consoleKey.currentState?.setState(() {});
        }
      },
      onMarkerRender: (MarkerRenderArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Marker (${args.pointIndex}) was rendered');
          if (args.pointIndex == 5) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _consoleKey.currentState?.setState(() {});
            });
          }
        }
      },
      onTooltipRender: (TooltipArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Tooltip (${args.text}) is showing');
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _consoleKey.currentState?.setState(() {});
          });
        }
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Chart was tapped up');
          _consoleKey.currentState?.setState(() {});
        }
      },
      onLegendItemRender: (LegendRenderArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Legend (${args.text}) was rendered');
        }
      },
      onDataLabelRender: (DataLabelRenderArgs args) {
        if (!isCardView) {
          _actionsList.insert(0, 'Data label (${args.text}) was rendered');
        }
      },
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Population growth of various countries',
      ),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          if (!isCardView) {
            _actionsList.insert(0, 'Axis label (${details.text}) was rendered');
          }
          return ChartAxisLabel(details.text, null);
        },
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}%',
        majorTickLines: const MajorTickLines(size: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          if (!isCardView) {
            _actionsList.insert(0, 'Axis label (${details.text}) was rendered');
          }
          return ChartAxisLabel(details.text, null);
        },
      ),
      series: _buildColumnSeries(),
      legend: Legend(
        isVisible: isCardView ? false : true,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        animationDuration: 0,
        name: 'Population',
        onPointTap: (ChartPointDetails args) {
          if (!isCardView) {
            _actionsList.insert(0, 'Point (${args.pointIndex}) was tapped');
            _consoleKey.currentState?.setState(() {});
          }
        },
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

/// Renders a console to display tracked events.
class Console extends StatefulWidget {
  /// Creates a console to display tracked events.
  const Console(this.actionsList, Key consoleKey) : super(key: consoleKey);

  /// List of actions that have been performed.
  final List<String> actionsList;
  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView.separated(
          controller: _scrollController,
          separatorBuilder: (BuildContext context, int build) =>
              const Divider(color: Colors.grey, height: 4),
          itemCount: widget.actionsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Text(widget.actionsList[index]),
            );
          },
        ),
      ),
    );
  }
}
