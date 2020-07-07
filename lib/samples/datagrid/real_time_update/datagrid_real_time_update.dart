//import 'dart:async';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';

class RealTimeUpdateDataGrid extends SampleView {
  const RealTimeUpdateDataGrid({Key key}) : super(key: key);

  @override
  _RealTimeUpdateDataGridPageState createState() =>
      _RealTimeUpdateDataGridPageState();
}

List<Stock> _stockData;

class _RealTimeUpdateDataGridPageState extends SampleViewState {
  _RealTimeUpdateDataGridPageState();

  Widget sampleWidget(SampleModel model) => const RealTimeUpdateDataGrid();

  final math.Random _random = math.Random();

  final RealTimeUpdateDataGridSource _realTimeUpdateDataGridSource =
      RealTimeUpdateDataGridSource();

  Timer _timer;

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

  List<Stock> generateList(int count) {
    final List<Stock> stockData = <Stock>[];
    for (int i = 1; i < _symbols.length; i++) {
      stockData.add(Stock(
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
    _stockData = generateList(100);
    _timer = Timer.periodic(const Duration(milliseconds: 200), (Timer args) {
      timerTick(args);
    });
  }

  void timerTick(Timer args) {
    changeRows(100);
  }

  void changeRows(int count) {
    if (_stockData.length < count) {
      count = _stockData.length;
    }

    for (int i = 0; i < count; ++i) {
      final int recNo = _random.nextInt(_stockData.length - 1);

      _stockData[recNo].stock = _stocks[(_random.nextInt(_stocks.length - 1))];
      _realTimeUpdateDataGridSource.notifyDataSourceListeners(
          rowColumnIndex: RowColumnIndex(recNo, 1));

      _stockData[recNo].open = 50.0 + _random.nextInt(40);
      _realTimeUpdateDataGridSource.notifyDataSourceListeners(
          rowColumnIndex: RowColumnIndex(recNo, 2));

      _stockData[recNo].previousClose = 50.0 + _random.nextInt(30);
      _realTimeUpdateDataGridSource.notifyDataSourceListeners(
          rowColumnIndex: RowColumnIndex(recNo, 3));

      _stockData[recNo].lastTrade = 50 + _random.nextInt(20);
      _realTimeUpdateDataGridSource.notifyDataSourceListeners(
          rowColumnIndex: RowColumnIndex(recNo, 4));
    }
  }

  SfDataGrid _dataGridSample() {
    return SfDataGrid(
      source: _realTimeUpdateDataGridSource,
      cellBuilder: (BuildContext context, GridColumn column, int rowIndex) {
        if (column.mappingName == 'stock') {
          final double stock = _stockData[rowIndex].stock;
          if (stock >= 0.5)
            return getWidget(_images[1], stock);
          else
            return getWidget(_images[0], stock);
        } else {
          return null;
        }
      },
      columnWidthMode: kIsWeb ? ColumnWidthMode.fill : ColumnWidthMode.header,
      columns: <GridColumn>[
        GridTextColumn(mappingName: 'symbol')
          ..headerText = 'Symbol'
          ..headerTextAlignment = Alignment.center
          ..textAlignment = Alignment.center,
        GridWidgetColumn(mappingName: 'stock')
          ..headerText = 'Stock'
          ..headerTextAlignment = Alignment.center
          ..textAlignment = Alignment.center,
        GridNumericColumn(mappingName: 'open')
          ..headerText = ' Open'
          ..headerTextAlignment = Alignment.center
          ..textAlignment = Alignment.center,
        GridNumericColumn(mappingName: 'previousClose')
          ..headerText = 'Previous Close'
          ..headerTextAlignment = Alignment.center
          ..textAlignment = Alignment.center,
        GridNumericColumn(mappingName: 'lastTrade')
          ..headerText = 'Last Trade'
          ..headerTextAlignment = Alignment.center
          ..textAlignment = Alignment.center,
      ],
    );
  }

  Widget getWidget(Image image, double stack) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: kIsWeb
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
                const SizedBox(width: 6.0,),
                Expanded(
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
  Widget build(BuildContext context) {
    return Scaffold(body: _dataGridSample());
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

class Stock {
  Stock(this.symbol, this.stock, this.open, this.previousClose, this.lastTrade);
  String symbol;
  double stock;
  double open;
  double previousClose;
  int lastTrade;
}

class RealTimeUpdateDataGridSource extends DataGridSource {
  RealTimeUpdateDataGridSource();
  @override
  List<Object> get dataSource => _stockData;
  @override
  Object getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'symbol':
        return _stockData[rowIndex].symbol;
        break;
      case 'open':
        return _stockData[rowIndex].open;
        break;
      case 'previousClose':
        return _stockData[rowIndex].previousClose;
        break;
      case 'lastTrade':
        return _stockData[rowIndex].lastTrade;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
