/// Flutter imports.
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Dart import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the spline area series chart with pagination.
class Pagination extends SampleView {
  /// Creates the spline area series chart with pagination.
  const Pagination(Key key) : super(key: key);

  @override
  _PaginationState createState() => _PaginationState();
}

/// State class for the spline area series chart with pagination.
class _PaginationState extends SampleViewState {
  late double _height;
  late double _width;
  late double _segmentedControlWidth;
  late double _containerWidth;
  late double _containerHeight;
  late int _segmentedControlGroupValue;
  late int _degree;
  late String _day;
  late String _imageName;
  late List<String> _daysWithTime;
  late List<String> _temperature;
  late List<String> _images;
  late List<String> _days;
  late List<double> _minValues;
  late List<double> _maxValues;
  late List<int> _degrees;
  late List<ChartSampleData> _chartData;
  late CategoryAxisController _axisController;

  @override
  void initState() {
    _segmentedControlGroupValue = 0;
    _degree = 25;
    _day = 'Friday, 01:00 am';
    _imageName = 'images/sunny_image.png';
    _daysWithTime = const <String>[
      'Friday, 01:00 am',
      'Saturday, 01:00 am',
      'Sunday, 01:00 am',
      'Monday, 01:00 am',
      'Tuesday, 01:00 am',
    ];
    _temperature = const <String>[
      '25°19°',
      '25°20°',
      '24°18°',
      '19°14°',
      '18°14°',
    ];
    _images = const <String>[
      'sunny_image.png',
      'sunny_image.png',
      'cloudy.png',
      'cloudy.png',
      'rainy.png',
    ];
    _days = const <String>['Fri', 'Sat', 'Sun', 'Mon', 'Tue'];
    _minValues = const <double>[0, 6, 12, 18, 24];
    _maxValues = const <double>[5, 11, 17, 23, 29];
    _degrees = const <int>[25, 25, 24, 19, 18];
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(xValue: '0', x: '1 am', y: 20),
      ChartSampleData(xValue: '1', x: '4 am', y: 20),
      ChartSampleData(xValue: '2', x: '7 am', y: 20),
      ChartSampleData(xValue: '3', x: '10 am', y: 21),
      ChartSampleData(xValue: '4', x: '1 pm', y: 21),
      ChartSampleData(xValue: '5', x: '4 pm', y: 24),
      ChartSampleData(xValue: '6', x: '1 am', y: 19),
      ChartSampleData(xValue: '7', x: '4 am', y: 20),
      ChartSampleData(xValue: '8', x: '7 am', y: 20),
      ChartSampleData(xValue: '9', x: '10 am', y: 21),
      ChartSampleData(xValue: '10', x: '1 pm', y: 24),
      ChartSampleData(xValue: '11', x: '4 pm', y: 24),
      ChartSampleData(xValue: '12', x: '1 am', y: 21),
      ChartSampleData(xValue: '13', x: '4 am', y: 21),
      ChartSampleData(xValue: '14', x: '7 am', y: 21),
      ChartSampleData(xValue: '15', x: '10 am', y: 22),
      ChartSampleData(xValue: '16', x: '1 pm', y: 23),
      ChartSampleData(xValue: '17', x: '4 pm', y: 24),
      ChartSampleData(xValue: '18', x: '1 am', y: 20),
      ChartSampleData(xValue: '19', x: '4 am', y: 19),
      ChartSampleData(xValue: '20', x: '7 am', y: 19),
      ChartSampleData(xValue: '21', x: '10 am', y: 18),
      ChartSampleData(xValue: '22', x: '1 pm', y: 19),
      ChartSampleData(xValue: '23', x: '4 pm', y: 19),
      ChartSampleData(xValue: '24', x: '1 am', y: 16),
      ChartSampleData(xValue: '25', x: '4 am', y: 15),
      ChartSampleData(xValue: '26', x: '7 am', y: 14),
      ChartSampleData(xValue: '27', x: '10 am', y: 15),
      ChartSampleData(xValue: '28', x: '1 pm', y: 16),
      ChartSampleData(xValue: '29', x: '4 pm', y: 18),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    _segmentedControlWidth = _width > 500
        ? model.isWebFullView
              ? _width * 0.5
              : _width * 0.7
        : double.infinity;
    _height = MediaQuery.of(context).size.height;
    _height = !model.isWebFullView ? _height - 46 : _height;
    _height = model.isWebFullView && !kIsWeb ? _height * 0.6 : _height * 0.65;
    _containerHeight = 30;

    return Center(
      child: Column(
        children: <Widget>[
          _buildHeader(orientation),
          _buildChartAndSegmentedControl(orientation),
        ],
      ),
    );
  }

  /// Builds the header section of the UI.
  Widget _buildHeader(Orientation orientation) {
    return SizedBox(
      width: _segmentedControlWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 5),
                height: _height * 0.085,
                width: model.isWebFullView ? 50 : _height * 0.08,
                decoration: BoxDecoration(
                  image: DecorationImage(image: ExactAssetImage(_imageName)),
                ),
              ),
              SizedBox(
                height: _height * 0.1,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      child: Text(
                        '$_degree',
                        style: TextStyle(
                          fontSize: orientation == Orientation.landscape
                              ? _height * 0.08
                              : _height * 0.06,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 30),
                      child: const Text(
                        '°C | °F',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('USA, Texas', style: TextStyle(fontSize: _height * 0.045)),
                Text(_day, style: TextStyle(fontSize: _height * 0.025)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Cartesian chart and segmented control button section.
  Widget _buildChartAndSegmentedControl(Orientation orientation) {
    return Expanded(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: _segmentedControlWidth,
            child: ClipRect(child: _buildCartesianChart()),
          ),
          Visibility(
            visible: _height >= 350,
            child: Container(
              padding: model.isWebFullView
                  ? const EdgeInsets.fromLTRB(0, 16, 0, 16)
                  : const EdgeInsets.fromLTRB(0, 8, 0, 8),
              width: _segmentedControlWidth,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _segmentedControlGroupValue,
                children: _buildSegmentedControlButtons(orientation),
                onValueChanged: (int? i) => _loadGroupValue(i!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the item of segmented control.
  Map<int, Widget> _buildSegmentedControlButtons(Orientation orientation) {
    _containerWidth = _segmentedControlWidth == double.infinity
        ? _width / 5
        : _segmentedControlWidth / 5;
    final Color color = model.themeData.brightness == Brightness.light
        ? const Color.fromRGBO(104, 104, 104, 1)
        : const Color.fromRGBO(242, 242, 242, 1);
    final ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
      backgroundColor: WidgetStateProperty.resolveWith(_fetchColor),
    );
    final Map<int, Widget> buttons = <int, Widget>{};
    for (int i = 0; i <= 4; i++) {
      buttons.putIfAbsent(
        i,
        () => SizedBox(
          width: _containerWidth,
          child: TextButton(
            onPressed: () => _loadGroupValue(i),
            style: style,
            child: Column(
              children: <Widget>[
                Text(_days[i], style: TextStyle(fontSize: 12, color: color)),
                _buildImageContainer('images/' + _images[i]),
                Text(
                  _temperature[i],
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  /// Returns the image container.
  Container _buildImageContainer(String imageName) {
    return Container(
      height: _containerHeight,
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      decoration: BoxDecoration(
        image: DecorationImage(image: ExactAssetImage(imageName)),
      ),
    );
  }

  /// Returns color for the button based on interaction performed.
  Color? _fetchColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return model.themeData.brightness == Brightness.light
          ? const Color.fromRGBO(235, 235, 235, 1)
          : const Color.fromRGBO(104, 104, 104, 1);
    } else if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return const Color.fromRGBO(224, 224, 224, 1);
    } else {
      return null;
    }
  }

  /// Calls while performing the swipe operation.
  void _performSwipe(ChartSwipeDirection direction) {
    int? index;
    if (_axisController.visibleMinimum == 0 &&
        _axisController.visibleMaximum == 5) {
      index = direction == ChartSwipeDirection.end ? 1 : null;
    } else if (_axisController.visibleMinimum == 6 &&
        _axisController.visibleMaximum == 11) {
      index = direction == ChartSwipeDirection.end ? 2 : 0;
    } else if (_axisController.visibleMinimum == 12 &&
        _axisController.visibleMaximum == 17) {
      index = direction == ChartSwipeDirection.end ? 3 : 1;
    } else if (_axisController.visibleMinimum == 18 &&
        _axisController.visibleMaximum == 23) {
      index = direction == ChartSwipeDirection.end ? 4 : 2;
    } else if (_axisController.visibleMinimum == 24 &&
        _axisController.visibleMaximum == 29) {
      index = direction == ChartSwipeDirection.end ? null : 3;
    }

    if (index != null) {
      _loadGroupValue(index);
    }
  }

  /// Load the values based on the provided index.
  void _loadGroupValue(int index) {
    _axisController.visibleMinimum = _minValues[index];
    _axisController.visibleMaximum = _maxValues[index];
    setState(() {
      _segmentedControlGroupValue = index;
      _degree = _degrees[index];
      _day = _daysWithTime[index];
      _imageName = 'images/' + _images[index];
    });
  }

  /// Returns the cartesian spline area chart with pagination.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        initialVisibleMinimum: 0,
        initialVisibleMaximum: 5,
        labelPlacement: LabelPlacement.onTicks,
        interval: 1,
        name: 'primaryXAxis',
        axisLine: const AxisLine(width: 0, color: Colors.transparent),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          if (details.axis.name == 'primaryXAxis') {
            for (final ChartSampleData sampleData in _chartData) {
              if (sampleData.xValue == details.text) {
                return ChartAxisLabel(sampleData.x, details.textStyle);
              }
            }
          }
          return ChartAxisLabel(details.text, details.textStyle);
        },
        onRendererCreated: (CategoryAxisController controller) {
          _axisController = controller;
        },
      ),
      primaryYAxis: const NumericAxis(
        interval: 2,
        minimum: 0,
        maximum: 26,
        isVisible: false,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      plotAreaBorderWidth: 0,
      series: _buildSplineAreaSeries(),
      onPlotAreaSwipe: (ChartSwipeDirection direction) =>
          _performSwipe(direction),
    );
  }

  /// Returns the list of cartesian spline area series.
  List<CartesianSeries<ChartSampleData, String>> _buildSplineAreaSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      SplineAreaSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.xValue,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        borderColor: const Color.fromRGBO(255, 204, 5, 1),
        color: const Color.fromRGBO(255, 245, 211, 1),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.outer,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
