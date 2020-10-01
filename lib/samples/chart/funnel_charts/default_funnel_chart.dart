/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/checkbox.dart';
import '../../../widgets/custom_button.dart';

/// Renders the default funnel chart
class FunnelDefault extends SampleView {
  /// Creates the default funnel chart
  const FunnelDefault(Key key) : super(key: key);

  @override
  _FunnelDefaultState createState() => _FunnelDefaultState();
}

class _FunnelDefaultState extends SampleViewState {
  _FunnelDefaultState();
  double gapRatio = 0;
  int neckWidth = 20;
  int neckHeight = 20;
  bool explode = false;

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Gap ratio  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: 0,
                    maxValue: 0.5,
                    initialValue: gapRatio,
                    onChanged: (double val) => setState(() {
                      gapRatio = val;
                    }),
                    step: 0.1,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Neck height  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: 0,
                    maxValue: 50,
                    initialValue: neckHeight.toDouble(),
                    onChanged: (double val) => setState(() {
                      neckHeight = val.toInt();
                    }),
                    step: 10,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Neck width',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: 0,
                    maxValue: 50,
                    initialValue: neckWidth.toDouble(),
                    onChanged: (double val) => setState(() {
                      neckWidth = val.toInt();
                    }),
                    step: 10,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Explode',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              const Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              CustomCheckBox(
                activeColor: model.backgroundColor,
                switchValue: explode,
                valueChanged: (dynamic value) {
                  setState(() {
                    explode = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getDefaultFunnelChart();
  }

  ///Get the default funnel chart
  SfFunnelChart _getDefaultFunnelChart() {
    return SfFunnelChart(
      smartLabelMode: SmartLabelMode.shift,
      title: ChartTitle(text: isCardView ? '' : 'Website conversion rate'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _getFunnelSeries(),
    );
  }

  /// This method returns the funnel series and
  /// its correspoding values to chart.
  FunnelSeries<ChartSampleData, String> _getFunnelSeries() {
    gapRatio = gapRatio ?? 0;
    neckWidth = neckWidth ?? 20;
    neckHeight = neckHeight ?? 20;
    explode = explode ?? true;
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Purchased ', y: 150),
      ChartSampleData(x: 'Requested price list', y: 300),
      ChartSampleData(x: 'Downloaded trail', y: 600),
      ChartSampleData(x: 'Visit download page', y: 1500),
      ChartSampleData(x: 'Watched demo', y: 2600),
      ChartSampleData(x: 'Website visitors', y: 3000)
    ];
    return FunnelSeries<ChartSampleData, String>(
        dataSource: pieData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        explode: isCardView ? false : explode,
        gapRatio: isCardView ? 0 : gapRatio,
        neckHeight: isCardView ? '20%' : neckHeight.toString() + '%',
        neckWidth: isCardView ? '20%' : neckWidth.toString() + '%',
        dataLabelSettings: DataLabelSettings(isVisible: true));
  }
}
