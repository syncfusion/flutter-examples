/// Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Core import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders stacked header data grid
class StackedHeaderDataGrid extends SampleView {
  /// Creates stacked header data grid
  const StackedHeaderDataGrid({Key? key}) : super(key: key);

  @override
  _StackedHeaderDataGridState createState() => _StackedHeaderDataGridState();
}

class _StackedHeaderDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final _StackedHeaderDataGridSource stackedHeaderDataGridSource =
      _StackedHeaderDataGridSource();

  late bool isWebOrDesktop;

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridTextColumn(
          columnName: 'customerName',
          width: isWebOrDesktop ? 180 : 140,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Customer Name',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'city',
          width: isWebOrDesktop ? 140 : 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'City',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'orderId',
          width: isWebOrDesktop ? 140 : 90,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'orderDate',
          width: isWebOrDesktop ? 140 : 110,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Order Date',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'product',
          width: isWebOrDesktop ? 160 : 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Product',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'productId',
          width: isWebOrDesktop ? 150 : 100,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Product ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'quantity',
          width: isWebOrDesktop ? 150 : 90,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Quantity',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'unitPrice',
          width: isWebOrDesktop ? 140 : 100,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            color: _getHeaderCellBackgroundColor(),
            child: const Text(
              'Unit Price',
              overflow: TextOverflow.ellipsis,
            ),
          )),
    ];
    return columns;
  }

  Color _getHeaderCellBackgroundColor() {
    return model.themeData.brightness == Brightness.light
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF3A3A3A);
  }

  Widget _getWidgetForStackedHeaderCell(String title) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: _getHeaderCellBackgroundColor(),
        alignment: Alignment.centerLeft,
        child: Text(title));
  }

  List<StackedHeaderRow> _getStackedHeaderRows() {
    List<StackedHeaderRow> _stackedHeaderRows;
    _stackedHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: <StackedHeaderCell>[
        StackedHeaderCell(columnNames: <String>[
          'customerName',
          'city',
        ], child: _getWidgetForStackedHeaderCell('Customer Details')),
        StackedHeaderCell(columnNames: <String>[
          'orderId',
          'orderDate',
        ], child: _getWidgetForStackedHeaderCell('Order Details')),
        StackedHeaderCell(columnNames: <String>[
          'product',
          'productId',
          'quantity',
          'unitPrice'
        ], child: _getWidgetForStackedHeaderCell('Product Details'))
      ])
    ];
    return _stackedHeaderRows;
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
        data: SfDataGridThemeData(
          brightness: model.themeData.brightness,
          headerHoverColor: Colors.transparent,
        ),
        child: SfDataGrid(
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          source: stackedHeaderDataGridSource,
          columns: _getColumns(),
          stackedHeaderRows: _getStackedHeaderRows(),
        ));
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

class _StackedHeaderDataGridSource extends DataGridSource {
  _StackedHeaderDataGridSource() {
    products = getProducts(30);
    buildDataGridRow();
  }

  final Random random = Random();

  List<_Product> products = <_Product>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Building the DataGridRows

  void buildDataGridRow() {
    dataGridRows = products.map<DataGridRow>((_Product product) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        DataGridCell<String>(
            columnName: 'customerName', value: product.customerName),
        DataGridCell<String>(columnName: 'city', value: product.city),
        DataGridCell<int>(columnName: 'orderId', value: product.orderId),
        DataGridCell<DateTime>(
            columnName: 'orderDate', value: product.orderDate),
        DataGridCell<String>(columnName: 'product', value: product.product),
        DataGridCell<int>(columnName: 'productId', value: product.productId),
        DataGridCell<int>(columnName: 'quantity', value: product.quantity),
        DataGridCell<double>(columnName: 'unitPrice', value: product.unitPrice),
      ]);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          DateFormat('MM/dd/yyyy').format(row.getCells()[3].value).toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[6].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          NumberFormat.currency(locale: 'en_US', symbol: r'$')
              .format(row.getCells()[7].value)
              .toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  // Products data set collections

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
