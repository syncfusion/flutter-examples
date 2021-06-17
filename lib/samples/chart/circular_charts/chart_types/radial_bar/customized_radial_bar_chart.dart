/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the radial bar customization.
class RadialBarCustomized extends SampleView {
  /// Cretaes customised  radial bar series.
  const RadialBarCustomized(Key key) : super(key: key);

  @override
  _RadialBarCustomizedState createState() => _RadialBarCustomizedState();
}

/// State class of radial bar customization.
class _RadialBarCustomizedState extends SampleViewState {
  _RadialBarCustomizedState();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCustomizedRadialBarChart();
  }

  /// Return the circular chart with radial customization.
  SfCircularChart _buildCustomizedRadialBarChart() {
    final List<ChartSampleData> dataSources = <ChartSampleData>[
      ChartSampleData(
          x: 'Vehicle',
          y: 62.70,
          text: '10%',
          pointColor: const Color.fromRGBO(69, 186, 161, 1.0)),
      ChartSampleData(
          x: 'Education',
          y: 29.20,
          text: '10%',
          pointColor: const Color.fromRGBO(230, 135, 111, 1.0)),
      ChartSampleData(
          x: 'Home',
          y: 85.20,
          text: '100%',
          pointColor: const Color.fromRGBO(145, 132, 202, 1.0)),
      ChartSampleData(
          x: 'Personal',
          y: 45.70,
          text: '100%',
          pointColor: const Color.fromRGBO(235, 96, 143, 1.0))
    ];

    final List<CircularChartAnnotation> _annotationSources =
        <CircularChartAnnotation>[
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset(
            'images/car_legend.png',
            width: 20,
            height: 20,
            color: const Color.fromRGBO(69, 186, 161, 1.0),
          ),
        ),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset(
            'images/book.png',
            width: 20,
            height: 20,
            color: const Color.fromRGBO(230, 135, 111, 1.0),
          ),
        ),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset('images/home.png',
              width: 20,
              height: 20,
              color: const Color.fromRGBO(145, 132, 202, 1.0)),
        ),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset(
            'images/personal_loan.png',
            width: 20,
            height: 20,
            color: const Color.fromRGBO(235, 96, 143, 1.0),
          ),
        ),
      ),
    ];

    const List<Color> colors = <Color>[
      Color.fromRGBO(69, 186, 161, 1.0),
      Color.fromRGBO(230, 135, 111, 1.0),
      Color.fromRGBO(145, 132, 202, 1.0),
      Color.fromRGBO(235, 96, 143, 1.0)
    ];

    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Percentage of loan closure'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
          return Container(
              height: 60,
              width: 150,
              child: Row(children: <Widget>[
                Container(
                    height: 75,
                    width: 65,
                    child: SfCircularChart(
                      annotations: <CircularChartAnnotation>[
                        _annotationSources[index],
                      ],
                      series: <RadialBarSeries<ChartSampleData, String>>[
                        RadialBarSeries<ChartSampleData, String>(
                            animationDuration: 0,
                            dataSource: <ChartSampleData>[dataSources[index]],
                            maximumValue: 100,
                            radius: '100%',
                            cornerStyle: CornerStyle.bothCurve,
                            xValueMapper: (ChartSampleData data, _) =>
                                point.x as String,
                            yValueMapper: (ChartSampleData data, _) => data.y,
                            pointColorMapper: (ChartSampleData data, _) =>
                                data.pointColor,
                            innerRadius: '70%',
                            pointRadiusMapper: (ChartSampleData data, _) =>
                                data.text),
                      ],
                    )),
                Container(
                    width: 72,
                    child: Text(
                      point.x,
                      style: TextStyle(
                          color: colors[index], fontWeight: FontWeight.bold),
                    )),
              ]));
        },
      ),
      series: _getRadialBarCustomizedSeries(),
      tooltipBehavior: _tooltipBehavior,
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          angle: 0,
          radius: '0%',
          height: '90%',
          width: '90%',
          widget: Container(
            child: Image.asset(
              'images/person.png',
              height: 100.0,
              width: 100.0,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns radial bar which need to be customized.
  List<RadialBarSeries<ChartSampleData, String>>
      _getRadialBarCustomizedSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Vehicle',
          y: 62.70,
          text: '100%',
          pointColor: const Color.fromRGBO(69, 186, 161, 1.0)),
      ChartSampleData(
          x: 'Education',
          y: 29.20,
          text: '100%',
          pointColor: const Color.fromRGBO(230, 135, 111, 1.0)),
      ChartSampleData(
          x: 'Home',
          y: 85.20,
          text: '100%',
          pointColor: const Color.fromRGBO(145, 132, 202, 1.0)),
      ChartSampleData(
          x: 'Personal',
          y: 45.70,
          text: '100%',
          pointColor: const Color.fromRGBO(235, 96, 143, 1.0))
    ];
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        animationDuration: 0,
        maximumValue: 100,
        gap: '10%',
        radius: '100%',
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        innerRadius: '50%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,

        /// Color mapper for each bar in radial bar series,
        /// which is get from datasource.
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        legendIconType: LegendIconType.circle,
      ),
    ];
  }
}
