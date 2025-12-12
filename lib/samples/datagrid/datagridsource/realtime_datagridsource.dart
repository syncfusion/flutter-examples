/// Dart import
import 'dart:async';
import 'dart:math' as math;

/// Package import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/realtime.dart';

/// Set stock's real time data collection to data grid source.
class RealTimeUpdateDataGridSource extends DataGridSource {
  /// Creates the stock data source class with required details.
  RealTimeUpdateDataGridSource({required this.isWebOrDesktop}) {
    _stocks = _fetchStocks(100);
    _buildDataGridRows();
  }

  /// Check whether the device is desktop or mobile platform.
  final bool isWebOrDesktop;

  final math.Random _random = math.Random.secure();

  List<Stock> _stocks = <Stock>[];

  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Runtime Updating the cell values
  void timerTick(Timer args) {
    _changeRows(100);
  }

  void _changeRows(int count) {
    if (_stocks.length < count) {
      count = _stocks.length;
    }

    for (int i = 0; i < count; ++i) {
      final int recNo = _random.nextInt(_stocks.length);

      // Reinitialize the DataGridRow for particular row and call the notify to
      // view the realtime changes in DataGrid.
      void updateDataRow() {
        _dataGridRows[recNo] = DataGridRow(
          cells: <DataGridCell>[
            DataGridCell<String>(
              columnName: 'symbol',
              value: _stocks[recNo].symbol,
            ),
            DataGridCell<double>(
              columnName: 'stock',
              value: _stocks[recNo].stock,
            ),
            DataGridCell<double>(
              columnName: 'open',
              value: _stocks[recNo].open,
            ),
            DataGridCell<double>(
              columnName: 'previousClose',
              value: _stocks[recNo].previousClose,
            ),
            DataGridCell<int>(
              columnName: 'lastTrade',
              value: _stocks[recNo].lastTrade,
            ),
          ],
        );
      }

      _stocks[recNo].stock =
          _stocksData[_random.nextInt(_stocksData.length - 1)];
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 1));
      _stocks[recNo].open = 50.0 + _random.nextInt(40);
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 2));
      updateDataRow();
      _stocks[recNo].previousClose = 50.0 + _random.nextInt(30);
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 3));
      _stocks[recNo].lastTrade = 50 + _random.nextInt(20);
      updateDataRow();
      updateDataSource(rowColumnIndex: RowColumnIndex(recNo, 4));
    }
  }

  /// Building datagrid rows
  void _buildDataGridRows() {
    _dataGridRows = _stocks
        .map<DataGridRow>((Stock stock) {
          return DataGridRow(
            cells: <DataGridCell>[
              DataGridCell<String>(columnName: 'symbol', value: stock.symbol),
              DataGridCell<double>(columnName: 'stock', value: stock.stock),
              DataGridCell<double>(columnName: 'open', value: stock.open),
              DataGridCell<double>(
                columnName: 'previousClose',
                value: stock.previousClose,
              ),
              DataGridCell<int>(
                columnName: 'lastTrade',
                value: stock.lastTrade,
              ),
            ],
          );
        })
        .toList(growable: false);
  }

  // Building Widget for each cell

  Widget _buildStocks(double value) {
    return value >= 0.5
        ? _buildWidget(_images[1]!, value)
        : _buildWidget(_images[0]!, value);
  }

  final Map<double, Image> _images = <double, Image>{
    1: Image.asset('images/Uparrow.png', width: 15, height: 15),
    0: Image.asset('images/Downarrow.png', width: 15, height: 15),
  };

  Widget _buildWidget(Image image, double stack) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isWebOrDesktop
            ? <Widget>[
                SizedBox(width: 20, child: image),
                SizedBox(width: 50, child: Text('   ' + stack.toString())),
              ]
            : <Widget>[
                Container(child: image),
                const SizedBox(width: 6.0),
                Flexible(
                  child: Text(
                    stack.toString(),
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ],
      ),
    );
  }

  // Overrides

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(row.getCells()[0].value.toString()),
        ),
        _buildStocks(row.getCells()[1].value),
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
      ],
    );
  }

  /// Update DataGrid source.
  void updateDataSource({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  // Data set for stock data collection

  final List<double> _stocksData = <double>[
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
    -0.94,
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

  List<Stock> _fetchStocks(int count) {
    final List<Stock> stockData = <Stock>[];
    for (int i = 1; i < _symbols.length; i++) {
      stockData.add(
        Stock(
          _symbols[i],
          _stocksData[_random.nextInt(_stocksData.length - 1)],
          50.0 + _random.nextInt(40),
          50.0 + _random.nextInt(30),
          50 + _random.nextInt(20),
        ),
      );
    }
    return stockData;
  }
}
