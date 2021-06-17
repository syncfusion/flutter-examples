/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
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
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title:
                Text('Gap ratio  ', style: TextStyle(color: model.textColor)),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
              width: 0.5 * screenWidth,
              child: CustomDirectionalButtons(
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
          ListTile(
            title:
                Text('Neck height  ', style: TextStyle(color: model.textColor)),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
              width: 0.5 * screenWidth,
              child: CustomDirectionalButtons(
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
          ListTile(
            title: Text('Neck width', style: TextStyle(color: model.textColor)),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
              width: 0.5 * screenWidth,
              child: CustomDirectionalButtons(
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
          ListTile(
              title: Text('Explode',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                  padding: EdgeInsets.only(left: 0.05 * screenWidth),
                  width: 0.5 * screenWidth,
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: model.backgroundColor,
                      value: explode,
                      onChanged: (bool? value) {
                        setState(() {
                          explode = value!;
                          stateSetter(() {});
                        });
                      }))),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultFunnelChart();
  }

  ///Get the default funnel chart
  SfFunnelChart _buildDefaultFunnelChart() {
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
    gapRatio = gapRatio;
    neckWidth = neckWidth;
    neckHeight = neckHeight;
    explode = explode;
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
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        explode: isCardView ? false : explode,
        gapRatio: isCardView ? 0 : gapRatio,
        neckHeight: isCardView ? '20%' : neckHeight.toString() + '%',
        neckWidth: isCardView ? '20%' : neckWidth.toString() + '%',
        dataLabelSettings: DataLabelSettings(isVisible: true));
  }
}
