/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';
import '../../../../widgets/customDropDown.dart';

/// Render the positioning axis label.
class LabelCustomization extends SampleView {
  const LabelCustomization(Key key) : super(key: key);
  @override
  _AxisCrossingState createState() => _AxisCrossingState();
}

/// State class of positioning axis label.
class _AxisCrossingState extends SampleViewState {
  _AxisCrossingState();
  String _ySelectedPositionType = 'inside';
  String _xSelectedPositionType = 'outside';
  //ignore: unused_field
  String _selectedAxisType = 'y';
  String _ySelectedAlignmentType = 'end';
  String _xSelectedAlignmentType = 'center';
  ChartDataLabelPosition _labelPositionX, _labelPositionY;
  TickPosition _tickPositionX, _tickPositionY;
  LabelAlignment _labelAlignmentX, _labelAlignmentY;

  /// List the axis position types.
  final List<String> _yPositionType = <String>['outside', 'inside'].toList();

  /// List the alignment type.
  final List<String> _yAlignmentType =
      <String>['start', 'end', 'center'].toList();
  final List<String> _xPositionType = <String>['outside', 'inside'].toList();
  final List<String> _xAlignmentType =
      <String>['start', 'end', 'center'].toList();
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Y Axis',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: model.textColor)),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label position  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _ySelectedPositionType,
                          item: _yPositionType.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'outside',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onPositionChange(value.toString(), model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label alignment',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _ySelectedAlignmentType,
                          item: _yAlignmentType.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'start',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onAlignmentChange(value.toString(), model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('X Axis',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: model.textColor)),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label position  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _xSelectedPositionType,
                          item: _xPositionType.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'outside',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onXPositionChange(value.toString(), model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label alignment',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _xSelectedAlignmentType,
                          item: _xAlignmentType.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'center',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onXAlignmentChange(value.toString(), model);
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getLabelCustomizationSample();
  }

  /// Returen the Spline series with axis label position changing.
  SfCartesianChart getLabelCustomizationSample() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'New York temperature details'),
      primaryXAxis: CategoryAxis(
          edgeLabelPlacement:EdgeLabelPlacement.shift,
          interval: 1,
          labelPosition: isCardView ? ChartDataLabelPosition.outside :_labelPositionX,
          labelAlignment: isCardView ? LabelAlignment.center : _labelAlignmentX,
          tickPosition: isCardView ? TickPosition.outside : _tickPositionX,
          majorGridLines: MajorGridLines(width: 0),
          title: AxisTitle(textStyle: const TextStyle(color: Colors.black))),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement:isCardView ? EdgeLabelPlacement.none : EdgeLabelPlacement.shift,
        labelPosition: isCardView ? ChartDataLabelPosition.outside : _labelPositionY,
        labelAlignment: isCardView ? LabelAlignment.center :_labelAlignmentY,
        tickPosition: isCardView ? TickPosition.outside :_tickPositionY,
        opposedPosition: false,
        minimum: 0,
        maximum: 35,
        interval: 5,
        labelFormat: '{value}°C',
      ),
      series: getSeries(isCardView),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Return the spline series.
  List<ChartSeries<ChartSampleData, dynamic>> getSeries(bool isCardView) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'May 1', y: 13, yValue2: 69.8),
      ChartSampleData(x: 'May 2', y: 26, yValue2: 87.8),
      ChartSampleData(x: 'May 3', y: 13, yValue2: 78.8),
      ChartSampleData(x: 'May 4', y: 22, yValue2: 75.2),
      ChartSampleData(x: 'May 5', y: 14, yValue2: 68),
      ChartSampleData(x: 'May 6', y: 23, yValue2: 78.8),
      ChartSampleData(x: 'May 7', y: 21, yValue2: 80.6),
      ChartSampleData(x: 'May 8', y: 22, yValue2: 73.4)
    ];
    return <ChartSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: MarkerSettings(isVisible: true),
          name: 'New York')
    ];
  }

  @override
  void initState() {
    initProperties();
    super.initState();
  }

  void initProperties([SampleModel sampleModel, bool init]) {
    _labelPositionX = ChartDataLabelPosition.outside;
    _labelPositionY = ChartDataLabelPosition.inside;
    _tickPositionX = TickPosition.outside;
    _tickPositionY = TickPosition.inside;
    _labelAlignmentX = LabelAlignment.center;
    _labelAlignmentY = LabelAlignment.end;
  }

  /// Method for axis change.
  void onAxisChange(String item, SampleModel model) {
    _selectedAxisType = item;
  }

  /// Method for Y axis label position change.
  void onPositionChange(String item, SampleModel model) {
    setState(() {
      _ySelectedPositionType = item;
      if (_ySelectedPositionType == 'outside') {
        _labelPositionY = ChartDataLabelPosition.outside;
        _tickPositionY = TickPosition.outside;
      }
      if (_ySelectedPositionType == 'inside') {
        _labelPositionY = ChartDataLabelPosition.inside;
        _tickPositionY = TickPosition.inside;
      }
    });
  }

  /// Method for X axis label position change.
  void onXPositionChange(String item, SampleModel model) {
    setState(() {
      _xSelectedPositionType = item;
      if (_xSelectedPositionType == 'outside') {
        _labelPositionX = ChartDataLabelPosition.outside;
        _tickPositionX = TickPosition.outside;
      } else {
        _labelPositionX = ChartDataLabelPosition.inside;
        _tickPositionX = TickPosition.inside;
      }
    });
  }

  /// Method for Y axis label alignment change.
  void onAlignmentChange(String item, SampleModel model) {
    setState(() {
      _ySelectedAlignmentType = item;
      if (_ySelectedAlignmentType == 'start') {
        _labelAlignmentY = LabelAlignment.start;
      } else if (_ySelectedAlignmentType == 'center') {
        _labelAlignmentY = LabelAlignment.center;
      } else if (_ySelectedAlignmentType == 'end') {
        _labelAlignmentY = LabelAlignment.end;
      }
    });
  }

  /// Method for X axis label alignment change.
  void onXAlignmentChange(String item, SampleModel model) {
    setState(() {
      _xSelectedAlignmentType = item;
      if (_xSelectedAlignmentType == 'start') {
        _labelAlignmentX = LabelAlignment.start;
      } else if (_xSelectedAlignmentType == 'center') {
        _labelAlignmentX = LabelAlignment.center;
      } else if (_xSelectedAlignmentType == 'end') {
        _labelAlignmentX = LabelAlignment.end;
      }
    });
  }
}
