import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Sample to depict the RTL feature
class RTLModeChart extends SampleView {
  ///Constructor for RTL chart
  const RTLModeChart(Key key) : super(key: key);

  @override
  _RTLModeChartState createState() => _RTLModeChartState();
}

class _RTLModeChartState extends SampleViewState {
  _RTLModeChartState() : super();

  List<ChartSampleData>? chartData;
  String? _title;
  late bool isInversedX, isOpposedPosition;
  String? firstSeriesName, secondSeriesName, thirdSeriesName;
  late TooltipBehavior tooltip;
  late List<Locale> _supportedLocales;
  final List<TextDirection> _supportedTextDirection = <TextDirection>[
    TextDirection.ltr,
    TextDirection.rtl,
  ];
  late TextDirection _textDirection;
  late Locale? _locale;

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    isInversedX = true;
    isOpposedPosition = true;
    _supportedLocales = <Locale>[
      const Locale('ar', 'AE'),
      const Locale('en', 'US'),
    ];
    _locale = const Locale('ar', 'AE');
    _textDirection = _locale == const Locale('ar', 'AE')
        ? TextDirection.rtl
        : TextDirection.ltr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _onLoadChartDataSource();
    return _buildDefaultLineChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.7 * screenWidth;
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
                          child: Text('Locale',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<Locale>(
                                  focusColor: Colors.transparent,
                                  isExpanded: true,
                                  underline: Container(
                                      color: const Color(0xFFBDBDBD),
                                      height: 1),
                                  value: _locale,
                                  items: _supportedLocales.map((Locale value) {
                                    String localeString = value.toString();
                                    localeString = (localeString == 'ar_AE')
                                        ? 'Arabic'
                                        : 'English';
                                    return DropdownMenuItem<Locale>(
                                        value: value,
                                        child: Text(localeString,
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  onChanged: (Locale? value) {
                                    setState(() {
                                      stateSetter(() {
                                        _locale = value;
                                        if (_locale ==
                                            const Locale('ar', 'AE')) {
                                          _textDirection = TextDirection.rtl;
                                        } else {
                                          _textDirection = TextDirection.ltr;
                                        }
                                      });
                                    });
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Rendering\nDirection',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<TextDirection>(
                                  focusColor: Colors.transparent,
                                  isExpanded: true,
                                  underline: Container(
                                      color: const Color(0xFFBDBDBD),
                                      height: 1),
                                  value: _textDirection,
                                  items: _supportedTextDirection
                                      .map((TextDirection value) {
                                    return DropdownMenuItem<TextDirection>(
                                        value: value,
                                        child: Text(
                                            value
                                                .toString()
                                                .split('.')[1]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  onChanged: (TextDirection? value) {
                                    setState(() {
                                      stateSetter(() {
                                        _textDirection = value!;
                                      });
                                    });
                                  })),
                        )
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Inverse \nx-axis',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(
                                  right: model.isMobile
                                      ? 0.29 * screenWidth
                                      : 0.37 * screenWidth),
                              width: dropDownWidth,
                              child: Checkbox(
                                  activeColor: model.backgroundColor,
                                  value: isInversedX,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isInversedX = value!;
                                      stateSetter(() {});
                                    });
                                  })),
                        )
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Oppose \ny-axis',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        const SizedBox(height: 6.0),
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(
                                  right: model.isMobile
                                      ? 0.29 * screenWidth
                                      : 0.37 * screenWidth),
                              width: dropDownWidth,
                              child: Checkbox(
                                  activeColor: model.backgroundColor,
                                  value: isOpposedPosition,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isOpposedPosition = value!;
                                      stateSetter(() {});
                                    });
                                  })),
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

  /// Get the cartesian chart with column series
  Widget _buildDefaultLineChart() {
    return Directionality(
      textDirection: _textDirection,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: (model.isWeb || model.isDesktop) ? 0 : 70.0),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          title: ChartTitle(text: _title!),
          legend: Legend(
            isVisible: true,
          ),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows,
              isInversed: isInversedX,
              majorGridLines: const MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(
              maximum: 20,
              interval: 4,
              axisLine: const AxisLine(width: 0),
              opposedPosition: isOpposedPosition,
              majorTickLines: const MajorTickLines(size: 0)),
          series: _getDefaultColumnSeries(),
          tooltipBehavior: tooltip,
        ),
      ),
    );
  }

  /// The method returns column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: firstSeriesName,
        color: const Color.fromRGBO(251, 193, 55, 1),
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
        name: secondSeriesName,
        color: const Color.fromRGBO(177, 183, 188, 1),
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
        name: thirdSeriesName,
        color: const Color.fromRGBO(140, 92, 69, 1),
      )
    ];
  }

  /// Method to get the widget's color based on the widget state
  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return model.backgroundColor;
    }
    return null;
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  // Method to update data source, title and name of the series based on the culture
  void _onLoadChartDataSource() {
    if (_locale == const Locale('en', 'US')) {
      chartData = <ChartSampleData>[
        ChartSampleData(
            x: 'Norway', y: 16, secondSeriesYValue: 8, thirdSeriesYValue: 13),
        ChartSampleData(
            x: 'USA', y: 8, secondSeriesYValue: 10, thirdSeriesYValue: 7),
        ChartSampleData(
            x: 'Germany', y: 12, secondSeriesYValue: 10, thirdSeriesYValue: 5),
        ChartSampleData(
            x: 'Canada', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
        ChartSampleData(
            x: 'Netherlands',
            y: 8,
            secondSeriesYValue: 5,
            thirdSeriesYValue: 4),
      ];
      _title = 'Winter Olympic medals count - 2022';
      firstSeriesName = 'Gold';
      secondSeriesName = 'Silver';
      thirdSeriesName = 'Bronze';
    } else if (_locale == const Locale('ar', 'AE')) {
      chartData = <ChartSampleData>[
        ChartSampleData(
            x: 'النرويج', y: 16, secondSeriesYValue: 8, thirdSeriesYValue: 13),
        ChartSampleData(
            x: 'الولايات المتحدة الأمريكية',
            y: 8,
            secondSeriesYValue: 10,
            thirdSeriesYValue: 7),
        ChartSampleData(
            x: 'ألمانيا', y: 12, secondSeriesYValue: 10, thirdSeriesYValue: 5),
        ChartSampleData(
            x: 'كندا', y: 4, secondSeriesYValue: 8, thirdSeriesYValue: 14),
        ChartSampleData(
            x: 'هولندا', y: 8, secondSeriesYValue: 5, thirdSeriesYValue: 4),
      ];
      _title = 'عدد الميداليات الأولمبية الشتوية - 2022';
      firstSeriesName = 'ذهب';
      secondSeriesName = 'فضة';
      thirdSeriesName = 'برونزية';
    }
  }
}
