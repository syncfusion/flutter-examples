/// Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class FreezePanesDataGrid extends SampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const FreezePanesDataGrid({Key key}) : super(key: key);

  @override
  _FreezePanesDataGridPageState createState() =>
      _FreezePanesDataGridPageState();
}

List<Product> _productData;

class _FreezePanesDataGridPageState extends SampleViewState {
  _FreezePanesDataGridPageState();

  final math.Random _random = math.Random();

  final _FreezePanesDataGridSource _freezePanesDataGridSource =
      _FreezePanesDataGridSource();

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

  List<Product> generateList(int count) {
    final List<Product> productData = <Product>[];
    for (int i = 0; i < count; i++) {
      productData.add(
        Product(
            i + 1000,
            _productId[i],
            _product[i],
            _random.nextInt(20),
            70.0 + _random.nextInt(100),
            _cities[
                i < _cities.length ? i : _random.nextInt(_cities.length - 1)],
            _orderDate[_random.nextInt(_orderDate.length - 1)],
            _names[i]),
      );
    }

    return productData;
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridNumericColumn(mappingName: 'id')
        ..width = model.isWeb ? 140 : 90
        ..headerText = 'ID',
      GridNumericColumn(mappingName: 'productId')
        ..width = model.isWeb ? 150 : 100
        ..headerText = 'Product ID',
      GridTextColumn(mappingName: 'name')
        ..width = model.isWeb ? 180 : 140
        ..headerText = 'Customer Name',
      GridTextColumn(mappingName: 'product')
        ..width = model.isWeb ? 160 : 100
        ..headerText = 'Product',
      GridDateTimeColumn(mappingName: 'orderDate')
        ..width = model.isWeb ? 140 : 110
        ..dateFormat = DateFormat('MM/dd/yyyy')
        ..headerText = 'Order Date',
      GridNumericColumn(mappingName: 'quantity')
        ..width = model.isWeb ? 150 : 90
        ..headerText = 'Quantity',
      GridTextColumn(mappingName: 'city')
        ..width = model.isWeb ? 140 : 100
        ..headerText = 'City',
      GridNumericColumn(mappingName: 'unitPrice')
        ..width = model.isWeb ? 140 : 100
        ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        ..headerText = 'Unit Price',
    ];
    return columns;
  }

  SfDataGrid _dataGridSample() {
    return SfDataGrid(
      source: _freezePanesDataGridSource,
      frozenRowsCount: 1,
      frozenColumnsCount: 1,
      columns: getColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    _productData = generateList(20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dataGridSample(),
    );
  }
}

class Product {
  Product(this.id, this.productId, this.product, this.quantity, this.unitPrice,
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

class _FreezePanesDataGridSource extends DataGridSource<Product> {
  _FreezePanesDataGridSource();
  @override
  List<Product> get dataSource => _productData;
  @override
  Object getValue(Product _product, String columnName) {
    switch (columnName) {
      case 'id':
        return _product.id;
        break;
      case 'product':
        return _product.product;
        break;
      case 'productId':
        return _product.productId;
        break;
      case 'unitPrice':
        return _product.unitPrice;
        break;
      case 'quantity':
        return _product.quantity;
        break;
      case 'city':
        return _product.city;
        break;
      case 'orderDate':
        return _product.orderDate;
        break;
      case 'name':
        return _product.name;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
