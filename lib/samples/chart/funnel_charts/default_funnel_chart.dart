/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';

/// Renders the default funnel chart.
class FunnelDefault extends SampleView {
  /// Creates the default funnel chart.
  const FunnelDefault(Key key) : super(key: key);

  @override
  _FunnelDefaultState createState() => _FunnelDefaultState();
}

class _FunnelDefaultState extends SampleViewState {
  _FunnelDefaultState();
  late List<ChartSampleData> _chartData;
  late double _gapRatio;
  late int _neckWidth;
  late int _neckHeight;
  late bool _explode;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Purchased ', y: 150),
      ChartSampleData(x: 'Requested price list', y: 300),
      ChartSampleData(x: 'Downloaded trail', y: 600),
      ChartSampleData(x: 'Visit download page', y: 1500),
      ChartSampleData(x: 'Watched demo', y: 2600),
      ChartSampleData(x: 'Website visitors', y: 3000),
    ];
    _gapRatio = 0;
    _neckWidth = 20;
    _neckHeight = 20;
    _explode = false;
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildGapRatioRow(context, screenWidth),
            const SizedBox(height: 8.0),
            _buildNeckHeightRow(context, screenWidth),
            const SizedBox(height: 8.0),
            _buildNeckWidthRow(context, screenWidth),
            const SizedBox(height: 6.0),
            _buildExplodeRow(context, screenWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the UI row for adjusting the gap ratio.
  Widget _buildGapRatioRow(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '   Gap ratio',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          width: 0.5 * screenWidth,
          padding: EdgeInsets.only(left: 0.03 * screenWidth),
          child: CustomDirectionalButtons(
            maxValue: 0.5,
            initialValue: _gapRatio,
            onChanged: (double val) => setState(() {
              _gapRatio = val;
            }),
            step: 0.1,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the UI row for adjusting the neck height.
  Widget _buildNeckHeightRow(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          model.isWebFullView ? '   Neck \n   height' : '   Neck height  ',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          width: 0.5 * screenWidth,
          padding: EdgeInsets.only(left: 0.03 * screenWidth),
          child: CustomDirectionalButtons(
            maxValue: 50,
            initialValue: _neckHeight.toDouble(),
            onChanged: (double val) => setState(() {
              _neckHeight = val.toInt();
            }),
            step: 10,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the UI row for adjusting the neck width.
  Widget _buildNeckWidthRow(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '   Neck width',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          width: 0.5 * screenWidth,
          padding: EdgeInsets.only(left: 0.03 * screenWidth),
          child: CustomDirectionalButtons(
            maxValue: 50,
            initialValue: _neckWidth.toDouble(),
            onChanged: (double val) => setState(() {
              _neckWidth = val.toInt();
            }),
            step: 10,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the UI row for enabling or disabling the explode feature.
  Widget _buildExplodeRow(
    BuildContext context,
    double screenWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '   Explode',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        SizedBox(
          width: 0.5 * screenWidth,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: model.primaryColor,
            value: _explode,
            onChanged: (bool? value) {
              setState(() {
                _explode = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultFunnelChart();
  }

  /// Returns the default funnel chart.
  SfFunnelChart _buildDefaultFunnelChart() {
    return SfFunnelChart(
      title: ChartTitle(text: isCardView ? '' : 'Website conversion rate'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _buildFunnelSeries(),
    );
  }

  /// Returns the funnel series.
  FunnelSeries<ChartSampleData, String> _buildFunnelSeries() {
    _gapRatio = _gapRatio;
    _neckWidth = _neckWidth;
    _neckHeight = _neckHeight;
    _explode = _explode;
    return FunnelSeries<ChartSampleData, String>(
      dataSource: _chartData,
      xValueMapper: (ChartSampleData data, int index) => data.x,
      yValueMapper: (ChartSampleData data, int index) => data.y,
      explode: isCardView ? false : _explode,
      gapRatio: isCardView ? 0 : _gapRatio,
      neckHeight: isCardView ? '20%' : _neckHeight.toString() + '%',
      neckWidth: isCardView ? '20%' : _neckWidth.toString() + '%',
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
