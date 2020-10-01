/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_dropdown.dart';

/// Renders the pyramid chart with smart data labels
class PyramidSmartLabels extends SampleView {
  /// Creates the pyramid chart with smart data labels
  const PyramidSmartLabels(Key key) : super(key: key);

  @override
  _PyramidSmartLabelState createState() => _PyramidSmartLabelState();
}

class _PyramidSmartLabelState extends SampleViewState {
  _PyramidSmartLabelState();
  final List<String> _labelPosition = <String>['outside', 'inside'].toList();
  ChartDataLabelPosition _selectedLabelPosition =
      ChartDataLabelPosition.outside;
  String _selectedPosition = 'outside';

  final List<String> _modeList = <String>['shift', 'none', 'hide'].toList();
  String _smartLabelMode = 'shift';
  SmartLabelMode _mode = SmartLabelMode.shift;

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Label position       ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                  padding: const EdgeInsets.fromLTRB(47, 0, 0, 0),
                  height: 50,
                  width: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedPosition,
                          item: _labelPosition.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'outside',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onLabelPositionChange(value.toString());
                          }),
                    ),
                  )),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Smart label mode ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
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
                          value: _smartLabelMode,
                          item: _modeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'shift',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onSmartLabelModeChange(value.toString());
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
    return _getPyramidSmartLabelChart();
  }

  ///Get the pyramid chart with smart data labels
  SfPyramidChart _getPyramidSmartLabelChart() {
    return SfPyramidChart(
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat format = NumberFormat.decimalPattern();
        args.text =
            format.format(args.dataPoints[args.pointIndex].y).toString();
      },
      title: ChartTitle(
          text: isCardView ? '' : 'Top 10 populated countries - 2019'),
      tooltipBehavior: TooltipBehavior(enable: true),

      /// To specify the smart label mode for pyramid chart.
      smartLabelMode: _mode ?? SmartLabelMode.shift,
      series: _getPyramidSeries(),
    );
  }

  ///Get the pyramid series
  PyramidSeries<ChartSampleData, String> _getPyramidSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(
          x: 'Mexico',
          y: 127575529,
          text: null,
          pointColor: const Color.fromRGBO(238, 238, 238, 1)),
      ChartSampleData(
          x: 'Russia ',
          y: 145872256,
          text: null,
          pointColor: const Color.fromRGBO(255, 240, 219, 1)),
      ChartSampleData(
          x: 'Bangladesh',
          y: 163046161,
          text: null,
          pointColor: const Color.fromRGBO(255, 205, 96, 1)),
      ChartSampleData(
          x: 'Nigeria ',
          y: 200963599,
          text: null,
          pointColor: const Color.fromRGBO(73, 76, 162, 1)),
      ChartSampleData(
          x: 'Brazil',
          y: 211049527,
          text: null,
          pointColor: const Color.fromRGBO(0, 168, 181, 1)),
      ChartSampleData(
          x: 'Pakistan ',
          y: 216565318,
          text: null,
          pointColor: const Color.fromRGBO(116, 180, 155, 1)),
      ChartSampleData(
          x: 'Indonesia',
          y: 270625568,
          text: null,
          pointColor: const Color.fromRGBO(248, 177, 149, 1)),
      ChartSampleData(
          x: 'US',
          y: 329064917,
          text: null,
          pointColor: const Color.fromRGBO(246, 114, 128, 1)),
      ChartSampleData(
          x: 'India',
          y: 1366417754,
          text: null,
          pointColor: const Color.fromRGBO(192, 108, 132, 1)),
      ChartSampleData(
          x: 'China',
          y: 1433783686,
          text: null,
          pointColor: const Color.fromRGBO(53, 92, 125, 1)),
    ];
    return PyramidSeries<ChartSampleData, String>(
        width: '60%',
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        textFieldMapper: (ChartSampleData data, _) => data.x,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: isCardView
                ? ChartDataLabelPosition.outside
                : _selectedLabelPosition,
            useSeriesColor: true));
  }

  ///change the data label position
  void _onLabelPositionChange(String item) {
    _selectedPosition = item;
    if (_selectedPosition == 'inside') {
      _selectedLabelPosition = ChartDataLabelPosition.inside;
    } else if (_selectedPosition == 'outside') {
      _selectedLabelPosition = ChartDataLabelPosition.outside;
    }
    setState(() {
      /// update the datalabel position type change
    });
  }

  ///Change the smart label mode
  void _onSmartLabelModeChange(String item) {
    _smartLabelMode = item;
    if (_smartLabelMode == 'shift') {
      _mode = SmartLabelMode.shift;
    }
    if (_smartLabelMode == 'hide') {
      _mode = SmartLabelMode.hide;
    }
    if (_smartLabelMode == 'none') {
      _mode = SmartLabelMode.none;
    }
    setState(() {
      /// update the smart data label placement type change
    });
  }
}
