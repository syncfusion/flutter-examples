/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// Renders the pyramid series chart with smart data labels.
class PyramidSmartLabels extends SampleView {
  /// Creates the pyramid series chart with smart data labels.
  const PyramidSmartLabels(Key key) : super(key: key);

  @override
  _PyramidSmartLabelState createState() => _PyramidSmartLabelState();
}

class _PyramidSmartLabelState extends SampleViewState {
  _PyramidSmartLabelState();
  late List<ChartSampleData> _chartData;
  late ChartDataLabelPosition _selectedLabelPosition;
  late String _selectedPosition;
  late String _selectedOverflowMode;
  late String _selectedIntersectAction;
  late LabelIntersectAction _labelIntersectAction;
  late OverflowMode _overflowMode;
  late List<Color> _palette1;
  late List<Color> _palette2;
  late List<Color> _palette3;
  late TooltipBehavior _tooltipBehavior;

  List<String>? _overflowModeList;
  List<String>? _labelPosition;
  List<String>? _labelIntersectActionList;

  @override
  void initState() {
    _initializePalettes();
    _chartData = _buildChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
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

  void _initializePalettes() {
    _palette1 = const <Color>[
      Color.fromRGBO(53, 92, 125, 1),
      Color.fromRGBO(192, 108, 132, 1),
      Color.fromRGBO(246, 114, 128, 1),
      Color.fromRGBO(248, 177, 149, 1),
      Color.fromRGBO(116, 180, 155, 1),
      Color.fromRGBO(0, 168, 181, 1),
      Color.fromRGBO(73, 76, 162, 1),
      Color.fromRGBO(255, 205, 96, 1),
      Color.fromRGBO(255, 240, 219, 1),
      Color.fromRGBO(238, 238, 238, 1),
    ];
    _palette2 = const <Color>[
      Color.fromRGBO(6, 174, 224, 1),
      Color.fromRGBO(99, 85, 199, 1),
      Color.fromRGBO(49, 90, 116, 1),
      Color.fromRGBO(255, 180, 0, 1),
      Color.fromRGBO(150, 60, 112, 1),
      Color.fromRGBO(33, 150, 245, 1),
      Color.fromRGBO(71, 59, 137, 1),
      Color.fromRGBO(236, 92, 123, 1),
      Color.fromRGBO(59, 163, 26, 1),
      Color.fromRGBO(236, 131, 23, 1),
    ];
    _palette3 = const <Color>[
      Color.fromRGBO(255, 245, 0, 1),
      Color.fromRGBO(51, 182, 119, 1),
      Color.fromRGBO(218, 150, 70, 1),
      Color.fromRGBO(201, 88, 142, 1),
      Color.fromRGBO(77, 170, 255, 1),
      Color.fromRGBO(255, 157, 69, 1),
      Color.fromRGBO(178, 243, 46, 1),
      Color.fromRGBO(185, 60, 228, 1),
      Color.fromRGBO(48, 167, 6, 1),
      Color.fromRGBO(207, 142, 14, 1),
    ];
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(x: 'Mexico', y: 127575529),
      ChartSampleData(x: 'Russia ', y: 145872256),
      ChartSampleData(x: 'Bangladesh', y: 163046161),
      ChartSampleData(x: 'Nigeria ', y: 200963599),
      ChartSampleData(x: 'Brazil', y: 211049527),
      ChartSampleData(x: 'Pakistan ', y: 216565318),
      ChartSampleData(x: 'Indonesia', y: 270625568),
      ChartSampleData(x: 'US', y: 329064917),
      ChartSampleData(x: 'India', y: 1366417754),
      ChartSampleData(x: 'China', y: 1433783686),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildPyramidSmartLabelChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
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
                      _buildLabelPositionRow(dropDownWidth, stateSetter),
                      _buildOverflowModeRow(dropDownWidth, stateSetter),
                      _buildLabelIntersectActionRow(dropDownWidth, stateSetter),
                    ],
                  ),
                ),
                Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the label position row.
  Widget _buildLabelPositionRow(double dropDownWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Label position',
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        SizedBox(
          width: dropDownWidth,
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedPosition,
            items: _labelPosition!.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'outside',
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _updateLabelPosition(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the overflow mode row.
  Widget _buildOverflowModeRow(double dropDownWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Overflow mode',
          style: TextStyle(
            fontSize: 16,
            color: _selectedPosition != 'inside'
                ? model.textColor.withValues(alpha: 0.3)
                : model.textColor,
          ),
        ),
        SizedBox(
          height: 50,
          width: dropDownWidth,
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedOverflowMode,
            items: _selectedPosition != 'inside'
                ? null
                : _overflowModeList!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'none',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
            onChanged: (dynamic value) {
              _updateOverflowMode(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the label intersect action row.
  Widget _buildLabelIntersectActionRow(
    double dropDownWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Label intersect \naction',
          style: TextStyle(
            fontSize: 16,
            color:
                (_selectedOverflowMode != 'none' &&
                    _selectedPosition != 'outside')
                ? model.textColor.withValues(alpha: 0.3)
                : model.textColor,
          ),
        ),
        SizedBox(
          height: 50,
          width: dropDownWidth,
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedIntersectAction,
            items:
                (_selectedOverflowMode != 'none' &&
                    _selectedPosition != 'outside')
                ? null
                : _labelIntersectActionList!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'shift',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
            onChanged: (dynamic value) {
              _updateLabelIntersectAction(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Returns the pyramid series chart with smart data labels.
  SfPyramidChart _buildPyramidSmartLabelChart() {
    return SfPyramidChart(
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat format = NumberFormat.decimalPattern();
        //ignore: noop_primitive_operations
        args.text =
            args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            //ignore: noop_primitive_operations
            format.format(args.dataPoints![args.pointIndex!.toInt()].y);
      },
      title: ChartTitle(
        text: isCardView ? '' : 'Top 10 populated countries - 2019',
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildPyramidSeries(),
    );
  }

  /// Returns the pyramid series.
  PyramidSeries<ChartSampleData, String> _buildPyramidSeries() {
    final ThemeData themeData = model.themeData;
    _palette1 = themeData.useMaterial3
        ? (themeData.brightness == Brightness.light ? _palette2 : _palette3)
        : _palette1;
    return PyramidSeries<ChartSampleData, String>(
      width: '60%',
      dataSource: _chartData,
      xValueMapper: (ChartSampleData data, int index) => data.x,
      yValueMapper: (ChartSampleData data, int index) => data.y,
      textFieldMapper: (ChartSampleData data, int index) => data.x,
      pointColorMapper: (ChartSampleData data, int index) =>
          _palette1[_palette1.length - 1 - index],
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelPosition: isCardView
            ? ChartDataLabelPosition.outside
            : _selectedLabelPosition,
        overflowMode: _overflowMode,
        labelIntersectAction: _labelIntersectAction,
        useSeriesColor: true,
      ),
    );
  }

  /// Updates the selected data label position.
  void _updateLabelPosition(String item) {
    _selectedPosition = item;
    if (_selectedPosition == 'inside') {
      _selectedLabelPosition = ChartDataLabelPosition.inside;
    } else if (_selectedPosition == 'outside') {
      _selectedLabelPosition = ChartDataLabelPosition.outside;
    }
    setState(() {
      /// Updates the data label position type change.
    });
  }

  /// Updates the selected label intersect action.
  void _updateLabelIntersectAction(String item) {
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
      /// Updates the label intersect action.
    });
  }

  /// Updates the selected overflow mode.
  void _updateOverflowMode(String item) {
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
      /// Updates the overflow mode.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _labelPosition!.clear();
    _labelIntersectActionList!.clear();
    _overflowModeList!.clear();
    super.dispose();
  }
}
