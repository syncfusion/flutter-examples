/// Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Core import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../model/sample_view.dart';

class StackedHeaderDataGrid extends SampleView {
  StackedHeaderDataGrid({Key key}) : super(key: key);

  @override
  _StackedHeaderDataGridState createState() => _StackedHeaderDataGridState();
}

List<Product> _productData;

class _StackedHeaderDataGridState extends SampleViewState {
  final _StackedHeaderDataGridSource _stackedHeaderDataGridSource =
      _StackedHeaderDataGridSource();
  final Random _random = Random();

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

  List<String> _names = [
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

  List<Product> _generateProductData(int count) {
    final List<Product> productData = <Product>[];
    for (int i = 0; i < count; i++) {
      productData.add(
        Product(
            i + 1000,
            _productId[i < _productId.length
                ? i
                : _random.nextInt(_productId.length - 1)],
            _product[
                i < _product.length ? i : _random.nextInt(_product.length - 1)],
            _random.nextInt(count),
            70.0 + _random.nextInt(100),
            _cities[
                i < _cities.length ? i : _random.nextInt(_cities.length - 1)],
            1700 + _random.nextInt(100),
            _orderDate[_random.nextInt(_orderDate.length - 1)],
            _names[i < _names.length ? i : _random.nextInt(_names.length - 1)]),
      );
    }

    return productData;
  }

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridTextColumn(
          mappingName: 'customerName',
          width: model.isWeb ? 180 : 140,
          headerText: 'Customer Name'),
      GridTextColumn(
          mappingName: 'city',
          width: model.isWeb ? 140 : 100,
          headerText: 'City'),
      GridNumericColumn(
          mappingName: 'orderId',
          width: model.isWeb ? 140 : 90,
          headerText: 'Order ID'),
      GridDateTimeColumn(
          mappingName: 'orderDate',
          width: model.isWeb ? 140 : 110,
          dateFormat: DateFormat('MM/dd/yyyy'),
          headerText: 'Order Date'),
      GridTextColumn(
          mappingName: 'product',
          width: model.isWeb ? 160 : 100,
          headerText: 'Product'),
      GridNumericColumn(
          mappingName: 'productId',
          width: model.isWeb ? 150 : 100,
          headerText: 'Product ID'),
      GridNumericColumn(
          mappingName: 'quantity',
          width: model.isWeb ? 150 : 90,
          headerText: 'Quantity'),
      GridNumericColumn(
          mappingName: 'unitPrice',
          width: model.isWeb ? 140 : 100,
          numberFormat: NumberFormat.currency(locale: 'en_US', symbol: '\$'),
          headerText: 'Unit Price'),
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
        padding: EdgeInsets.all(16.0),
        color: _getHeaderCellBackgroundColor(),
        alignment: Alignment.centerLeft,
        child: Text(title));
  }

  List<StackedHeaderRow> _getStackedHeaderRows() {
    List<StackedHeaderRow> _stackedHeaderRows;
    _stackedHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: [
        StackedHeaderCell(columnNames: [
          'customerName',
          'city',
        ], child: _getWidgetForStackedHeaderCell('Customer Details')),
        StackedHeaderCell(columnNames: [
          'orderId',
          'orderDate',
        ], child: _getWidgetForStackedHeaderCell('Order Details')),
        StackedHeaderCell(
            columnNames: ['product', 'productId', 'quantity', 'unitPrice'],
            child: _getWidgetForStackedHeaderCell('Product Details'))
      ])
    ];
    return _stackedHeaderRows;
  }

  @override
  void initState() {
    super.initState();
    _productData = _generateProductData(30);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
        data: SfDataGridThemeData(
            brightness: model.themeData.brightness,
            headerStyle: DataGridHeaderCellStyle(
                hoverColor: Colors.transparent,
                hoverTextStyle:
                    SfTheme.of(context).dataGridThemeData.headerStyle.textStyle,
                backgroundColor: _getHeaderCellBackgroundColor())),
        child: SfDataGrid(
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          source: _stackedHeaderDataGridSource,
          columns: _getColumns(),
          stackedHeaderRows: _getStackedHeaderRows(),
        ));
  }
}

class Product {
  Product(
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

class _StackedHeaderDataGridSource extends DataGridSource<Product> {
  _StackedHeaderDataGridSource();
  @override
  List<Product> get dataSource => _productData;
  @override
  Object getValue(Product product, String columnName) {
    switch (columnName) {
      case 'orderId':
        return product.orderId;
        break;
      case 'product':
        return product.product;
        break;
      case 'productId':
        return product.productId;
        break;
      case 'unitPrice':
        return product.unitPrice;
        break;
      case 'quantity':
        return product.quantity;
        break;
      case 'city':
        return product.city;
        break;
      case 'customerId':
        return product.customerId;
        break;
      case 'orderDate':
        return product.orderDate;
        break;
      case 'customerName':
        return product.customerName;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
