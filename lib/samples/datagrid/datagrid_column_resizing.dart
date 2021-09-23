import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Renders column resizing data grid sample
class ColumnResizingDataGrid extends SampleView {
  /// Creates column resizing data grid sample
  const ColumnResizingDataGrid({Key? key}) : super(key: key);

  @override
  _ColumnResizingDataGridState createState() => _ColumnResizingDataGridState();
}

class _ColumnResizingDataGridState extends SampleViewState {
  late _ColumnResizingDataGridSource columnResizingDataGridSource;
  late List<GridColumn> columns;
  late double orderIdColumnWidth;
  late double customerNameColumnWidth;
  late double productIdColumnWidth;
  late double productColumnWidth;
  late double quantityColumnWidth;
  late double cityColumnWidth;
  late double unitPriceColumnWidth;
  late double orderDateColumnWidth;

  Color _getHeaderCellBackgroundColor() {
    return model.themeData.brightness == Brightness.light
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF3A3A3A);
  }

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
          columnName: 'orderId',
          width: orderIdColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Order ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'productId',
          width: productIdColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Product ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'customerName',
          width: customerNameColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Customer Name',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'product',
          width: productColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Product',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'orderDate',
          width: orderDateColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Order Date',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'quantity',
          width: quantityColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Quantity',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'city',
          width: cityColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'City',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'unitPrice',
          width: unitPriceColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Unit Price',
                overflow: TextOverflow.ellipsis,
              ))),
    ];
    return columns;
  }

  @override
  void initState() {
    super.initState();
    orderIdColumnWidth = model.isWeb ? 150 : 90;
    customerNameColumnWidth = model.isWeb ? 150 : 140;
    productIdColumnWidth = model.isWeb ? 150 : 120;
    productColumnWidth = model.isWeb ? 150 : 90;
    quantityColumnWidth = model.isWeb ? 150 : 90;
    cityColumnWidth = model.isWeb ? 150 : 90;
    unitPriceColumnWidth = model.isWeb ? 150 : 120;
    orderDateColumnWidth = model.isWeb ? 150 : 120;
    columns = _getColumns();
    columnResizingDataGridSource = _ColumnResizingDataGridSource();
  }

  String _columnResizeMode = 'onResize';
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;

  final List<String> _columnResize = <String>[
    'onResize',
    'onResizeEnd',
  ];

  void _onColumnResizeModeChanged(String item) {
    _columnResizeMode = item;
    switch (_columnResizeMode) {
      case 'onResize':
        columnResizeMode = ColumnResizeMode.onResize;
        break;
      case 'onResizeEnd':
        columnResizeMode = ColumnResizeMode.onResizeEnd;
        break;
    }
    setState(() {});
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Column resize \nmode',
                    softWrap: false,
                    style: TextStyle(fontSize: 16.0, color: model.textColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.bottomLeft,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _columnResizeMode,
                        items: _columnResize.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'onResize',
                              child: Text(value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onColumnResizeModeChanged(value);
                          stateSetter(() {});
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: model.themeData.brightness,
          headerColor: _getHeaderCellBackgroundColor(),
          headerHoverColor: _getHeaderCellBackgroundColor(),
          columnResizeIndicatorColor: model.backgroundColor),
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        source: columnResizingDataGridSource,
        columns: _getColumns(),
        allowColumnsResizing: true,
        columnResizeMode: columnResizeMode,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
          setState(() {
            if (args.column.columnName == 'orderId') {
              orderIdColumnWidth = args.width;
            } else if (args.column.columnName == 'productId') {
              productIdColumnWidth = args.width;
            } else if (args.column.columnName == 'customerName') {
              customerNameColumnWidth = args.width;
            } else if (args.column.columnName == 'product') {
              productColumnWidth = args.width;
            } else if (args.column.columnName == 'orderDate') {
              orderDateColumnWidth = args.width;
            } else if (args.column.columnName == 'quantity') {
              quantityColumnWidth = args.width;
            } else if (args.column.columnName == 'city') {
              cityColumnWidth = args.width;
            } else if (args.column.columnName == 'unitPrice') {
              unitPriceColumnWidth = args.width;
            }
          });
          return true;
        },
      ),
    );
  }
}

class _Product {
  _Product(
      this.orderId,
      this.productId,
      this.product,
      this.quantity,
      this.unitPrice,
      this.city,
      this.customerId,
      this.orderDate,
      this.customerName);
  final int orderId;
  final int productId;
  final String product;
  final int quantity;
  final double unitPrice;
  final String city;
  final int customerId;
  final DateTime orderDate;
  final String customerName;
}

class _ColumnResizingDataGridSource extends DataGridSource {
  _ColumnResizingDataGridSource() {
    _productData = _generateProductData(30);
    buildDataGridRows();
  }
  List<_Product> _productData = <_Product>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  void buildDataGridRows() {
    dataGridRows = _productData.map<DataGridRow>((_Product dataGridRow) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'orderId', value: dataGridRow.orderId),
        DataGridCell<int>(
            columnName: 'productId', value: dataGridRow.productId),
        DataGridCell<String>(
            columnName: 'CustomerName', value: dataGridRow.customerName),
        DataGridCell<String>(columnName: 'product', value: dataGridRow.product),
        DataGridCell<DateTime>(
            columnName: 'orderDate', value: dataGridRow.orderDate),
        DataGridCell<int>(columnName: 'quantity', value: dataGridRow.quantity),
        DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
        DataGridCell<double>(
            columnName: 'unitPrice', value: dataGridRow.unitPrice),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            DateFormat('MM/dd/yyyy').format(row.getCells()[4].value).toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            row.getCells()[6].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(row.getCells()[7].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          )),
    ]);
  }

  final Random random = Random();

  List<_Product> productData = <_Product>[];

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

  List<_Product> _generateProductData(int count) {
    final List<_Product> productData = <_Product>[];
    for (int i = 0; i < count; i++) {
      productData.add(
        _Product(
            i + 1000,
            productId[i < productId.length
                ? i
                : random.nextInt(productId.length - 1)],
            product[
                i < product.length ? i : random.nextInt(product.length - 1)],
            random.nextInt(count),
            70.0 + random.nextInt(100),
            cities[i < cities.length ? i : random.nextInt(cities.length - 1)],
            1700 + random.nextInt(100),
            orderDate[random.nextInt(orderDate.length - 1)],
            names[i < names.length ? i : random.nextInt(names.length - 1)]),
      );
    }
    return productData;
  }
}
