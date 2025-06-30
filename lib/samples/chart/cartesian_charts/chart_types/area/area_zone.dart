/// Package imports.
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

///Renders default Line series Chart.
class AreaZone extends SampleView {
  const AreaZone(Key key) : super(key: key);

  @override
  _AreaZoneState createState() => _AreaZoneState();
}

class _AreaZoneState extends SampleViewState {
  _AreaZoneState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 35.53),
      ChartSampleData(x: 'Feb', y: 46.06),
      ChartSampleData(x: 'Mar', y: 46.06),
      ChartSampleData(x: 'Apr', y: 50.86),
      ChartSampleData(x: 'May', y: 60.89),
      ChartSampleData(x: 'Jun', y: 70.27),
      ChartSampleData(x: 'Jul', y: 75.65),
      ChartSampleData(x: 'Aug', y: 74.7),
      ChartSampleData(x: 'Sep', y: 65.91),
      ChartSampleData(x: 'Oct', y: 54.28),
      ChartSampleData(x: 'Nov', y: 46.33),
      ChartSampleData(x: 'Dec', y: 35.71),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart(context);
  }

  /// Return the Cartesian Chart with Area series.
  SfCartesianChart _buildCartesianChart(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final double containerSize = kIsWeb
        ? 80
        : orientation == Orientation.portrait
        ? 80
        : 45;
    final double fontSize = 14 / MediaQuery.of(context).textScaler.scale(1);
    final double size = 13 / MediaQuery.of(context).textScaler.scale(1);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Average monthly temperature of US - 2020',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        // ignore: use_raw_strings
        labelFormat: '{value}°F',
        minimum: 0,
        maximum: 90,
        interval: 30,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildAreaSeries(),
      tooltipBehavior: _tooltipBehavior,

      /// To set the annotation content for Chart.
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: SizedBox(
            height: containerSize,
            width: containerSize,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      color: const Color.fromRGBO(116, 182, 194, 1),
                      size: size,
                    ),
                    Text(' Winter', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      color: const Color.fromRGBO(75, 189, 138, 1),
                      size: size,
                    ),
                    Text(' Spring', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      color: const Color.fromRGBO(255, 186, 83, 1),
                      size: size,
                    ),
                    Text(' Summer', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      color: const Color.fromRGBO(194, 110, 21, 1),
                      size: size,
                    ),
                    Text(' Autumn', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ],
            ),
          ),
          coordinateUnit: CoordinateUnit.percentage,
          x: kIsWeb ? '95%' : '85%',
          y: kIsWeb ? '21%' : '14%',
        ),
      ],
    );
  }

  /// Returns the list of Cartesian Area series.
  List<CartesianSeries<ChartSampleData, String>> _buildAreaSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      AreaSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'US',
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
            details.rect.bottomLeft,
            details.rect.bottomRight,
            const <Color>[
              Color.fromRGBO(116, 182, 194, 1),
              Color.fromRGBO(75, 189, 138, 1),
              Color.fromRGBO(75, 189, 138, 1),
              Color.fromRGBO(255, 186, 83, 1),
              Color.fromRGBO(255, 186, 83, 1),
              Color.fromRGBO(194, 110, 21, 1),
              Color.fromRGBO(194, 110, 21, 1),
              Color.fromRGBO(116, 182, 194, 1),
            ],
            <double>[0.165, 0.165, 0.416, 0.416, 0.666, 0.666, 0.918, 0.918],
          );
        },
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
