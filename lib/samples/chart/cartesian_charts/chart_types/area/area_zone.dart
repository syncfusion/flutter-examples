/// Package import
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Renders default line series chart
class AreaZone extends SampleView {
  ///Creates default line series chart
  const AreaZone(Key key) : super(key: key);

  @override
  _AreaZoneState createState() => _AreaZoneState();
}

class _AreaZoneState extends SampleViewState {
  _AreaZoneState();

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAreaZoneChart(context);
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildAreaZoneChart(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final double containerSize = kIsWeb
        ? 80
        : orientation == Orientation.portrait
            ? 80
            : 45;
    final double fontSize = 14 / MediaQuery.of(context).textScaleFactor;
    final double size = 13 / MediaQuery.of(context).textScaleFactor;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Average monthly temperature of US - 2020'),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          // ignore: use_raw_strings
          labelFormat: '{value}°F',
          minimum: 0,
          maximum: 90,
          interval: 30,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getAreaZoneSeries(),
      tooltipBehavior: _tooltipBehavior,

      /// To set the annotation content for chart.
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
            widget: SizedBox(
                height: containerSize,
                width: containerSize,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(
                        Icons.circle,
                        color: const Color.fromRGBO(116, 182, 194, 1),
                        size: size,
                      ),
                      Text(
                        ' Winter',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Icon(Icons.circle,
                          color: const Color.fromRGBO(75, 189, 138, 1),
                          size: size),
                      Text(
                        ' Spring',
                        style: TextStyle(fontSize: fontSize),
                      )
                    ]),
                    Row(children: <Widget>[
                      Icon(Icons.circle,
                          color: const Color.fromRGBO(255, 186, 83, 1),
                          size: size),
                      Text(
                        ' Summer',
                        style: TextStyle(fontSize: fontSize),
                      )
                    ]),
                    Row(children: <Widget>[
                      Icon(Icons.circle,
                          color: const Color.fromRGBO(194, 110, 21, 1),
                          size: size),
                      Text(
                        ' Autumn',
                        style: TextStyle(fontSize: fontSize),
                      )
                    ]),
                  ],
                )),
            coordinateUnit: CoordinateUnit.percentage,
            x: kIsWeb ? '95%' : '85%',
            y: kIsWeb ? '21%' : '14%')
      ],
    );
  }

  /// The method returns line series to chart.
  List<CartesianSeries<ChartSampleData, String>> _getAreaZoneSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      AreaSeries<ChartSampleData, String>(
        animationDuration: 2500,
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Jan', y: 35.53),
          ChartSampleData(
            x: 'Feb',
            y: 46.06,
          ),
          ChartSampleData(
            x: 'Mar',
            y: 46.06,
          ),
          ChartSampleData(
            x: 'Apr',
            y: 50.86,
          ),
          ChartSampleData(
            x: 'May',
            y: 60.89,
          ),
          ChartSampleData(
            x: 'Jun',
            y: 70.27,
          ),
          ChartSampleData(
            x: 'Jul',
            y: 75.65,
          ),
          ChartSampleData(x: 'Aug', y: 74.7),
          ChartSampleData(
            x: 'Sep',
            y: 65.91,
          ),
          ChartSampleData(x: 'Oct', y: 54.28),
          ChartSampleData(x: 'Nov', y: 46.33),
          ChartSampleData(x: 'Dec', y: 35.71),
        ],
        name: 'US',
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.bottomLeft, details.rect.bottomRight, const <Color>[
            Color.fromRGBO(116, 182, 194, 1),
            Color.fromRGBO(75, 189, 138, 1),
            Color.fromRGBO(75, 189, 138, 1),
            Color.fromRGBO(255, 186, 83, 1),
            Color.fromRGBO(255, 186, 83, 1),
            Color.fromRGBO(194, 110, 21, 1),
            Color.fromRGBO(194, 110, 21, 1),
            Color.fromRGBO(116, 182, 194, 1),
          ], <double>[
            0.165,
            0.165,
            0.416,
            0.416,
            0.666,
            0.666,
            0.918,
            0.918
          ]);
        },
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}
