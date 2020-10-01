/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Package import
import 'package:flutter/material.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/checkbox.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../widgets/shared/web.dart';

/// Renders the spline chart with axis crossing sample.
class AxisCrossing extends SampleView {
  ///Creates default axis crossing sample, chart widget
  const AxisCrossing(Key key) : super(key: key);

  @override
  _AxisCrossingState createState() => _AxisCrossingState();
}

/// State class of the spline chart with axis crossing.
class _AxisCrossingState extends SampleViewState {
  _AxisCrossingState();
  final List<String> _axis = <String>['x', 'y'].toList();
  // final List<String> _series = <String>['column', 'bar', 'spline'].toList();
  String _selectedSeriesType = 'column';
  //ignore: unused_field
  String _selectedSeries;
  String _selectedAxisType = 'x';
  String _selectedAxis;
  double _crossAt = 0;
  bool _isPlaceLabelsNearAxisLine = true;

  @override
  void initState() {
    _selectedAxisType = 'x';
    _selectedAxis = 'x';
    _selectedSeriesType = 'column';
    _selectedSeries = 'column';
    _crossAt = 0;
    _isPlaceLabelsNearAxisLine = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getAxisCrossingSample();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        // Row(children: [
        //   Text('Chart type',
        //         style: TextStyle(fontSize: 16.0, color: model.textColor)),
        //     Container(
        //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //         height: 50,
        //         width: 150,
        //         child: Align(
        //           alignment: Alignment.bottomCenter,
        //           child: Theme(
        //             data: Theme.of(context).copyWith(
        //                 canvasColor: model.bottomSheetBackgroundColor),
        //             child: DropDown(
        //                 value: _selectedSeries,
        //                 item: _series.map((String value) {
        //                   return DropdownMenuItem<String>(
        //                       value: (value != null) ? value : 'column',
        //                       child: Text('$value',
        //                           style: TextStyle(color: model.textColor)));
        //                 }).toList(),
        //                 valueChanged: (dynamic value) {
        //                   _onSeriesTypeChange(value.toString());
        //                 }),
        //           ),
        //         ))
        // ],),
        Row(
          children: <Widget>[
            Text('Axis',
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
            Container(
                padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                height: 50,
                width: 150,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: DropDown(
                        value: _selectedAxis,
                        item: _axis.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'x',
                              child: Text('$value',
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        valueChanged: (dynamic value) {
                          _onAxisTypeChange(value.toString());
                        }),
                  ),
                ))
          ],
        ),
        Row(
          children: <Widget>[
            Text('Cross at',
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: CustomDirectionalButtons(
                  minValue: -8,
                  maxValue: 8,
                  initialValue: _crossAt,
                  onChanged: (double val) => setState(() {
                    _crossAt = val;
                  }),
                  step: 2,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 20.0, color: model.textColor),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Labels near\naxisline',
                style: TextStyle(
                    color: model.textColor,
                    fontSize: 16,
                    letterSpacing: 0.34,
                    fontWeight: FontWeight.normal)),
            HandCursor(
              child: CustomCheckBox(
                activeColor: model.backgroundColor,
                switchValue: _isPlaceLabelsNearAxisLine,
                valueChanged: (dynamic value) {
                  setState(() {
                    _isPlaceLabelsNearAxisLine = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns the spline chart with axis crossing at provided axis value.
  SfCartesianChart _getAxisCrossingSample() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Spline Interpolation'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(
          minimum: -8,
          maximum: 8,
          interval: 2,
          placeLabelsNearAxisLine: isCardView
              ? true
              : _selectedAxisType == 'x'
                  ? _isPlaceLabelsNearAxisLine ?? true
                  : true,
          crossesAt: _selectedAxisType == 'x' ? _crossAt ?? 0 : 0,
          minorTicksPerInterval: 3),
      primaryYAxis: NumericAxis(
          minimum: -8,
          maximum: 8,
          interval: 2,
          placeLabelsNearAxisLine: isCardView
              ? true
              : _selectedAxisType == 'y'
                  ? _isPlaceLabelsNearAxisLine ?? true
                  : true,
          crossesAt: _selectedAxisType == 'y' ? _crossAt ?? 0 : 0,
          minorTicksPerInterval: 3),
      series: _getSeries(_selectedSeriesType),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on
  /// the spline chart with axis crossing.

  List<ChartSeries<ChartSampleData, num>> _getSeries(String seriesType) {
    List<ChartSeries<ChartSampleData, num>> chart = null;
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: -7, y: -3),
      ChartSampleData(x: -4.5, y: -2),
      ChartSampleData(x: -3.5, y: 0),
      ChartSampleData(x: -3, y: 2),
      ChartSampleData(x: 0, y: 7),
      ChartSampleData(x: 3, y: 2),
      ChartSampleData(x: 3.5, y: 0),
      ChartSampleData(x: 4.5, y: -2),
      ChartSampleData(x: 7, y: -3),
    ];
    chart = <ChartSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          color: const Color.fromRGBO(20, 122, 20, 1),
          name: 'Cubic Interpolation',
          width: 2),
    ];
    // if(seriesType == 'column'){
    // chart = <ChartSeries<ChartSampleData, num>>[
    //   ColumnSeries<ChartSampleData, num>(
    //       dataSource: chartData,
    //       xValueMapper: (ChartSampleData sales, _) => sales.x,
    //       yValueMapper: (ChartSampleData sales, _) => sales.y,
    //       color: const Color.fromRGBO(20, 122, 20, 1),
    //       name: 'Cubic Interpolation',
    //       width: 0.7),
    // ];
    // }
    // else if(seriesType == 'bar'){
    // chart = <ChartSeries<ChartSampleData, num>>[
    //   BarSeries<ChartSampleData, num>(
    //       dataSource: chartData,
    //       xValueMapper: (ChartSampleData sales, _) => sales.x,
    //       yValueMapper: (ChartSampleData sales, _) => sales.y,
    //       color: const Color.fromRGBO(20, 122, 20, 1),
    //       name: 'Cubic Interpolation',
    //       width: 0.7),
    // ];
    // }
    // else if(seriesType == 'spline'){
    // chart = <ChartSeries<ChartSampleData, num>>[
    //   SplineSeries<ChartSampleData, num>(
    //       dataSource: chartData,
    //       xValueMapper: (ChartSampleData sales, _) => sales.x,
    //       yValueMapper: (ChartSampleData sales, _) => sales.y,
    //       color: const Color.fromRGBO(20, 122, 20, 1),
    //       name: 'Cubic Interpolation',
    //       width: 2),
    // ];
    // }
    return chart;
  }

  /// Method for updating the axis type on change.
  void _onAxisTypeChange(String item) {
    _selectedAxis = item;
    if (_selectedAxis == 'x') {
      _selectedAxisType = 'x';
    } else if (_selectedAxis == 'y') {
      _selectedAxisType = 'y';
    }
    setState(() {
      /// update the axis type changes
    });
  }
  // /// Method for updating the series type on change.
  // void _onSeriesTypeChange(String item) {
  //   _selectedSeries = item;
  //   if (_selectedSeries == 'column') {
  //     _selectedSeriesType = 'column';
  //   } else if (_selectedSeries == 'bar') {
  //     _selectedSeriesType = 'bar';
  //   } else if (_selectedSeries == 'spline') {
  //     _selectedSeriesType = 'spline';
  //   }
  //   setState(() {
  //     /// update the series type changes
  //   });
  // }
}
