/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// URL launcher import.
import 'package:url_launcher/url_launcher.dart' show launchUrl;

/// Local imports.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders default bar series chart with navigation and event handling.
class NavigationWithEvents extends SampleView {
  /// Creates default bar series chart with navigation and event handling.
  const NavigationWithEvents(Key key) : super(key: key);

  @override
  _NavigationWithEventsState createState() => _NavigationWithEventsState();
}

/// State class for the chart with navigation and event handling.
class _NavigationWithEventsState extends SampleViewState {
  _NavigationWithEventsState();
  late double _xMaximumLabelWidth;
  late double _xLabelsExtent;
  late bool _isEnableLabelExtend;
  late bool _isEnableMaximumLabelWidth;
  late List<bool> _isSelected;
  late TooltipBehavior _tooltipBehavior;
  late String _selectedType;
  late List<String> _typeList;
  late List<ChartSampleData> _chartData;
  late GlobalKey<ScaffoldMessengerState> _scaffoldKey;

  @override
  void initState() {
    _xMaximumLabelWidth = 80;
    _xLabelsExtent = 20;
    _isEnableLabelExtend = false;
    _isEnableMaximumLabelWidth = true;
    _isSelected = <bool>[true, false];
    _typeList = <String>['Maximum label width', 'Labels extent'];
    _selectedType = 'Maximum label width';
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Goldin\nFinance 117', y: 597),
      ChartSampleData(x: 'Ping An\nFinance Center', y: 599),
      ChartSampleData(x: 'Makkah Clock\nRoyal Tower', y: 601),
      ChartSampleData(x: 'Shanghai\nTower', y: 632),
      ChartSampleData(x: 'Burj\nKhalifa', y: 828),
    ];
    _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
      activationMode: ActivationMode.longPress,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: model.sampleOutputCardColor,
        body: _buildDefaultBarChart(),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildToggleButtons(stateSetter),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            _buildLabelWidthSetting(),
            _buildLabelsExtentSetting(),
          ],
        );
      },
    );
  }

  /// Builds the toggle buttons for selecting settings.
  Widget _buildToggleButtons(StateSetter stateSetter) {
    return Container(
      alignment: Alignment.center,
      child: ToggleButtons(
        constraints: const BoxConstraints(maxWidth: 150, minHeight: 40),
        onPressed: (int index) {
          setState(() {
            for (
              int buttonIndex = 0;
              buttonIndex < _isSelected.length;
              buttonIndex++
            ) {
              _isSelected[buttonIndex] = buttonIndex == index;
              stateSetter(() {
                _onTypeChange(_typeList[index]);
              });
            }
          });
        },
        isSelected: _isSelected,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text('Maximum label \nwidth', textAlign: TextAlign.center),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text('Labels extent', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  /// Builds the settings for maximum label width.
  Widget _buildLabelWidthSetting() {
    return Visibility(
      visible: _isEnableMaximumLabelWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text(
              'Maximum label\nwidth',
              style: TextStyle(color: model.textColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: CustomDirectionalButtons(
              maxValue: 120,
              minValue: 1,
              initialValue: _xMaximumLabelWidth,
              onChanged: (double val) {
                setState(() {
                  _xMaximumLabelWidth = val;
                });
              },
              step: 10,
              loop: true,
              padding: 5.0,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the settings for labels extent.
  Widget _buildLabelsExtentSetting() {
    return Visibility(
      visible: _isEnableLabelExtend,
      child: Row(
        children: <Widget>[
          Text('Labels extent', style: TextStyle(color: model.textColor)),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: CustomDirectionalButtons(
              maxValue: 200,
              minValue: 1,
              initialValue: _xLabelsExtent,
              onChanged: (double val) {
                setState(() {
                  _xLabelsExtent = val;
                });
              },
              step: 10,
              loop: true,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the cartesian chart with default bar series.
  SfCartesianChart _buildDefaultBarChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text = args.dataPoints[args.pointIndex].y.toString() + ' m';
      },
      onTooltipRender: (TooltipArgs args) {
        args.text =
            args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            args.dataPoints![args.pointIndex!.toInt()].y.toString() +
            ' m';
      },
      onDataLabelTapped: (DataLabelTapDetails args) {
        _scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            width: model.isWebFullView
                ? _measureText(
                    'Data label tapped/clicked. Navigating to the link.',
                  ).width
                : null,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            duration: const Duration(milliseconds: 2000),
            content: const Text(
              'Data label tapped/clicked. Navigating to the link.',
            ),
          ),
        );
        _launchHyperLink(args.text);
      },
      onAxisLabelTapped: (AxisLabelTapArgs args) {
        _scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            width: model.isWebFullView
                ? _measureText(
                    'Axis label tapped/clicked. Navigating to the link.',
                  ).width
                : null,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            duration: const Duration(milliseconds: 2000),
            content: const Text(
              'Axis label tapped/clicked. Navigating to the link.',
            ),
          ),
        );
        _launchHyperLink(args.value.toString());
      },
      primaryXAxis: CategoryAxis(
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.multipleRows
            : AxisLabelIntersectAction.rotate45,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Height (meters)'),
        minimum: 500,
        maximum: 900,
        interval: 100,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  void _launchHyperLink(String text) {
    switch (text) {
      case 'Goldin Finance 117':
      case '597 m':
      case '500.0':
      case '500':
      case '0':
        launchUrl(
          Uri.parse(
            'https://www.emporis.com/buildings/388229/goldin-finance-117-tianjin-china',
          ),
        );
        break;
      case 'Ping An Finance Center':
      case '599 m':
      case '600.0':
      case '600':
      case '1':
        launchUrl(
          Uri.parse(
            'https://www.emporis.com/buildings/1189351/ping-an-international-finance-center-shenzhen-china',
          ),
        );
        break;
      case 'Makkah Clock Royal Tower':
      case '601 m':
      case '700.0':
      case '700':
      case '2':
        launchUrl(
          Uri.parse(
            'https://www.emporis.com/buildings/221047/makkah-clock-royal-tower-makkah-saudi-arabia',
          ),
        );
        break;
      case 'Shanghai Tower':
      case '632 m':
      case '800.0':
      case '800':
      case '3':
        launchUrl(
          Uri.parse(
            'https://www.emporis.com/buildings/323473/shanghai-tower-shanghai-china',
          ),
        );
        break;
      case 'Burj Khalifa':
      case '828 m':
      case '900.0':
      case '900':
      case '4':
        launchUrl(
          Uri.parse(
            'https://www.emporis.com/buildings/182168/burj-khalifa-dubai-united-arab-emirates',
          ),
        );
        break;
    }
  }

  /// Returns the list of cartesian bar series.
  List<CartesianSeries<ChartSampleData, String>> _buildBarSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        onPointTap: (ChartPointDetails args) {
          _scaffoldKey.currentState?.showSnackBar(
            SnackBar(
              width: model.isWebFullView
                  ? _measureText(
                      'Data point tapped/clicked. Navigating to the link.',
                    ).width
                  : null,
              behavior: SnackBarBehavior.floating,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              duration: const Duration(milliseconds: 2000),
              content: const Text(
                'Data point tapped/clicked. Navigating to the link.',
              ),
            ),
          );
          _launchHyperLink(args.pointIndex.toString());
        },
      ),
    ];
  }

  void _onTypeChange(String item) {
    _selectedType = item;
    if (_selectedType == 'Maximum label width') {
      _isEnableMaximumLabelWidth = true;
      _isEnableLabelExtend = false;
    }
    if (_selectedType == 'Labels extent') {
      _isEnableLabelExtend = true;
      _isEnableMaximumLabelWidth = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _typeList.clear();
    _chartData.clear();
    super.dispose();
  }
}

Size _measureText(String textValue) {
  Size size;
  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    text: TextSpan(text: textValue),
  );
  textPainter.layout();
  size = Size(textPainter.width + 40, textPainter.height);
  return size;
}
