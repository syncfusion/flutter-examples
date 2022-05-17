import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

///URL launcher import
import 'package:url_launcher/url_launcher.dart' show launchUrl;

/// Local imports
import '../../../../../model/sample_view.dart';

///
List<String>? xvalue = <String>[
  'YouTube',
  'Twitter',
  'Instagram',
  'Snapchat',
  'Facebook'
];

///
List<int>? yvalue = <int>[51, 42, 63, 61, 74];

///
String sortby = '';

///Renders default column chart sample
class DataPoints extends SampleView {
  ///Renders default column chart sample
  const DataPoints(Key key) : super(key: key);
  @override
  _DataPointsState createState() => _DataPointsState();
}

class _DataPointsState extends SampleViewState {
  _DataPointsState();
  late List<ChartSampleData> chartData;
  late SortingOrder sortingOrder;
  late String sortBy;
  late GlobalKey<ScaffoldMessengerState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    sortBy = '';
    sortingOrder = SortingOrder.none;
    chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'YouTube',
        y: 51,
        pointColor: const Color.fromRGBO(192, 33, 39, 1),
      ),
      ChartSampleData(
        x: 'Twitter',
        y: 42,
        pointColor: const Color.fromRGBO(26, 157, 235, 1),
      ),
      ChartSampleData(
        x: 'Instagram',
        y: 63,
      ),
      ChartSampleData(
        x: 'Snapchat',
        y: 61,
        pointColor: const Color.fromRGBO(254, 250, 55, 1),
      ),
      ChartSampleData(
        x: 'Facebook',
        y: 74,
        pointColor: const Color.fromRGBO(47, 107, 167, 1),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
            backgroundColor: model.cardThemeColor,
            body: _buildDefaultColumnChart()));
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Percentage of people using social media on a daily basis'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interval: isCardView ? 20 : 10,
          maximum: isCardView ? 100 : 90,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                    height: 40,
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      title: const Text('Sort Data Points',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: model.backgroundColor),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text(
                    'Ascending (x-value)',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    xvalue!.sort();
                    sortingOrder = SortingOrder.ascending;
                    sortBy = 'sortByX';
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                const Divider(height: 4, thickness: 2),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text(
                    'Descending (x-value)',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    xvalue!.sort((String b, String a) => a.compareTo(b));
                    sortingOrder = SortingOrder.descending;
                    sortBy = 'sortByX';
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                const Divider(height: 4, thickness: 2),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text(
                    'Ascending (y-value)',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    yvalue!.sort();
                    xvalue = <String>[
                      'Twitter',
                      'YouTube',
                      'Snapchat',
                      'Instagram',
                      'Facebook'
                    ];
                    sortingOrder = SortingOrder.ascending;
                    sortBy = 'sortByY';
                    sortby = 'sortByY';
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                const Divider(height: 4, thickness: 2),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text(
                    'Descending (y-value)',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    yvalue!.sort((int b, int a) => a.compareTo(b));
                    xvalue = <String>[
                      'Facebook',
                      'Instagram',
                      'Snapchat',
                      'YouTube',
                      'Twitter'
                    ];
                    sortingOrder = SortingOrder.descending;
                    sortBy = 'sortByY';
                    sortby = 'sortByY';
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
          return _CustomColumnSeriesRenderer(isCardView);
        },
        onPointTap: (ChartPointDetails args) {
          final String xValue = xvalue![args.viewportPointIndex! as int];
          String? snackBarText = '';
          if (xValue == 'YouTube') {
            snackBarText = '51% of YouTube users are using it on daily basis.';
          } else if (xValue == 'Twitter') {
            snackBarText = '42% of Twitter users are using it on daily basis.';
          } else if (xValue == 'Instagram') {
            snackBarText =
                '63% of Instagram users are using it on daily basis.';
          } else if (xValue == 'Snapchat') {
            snackBarText = '61% of Snapchat users are using it on daily basis.';
          } else if (xValue == 'Facebook') {
            snackBarText = '74% of Facebook users are using it on daily basis.';
          }
          _scaffoldKey.currentState?.hideCurrentSnackBar();
          _scaffoldKey.currentState?.showSnackBar(SnackBar(
            width: _measureText(snackBarText).width,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            duration: const Duration(milliseconds: 3000),
            content: Text(
              snackBarText,
              textAlign: TextAlign.center,
            ),
          ));
        },
        onPointDoubleTap: (ChartPointDetails args) {
          args.pointIndex == 0
              ? launchUrl(Uri.parse('https://www.youtube.com/'))
              : args.pointIndex == 1
                  ? launchUrl(Uri.parse('http://www.twitter.com/'))
                  : args.pointIndex == 2
                      ? launchUrl(Uri.parse('https://www.instagram.com/'))
                      : args.pointIndex == 3
                          ? launchUrl(Uri.parse('http://www.snapchat.com/'))
                          : launchUrl(Uri.parse('https://www.facebook.com/'));
        },
        onPointLongPress: (ChartPointDetails args) {
          _showMyDialog();
          sortby = '';
        },
        dataSource: chartData,
        animationDuration: 0,
        sortingOrder: sortingOrder,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        sortFieldValueMapper: (ChartSampleData sales, _) =>
            sortBy == 'sortByX' ? sales.x : sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
        gradient: const LinearGradient(colors: <Color>[
          Color.fromRGBO(93, 80, 202, 1),
          Color.fromRGBO(183, 45, 145, 1),
          Color.fromRGBO(250, 203, 118, 1)
        ], stops: <double>[
          0.0,
          0.5,
          1.0
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      )
    ];
  }

  @override
  void dispose() {
    chartData.clear();
    super.dispose();
  }
}

class _CustomColumnSeriesRenderer extends ColumnSeriesRenderer {
  _CustomColumnSeriesRenderer(this._isCardView);
  final bool _isCardView;
  @override
  ChartSegment createSegment() {
    return _ColumnCustomPainter(_isCardView);
  }
}

class _ColumnCustomPainter extends ColumnSegment {
  _ColumnCustomPainter(this._isCardView);
  final bool _isCardView;
  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;
  @override
  void onPaint(Canvas canvas) {
    Paint? myPaint = fillPaint;
    if (_isCardView) {
      xvalue = <String>[
        'YouTube',
        'Twitter',
        'Instagram',
        'Snapchat',
        'Facebook'
      ];
      sortby = '';
    }
    if (sortby == 'sortByY'
        ? yvalue![currentSegmentIndex] == 51
        : xvalue![currentSegmentIndex] == 'YouTube') {
      myPaint = Paint()..color = const Color.fromRGBO(192, 33, 39, 1);
    } else if (sortby == 'sortByY'
        ? yvalue![currentSegmentIndex] == 42
        : xvalue![currentSegmentIndex] == 'Twitter') {
      myPaint = Paint()..color = const Color.fromRGBO(26, 157, 235, 1);
    } else if (sortby == 'sortByY'
        ? yvalue![currentSegmentIndex] == 63
        : xvalue![currentSegmentIndex] == 'Instagram') {
      myPaint = fillPaint;
    } else if (sortby == 'sortByY'
        ? yvalue![currentSegmentIndex] == 61
        : xvalue![currentSegmentIndex] == 'Snapchat') {
      myPaint = Paint()..color = const Color.fromRGBO(254, 250, 55, 1);
    } else if (sortby == 'sortByY'
        ? yvalue![currentSegmentIndex] == 74
        : xvalue![currentSegmentIndex] == 'Facebook') {
      myPaint = Paint()..color = const Color.fromRGBO(60, 92, 156, 1);
    }
    final Rect rect = Rect.fromLTRB(segmentRect.left, segmentRect.top,
        segmentRect.right * animationFactor, segmentRect.bottom);
    canvas.drawRect(rect, myPaint!);
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
