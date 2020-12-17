import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:math';

List<Product> _productData;
Random _random = Random();

class CustomHeaderDataGrid extends SampleView {
  CustomHeaderDataGrid({Key key}) : super(key: key);

  @override
  _CustomHeaderDataGridState createState() => _CustomHeaderDataGridState();
}

class _CustomHeaderDataGridState extends SampleViewState {
  _SortingDataSource _source;
  List<GridColumn> _columns;
  GlobalKey key = GlobalKey();

  List<String> _showMenuItems = ['Ascending', 'Descending', 'Clear Sorting'];

  @override
  void initState() {
    super.initState();
    _productData = generateList(20);
    _source = _SortingDataSource();
    _columns = getColumns();
  }

  Widget buildMenuItem(GridColumn column, String value) {
    return GestureDetector(
        onTap: () {
          setState(() {
            processShowMenuFuctions(value, column);
          });
          Navigator.pop(context);
        },
        child: Container(width: 130, height: 30, child: Text(value)));
  }

  List<PopupMenuItem> buildMenuItems(GridColumn column) {
    List<PopupMenuItem> menuItems;
    final sortColumn = _source.sortedColumns.firstWhere(
        (sortColumn) => sortColumn.name == column.mappingName,
        orElse: () => null);

    menuItems = [
      PopupMenuItem(
        child: buildMenuItem(column, _showMenuItems[0]),
        value: _showMenuItems[0],
        enabled: sortColumn != null
            ? sortColumn.sortDirection == DataGridSortDirection.ascending
                ? false
                : true
            : true,
      ),
      PopupMenuItem(
        child: buildMenuItem(column, _showMenuItems[1]),
        value: _showMenuItems[1],
        enabled: sortColumn != null
            ? sortColumn.sortDirection == DataGridSortDirection.descending
                ? false
                : true
            : true,
      ),
    ];

    if (sortColumn != null) {
      menuItems.add(PopupMenuItem(
        child: buildMenuItem(column, _showMenuItems[2]),
        value: _showMenuItems[2],
        enabled: _source.sortedColumns.isNotEmpty ? true : false,
      ));
    }

    return menuItems;
  }

  void processShowMenuFuctions(String value, GridColumn gridColumn) {
    switch (value) {
      case 'Ascending':
      case 'Descending':
        if (_source.sortedColumns.isNotEmpty) {
          _source.sortedColumns.clear();
        }
        _source.sortedColumns.add(SortColumnDetails(
            name: gridColumn.mappingName,
            sortDirection: value == 'Ascending'
                ? DataGridSortDirection.ascending
                : DataGridSortDirection.descending));
        _source.sort();
        break;
      case 'Clear Sorting':
        if (_source.sortedColumns.isNotEmpty) {
          _source.sortedColumns.clear();
          _source.sort();
        }
        break;
    }
  }

  Widget buildHeaderCell(GridColumn column) {
    final themeData =
        SfDataGridThemeData(brightness: model.themeData.brightness);
    return Container(
        child: Row(
      children: [
        Flexible(
            child: Text(column.headerText,
                style: themeData.headerStyle.textStyle)),
        Icon(
          Icons.keyboard_arrow_down,
          size: 25,
          color: Colors.grey,
        )
      ],
    ));
  }

  buildShowMenu(BuildContext context, DataGridCellTapDetails details) {
    double dx = 0.0, dy = 0.0;
    final rowHeight = 56.0;
    if (kIsWeb) {
      RenderBox getBox = context.findRenderObject();
      final local = getBox.globalToLocal(details.globalPosition);
      dx = local.dx - details.localPosition.dx;
      dy = local.dy - details.localPosition.dy + rowHeight;
    } else {
      dx = details.globalPosition.dx - details.localPosition.dx;
      dy = details.globalPosition.dy - details.localPosition.dy + rowHeight;
    }

    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx + 200, dy + 200),
        items: buildMenuItems(details.column));
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: key,
      source: _source,
      columns: _columns,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      onCellTap: (details) {
        if (details.rowColumnIndex.rowIndex == 0) {
          buildShowMenu(context, details);
        }
      },
      headerCellBuilder: (BuildContext context, GridColumn column) {
        return buildHeaderCell(column);
      },
    );
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridNumericColumn(mappingName: 'id', width: 140, headerText: 'Order ID'),
      GridNumericColumn(
          mappingName: 'productId', width: 150, headerText: 'Product ID'),
      GridTextColumn(
          mappingName: 'name', width: 185, headerText: 'Customer Name'),
      GridTextColumn(mappingName: 'product', width: 135, headerText: 'Product'),
      GridDateTimeColumn(
          mappingName: 'orderDate',
          width: 150,
          dateFormat: DateFormat('MM/dd/yyyy'),
          headerText: 'Order Date'),
      GridNumericColumn(
          mappingName: 'quantity', width: 135, headerText: 'Quantity'),
      GridTextColumn(mappingName: 'city', width: 130, headerText: 'City'),
      GridNumericColumn(
          mappingName: 'unitPrice',
          width: 140,
          numberFormat: NumberFormat.currency(locale: 'en_US', symbol: '\$'),
          headerText: 'Unit Price'),
    ];
    return columns;
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
          _cities[i < _cities.length ? i : _random.nextInt(_cities.length - 1)],
          _orderDate[_random.nextInt(_orderDate.length - 1)],
          _names[i]),
    );
  }

  return productData;
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

class _SortingDataSource extends DataGridSource<Product> {
  _SortingDataSource();
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
