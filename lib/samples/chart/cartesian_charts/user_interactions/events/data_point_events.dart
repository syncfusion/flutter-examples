/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// URL launcher import.
import 'package:url_launcher/url_launcher.dart' show launchUrl;

/// Local import.
import '../../../../../model/sample_view.dart';

/// List of social media platforms.
List<String>? socialMediaPlatforms = <String>[
  'YouTube',
  'Twitter',
  'Instagram',
  'Snapchat',
  'Facebook',
];

/// Number of users for the social media platforms.
List<int>? userCounts = <int>[51, 42, 63, 61, 74];

/// Specifies the sorting criteria for the data.
String sortingCriteria = '';

/// Renders the default column series chart with interactive data points.
class DataPoints extends SampleView {
  /// Creates the default column series chart with interactive data points.
  const DataPoints(Key key) : super(key: key);
  @override
  _DataPointsState createState() => _DataPointsState();
}

/// State class for the default column series chart
/// with interactive data points.
class _DataPointsState extends SampleViewState {
  _DataPointsState();
  late List<ChartSampleData> _chartData;
  late SortingOrder _sortingOrder;
  late String _sortingCriteria;
  late GlobalKey<ScaffoldMessengerState> _scaffoldKey;
  late LinearGradient _gradient;

  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    _sortingCriteria = '';
    _sortingOrder = SortingOrder.none;
    _gradient = const LinearGradient(
      colors: <Color>[
        Color.fromRGBO(93, 80, 202, 1),
        Color.fromRGBO(183, 45, 145, 1),
        Color.fromRGBO(250, 203, 118, 1),
      ],
      stops: <double>[0.0, 0.5, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    _chartData = <ChartSampleData>[
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
      ChartSampleData(x: 'Instagram', y: 63),
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
        backgroundColor: model.sampleOutputCardColor,
        body: _buildDefaultColumnChart(),
      ),
    );
  }

  /// Returns a cartesian chart with default column series.
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView
            ? ''
            : 'Percentage of people using social media on a daily basis',
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        interval: isCardView ? 20 : 10,
        maximum: isCardView ? 100 : 90,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
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
                _buildDialogHeader(context),
                _buildSortingOptions(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        title: const Text(
          'Sort Data Points',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, color: model.primaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildSortingOptions(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          horizontalTitleGap: 0,
          title: const Text('Ascending (x-value)', textAlign: TextAlign.center),
          onTap: () {
            socialMediaPlatforms!.sort();
            _sortingOrder = SortingOrder.ascending;
            _sortingCriteria = 'sortByX';
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
            socialMediaPlatforms!.sort((String b, String a) => a.compareTo(b));
            _sortingOrder = SortingOrder.descending;
            _sortingCriteria = 'sortByX';
            Navigator.of(context).pop();
            setState(() {});
          },
        ),
        const Divider(height: 4, thickness: 2),
        ListTile(
          horizontalTitleGap: 0,
          title: const Text('Ascending (y-value)', textAlign: TextAlign.center),
          onTap: () {
            userCounts!.sort();
            socialMediaPlatforms = <String>[
              'Twitter',
              'YouTube',
              'Snapchat',
              'Instagram',
              'Facebook',
            ];
            _sortingOrder = SortingOrder.ascending;
            _sortingCriteria = 'sortByY';
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
            userCounts!.sort((int b, int a) => a.compareTo(b));
            socialMediaPlatforms = <String>[
              'Facebook',
              'Instagram',
              'Snapchat',
              'YouTube',
              'Twitter',
            ];
            _sortingOrder = SortingOrder.descending;
            _sortingCriteria = 'sortByY';
            Navigator.of(context).pop();
            setState(() {});
          },
        ),
      ],
    );
  }

  /// Returns the list of cartesian column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
        sortingOrder: _sortingOrder,
        gradient: _gradient,
        pointColorMapper: (ChartSampleData data, int index) => data.pointColor,
        sortFieldValueMapper: (ChartSampleData data, int index) =>
            _sortingCriteria == 'sortByX' ? data.x : data.y,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10),
        ),
        onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
          return _CustomColumnSeriesRenderer(isCardView);
        },
        onPointTap: (ChartPointDetails args) {
          final String xValue =
              socialMediaPlatforms![args.viewportPointIndex! as int];
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
          _scaffoldKey.currentState?.showSnackBar(
            SnackBar(
              width: _measureText(snackBarText).width,
              behavior: SnackBarBehavior.floating,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              duration: const Duration(milliseconds: 3000),
              content: Text(snackBarText, textAlign: TextAlign.center),
            ),
          );
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
          sortingCriteria = '';
        },
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class _CustomColumnSeriesRenderer<T, D> extends ColumnSeriesRenderer<T, D> {
  _CustomColumnSeriesRenderer(this._isCardView);
  final bool _isCardView;
  @override
  ColumnSegment<T, D> createSegment() {
    return _ColumnCustomPainter(_isCardView);
  }
}

class _ColumnCustomPainter<T, D> extends ColumnSegment<T, D> {
  _ColumnCustomPainter(this._isCardView);
  final bool _isCardView;

  @override
  void onPaint(Canvas canvas) {
    Paint? myPaint = fillPaint;
    if (_isCardView) {
      socialMediaPlatforms = <String>[
        'YouTube',
        'Twitter',
        'Instagram',
        'Snapchat',
        'Facebook',
      ];
      sortingCriteria = '';
    }
    final bool isSortingByY = sortingCriteria == 'sortByY';
    if (isSortingByY
        ? userCounts![currentSegmentIndex] == 51
        : socialMediaPlatforms![currentSegmentIndex] == 'YouTube') {
      myPaint = Paint()..color = const Color.fromRGBO(192, 33, 39, 1);
    } else if (isSortingByY
        ? userCounts![currentSegmentIndex] == 42
        : socialMediaPlatforms![currentSegmentIndex] == 'Twitter') {
      myPaint = Paint()..color = const Color.fromRGBO(26, 157, 235, 1);
    } else if (isSortingByY
        ? userCounts![currentSegmentIndex] == 63
        : socialMediaPlatforms![currentSegmentIndex] == 'Instagram') {
      myPaint = fillPaint;
    } else if (isSortingByY
        ? userCounts![currentSegmentIndex] == 61
        : socialMediaPlatforms![currentSegmentIndex] == 'Snapchat') {
      myPaint = Paint()..color = const Color.fromRGBO(254, 250, 55, 1);
    } else if (isSortingByY
        ? userCounts![currentSegmentIndex] == 74
        : socialMediaPlatforms![currentSegmentIndex] == 'Facebook') {
      myPaint = Paint()..color = const Color.fromRGBO(60, 92, 156, 1);
    }
    if (segmentRect != null) {
      final Rect rect = Rect.fromLTRB(
        segmentRect!.left,
        segmentRect!.top,
        segmentRect!.right * animationFactor,
        segmentRect!.bottom,
      );
      canvas.drawRect(rect, myPaint);
    }
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
