import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Renders custom sorting data grid sample
class CustomSortingDataGrid extends SampleView {
  /// Creates custom sorting data grid sample
  const CustomSortingDataGrid({Key? key}) : super(key: key);

  @override
  _CustomSortingDataGridState createState() => _CustomSortingDataGridState();
}

class _CustomSortingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _CustomSortingDataGridSource _customSortingDataGridSource;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> columns;

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    columns = getColumns();
    _customSortingDataGridSource = _CustomSortingDataGridSource();

    /// Programmaticaly sorting based on string length for 'customer name' GirdColumn

    _customSortingDataGridSource.sortedColumns.add(const SortColumnDetails(
        name: 'name', sortDirection: DataGridSortDirection.ascending));
    _customSortingDataGridSource.sort();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _customSortingDataGridSource,
      columns: columns,
      allowSorting: true,
      columnWidthMode: isWebOrDesktop
          ? (isWebOrDesktop && model.isMobileResolution)
              ? ColumnWidthMode.none
              : ColumnWidthMode.fill
          : ColumnWidthMode.none,
    );
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'id',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'productId',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Product ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'name',
          width: isWebOrDesktop ? 170 : 150,
          label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              child: const Text('Customer Name'))),
      GridColumn(
          columnName: 'product',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Product',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'orderDate',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Order Date',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'quantity',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Quantity',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'city',
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'City',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'unitPrice',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Unit Price',
              overflow: TextOverflow.ellipsis,
            ),
          )),
    ];
  }
}

class _Product {
  _Product(this.id, this.productId, this.product, this.quantity, this.unitPrice,
      this.city, this.orderDate, this.name);
  final int id;
  final int productId;
  final String product;
  final int quantity;
  final double unitPrice;
  final String city;
  final DateTime orderDate;
  final String name;

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell<dynamic>>[
      DataGridCell<int>(columnName: 'id', value: id),
      DataGridCell<int>(columnName: 'productId', value: productId),
      DataGridCell<String>(columnName: 'name', value: name),
      DataGridCell<String>(columnName: 'product', value: product),
      DataGridCell<DateTime>(columnName: 'orderDate', value: orderDate),
      DataGridCell<int>(columnName: 'quantity', value: quantity),
      DataGridCell<String>(columnName: 'city', value: city),
      DataGridCell<double>(columnName: 'unitPrice', value: unitPrice),
    ]);
  }
}

class _CustomSortingDataGridSource extends DataGridSource {
  _CustomSortingDataGridSource() {
    products = getProducts(20);
    buildDataGridRows();
  }

  final Random random = Random();

  List<_Product> products = <_Product>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRows() {
    dataGridRows = products
        .map<DataGridRow>(
            (_Product dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
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
          DateFormat('MM/dd/yyyy').format(row.getCells()[4].value).toString(),
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
          NumberFormat.currency(locale: 'en_US', symbol: r'$')
              .format(row.getCells()[7].value)
              .toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    if (sortColumn.name == 'name') {
      final String? value1 = a
          ?.getCells()
          .firstWhereOrNull(
              (dynamic element) => element.columnName == sortColumn.name)
          ?.value
          ?.toString();
      final String? value2 = b
          ?.getCells()
          .firstWhereOrNull(
              (dynamic element) => element.columnName == sortColumn.name)
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
    }
    return super.compare(a, b, sortColumn);
  }

  final List<String> product = <String>[
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

  final List<String> cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende',
  ];

  final List<int> productId = <int>[
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

  final List<DateTime> orderDate = <DateTime>[
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

  List<String> names = <String>[
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
    'Zeke'
  ];

  List<_Product> getProducts(int count) {
    final List<_Product> productData = <_Product>[];
    for (int i = 0; i < count; i++) {
      productData.add(
        _Product(
            i + 1000,
            productId[i],
            product[i],
            random.nextInt(20),
            70.0 + random.nextInt(100),
            cities[i < cities.length ? i : random.nextInt(cities.length - 1)],
            orderDate[random.nextInt(orderDate.length - 1)],
            names[i]),
      );
    }
    return productData;
  }
}
