/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Package import
import 'package:flutter/material.dart';

/// Local imports
import '../../../model/sample_view.dart';
// import '../../../widgets/checkbox.dart';
// import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
// import '../../../widgets/shared/mobile.dart'
//     if (dart.library.html) '../../../../widgets/shared/web.dart';

/// Renders the spline chart with axis crossing sample.
class AxisCrossingBaseValue extends SampleView {
  ///Creates default axis crossing sample, chart widget
  const AxisCrossingBaseValue(Key key) : super(key: key);

  @override
  _AxisCrossingBaseValueState createState() => _AxisCrossingBaseValueState();
}

/// State class of the spline chart with axis crossing.
class _AxisCrossingBaseValueState extends SampleViewState {
  _AxisCrossingBaseValueState();
  final List<String> _axis = <String>['-2 (modified)', '0 (default)'].toList();
  final List<String> _series = <String>['column', 'area'].toList();
  String _selectedSeriesType = 'column';
  String _selectedSeries;
  //ignore: unused_field
  String _selectedAxisType = '-2 (modified)';
  String _selectedAxis;
  double _crossAt = 0;
  // bool _isPlaceLabelsNearAxisLine = true;

  @override
  void initState() {
    _selectedAxisType = '-2 (modified)';
    _selectedAxis = '-2 (modified)';
    _selectedSeriesType = 'column';
    _selectedSeries = 'column';
    _crossAt = -2;
    // _isPlaceLabelsNearAxisLine = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getAxisCrossingBaseValueSample();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: [
            Text('Chart type',
                style: TextStyle(fontSize: 16.0, color: model.textColor)),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: 50,
                width: 150,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: model.bottomSheetBackgroundColor),
                    child: DropDown(
                        value: _selectedSeries,
                        item: _series.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'column',
                              child: Text('$value',
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        valueChanged: (dynamic value) {
                          _onSeriesTypeChange(value.toString());
                        }),
                  ),
                ))
          ],
        ),
        Row(
          children: <Widget>[
            Text('Axis base\nvalue ',
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
                        value: _selectedAxis,
                        item: _axis.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : '-2 (modified)',
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
      ],
    );
  }

  /// Returns the spline chart with axis crossing at provided axis value.
  SfCartesianChart _getAxisCrossingBaseValueSample() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth rate of countries'),
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.wrap,
          crossesAt: _crossAt,
          placeLabelsNearAxisLine: false),
      primaryYAxis: NumericAxis(
          minimum: -2, maximum: 2, majorTickLines: MajorTickLines(size: 0)),
      series: _getSeries(_selectedSeriesType),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on
  /// the bar or column chart with axis crossing.

  List<ChartSeries<ChartSampleData, String>> _getSeries(String seriesType) {
    List<ChartSeries<ChartSampleData, String>> chart = null;
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Iceland', y: 1.13),
      ChartSampleData(x: 'Algeria', y: 1.7),
      ChartSampleData(x: 'Singapore', y: 1.82),
      ChartSampleData(x: 'Malaysia', y: 1.37),
      ChartSampleData(x: 'Moldova', y: -1.05),
      ChartSampleData(x: 'American Samoa', y: -1.3),
      ChartSampleData(x: 'Latvia', y: -1.1)
    ];
    if (seriesType == 'column') {
      chart = <ChartSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            yValueMapper: (ChartSampleData sales, _) => sales.y,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle,
                alignment: ChartAlignment.center)),
      ];
    } else if (seriesType == 'area') {
      chart = <ChartSeries<ChartSampleData, String>>[
        AreaSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            yValueMapper: (ChartSampleData sales, _) => sales.y,
            markerSettings: MarkerSettings(isVisible: true)),
      ];
    }
    return chart;
  }

  /// Method for updating the axis type on change.
  void _onAxisTypeChange(String item) {
    _selectedAxis = item;
    if (_selectedAxis == '-2 (modified)') {
      _selectedAxisType = '-2 (modified)';
      _crossAt = -2;
    } else if (_selectedAxis == '0 (default)') {
      _selectedAxisType = '0 (default)';
      _crossAt = 0;
    }
    setState(() {
      /// update the axis type changes
    });
  }

  /// Method for updating the series type on change.
  void _onSeriesTypeChange(String item) {
    _selectedSeries = item;
    if (_selectedSeries == 'column') {
      _selectedSeriesType = 'column';
    } else if (_selectedSeries == 'area') {
      _selectedSeriesType = 'area';
    }
    setState(() {
      /// update the series type changes
    });
  }
}
