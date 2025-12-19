///Dart import
import 'dart:math' as math;

/// Package imports
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/stockinfo.dart';

/// Set stock's data collection to data grid source.
class StockInfoDataGridSource extends DataGridSource {
  /// Creates the stock data source class with required details.
  StockInfoDataGridSource({this.isGroupingSample = false}) {
    _stocks = _fetchStocks(100);
    _buildDataGridRows();
  }

  /// Checks whether it's a grouping sample source or not.
  late bool isGroupingSample;

  final math.Random _random = math.Random.secure();

  List<StockInfo> _stocks = <StockInfo>[];

  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Rows are generated once and for CRUD operation we have to refresh
  /// the data row.
  void _buildDataGridRows() {
    _dataGridRows = _stocks
        .map<DataGridRow>(
          (StockInfo dataGridRow) => DataGridRow(
            cells: <DataGridCell<dynamic>>[
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<double>(columnName: 'Qs1', value: dataGridRow.qs1),
              DataGridCell<double>(columnName: 'Qs2', value: dataGridRow.qs2),
              DataGridCell<double>(columnName: 'Qs3', value: dataGridRow.qs3),
              DataGridCell<double>(columnName: 'Qs4', value: dataGridRow.qs4),
              DataGridCell<double>(
                columnName: 'Total Sales',
                value: dataGridRow.totalSales,
              ),
            ],
          ),
        )
        .toList();
  }

  // Building the Widget for each data cells
  Widget _buildQ1(double value) {
    if (value > 2000 && value < 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }

  Widget _buildQ2(double value) {
    if (value > 2000 && value < 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }

  Widget _buildQ3(double value) {
    if (value > 2000 && value < 4000) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 4000) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }

  Widget _buildQ4(double value) {
    if (value > 2000 && value < 3000) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 3000) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: !isGroupingSample
                ? const TextStyle(color: Colors.black)
                : null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }

  Widget _buildTotal(double value) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        child: Text(
          NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
          style: const TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Override method

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Align(child: Text(row.getCells()[0].value.toString())),
        ),
        _buildQ1(row.getCells()[1].value),
        _buildQ2(row.getCells()[2].value),
        _buildQ3(row.getCells()[3].value),
        _buildQ4(row.getCells()[4].value),
        _buildTotal(row.getCells()[5].value),
      ],
    );
  }

  // Generating the stock data collection

  final List<String> _names = <String>[
    'Maciej',
    'Shelley',
    'Linda',
    'Shanon',
    'Jauna',
    'Michael',
    'Terry',
    'Julie',
    'Twanna',
    'Gary',
    'Carol',
    'James',
    'Martha',
  ];

  List<StockInfo> _fetchStocks(int count) {
    final List<StockInfo> stockData = <StockInfo>[];
    for (int i = 1; i < count; i++) {
      stockData.add(
        StockInfo(
          _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
          1800.0 + _random.nextInt(2000),
          1500.0 + _random.nextInt(1000),
          2000.0 + _random.nextInt(3000),
          1400.0 + _random.nextInt(4000),
        ),
      );
    }
    return stockData;
  }

  @override
  Widget? buildGroupCaptionCellWidget(
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text(summaryValue),
    );
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    final String formattedValue = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'Total Sales : $',
    ).format(double.parse(summaryValue));
    return Container(
      padding: const EdgeInsets.fromLTRB(55, 15, 15, 15),
      child: Text(formattedValue),
    );
  }

  @override
  String performGrouping(String columnName, DataGridRow row) {
    if (columnName == 'Total Sales') {
      final double total = row
          .getCells()
          .firstWhereOrNull(
            (DataGridCell cell) => cell.columnName == columnName,
          )!
          .value;
      if (total <= 10000) {
        return '<= 10 K';
      } else if (total > 10000 && total <= 12000) {
        return '> 11 K & <= 12 K';
      } else if (total > 12000 && total <= 13000) {
        return '> 12 K & <= 13 K';
      } else if (total > 13000 && total <= 15000) {
        return '> 13 K & <= 15 K';
      } else {
        return '> 15 K';
      }
    }
    return super.performGrouping(columnName, row);
  }
}
