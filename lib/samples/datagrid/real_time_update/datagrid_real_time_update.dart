/// Dart import
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders real time value change data grid
class RealTimeUpdateDataGrid extends SampleView {
  /// Creates real time value change data grid
  const RealTimeUpdateDataGrid({Key? key}) : super(key: key);

  @override
  _RealTimeUpdateDataGridPageState createState() =>
      _RealTimeUpdateDataGridPageState();
}

class _RealTimeUpdateDataGridPageState extends SampleViewState {
  /// Used to refresh the widget for every 200ms respectively.
  late Timer timer;

  /// Decide whether to use the sample in  mobile or web mode.
  bool isLandscapeInMobileView = false;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _RealTimeUpdateDataGridSource realTimeUpdateDataGridSource;

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    realTimeUpdateDataGridSource =
        _RealTimeUpdateDataGridSource(isWebOrDesktop: isWebOrDesktop);
    timer = Timer.periodic(const Duration(milliseconds: 200), (Timer args) {
      realTimeUpdateDataGridSource.timerTick(args);
    });
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: realTimeUpdateDataGridSource,
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      columns: <GridColumn>[
        GridTextColumn(
            columnName: 'symbol',
            width: (isWebOrDesktop && model.isMobileResolution)
                ? 150.0
                : double.nan,
            label: Container(
              alignment: Alignment.center,
              child: const Text('Symbol'),
            )),
        GridTextColumn(
          columnName: 'stock',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.center,
            child: const Text('Stock'),
          ),
        ),
        GridTextColumn(
          columnName: 'open',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.center,
            child: const Text(' Open'),
          ),
        ),
        GridTextColumn(
          width: (isWebOrDesktop && model.isMobileResolution) ? 150.0 : 130.0,
          columnName: 'previousClose',
          label: Container(
            alignment: Alignment.center,
            child: const Text('Previous Close'),
          ),
        ),
        GridTextColumn(
          columnName: 'lastTrade',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.center,
            child: const Text('Last Trade'),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildDataGrid());
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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

class _RealTimeUpdateDataGridSource extends DataGridSource {
  _RealTimeUpdateDataGridSource({required this.isWebOrDesktop}) {
    stocks = getStocks(100);
    buildDataGridRows();
  }

  final math.Random random = math.Random();

  final bool isWebOrDesktop;

  List<_Stock> stocks = <_Stock>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Runtime Updating the cell values

  void timerTick(Timer args) {
    _changeRows(100);
  }

  void _changeRows(int count) {
    if (stocks.length < count) {
      count = stocks.length;
    }

    for (int i = 0; i < count; ++i) {
      final int recNo = random.nextInt(stocks.length - 1);

      // Reinitialize the DataGridRow for particular row and call the notify to
      // view the realtime changes in DataGrid.
      void updateDataRow() {
        dataGridRows[recNo] = DataGridRow(cells: <DataGridCell>[
          DataGridCell<String>(
              columnName: 'symbol', value: stocks[recNo].symbol),
          DataGridCell<double>(columnName: 'stock', value: stocks[recNo].stock),
          DataGridCell<double>(columnName: 'open', value: stocks[recNo].open),
          DataGridCell<double>(
              columnName: 'previousClose', value: stocks[recNo].previousClose),
          DataGridCell<int>(
              columnName: 'lastTrade', value: stocks[recNo].lastTrade),
        ]);
      }

      stocks[recNo].stock = stocksData[(random.nextInt(stocksData.length - 1))];
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 1));
      stocks[recNo].open = 50.0 + random.nextInt(40);
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 2));
      updateDataRow();
      stocks[recNo].previousClose = 50.0 + random.nextInt(30);
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 3));
      stocks[recNo].lastTrade = 50 + random.nextInt(20);
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 4));
    }
  }

  void buildDataGridRows() {
    dataGridRows = stocks.map<DataGridRow>((_Stock stock) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'symbol', value: stock.symbol),
        DataGridCell<double>(columnName: 'stock', value: stock.stock),
        DataGridCell<double>(columnName: 'open', value: stock.open),
        DataGridCell<double>(
            columnName: 'previousClose', value: stock.previousClose),
        DataGridCell<int>(columnName: 'lastTrade', value: stock.lastTrade),
      ]);
    }).toList(growable: false);
  }

  // Building Widget for each cell

  Widget buildStocks(double value) {
    return value >= 0.5
        ? _getWidget(_images[1]!, value)
        : _getWidget(_images[0]!, value);
  }

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

  Widget _getWidget(Image image, double stack) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isWebOrDesktop
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

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        alignment: Alignment.center,
        child: Text(row.getCells()[0].value.toString()),
      ),
      buildStocks(row.getCells()[1].value),
      Container(
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(row.getCells()[4].value.toString()),
      ),
    ]);
  }

  void updateDataSource({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  // Data set for stock data collection

  final List<double> stocksData = <double>[
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

  final List<String> symbols = <String>[
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

  List<_Stock> getStocks(int count) {
    final List<_Stock> stockData = <_Stock>[];
    for (int i = 1; i < symbols.length; i++) {
      stockData.add(_Stock(
          symbols[i],
          stocksData[random.nextInt(stocksData.length - 1)],
          50.0 + random.nextInt(40),
          50.0 + random.nextInt(30),
          50 + random.nextInt(20)));
    }
    return stockData;
  }
}
