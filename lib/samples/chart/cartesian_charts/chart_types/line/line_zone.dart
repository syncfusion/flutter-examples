/// Package import
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

///Renders default line series chart
class LineZone extends SampleView {
  ///Creates default line series chart
  const LineZone(Key key) : super(key: key);

  @override
  _LineZoneState createState() => _LineZoneState();
}

class _LineZoneState extends SampleViewState {
  _LineZoneState();

  TrackballBehavior? _trackballBehavior;
  @override
  void initState() {
    yValues = <double>[
      30.87,
      31.25,
      28.31,
      26.15,
      27.74,
      25.38,
      33.87,
      30.23,
      30.6,
      28.75,
      31.25,
      28.6,
      25.7,
      30.26,
      29.8,
      27.26,
      29.6,
      30.39,
      30.63,
      29.7,
      30.33,
      31.7,
      34.96,
      30.62,
      33.03,
      26.31,
      30.44,
      30.14,
      32.75,
      28.27,
      29.96,
      33.86,
      34.76,
      31.4,
      29.97,
      31.38,
      29.01,
      25.9,
      29.05,
      32.17,
      32.44,
      31.26,
      32.62,
      30.62,
      32.69,
      33.7,
      31.86,
      33.89,
      28.47,
      28.22,
      29.02,
      29.05,
      30.51,
      33.25,
      30.08,
      29.82,
      29.18,
      31.24,
      32.3,
      31.37,
      30.1,
    ];
    _trackballBehavior = TrackballBehavior(
      enable: true,
      lineType: TrackballLineType.none,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(canShowMarker: false),
    );
    super.initState();
  }

  List<double>? yValues;

  @override
  Widget build(BuildContext context) {
    return _buildLineZoneChart(context);
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildLineZoneChart(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final double containerWidth = kIsWeb
        ? 80
        : orientation == Orientation.portrait
            ? 80
            : 60;
    final double containerHeight = kIsWeb
        ? 60
        : orientation == Orientation.portrait
            ? 60
            : 42;
    final double fontSize = 14 / MediaQuery.of(context).textScaleFactor;
    final double size = 13 / MediaQuery.of(context).textScaleFactor;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Average annual rainfall of United Kingdom'),
      primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: model.isWebFullView
              ? EdgeLabelPlacement.shift
              : EdgeLabelPlacement.none,
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          interval: kIsWeb ? 5 : 10,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}mm',
          minimum: 24,
          maximum: 36,
          interval: 2,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: _getLineZoneSeries(),
      trackballBehavior: _trackballBehavior,
      onTrackballPositionChanging: (TrackballArgs args) {
        args.chartPointInfo.label =
            args.chartPointInfo.header! + ' : ' + args.chartPointInfo.label!;
      },

      /// To set the annotation content for chart.
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
            widget: SizedBox(
                height: containerHeight,
                width: containerWidth,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(Icons.circle,
                          color: const Color.fromRGBO(4, 8, 195, 1),
                          size: size),
                      Text(' High', style: TextStyle(fontSize: fontSize)),
                    ]),
                    Row(children: <Widget>[
                      Icon(Icons.circle,
                          color: const Color.fromRGBO(26, 112, 23, 1),
                          size: size),
                      Text(' Medium', style: TextStyle(fontSize: fontSize))
                    ]),
                    Row(children: <Widget>[
                      Icon(Icons.circle,
                          color: const Color.fromRGBO(229, 11, 10, 1),
                          size: size),
                      Text(' Low', style: TextStyle(fontSize: fontSize))
                    ]),
                  ],
                )),
            coordinateUnit: CoordinateUnit.percentage,
            x: kIsWeb ? '95%' : '85%',
            y: kIsWeb
                ? '19%'
                : orientation == Orientation.portrait
                    ? '14%'
                    : '17%')
      ],
    );
  }

  /// The method returns line series to chart.
  List<CartesianSeries<_ChartData, DateTime>> _getLineZoneSeries() {
    return <CartesianSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        animationDuration: 2500,
        dataSource: getData(),
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter, details.rect.bottomCenter, <Color>[
            const Color.fromRGBO(4, 8, 195, 1),
            const Color.fromRGBO(4, 8, 195, 1),
            const Color.fromRGBO(26, 112, 23, 1),
            const Color.fromRGBO(26, 112, 23, 1),
            const Color.fromRGBO(229, 11, 10, 1),
            const Color.fromRGBO(229, 11, 10, 1),
          ], <double>[
            0,
            0.333333,
            0.333333,
            0.666666,
            0.666666,
            0.999999,
          ]);
        },
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
      ),
    ];
  }

  List<_ChartData> getData() {
    final List<_ChartData> data = <_ChartData>[];
    for (int i = 0; i < yValues!.length; i++) {
      data.add(_ChartData(DateTime(i + 1950), yValues![i]));
    }
    return data;
  }

  @override
  void dispose() {
    yValues!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
