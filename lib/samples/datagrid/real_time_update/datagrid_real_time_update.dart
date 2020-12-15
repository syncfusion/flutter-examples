/// Dart import
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders real time value change data grid
class RealTimeUpdateDataGrid extends SampleView {
  /// Creates real time value change data grid
  const RealTimeUpdateDataGrid({Key key}) : super(key: key);

  @override
  _RealTimeUpdateDataGridPageState createState() =>
      _RealTimeUpdateDataGridPageState();
}

List<_Stock> _stockData;

class _RealTimeUpdateDataGridPageState extends SampleViewState {
  _RealTimeUpdateDataGridPageState();

  final math.Random _random = math.Random();

  final _RealTimeUpdateDataGridSource _realTimeUpdateDataGridSource =
      _RealTimeUpdateDataGridSource();

  Timer _timer;
  bool _isLandscapeInMobileView;

  final Map<double, Image> _images = <double, Image>{
    1: Image.asset(
      'images/Uparrow.png',
      width: 15,
      height: 15,
    ),
    0: Image.asset(
      'images/Downarrow.png',
      width: 15,
      height: 15,
    ),
  };

  final List<double> _stocks = <double>[
    -0.76,
    0.3,
    0.42,
    0.12,
    0.55,
    -0.78,
    0.68,
    0.99,
    0.31,
    -0.8,
    -0.99,
    0.43,
    -0.5,
    0.84 - 0.84,
    0.18,
    -0.71,
    -0.94
  ];

  final List<String> _symbols = <String>[
    'OJEC',
    'PUYU',
    'EXTB',
    'QBLI',
    'SFIO',
    'MIXR',
    'KQOW',
    'DSHN',
    'ZATR',
    'SFBK',
    'FLRT',
    'PHKH',
    'XRDZ',
    'QSGB',
    'XEMM',
    'ORTC',
    'ICGC',
    'NLGV',
    'TJXR',
    'HNDZ',
    'XMXT',
    'JKLN',
    'INEP',
    'RSTU',
    'THLF',
    'MHRE',
    'YZGO',
    'ZNNT',
    'QWIC',
    'XTNF',
    'PXNZ',
    'CTNR',
    'MXQN',
    'HBMR',
    'EPAF',
    'RTES',
    'RCOT',
    'BMQX',
    'OULN',
    'RRZR',
    'NRVV',
    'PFWE',
    'HFTB',
  ];

  List<_Stock> _generateList(int count) {
    final List<_Stock> stockData = <_Stock>[];
    for (int i = 1; i < _symbols.length; i++) {
      stockData.add(_Stock(
          _symbols[i],
          _stocks[_random.nextInt(_stocks.length - 1)],
          50.0 + _random.nextInt(40),
          50.0 + _random.nextInt(30),
          50 + _random.nextInt(20)));
    }
    return stockData;
  }

  @override
  void initState() {
    super.initState();
    _stockData = _generateList(100);
    _timer = Timer.periodic(const Duration(milliseconds: 200), (Timer args) {
      timerTick(args);
    });
  }

  void timerTick(Timer args) {
    _changeRows(100);
  }

  void _changeRows(int count) {
    if (_stockData.length < count) {
      count = _stockData.length;
    }

    for (int i = 0; i < count; ++i) {
      final int recNo = _random.nextInt(_stockData.length - 1);

      _stockData[recNo].stock = _stocks[(_random.nextInt(_stocks.length - 1))];
      _realTimeUpdateDataGridSource.updateDataSource(
          rowColumnIndex: RowColumnIndex(recNo, 1));

      _stockData[recNo].open = 50.0 + _random.nextInt(40);
      _realTimeUpdateDataGridSource.updateDataSource(
          rowColumnIndex: RowColumnIndex(recNo, 2));

      _stockData[recNo].previousClose = 50.0 + _random.nextInt(30);
      _realTimeUpdateDataGridSource.updateDataSource(
          rowColumnIndex: RowColumnIndex(recNo, 3));

      _stockData[recNo].lastTrade = 50 + _random.nextInt(20);
      _realTimeUpdateDataGridSource.updateDataSource(
          rowColumnIndex: RowColumnIndex(recNo, 4));
    }
  }

  SfDataGrid _dataGridSample() {
    return SfDataGrid(
      source: _realTimeUpdateDataGridSource,
      cellBuilder: (BuildContext context, GridColumn column, int rowIndex) {
        if (column.mappingName == 'stock') {
          final double stock = _stockData[rowIndex].stock;
          return stock >= 0.5
              ? _getWidget(_images[1], stock)
              : _getWidget(_images[0], stock);
        } else {
          return null;
        }
      },
      columnWidthMode: model.isWeb || _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.header,
      columns: <GridColumn>[
        GridTextColumn(
            mappingName: 'symbol',
            headerText: 'Symbol',
            headerTextAlignment: Alignment.center,
            textAlignment: Alignment.center),
        GridWidgetColumn(
            mappingName: 'stock',
            headerText: 'Stock',
            headerTextAlignment: Alignment.center,
            textAlignment: Alignment.center),
        GridNumericColumn(
            mappingName: 'open',
            headerText: ' Open',
            headerTextAlignment: Alignment.center,
            textAlignment: Alignment.center),
        GridNumericColumn(
            mappingName: 'previousClose',
            headerText: 'Previous Close',
            headerTextAlignment: Alignment.center,
            textAlignment: Alignment.center),
        GridNumericColumn(
            mappingName: 'lastTrade',
            headerText: 'Last Trade',
            headerTextAlignment: Alignment.center,
            textAlignment: Alignment.center),
      ],
    );
  }

  Widget _getWidget(Image image, double stack) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: model.isWeb
            ? <Widget>[
                Container(width: 20, child: image),
                Container(
                  width: 50,
                  child: Text(
                    '   ' + stack.toString(),
                  ),
                )
              ]
            : <Widget>[
                Container(child: image),
                const SizedBox(
                  width: 6.0,
                ),
                Flexible(
                  child: Text(
                    stack.toString(),
                    textScaleFactor: 1.0,
                  ),
                )
              ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _dataGridSample());
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

class _Stock {
  _Stock(
      this.symbol, this.stock, this.open, this.previousClose, this.lastTrade);
  String symbol;
  double stock;
  double open;
  double previousClose;
  int lastTrade;
}

class _RealTimeUpdateDataGridSource extends DataGridSource<_Stock> {
  _RealTimeUpdateDataGridSource();
  @override
  List<_Stock> get dataSource => _stockData;
  @override
  Object getValue(_Stock _stock, String columnName) {
    switch (columnName) {
      case 'symbol':
        return _stock.symbol;
        break;
      case 'open':
        return _stock.open;
        break;
      case 'previousClose':
        return _stock.previousClose;
        break;
      case 'lastTrade':
        return _stock.lastTrade;
        break;
      default:
        return 'empty';
        break;
    }
  }

  void updateDataSource({RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }
}
