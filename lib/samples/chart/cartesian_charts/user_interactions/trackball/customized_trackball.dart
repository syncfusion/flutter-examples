/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with default trackball sample.
class TrackballTemplate extends SampleView {
  /// Creates the chart with default trackball sample.
  const TrackballTemplate(Key key) : super(key: key);

  @override
  _TrackballTemplateState createState() => _TrackballTemplateState();
}

/// State class the chart with default trackball.
class _TrackballTemplateState extends SampleViewState {
  _TrackballTemplateState();
  // ignore: unused_field
  double _duration = 2;
  // ignore: unused_field
  bool _showAlways = false;
  final List<String> _modeList =
      <String>['floatAllPoints', 'groupAllPoints', 'nearestPoint'].toList();
  String _selectedMode = 'floatAllPoints';

  TrackballDisplayMode _mode = TrackballDisplayMode.floatAllPoints;

  bool _isTemplate = true;

  @override
  void initState() {
    _duration = 2;
    _showAlways = false;
    _selectedMode = 'floatAllPoints';
    _mode = TrackballDisplayMode.floatAllPoints;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackballTemplateChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 50,
                child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text('Display mode',
                                style: TextStyle(
                                  color: model.textColor,
                                  fontSize: 16,
                                )),
                            Container(
                              padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                              height: 50,
                              width: 190,
                              alignment: Alignment.bottomLeft,
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: Container(
                                      color: const Color(0xFFBDBDBD),
                                      height: 1),
                                  value: _selectedMode,
                                  items: _modeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null)
                                            ? value
                                            : 'floatAllPoints',
                                        child: Text(value,
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      onModeTypeChange(value!);
                                      stateSetter(() {});
                                    });
                                  }),
                            ),
                          ],
                        ),
                      )
                    ]));
          }),
          Container(
            child: Row(
              children: <Widget>[
                Text('Tooltip template',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                    width: 90,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: _isTemplate,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTemplate = value!;
                            stateSetter(() {});
                          });
                        }))
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the cartesian chart with default trackball.
  SfCartesianChart _buildTrackballTemplateChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Monthly expense of a family'),
      legend: Legend(isVisible: !isCardView, toggleSeriesVisibility: false),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelRotation: isCardView || model.isWebFullView ? 0 : -45,
      ),
      primaryYAxis: NumericAxis(
          maximum: 200,
          axisLine: const AxisLine(width: 0),
          labelFormat: r'${value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultTrackballSeries(),

      /// To set the track ball as true and customized trackball behaviour.
      trackballBehavior: TrackballBehavior(
          enable: true,
          markerSettings: TrackballMarkerSettings(
            height: 10,
            width: 10,
            borderWidth: 1,
          ),
          hideDelay: 2000,
          activationMode: ActivationMode.singleTap,
          tooltipDisplayMode:
              isCardView ? TrackballDisplayMode.floatAllPoints : _mode,
          builder: _isTemplate
              ? (BuildContext context, TrackballDetails trackballDetails) {
                  return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                          height: _mode == TrackballDisplayMode.groupAllPoints
                              ? model.isWebFullView
                                  ? 125
                                  : 105
                              : 50,
                          width: _mode == TrackballDisplayMode.groupAllPoints
                              ? 145
                              : 120,
                          decoration: BoxDecoration(
                            color: model.themeData.brightness == Brightness.dark
                                ? const Color.fromRGBO(255, 255, 255, 1)
                                : const Color.fromRGBO(0, 8, 22, 0.75),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: Row(children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: SizedBox(
                                  height: _mode ==
                                          TrackballDisplayMode.groupAllPoints
                                      ? 40
                                      : 35,
                                  width: _mode ==
                                          TrackballDisplayMode.groupAllPoints
                                      ? 40
                                      : 35,
                                  child: Image.asset(
                                      _getImageTemplate(trackballDetails)),
                                )),
                            Center(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                    child: Center(
                                        child: getGroupingTemplateWidgets(
                                            trackballDetails))))
                          ])));
                }
              : null),
    );
  }

  Column getGroupingTemplateWidgets(TrackballDetails _trackballDetails) {
    //ignore: prefer_final_locals
    Column _columnWidgets = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      //ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[],
    );
    if (_mode == TrackballDisplayMode.groupAllPoints) {
      _columnWidgets.children.add(Container(
          child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                  _trackballDetails.groupingModeInfo!.points[0].x.toString(),
                  style: TextStyle(
                      color: model.themeData.brightness == Brightness.dark
                          ? const Color.fromRGBO(0, 0, 0, 1)
                          : const Color.fromRGBO(255, 255, 255, 1))))));
      _columnWidgets.children.add(Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Container(
            height: 1,
            width: 80,
            color: model.themeData.brightness == Brightness.dark
                ? const Color.fromRGBO(61, 61, 61, 1)
                : const Color.fromRGBO(238, 238, 238, 1),
          )));
      //ignore: prefer_final_locals
      Column _columnChildWidgets = Column(
        crossAxisAlignment: _mode == TrackballDisplayMode.groupAllPoints
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        //ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[],
      );
      final List<int> seriesIndices =
          _trackballDetails.groupingModeInfo!.visibleSeriesIndices;
      for (int i = 0; i < seriesIndices.length; i++) {
        _columnChildWidgets.children.add(
          Container(
              child: Text(
                  '${_trackballDetails.groupingModeInfo!.visibleSeriesList[i].name.toString()} : \$${_trackballDetails.groupingModeInfo!.points[i].y.toString()}',
                  textAlign: TextAlign.left,
                  style: _getTrackballTextStyle())),
        );
      }
      _columnWidgets.children.add(_columnChildWidgets);
    } else {
      _columnWidgets.children.add(Text(_trackballDetails.point!.x.toString(),
          style: _getTrackballTextStyle()));
      _columnWidgets.children.add(Text(
          '\$${_trackballDetails.point!.y.toString()}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: model.themeData.brightness == Brightness.dark
                  ? const Color.fromRGBO(0, 0, 0, 1)
                  : const Color.fromRGBO(255, 255, 255, 1))));
    }
    return _columnWidgets;
  }

  TextStyle _getTrackballTextStyle() {
    return TextStyle(
        color: model.themeData.brightness == Brightness.dark
            ? const Color.fromRGBO(0, 0, 0, 1)
            : const Color.fromRGBO(255, 255, 255, 1));
  }

  /// Returns the list of chart which need to render  on the cartesian chart.
  List<CartesianSeries<ChartSampleData, String>> _getDefaultTrackballSeries() {
    final List<ChartSampleData> _chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Food',
          y: 55,
          yValue: 40,
          secondSeriesYValue: 45,
          thirdSeriesYValue: 48),
      ChartSampleData(
          x: 'Transport',
          y: 33,
          yValue: 45,
          secondSeriesYValue: 54,
          thirdSeriesYValue: 28),
      ChartSampleData(
          x: 'Medical',
          y: 43,
          yValue: 23,
          secondSeriesYValue: 20,
          thirdSeriesYValue: 34),
      ChartSampleData(
          x: 'Clothes',
          y: 32,
          yValue: 54,
          secondSeriesYValue: 23,
          thirdSeriesYValue: 54),
      ChartSampleData(
          x: 'Books',
          y: 56,
          yValue: 18,
          secondSeriesYValue: 43,
          thirdSeriesYValue: 55),
      ChartSampleData(
          x: 'Others',
          y: 23,
          yValue: 54,
          secondSeriesYValue: 33,
          thirdSeriesYValue: 56),
    ];
    return <CartesianSeries<ChartSampleData, String>>[
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'John',
          markerSettings: const MarkerSettings(isVisible: true)),
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Mary',
          markerSettings: const MarkerSettings(isVisible: true)),
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Martin',
          markerSettings: const MarkerSettings(isVisible: true)),
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Jessica',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  String _getImageTemplate(TrackballDetails _pointInfo) {
    String _path;
    final int? _seriesIndex = _pointInfo.seriesIndex;

    _path = _seriesIndex == 0
        ? 'images/People_Circle12.png'
        : _seriesIndex == 1
            ? 'images/People_Circle3.png'
            : _seriesIndex == 2
                ? 'images/People_Circle14.png'
                : _seriesIndex == 3
                    ? 'images/People_Circle16.png'
                    : model.themeData.brightness == Brightness.dark
                        ? 'images/grouping_dark.png'
                        : 'images/grouping_light.png';

    return _path;
  }

  /// Method to update the trackball display mode in the chart on change.
  void onModeTypeChange(String _item) {
    _selectedMode = _item;
    if (_selectedMode == 'floatAllPoints') {
      _mode = TrackballDisplayMode.floatAllPoints;
    }
    if (_selectedMode == 'groupAllPoints') {
      _mode = TrackballDisplayMode.groupAllPoints;
    }
    if (_selectedMode == 'nearestPoint') {
      _mode = TrackballDisplayMode.nearestPoint;
    }
    if (_selectedMode == 'none') {
      _mode = TrackballDisplayMode.none;
    }
    setState(() {
      /// update the trackball display type changes
    });
  }
}
