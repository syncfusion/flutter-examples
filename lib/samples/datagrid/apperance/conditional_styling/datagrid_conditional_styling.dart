///Dart import
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Render data grid with conditional styling
class ConditionalStylingDataGrid extends SampleView {
  /// Creates data grid with conditional styling
  const ConditionalStylingDataGrid({Key? key}) : super(key: key);

  @override
  _ConditionalStylingDataGridState createState() =>
      _ConditionalStylingDataGridState();
}

class _ConditionalStylingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final _ConditionalStyleDataGridSource conditionalStyleDataGridSource =
      _ConditionalStyleDataGridSource();

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: conditionalStyleDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridTextColumn(
          columnName: 'name',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'qs1',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Center(
              child: Text(
                'Q1',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'qs2',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Center(
              child: Text(
                'Q2',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'qs3',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Center(
              child: Text(
                'Q3',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        GridTextColumn(
          columnName: 'qs4',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Center(
              child: Text(
                'Q4',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildDataGrid());
  }
}

class _Stock {
  _Stock(
    this.name,
    this.qs1,
    this.qs2,
    this.qs3,
    this.qs4,
  );
  final double qs1;
  final double qs2;
  final double qs3;
  final double qs4;
  final String name;
}

class _ConditionalStyleDataGridSource extends DataGridSource {
  _ConditionalStyleDataGridSource() {
    stocks = getStocks(100);
    buildDataGridRows();
  }

  final math.Random random = math.Random();

  List<_Stock> stocks = <_Stock>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Rows are generated once and for CRUD operation we have to refresh
  /// the data row.
  void buildDataGridRows() {
    dataGridRows = stocks
        .map<DataGridRow>(
            (_Stock dataGridRow) => DataGridRow(cells: <DataGridCell<dynamic>>[
                  DataGridCell<String>(
                    columnName: 'name',
                    value: dataGridRow.name,
                  ),
                  DataGridCell<double>(
                    columnName: 'qs1',
                    value: dataGridRow.qs1,
                  ),
                  DataGridCell<double>(
                    columnName: 'qs2',
                    value: dataGridRow.qs2,
                  ),
                  DataGridCell<double>(
                    columnName: 'qs3',
                    value: dataGridRow.qs3,
                  ),
                  DataGridCell<double>(
                    columnName: 'qs4',
                    value: dataGridRow.qs4,
                  ),
                ]))
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
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(value)
                  .toString(),
              style: const TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ));
    } else if (value > 2500) {
      return Container(
          padding: const EdgeInsets.all(4.0),
          color: const Color(0xFFEB552C),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(value)
                  .toString(),
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ));
    } else {
      return Container(
          padding: const EdgeInsets.all(4.0),
          color: const Color(0xFFEF8465),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(value)
                  .toString(),
              style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
              overflow: TextOverflow.ellipsis,
            ),
          ));
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
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(value)
                  .toString(),
              style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
              overflow: TextOverflow.ellipsis,
            ),
          ));
    } else if (value > 2500) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        color: const Color(0xFFF8DBAE),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
            style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
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
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
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
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
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
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
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
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
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
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
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
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(value)
                .toString(),
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
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(value)
                  .toString(),
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ));
    }
  }

  // Override method

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(row.getCells()[0].value.toString())),
      ),
      _buildQ1(row.getCells()[1].value),
      _buildQ2(row.getCells()[2].value),
      _buildQ3(row.getCells()[3].value),
      _buildQ4(row.getCells()[4].value)
    ]);
  }

  // Generating the stock data collection

  final List<String> names = <String>[
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
    'Martha'
  ];

  List<_Stock> getStocks(int count) {
    final List<_Stock> stockData = <_Stock>[];
    for (int i = 1; i < count; i++) {
      stockData.add(_Stock(
        names[i < names.length ? i : random.nextInt(names.length - 1)],
        1800.0 + random.nextInt(2000),
        1500.0 + random.nextInt(1000),
        2000.0 + random.nextInt(3000),
        1400.0 + random.nextInt(4000),
      ));
    }
    return stockData;
  }
}
