/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the pyramid chart with smart data labels
class PyramidSmartLabels extends SampleView {
  /// Creates the pyramid chart with smart data labels
  const PyramidSmartLabels(Key key) : super(key: key);

  @override
  _PyramidSmartLabelState createState() => _PyramidSmartLabelState();
}

class _PyramidSmartLabelState extends SampleViewState {
  _PyramidSmartLabelState();

  late ChartDataLabelPosition _selectedLabelPosition;
  late String _selectedPosition;
  late String _selectedOverflowMode;
  late String _selectedIntersectAction;
  late LabelIntersectAction _labelIntersectAction;
  late OverflowMode _overflowMode;
  List<String>? _overflowModeList;
  List<String>? _labelPosition;
  List<String>? _labelIntersectActionList;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _selectedLabelPosition = ChartDataLabelPosition.inside;
    _selectedPosition = 'inside';
    _labelIntersectAction = LabelIntersectAction.shift;
    _selectedIntersectAction = 'shift';
    _selectedOverflowMode = 'none';
    _overflowMode = OverflowMode.none;
    _overflowModeList = <String>['shift', 'none', 'hide', 'trim'].toList();
    _labelPosition = <String>['inside', 'outside'].toList();
    _labelIntersectActionList = <String>['shift', 'none', 'hide'].toList();
    super.initState();
  }

  @override
  void dispose() {
    _labelPosition!.clear();
    _labelIntersectActionList!.clear();
    _overflowModeList!.clear();
    super.dispose();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    final double dropDownWidth = (model.isMobile ? 0.2 : 0.4) * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
              Expanded(
                flex: 14,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Label position',
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 16, color: model.textColor)),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: dropDownWidth,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedPosition,
                                items: _labelPosition!.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value:
                                          (value != null) ? value : 'outside',
                                      child: Text(value,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                onChanged: (dynamic value) {
                                  _onLabelPositionChange(value.toString());
                                  stateSetter(() {});
                                }),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Overflow mode',
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedPosition != 'inside'
                                      ? model.textColor.withOpacity(0.3)
                                      : model.textColor)),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            width: dropDownWidth,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedOverflowMode,
                                items: _selectedPosition != 'inside'
                                    ? null
                                    : _overflowModeList!.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: (value != null)
                                                ? value
                                                : 'none',
                                            child: Text(value,
                                                style: TextStyle(
                                                    color: model.textColor)));
                                      }).toList(),
                                onChanged: (dynamic value) {
                                  _changeOverflowMode(value.toString());
                                  stateSetter(() {});
                                }),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Label intersect \naction',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: (_selectedOverflowMode != 'none' &&
                                        _selectedPosition != 'outside')
                                    ? model.textColor.withOpacity(0.3)
                                    : model.textColor,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            width: dropDownWidth,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedIntersectAction,
                                items: (_selectedOverflowMode != 'none' &&
                                        _selectedPosition != 'outside')
                                    ? null
                                    : _labelIntersectActionList!
                                        .map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: (value != null)
                                                ? value
                                                : 'shift',
                                            child: Text(value,
                                                style: TextStyle(
                                                    color: model.textColor)));
                                      }).toList(),
                                onChanged: (dynamic value) {
                                  _changeLabelIntersectAction(value.toString());
                                  stateSetter(() {});
                                }),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
            ],
          ),
        ],
      );
    });
  }

  ///Get the pyramid chart with smart data labels
  SfPyramidChart _buildPyramidSmartLabelChart() {
    return SfPyramidChart(
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat format = NumberFormat.decimalPattern();
        //ignore: noop_primitive_operations
        args.text = args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            //ignore: noop_primitive_operations
            format.format(args.dataPoints![args.pointIndex!.toInt()].y);
      },
      title: ChartTitle(
          text: isCardView ? '' : 'Top 10 populated countries - 2019'),
      tooltipBehavior: _tooltip,
      series: _getPyramidSeries(),
    );
  }

  ///Get the pyramid series
  PyramidSeries<ChartSampleData, String> _getPyramidSeries() {
    return PyramidSeries<ChartSampleData, String>(
        width: '60%',
        dataSource: <ChartSampleData>[
          ChartSampleData(
              x: 'Mexico',
              y: 127575529,
              pointColor: const Color.fromRGBO(238, 238, 238, 1)),
          ChartSampleData(
              x: 'Russia ',
              y: 145872256,
              pointColor: const Color.fromRGBO(255, 240, 219, 1)),
          ChartSampleData(
              x: 'Bangladesh',
              y: 163046161,
              pointColor: const Color.fromRGBO(255, 205, 96, 1)),
          ChartSampleData(
              x: 'Nigeria ',
              y: 200963599,
              pointColor: const Color.fromRGBO(73, 76, 162, 1)),
          ChartSampleData(
              x: 'Brazil',
              y: 211049527,
              pointColor: const Color.fromRGBO(0, 168, 181, 1)),
          ChartSampleData(
              x: 'Pakistan ',
              y: 216565318,
              pointColor: const Color.fromRGBO(116, 180, 155, 1)),
          ChartSampleData(
              x: 'Indonesia',
              y: 270625568,
              pointColor: const Color.fromRGBO(248, 177, 149, 1)),
          ChartSampleData(
              x: 'US',
              y: 329064917,
              pointColor: const Color.fromRGBO(246, 114, 128, 1)),
          ChartSampleData(
              x: 'India',
              y: 1366417754,
              pointColor: const Color.fromRGBO(192, 108, 132, 1)),
          ChartSampleData(
              x: 'China',
              y: 1433783686,
              pointColor: const Color.fromRGBO(53, 92, 125, 1)),
        ],
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        textFieldMapper: (ChartSampleData data, _) => data.x as String,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: isCardView
                ? ChartDataLabelPosition.outside
                : _selectedLabelPosition,
            overflowMode: _overflowMode,
            labelIntersectAction: _labelIntersectAction,
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

  /// Change the label intersect action
  void _changeLabelIntersectAction(String item) {
    _selectedIntersectAction = item;
    if (_selectedIntersectAction == 'shift') {
      _labelIntersectAction = LabelIntersectAction.shift;
    }
    if (_selectedIntersectAction == 'hide') {
      _labelIntersectAction = LabelIntersectAction.hide;
    }
    if (_selectedIntersectAction == 'none') {
      _labelIntersectAction = LabelIntersectAction.none;
    }
    setState(() {
      /// update the label intersect action
    });
  }

  /// Change the overflow mode
  void _changeOverflowMode(String item) {
    _selectedOverflowMode = item;
    if (_selectedOverflowMode == 'shift') {
      _overflowMode = OverflowMode.shift;
    }
    if (_selectedOverflowMode == 'hide') {
      _overflowMode = OverflowMode.hide;
    }
    if (_selectedOverflowMode == 'none') {
      _overflowMode = OverflowMode.none;
    }
    if (_selectedOverflowMode == 'trim') {
      _overflowMode = OverflowMode.trim;
    }
    setState(() {
      /// update the overflow mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPyramidSmartLabelChart();
  }
}
