/// Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class FreezePanesDataGrid extends SampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const FreezePanesDataGrid({Key? key}) : super(key: key);

  @override
  _FreezePanesDataGridPageState createState() =>
      _FreezePanesDataGridPageState();
}

class _FreezePanesDataGridPageState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  _FreezePanesDataGridSource freezePanesDataGridSource =
      _FreezePanesDataGridSource();

  late bool isWebOrDesktop;

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridTextColumn(
          columnName: 'id',
          width: isWebOrDesktop ? 140 : 90,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'productId',
          width: isWebOrDesktop ? 150 : 100,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Product ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'name',
          width: isWebOrDesktop ? 180 : 140,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Customer Name',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'product',
          width: isWebOrDesktop ? 160 : 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Product',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'orderDate',
          width: isWebOrDesktop ? 140 : 110,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Order Date',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'quantity',
          width: isWebOrDesktop ? 150 : 90,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Quantity',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'city',
          width: isWebOrDesktop ? 140 : 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'City',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
          columnName: 'unitPrice',
          width: isWebOrDesktop ? 140 : 100,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Unit Price',
              overflow: TextOverflow.ellipsis,
            ),
          )),
    ];
    return columns;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: freezePanesDataGridSource,
      frozenRowsCount: 1,
      frozenColumnsCount: 1,
      columns: getColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDataGrid(),
    );
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
}

class _FreezePanesDataGridSource extends DataGridSource {
  _FreezePanesDataGridSource() {
    products = getProducts(20);
    buildDataGridRows();
  }

  final math.Random random = math.Random();

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  List<_Product> products = <_Product>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = products.map<DataGridRow>((_Product product) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: product.id),
        DataGridCell<int>(columnName: 'productId', value: product.productId),
        DataGridCell<String>(columnName: 'name', value: product.name),
        DataGridCell<String>(columnName: 'product', value: product.product),
        DataGridCell<DateTime>(
            columnName: 'orderDate', value: product.orderDate),
        DataGridCell<int>(columnName: 'quantity', value: product.quantity),
        DataGridCell<String>(columnName: 'city', value: product.city),
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
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          DateFormat('MM/dd/yyyy').format(row.getCells()[4].value).toString(),
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
        alignment: Alignment.centerLeft,
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

  // Products data's

  final List<String> _products = <String>[
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

  final List<int> productIds = <int>[
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

  final List<DateTime> orderDates = <DateTime>[
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
            productIds[i],
            _products[i],
            random.nextInt(20),
            70.0 + random.nextInt(100),
            cities[i < cities.length ? i : random.nextInt(cities.length - 1)],
            orderDates[random.nextInt(orderDates.length - 1)],
            names[i]),
      );
    }
    return productData;
  }
}
