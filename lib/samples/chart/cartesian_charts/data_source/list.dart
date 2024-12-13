/// Package import.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders default line series chart using List data.
class LocalData extends SampleView {
  /// Creates default line series chart using List data.
  const LocalData(Key key) : super(key: key);

  @override
  _LocalDataState createState() => _LocalDataState();
}

/// State class for the default line series chart using Json data.
class _LocalDataState extends SampleViewState {
  _LocalDataState();
  List<_ChartData>? _chartData;
  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      lineColor: model.themeData.colorScheme.brightness == Brightness.dark
          ? const Color.fromRGBO(255, 255, 255, 0.03)
          : const Color.fromRGBO(0, 0, 0, 0.03),
      lineWidth: 15,
      activationMode: ActivationMode.singleTap,
      markerSettings: const TrackballMarkerSettings(
        borderWidth: 4,
        height: 10,
        width: 10,
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );
    _chartData = _buildChartData();
  }

  /// Method to get chart data points.
  List<_ChartData> _buildChartData() {
    return [
      _ChartData(x: DateTime(1980, 1, 23), y1: 83, y2: 94),
      _ChartData(x: DateTime(1980, 2, 24), y1: 83, y2: 93),
      _ChartData(x: DateTime(1980, 3, 25), y1: 82, y2: 93),
      _ChartData(x: DateTime(1980, 4, 26), y1: 83, y2: 93),
      _ChartData(x: DateTime(1980, 5, 27), y1: 83, y2: 93),
      _ChartData(x: DateTime(1980, 6, 28), y1: 84, y2: 94),
      _ChartData(x: DateTime(1980, 7, 29), y1: 84, y2: 94),
      _ChartData(x: DateTime(1980, 9, 30), y1: 85, y2: 95),
      _ChartData(x: DateTime(1980, 10), y1: 84, y2: 94),
      _ChartData(x: DateTime(1980, 11, 2), y1: 83, y2: 93),
      _ChartData(x: DateTime(1980, 12, 3), y1: 83, y2: 94),
      _ChartData(x: DateTime(1981, 1, 4), y1: 83, y2: 94),
      _ChartData(x: DateTime(1981, 2, 5), y1: 82, y2: 93),
      _ChartData(x: DateTime(1981, 3, 6), y1: 82, y2: 93),
      _ChartData(x: DateTime(1981, 4, 7), y1: 82, y2: 94),
      _ChartData(x: DateTime(1981, 5, 8), y1: 83, y2: 94),
      _ChartData(x: DateTime(1981, 6, 9), y1: 83, y2: 94),
      _ChartData(x: DateTime(1981, 7, 10), y1: 83, y2: 94),
      _ChartData(x: DateTime(1981, 8, 11), y1: 83, y2: 95),
      _ChartData(x: DateTime(1981, 9, 12), y1: 84, y2: 95),
      _ChartData(x: DateTime(1981, 10, 13), y1: 83, y2: 95),
      _ChartData(x: DateTime(1981, 11, 14), y1: 84, y2: 96),
      _ChartData(x: DateTime(1981, 12, 15), y1: 83, y2: 96),
      _ChartData(x: DateTime(1982, 1, 16), y1: 84, y2: 97),
      _ChartData(x: DateTime(1982, 2, 17), y1: 84, y2: 96),
      _ChartData(x: DateTime(1982, 3, 18), y1: 84, y2: 96),
      _ChartData(x: DateTime(1982, 4, 19), y1: 84, y2: 96),
      _ChartData(x: DateTime(1982, 5, 20), y1: 84, y2: 96),
      _ChartData(x: DateTime(1982, 6, 21), y1: 83, y2: 95),
      _ChartData(x: DateTime(1982, 7, 22), y1: 84, y2: 96),
      _ChartData(x: DateTime(1982, 8, 23), y1: 83, y2: 95),
      _ChartData(x: DateTime(1982, 9, 24), y1: 83, y2: 94),
      _ChartData(x: DateTime(1982, 10, 25), y1: 83, y2: 95),
      _ChartData(x: DateTime(1982, 11, 26), y1: 83, y2: 94),
      _ChartData(x: DateTime(1982, 12, 27), y1: 84, y2: 94),
      _ChartData(x: DateTime(1983, 1, 28), y1: 85, y2: 95),
      _ChartData(x: DateTime(1983, 2, 29), y1: 84, y2: 95),
      _ChartData(x: DateTime(1983, 4, 30), y1: 84, y2: 95),
      _ChartData(x: DateTime(1983, 5), y1: 83, y2: 95),
      _ChartData(x: DateTime(1983, 6, 2), y1: 84, y2: 95),
      _ChartData(x: DateTime(1983, 7, 3), y1: 85, y2: 95),
      _ChartData(x: DateTime(1983, 8, 4), y1: 86, y2: 95),
      _ChartData(x: DateTime(1983, 9, 5), y1: 86, y2: 96),
      _ChartData(x: DateTime(1983, 10, 6), y1: 87, y2: 97),
      _ChartData(x: DateTime(1983, 11, 7), y1: 87, y2: 98),
      _ChartData(x: DateTime(1983, 12, 8), y1: 87, y2: 99),
      _ChartData(x: DateTime(1984, 1, 9), y1: 86, y2: 98),
      _ChartData(x: DateTime(1984, 2, 10), y1: 86, y2: 98),
      _ChartData(x: DateTime(1984, 3, 11), y1: 86, y2: 97),
      _ChartData(x: DateTime(1984, 4, 12), y1: 86, y2: 96),
      _ChartData(x: DateTime(1984, 5, 13), y1: 86, y2: 97),
      _ChartData(x: DateTime(1984, 6, 14), y1: 85, y2: 97),
      _ChartData(x: DateTime(1984, 7, 15), y1: 85, y2: 96),
      _ChartData(x: DateTime(1984, 8, 16), y1: 84, y2: 96),
      _ChartData(x: DateTime(1984, 9, 17), y1: 84, y2: 96),
      _ChartData(x: DateTime(1984, 10, 18), y1: 84, y2: 97),
      _ChartData(x: DateTime(1984, 11, 19), y1: 85, y2: 98),
      _ChartData(x: DateTime(1984, 12, 20), y1: 85, y2: 98),
      _ChartData(x: DateTime(1985, 1, 21), y1: 85, y2: 97),
      _ChartData(x: DateTime(1985, 2, 22), y1: 85, y2: 98),
      _ChartData(x: DateTime(1985, 3, 23), y1: 86, y2: 99),
      _ChartData(x: DateTime(1985, 4, 24), y1: 85, y2: 98),
      _ChartData(x: DateTime(1985, 5, 25), y1: 85, y2: 97),
      _ChartData(x: DateTime(1985, 6, 26), y1: 86, y2: 97),
      _ChartData(x: DateTime(1985, 7, 27), y1: 86, y2: 98),
      _ChartData(x: DateTime(1985, 8, 28), y1: 86, y2: 97),
      _ChartData(x: DateTime(1985, 9, 29), y1: 86, y2: 96),
      _ChartData(x: DateTime(1985, 11, 30), y1: 86, y2: 97),
      _ChartData(x: DateTime(1985, 12), y1: 86, y2: 98),
      _ChartData(x: DateTime(1986, 1, 2), y1: 87, y2: 98),
      _ChartData(x: DateTime(1986, 2, 3), y1: 87, y2: 98),
      _ChartData(x: DateTime(1986, 3, 4), y1: 87, y2: 98),
      _ChartData(x: DateTime(1986, 4, 5), y1: 88, y2: 99),
      _ChartData(x: DateTime(1986, 5, 6), y1: 88, y2: 98),
      _ChartData(x: DateTime(1986, 6, 7), y1: 87, y2: 97),
      _ChartData(x: DateTime(1986, 7, 8), y1: 88, y2: 98),
      _ChartData(x: DateTime(1986, 8, 9), y1: 88, y2: 98),
      _ChartData(x: DateTime(1986, 9, 10), y1: 88, y2: 98),
      _ChartData(x: DateTime(1986, 10, 11), y1: 88, y2: 97),
      _ChartData(x: DateTime(1986, 11, 12), y1: 88, y2: 98),
      _ChartData(x: DateTime(1986, 12, 13), y1: 89, y2: 99),
      _ChartData(x: DateTime(1987, 1, 14), y1: 88, y2: 98),
      _ChartData(x: DateTime(1987, 2, 15), y1: 89, y2: 98),
      _ChartData(x: DateTime(1987, 3, 16), y1: 88, y2: 98),
      _ChartData(x: DateTime(1987, 4, 17), y1: 87, y2: 97),
      _ChartData(x: DateTime(1987, 5, 18), y1: 87, y2: 98),
      _ChartData(x: DateTime(1987, 6, 19), y1: 87, y2: 97),
      _ChartData(x: DateTime(1987, 7, 20), y1: 87, y2: 96),
      _ChartData(x: DateTime(1987, 8, 21), y1: 87, y2: 95),
      _ChartData(x: DateTime(1987, 9, 22), y1: 87, y2: 95),
      _ChartData(x: DateTime(1987, 10, 23), y1: 86, y2: 94),
      _ChartData(x: DateTime(1987, 11, 24), y1: 85, y2: 94),
      _ChartData(x: DateTime(1987, 12, 25), y1: 86, y2: 95),
      _ChartData(x: DateTime(1988, 1, 26), y1: 85, y2: 94),
      _ChartData(x: DateTime(1988, 2, 27), y1: 86, y2: 95),
      _ChartData(x: DateTime(1988, 3, 28), y1: 85, y2: 95),
      _ChartData(x: DateTime(1988, 4, 29), y1: 85, y2: 95),
      _ChartData(x: DateTime(1988, 6, 30), y1: 85, y2: 95),
      _ChartData(x: DateTime(1988, 7), y1: 86, y2: 96),
      _ChartData(x: DateTime(1988, 8, 2), y1: 85, y2: 96),
      _ChartData(x: DateTime(1988, 9, 3), y1: 84, y2: 95),
      _ChartData(x: DateTime(1988, 10, 4), y1: 85, y2: 96),
      _ChartData(x: DateTime(1988, 11, 5), y1: 85, y2: 96),
      _ChartData(x: DateTime(1988, 12, 6), y1: 85, y2: 96),
      _ChartData(x: DateTime(1989, 1, 7), y1: 86, y2: 97),
      _ChartData(x: DateTime(1989, 2, 8), y1: 86, y2: 97),
      _ChartData(x: DateTime(1989, 3, 9), y1: 85, y2: 96),
      _ChartData(x: DateTime(1989, 4, 10), y1: 84, y2: 95),
      _ChartData(x: DateTime(1989, 5, 11), y1: 85, y2: 96),
      _ChartData(x: DateTime(1989, 6, 12), y1: 84, y2: 95),
      _ChartData(x: DateTime(1989, 7, 13), y1: 84, y2: 94),
      _ChartData(x: DateTime(1989, 8, 14), y1: 85, y2: 95),
      _ChartData(x: DateTime(1989, 9, 15), y1: 84, y2: 94),
      _ChartData(x: DateTime(1989, 10, 16), y1: 84, y2: 95),
      _ChartData(x: DateTime(1989, 11, 17), y1: 84, y2: 95),
      _ChartData(x: DateTime(1989, 12, 18), y1: 84, y2: 95),
      _ChartData(x: DateTime(1990, 1, 19), y1: 83, y2: 95),
      _ChartData(x: DateTime(1990, 2, 20), y1: 84, y2: 95),
      _ChartData(x: DateTime(1990, 3, 21), y1: 85, y2: 96),
      _ChartData(x: DateTime(1990, 4, 22), y1: 84, y2: 95),
      _ChartData(x: DateTime(1990, 5, 23), y1: 83, y2: 94),
      _ChartData(x: DateTime(1990, 6, 24), y1: 84, y2: 95),
      _ChartData(x: DateTime(1990, 7, 25), y1: 84, y2: 96),
      _ChartData(x: DateTime(1990, 8, 26), y1: 84, y2: 96),
      _ChartData(x: DateTime(1990, 9, 27), y1: 84, y2: 95),
      _ChartData(x: DateTime(1990, 10, 28), y1: 83, y2: 94),
      _ChartData(x: DateTime(1990, 11, 29), y1: 84, y2: 94),
      _ChartData(x: DateTime(1991, 1, 30), y1: 84, y2: 95),
      _ChartData(x: DateTime(1991, 2), y1: 84, y2: 95),
      _ChartData(x: DateTime(1991, 3, 2), y1: 83, y2: 94),
      _ChartData(x: DateTime(1991, 4, 3), y1: 84, y2: 95),
      _ChartData(x: DateTime(1991, 5, 4), y1: 85, y2: 96),
      _ChartData(x: DateTime(1991, 6, 5), y1: 84, y2: 96),
      _ChartData(x: DateTime(1991, 7, 6), y1: 84, y2: 95),
      _ChartData(x: DateTime(1991, 8, 7), y1: 84, y2: 96),
      _ChartData(x: DateTime(1991, 9, 8), y1: 84, y2: 96),
      _ChartData(x: DateTime(1991, 10, 9), y1: 84, y2: 96),
      _ChartData(x: DateTime(1991, 11, 10), y1: 84, y2: 96),
      _ChartData(x: DateTime(1991, 12, 11), y1: 84, y2: 97),
      _ChartData(x: DateTime(1992, 1, 12), y1: 85, y2: 97),
      _ChartData(x: DateTime(1992, 2, 13), y1: 86, y2: 98),
      _ChartData(x: DateTime(1992, 3, 14), y1: 86, y2: 99),
      _ChartData(x: DateTime(1992, 4, 15), y1: 86, y2: 98),
      _ChartData(x: DateTime(1992, 5, 16), y1: 86, y2: 98),
      _ChartData(x: DateTime(1992, 6, 17), y1: 85, y2: 98),
      _ChartData(x: DateTime(1992, 7, 18), y1: 85, y2: 98),
      _ChartData(x: DateTime(1992, 8, 19), y1: 86, y2: 98),
      _ChartData(x: DateTime(1992, 9, 20), y1: 87, y2: 98),
      _ChartData(x: DateTime(1992, 10, 21), y1: 88, y2: 99),
      _ChartData(x: DateTime(1992, 11, 22), y1: 87, y2: 98),
      _ChartData(x: DateTime(1992, 12, 23), y1: 87, y2: 98),
      _ChartData(x: DateTime(1993, 1, 24), y1: 87, y2: 99),
      _ChartData(x: DateTime(1993, 2, 25), y1: 88, y2: 100),
      _ChartData(x: DateTime(1993, 3, 26), y1: 87, y2: 99),
      _ChartData(x: DateTime(1993, 4, 27), y1: 86, y2: 99),
      _ChartData(x: DateTime(1993, 5, 28), y1: 86, y2: 99),
      _ChartData(x: DateTime(1993, 6, 29), y1: 85, y2: 98),
      _ChartData(x: DateTime(1993, 8, 30), y1: 85, y2: 98),
      _ChartData(x: DateTime(1993, 9), y1: 85, y2: 98),
      _ChartData(x: DateTime(1993, 10, 2), y1: 85, y2: 98),
      _ChartData(x: DateTime(1993, 11, 3), y1: 84, y2: 97),
      _ChartData(x: DateTime(1993, 12, 4), y1: 85, y2: 97),
      _ChartData(x: DateTime(1994, 1, 5), y1: 84, y2: 97),
      _ChartData(x: DateTime(1994, 2, 6), y1: 84, y2: 96),
      _ChartData(x: DateTime(1994, 3, 7), y1: 83, y2: 96),
      _ChartData(x: DateTime(1994, 4, 8), y1: 83, y2: 95),
      _ChartData(x: DateTime(1994, 5, 9), y1: 84, y2: 96),
      _ChartData(x: DateTime(1994, 6, 10), y1: 83, y2: 95),
      _ChartData(x: DateTime(1994, 7, 11), y1: 83, y2: 95),
      _ChartData(x: DateTime(1994, 8, 12), y1: 84, y2: 95),
      _ChartData(x: DateTime(1994, 9, 13), y1: 83, y2: 95),
      _ChartData(x: DateTime(1994, 10, 14), y1: 82, y2: 94),
      _ChartData(x: DateTime(1994, 11, 15), y1: 83, y2: 94),
      _ChartData(x: DateTime(1994, 12, 16), y1: 83, y2: 95),
      _ChartData(x: DateTime(1995, 1, 17), y1: 83, y2: 96),
      _ChartData(x: DateTime(1995, 2, 18), y1: 83, y2: 95),
      _ChartData(x: DateTime(1995, 3, 19), y1: 84, y2: 96),
      _ChartData(x: DateTime(1995, 4, 20), y1: 84, y2: 96),
      _ChartData(x: DateTime(1995, 5, 21), y1: 84, y2: 97),
      _ChartData(x: DateTime(1995, 6, 22), y1: 84, y2: 97),
      _ChartData(x: DateTime(1995, 7, 23), y1: 83, y2: 96),
      _ChartData(x: DateTime(1995, 8, 24), y1: 84, y2: 97),
      _ChartData(x: DateTime(1995, 9, 25), y1: 84, y2: 96),
      _ChartData(x: DateTime(1995, 10, 26), y1: 84, y2: 97),
      _ChartData(x: DateTime(1995, 11, 27), y1: 84, y2: 96),
      _ChartData(x: DateTime(1995, 12, 28), y1: 85, y2: 96),
      _ChartData(x: DateTime(1996, 1, 29), y1: 85, y2: 97),
      _ChartData(x: DateTime(1996, 3, 30), y1: 84, y2: 96),
      _ChartData(x: DateTime(1996, 4), y1: 84, y2: 96),
      _ChartData(x: DateTime(1996, 5, 2), y1: 84, y2: 97),
      _ChartData(x: DateTime(1996, 6, 3), y1: 85, y2: 97),
      _ChartData(x: DateTime(1996, 7, 4), y1: 86, y2: 97),
      _ChartData(x: DateTime(1996, 8, 5), y1: 87, y2: 98),
      _ChartData(x: DateTime(1996, 9, 6), y1: 86, y2: 97),
      _ChartData(x: DateTime(1996, 10, 7), y1: 85, y2: 97),
      _ChartData(x: DateTime(1996, 11, 8), y1: 85, y2: 96),
      _ChartData(x: DateTime(1996, 12, 9), y1: 84, y2: 96),
      _ChartData(x: DateTime(1997, 1, 10), y1: 84, y2: 96),
      _ChartData(x: DateTime(1997, 2, 11), y1: 85, y2: 96),
      _ChartData(x: DateTime(1997, 3, 12), y1: 85, y2: 96),
      _ChartData(x: DateTime(1997, 4, 13), y1: 86, y2: 96),
      _ChartData(x: DateTime(1997, 5, 14), y1: 85, y2: 95),
      _ChartData(x: DateTime(1997, 6, 15), y1: 86, y2: 96),
      _ChartData(x: DateTime(1997, 7, 16), y1: 85, y2: 96),
      _ChartData(x: DateTime(1997, 8, 17), y1: 85, y2: 95),
      _ChartData(x: DateTime(1997, 9, 18), y1: 85, y2: 96),
      _ChartData(x: DateTime(1997, 10, 19), y1: 86, y2: 96),
      _ChartData(x: DateTime(1997, 11, 20), y1: 85, y2: 95),
      _ChartData(x: DateTime(1997, 12, 21), y1: 86, y2: 95),
      _ChartData(x: DateTime(1998, 1, 22), y1: 86, y2: 96),
      _ChartData(x: DateTime(1998, 2, 23), y1: 86, y2: 97),
      _ChartData(x: DateTime(1998, 3, 24), y1: 87, y2: 97),
      _ChartData(x: DateTime(1998, 4, 25), y1: 87, y2: 98),
      _ChartData(x: DateTime(1998, 5, 26), y1: 87, y2: 99),
      _ChartData(x: DateTime(1998, 6, 27), y1: 88, y2: 99),
      _ChartData(x: DateTime(1998, 7, 28), y1: 88, y2: 98),
      _ChartData(x: DateTime(1998, 8, 29), y1: 87, y2: 97),
      _ChartData(x: DateTime(1998, 10, 30), y1: 87, y2: 97),
      _ChartData(x: DateTime(1998, 11), y1: 87, y2: 98),
      _ChartData(x: DateTime(1998, 12, 2), y1: 86, y2: 98),
      _ChartData(x: DateTime(1999, 1, 3), y1: 86, y2: 97),
      _ChartData(x: DateTime(1999, 2, 4), y1: 86, y2: 96),
      _ChartData(x: DateTime(1999, 3, 5), y1: 86, y2: 97),
      _ChartData(x: DateTime(1999, 4, 6), y1: 85, y2: 97),
      _ChartData(x: DateTime(1999, 5, 7), y1: 85, y2: 96),
      _ChartData(x: DateTime(1999, 6, 8), y1: 84, y2: 95),
      _ChartData(x: DateTime(1999, 7, 9), y1: 85, y2: 96),
      _ChartData(x: DateTime(1999, 8, 10), y1: 84, y2: 96),
      _ChartData(x: DateTime(1999, 9, 11), y1: 84, y2: 96),
      _ChartData(x: DateTime(1999, 10, 12), y1: 83, y2: 95),
      _ChartData(x: DateTime(1999, 11, 13), y1: 84, y2: 96),
      _ChartData(x: DateTime(1999, 12, 14), y1: 84, y2: 96),
      _ChartData(x: DateTime(2000, 1, 15), y1: 84, y2: 95),
      _ChartData(x: DateTime(2000, 2, 16), y1: 84, y2: 96),
      _ChartData(x: DateTime(2000, 3, 17), y1: 85, y2: 96),
      _ChartData(x: DateTime(2000, 4, 18), y1: 84, y2: 95),
      _ChartData(x: DateTime(2000, 5, 19), y1: 85, y2: 96),
      _ChartData(x: DateTime(2000, 6, 20), y1: 85, y2: 96),
      _ChartData(x: DateTime(2000, 7, 21), y1: 85, y2: 96),
      _ChartData(x: DateTime(2000, 8, 22), y1: 84, y2: 96),
      _ChartData(x: DateTime(2000, 9, 23), y1: 84, y2: 96),
      _ChartData(x: DateTime(2000, 10, 24), y1: 84, y2: 96),
      _ChartData(x: DateTime(2000, 11, 25), y1: 84, y2: 95),
      _ChartData(x: DateTime(2000, 12, 26), y1: 84, y2: 94),
      _ChartData(x: DateTime(2001, 1, 27), y1: 85, y2: 95),
      _ChartData(x: DateTime(2001, 2, 28), y1: 85, y2: 94),
      _ChartData(x: DateTime(2001, 3, 29), y1: 85, y2: 95),
      _ChartData(x: DateTime(2001, 5, 30), y1: 84, y2: 94),
      _ChartData(x: DateTime(2001, 6), y1: 84, y2: 94),
      _ChartData(x: DateTime(2001, 7, 2), y1: 85, y2: 94),
      _ChartData(x: DateTime(2001, 8, 3), y1: 85, y2: 95),
      _ChartData(x: DateTime(2001, 9, 4), y1: 84, y2: 95),
      _ChartData(x: DateTime(2001, 10, 5), y1: 84, y2: 94),
      _ChartData(x: DateTime(2001, 11, 6), y1: 85, y2: 95),
      _ChartData(x: DateTime(2001, 12, 7), y1: 85, y2: 95),
      _ChartData(x: DateTime(2002, 1, 8), y1: 84, y2: 95),
      _ChartData(x: DateTime(2002, 2, 9), y1: 84, y2: 94),
      _ChartData(x: DateTime(2002, 3, 10), y1: 84, y2: 93),
      _ChartData(x: DateTime(2002, 4, 11), y1: 84, y2: 93),
      _ChartData(x: DateTime(2002, 5, 12), y1: 84, y2: 92),
      _ChartData(x: DateTime(2002, 6, 13), y1: 84, y2: 92),
      _ChartData(x: DateTime(2002, 7, 14), y1: 84, y2: 92),
      _ChartData(x: DateTime(2002, 8, 15), y1: 83, y2: 91),
      _ChartData(x: DateTime(2002, 9, 16), y1: 83, y2: 92),
      _ChartData(x: DateTime(2002, 10, 17), y1: 84, y2: 93),
      _ChartData(x: DateTime(2002, 11, 18), y1: 84, y2: 93),
      _ChartData(x: DateTime(2002, 12, 19), y1: 83, y2: 92),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultLineChart();
  }

  /// Returns the cartesian chart with default line series.
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison'),
      legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        name: 'Years',
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 70,
        maximum: 110,
        interval: 10,
        rangePadding: ChartRangePadding.none,
        name: 'Price',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: _buildDefaultLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<_ChartData, DateTime>> _buildDefaultLineSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y1,
        name: 'Product A',
      ),
      LineSeries<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y2,
        name: 'Product B',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData({this.x, this.y1, this.y2});
  DateTime? x;
  num? y1;
  num? y2;
}
