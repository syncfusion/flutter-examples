/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

///URL launcher import
import 'package:url_launcher/url_launcher.dart' show launch;

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the chart with sorting options sample.
class NavigationWithEvents extends SampleView {
  /// Creates the chart with sorting options sample.
  const NavigationWithEvents(Key key) : super(key: key);

  @override
  _NavigationWithEventsState createState() => _NavigationWithEventsState();
}

/// State class the chart with sorting options.
class _NavigationWithEventsState extends SampleViewState {
  _NavigationWithEventsState();
  double _xMaximumLabelWidth = 80;
  double _xLabelsExtent = 20;
  bool _isEnableLabelExtend = false;
  bool _isEnableMaximumLabelWidth = true;
  late List<bool> _isSelected;
  late TooltipBehavior _tooltipBehavior;
  String _selectedType = 'Maximum label width';
  final List<String> _typeList = <String>[
    'Maximum label width',
    'Labels extent'
  ];
  final List<ChartSampleData> _chartData = <ChartSampleData>[
    ChartSampleData(x: 'Goldin\nFinance 117', y: 597),
    ChartSampleData(x: 'Ping An\nFinance Center', y: 599),
    ChartSampleData(x: 'Makkah Clock\nRoyal Tower', y: 601),
    ChartSampleData(x: 'Shanghai\nTower', y: 632),
    ChartSampleData(x: 'Burj\nKhalifa', y: 828)
  ];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    _isSelected = <bool>[true, false];
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        activationMode: ActivationMode.longPress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
            backgroundColor: model.cardThemeColor,
            body: _buildmaximumLabelWidthChart()));
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: ToggleButtons(
                constraints: const BoxConstraints(maxWidth: 150, minHeight: 40),
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < _isSelected.length;
                        buttonIndex++) {
                      _isSelected[buttonIndex] = buttonIndex == index;
                      stateSetter(() {
                        onTypeChange(_typeList[index]);
                      });
                    }
                  });
                },
                isSelected: _isSelected,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Maximum label \nwidth',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text('Labels extent', textAlign: TextAlign.center),
                  )
                ],
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          ),
          Container(
            child: Visibility(
                visible: _isEnableMaximumLabelWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text('Maximum label\nwidth',
                          style: TextStyle(color: model.textColor)),
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
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    )
                  ],
                )),
          ),
          Container(
            child: Visibility(
                visible: _isEnableLabelExtend,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Labels extent',
                        style: TextStyle(color: model.textColor)),
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
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      );
    });
  }

  /// Returns the Cartesian chart with sorting options.
  SfCartesianChart _buildmaximumLabelWidthChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text = args.dataPoints[args.pointIndex].y.toString() + ' m';
      },
      onTooltipRender: (TooltipArgs args) {
        args.text = args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            args.dataPoints![args.pointIndex!.toInt()].y.toString() +
            ' m';
      },
      onDataLabelTapped: (DataLabelTapDetails args) {
        _scaffoldKey.currentState?.showSnackBar(SnackBar(
          width: model.isWebFullView
              ? _measureText(
                      'Data label tapped/clicked. Navigating to the link.')
                  .width
              : null,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          duration: const Duration(milliseconds: 2000),
          content:
              const Text('Data label tapped/clicked. Navigating to the link.'),
        ));
        launchHyperLink(args.text);
      },
      onAxisLabelTapped: (AxisLabelTapArgs args) {
        _scaffoldKey.currentState?.showSnackBar(SnackBar(
          width: model.isWebFullView
              ? _measureText(
                      'Axis label tapped/clicked. Navigating to the link.')
                  .width
              : null,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          duration: const Duration(milliseconds: 2000),
          content:
              const Text('Axis label tapped/clicked. Navigating to the link.'),
        ));
        launchHyperLink(args.value.toString());
      },
      onPointTapped: (PointTapArgs args) {
        _scaffoldKey.currentState?.showSnackBar(SnackBar(
          width: model.isWebFullView
              ? _measureText(
                      'Data point tapped/clicked. Navigating to the link.')
                  .width
              : null,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          duration: const Duration(milliseconds: 2000),
          content:
              const Text('Data point tapped/clicked. Navigating to the link.'),
        ));
        launchHyperLink(args.pointIndex.toString());
      },
      primaryXAxis: CategoryAxis(
          labelIntersectAction: isCardView
              ? AxisLabelIntersectAction.multipleRows
              : AxisLabelIntersectAction.rotate45,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Height (meters)'),
          minimum: 500,
          maximum: 900,
          interval: 100,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSortingSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  void launchHyperLink(String text) {
    switch (text) {
      case 'Goldin Finance 117':
      case '597 ft':
      case '0':
        launch(
            'https://www.emporis.com/buildings/388229/goldin-finance-117-tianjin-china');
        break;
      case 'Ping An Finance Center':
      case '599 ft':
      case '1':
        launch(
            'https://www.emporis.com/buildings/1189351/ping-an-international-finance-center-shenzhen-china');
        break;
      case 'Makkah Clock Royal Tower':
      case '601 ft':
      case '2':
        launch(
            'https://www.emporis.com/buildings/221047/makkah-clock-royal-tower-makkah-saudi-arabia');
        break;
      case 'Shanghai Tower':
      case '632 ft':
      case '3':
        launch(
            'https://www.emporis.com/buildings/323473/shanghai-tower-shanghai-china');
        break;
      case 'Burj Khalifa':
      case '828 ft':
      case '4':
        launch(
            'https://www.emporis.com/buildings/182168/burj-khalifa-dubai-united-arab-emirates');
        break;
    }
  }

  /// Returns the list of chart series which need to
  /// render on the chart with sorting options.
  List<CartesianSeries<ChartSampleData, String>> _getDefaultSortingSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings:
            DataLabelSettings(isVisible: true, offset: const Offset(-5, 0)),
      )
    ];
  }

  void onTypeChange(String item) {
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
}

Size _measureText(String textValue) {
  Size size;
  final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(text: textValue));
  textPainter.layout();
  size = Size(textPainter.width + 40, textPainter.height);
  return size;
}
