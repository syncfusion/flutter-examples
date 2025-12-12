import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/product.dart';

/// Set product's data collection to data grid source.
class ProductDataGridSource extends DataGridSource {
  /// Creates the product data source class with required details.
  ProductDataGridSource(
    String sampleType, {
    required this.productDataCount,
    columns,
  }) {
    _products = _fetchProducts(productDataCount);
    _sampleName = sampleType;
    if (columns != null) {
      _columns = columns;
    }

    _buildDataGridRows(sampleType);
  }

  final Random _random = Random.secure();

  /// Get data count of product.
  final int productDataCount;

  /// Instance of products.
  List<Product> _products = <Product>[];

  /// Instance of DataGridRow.
  List<DataGridRow> _dataGridRows = <DataGridRow>[];
  String _sampleName = '';

  List<GridColumn> _columns = [];

  /// Build DataGridRows
  void _buildDataGridRows(String sampleType) {
    _dataGridRows = _products.map<DataGridRow>((Product product) {
      if (sampleType == 'Stacked Header') {
        return DataGridRow(
          cells: <DataGridCell<dynamic>>[
            DataGridCell<String>(columnName: 'name', value: product.name),
            DataGridCell<String>(columnName: 'city', value: product.city),
            DataGridCell<int>(columnName: 'id', value: product.id),
            DataGridCell<DateTime>(
              columnName: 'orderDate',
              value: product.orderDate,
            ),
            DataGridCell<String>(columnName: 'product', value: product.product),
            DataGridCell<int>(
              columnName: 'productId',
              value: product.productId,
            ),
            DataGridCell<int>(columnName: 'quantity', value: product.quantity),
            DataGridCell<double>(
              columnName: 'unitPrice',
              value: product.unitPrice,
            ),
          ],
        );
      } else {
        return DataGridRow(
          cells: <DataGridCell<dynamic>>[
            DataGridCell<int>(columnName: 'id', value: product.id),
            DataGridCell<int>(
              columnName: 'productId',
              value: product.productId,
            ),
            DataGridCell<String>(columnName: 'name', value: product.name),
            DataGridCell<String>(columnName: 'product', value: product.product),
            DataGridCell<DateTime>(
              columnName: 'orderDate',
              value: product.orderDate,
            ),
            DataGridCell<int>(columnName: 'quantity', value: product.quantity),
            DataGridCell<String>(columnName: 'city', value: product.city),
            DataGridCell<double>(
              columnName: 'unitPrice',
              value: product.unitPrice,
            ),
          ],
        );
      }
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    if (_sampleName == 'Stacked Header') {
      return DataGridRowAdapter(
        cells: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[0].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[1].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[2].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              DateFormat('MM/dd/yyyy').format(row.getCells()[3].value),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[4].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[5].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[6].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              NumberFormat.currency(
                locale: 'en_US',
                symbol: r'$',
              ).format(row.getCells()[7].value),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else if (_sampleName == 'Column Drag and Drop') {
      return DataGridRowAdapter(
        cells: _columns.map<Widget>((e) {
          final DataGridCell cell = row.getCells().firstWhere(
            (cell) => cell.columnName == e.columnName,
          );

          return Container(
            alignment:
                (cell.columnName == 'name' ||
                    cell.columnName == 'product' ||
                    cell.columnName == 'city')
                ? Alignment.centerLeft
                : Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: cell.columnName == 'orderDate'
                ? Text(
                    DateFormat('MM/dd/yyyy').format(cell.value),
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(cell.value.toString()),
          );
        }).toList(),
      );
    } else {
      return DataGridRowAdapter(
        cells: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[0].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[1].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[2].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[3].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              DateFormat('MM/dd/yyyy').format(row.getCells()[4].value),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[5].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              row.getCells()[6].value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: Text(
              NumberFormat.currency(
                locale: 'en_US',
                symbol: r'$',
              ).format(row.getCells()[7].value),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
  }

  final List<String> _product = <String>[
    'Lax',
    'Chocolate',
    'Syrup',
    'Chai',
    'Bags',
    'Meat',
    'Filo',
    'Cashew',
    'Walnuts',
    'Geitost',
    'Cote de',
    'Crab',
    'Chang',
    'Cajun',
    'Gum',
    'Filo',
    'Cashew',
    'Walnuts',
    'Geitost',
    'Bag',
    'Meat',
    'Filo',
    'Cashew',
    'Geitost',
    'Cote de',
    'Crab',
    'Chang',
    'Cajun',
    'Gum',
  ];

  final List<String> _cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende',
  ];

  final List<int> _productId = <int>[
    3524,
    2523,
    1345,
    5243,
    1803,
    4932,
    6532,
    9475,
    2435,
    2123,
    3652,
    4523,
    4263,
    3527,
    3634,
    4932,
    6532,
    9475,
    2435,
    2123,
    6532,
    9475,
    2435,
    2123,
    4523,
    4263,
    3527,
    3634,
    4932,
  ];

  final List<DateTime> _orderDate = <DateTime>[
    DateTime.now(),
    DateTime(2002, 8, 27),
    DateTime(2015, 7, 4),
    DateTime(2007, 4, 15),
    DateTime(2010, 12, 23),
    DateTime(2010, 4, 20),
    DateTime(2004, 6, 13),
    DateTime(2008, 11, 11),
    DateTime(2005, 7, 29),
    DateTime(2009, 4, 5),
    DateTime(2003, 3, 20),
    DateTime(2011, 3, 8),
    DateTime(2013, 10, 22),
  ];

  final List<String> _names = <String>[
    'Kyle',
    'Gina',
    'Irene',
    'Katie',
    'Michael',
    'Oscar',
    'Ralph',
    'Torrey',
    'William',
    'Bill',
    'Daniel',
    'Frank',
    'Brenda',
    'Danielle',
    'Fiona',
    'Howard',
    'Jack',
    'Larry',
    'Holly',
    'Jennifer',
    'Liz',
    'Pete',
    'Steve',
    'Vince',
    'Zeke',
  ];

  /// Get products collection
  List<Product> _fetchProducts(int count) {
    final List<Product> productData = <Product>[];
    for (int i = 0; i < count; i++) {
      productData.add(
        Product(
          i + 1000,
          _productId[i < _productId.length
              ? i
              : _random.nextInt(_productId.length - 1)],
          _product[i < _product.length
              ? i
              : _random.nextInt(_product.length - 1)],
          _random.nextInt(count),
          70.0 + _random.nextInt(100),
          _cities[i < _cities.length ? i : _random.nextInt(_cities.length - 1)],
          // 1700 + random.nextInt(100),
          _orderDate[_random.nextInt(_orderDate.length - 1)],
          _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
        ),
      );
    }
    return productData;
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    if (_sampleName == 'Custom Sorting' && sortColumn.name == 'name') {
      final String? value1 = a
          ?.getCells()
          .firstWhereOrNull(
            (dynamic element) => element.columnName == sortColumn.name,
          )
          ?.value
          ?.toString();
      final String? value2 = b
          ?.getCells()
          .firstWhereOrNull(
            (dynamic element) => element.columnName == sortColumn.name,
          )
          ?.value
          ?.toString();

      final int? aLength = value1?.length;
      final int? bLength = value2?.length;

      if (aLength == null || bLength == null) {
        return 0;
      }

      if (aLength.compareTo(bLength) > 0) {
        return sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 1
            : -1;
      } else if (aLength.compareTo(bLength) == -1) {
        return sortColumn.sortDirection == DataGridSortDirection.ascending
            ? -1
            : 1;
      } else {
        return 0;
      }
    } else {
      return super.compare(a, b, sortColumn);
    }
  }
}
