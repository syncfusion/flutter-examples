///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/stock.dart';

/// Set stock's data collection to data grid source.
class ConditionalStyleDataGridSource extends DataGridSource {
  /// Creates the stock data source class with required details.
  ConditionalStyleDataGridSource() {
    _stocks = _fetchStocks(100);
    _buildDataGridRows();
  }

  final math.Random _random = math.Random.secure();

  List<Stock> _stocks = <Stock>[];

  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Rows are generated once and for CRUD operation we have to refresh
  /// the data row.
  void _buildDataGridRows() {
    _dataGridRows = _stocks
        .map<DataGridRow>(
          (Stock dataGridRow) => DataGridRow(
            cells: <DataGridCell<dynamic>>[
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<double>(columnName: 'qs1', value: dataGridRow.qs1),
              DataGridCell<double>(columnName: 'qs2', value: dataGridRow.qs2),
              DataGridCell<double>(columnName: 'qs3', value: dataGridRow.qs3),
              DataGridCell<double>(columnName: 'qs4', value: dataGridRow.qs4),
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
        color: const Color(0xFFF4C5B9),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFEB552C),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFEF8465),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
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
        color: const Color(0xFFF5BD16),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFF8DBAE),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFF8DBAE),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
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
        color: const Color(0xFF8A3D94),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 4000) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFC390C1),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFDEB6D5),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
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
        color: const Color(0xFF7BC282),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (value > 3000) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFC1DCA7),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFF4CAC4C),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value),
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(row.getCells()[0].value.toString()),
          ),
        ),
        _buildQ1(row.getCells()[1].value),
        _buildQ2(row.getCells()[2].value),
        _buildQ3(row.getCells()[3].value),
        _buildQ4(row.getCells()[4].value),
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

  List<Stock> _fetchStocks(int count) {
    final List<Stock> stockData = <Stock>[];
    for (int i = 1; i < count; i++) {
      stockData.add(
        Stock(
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
}
