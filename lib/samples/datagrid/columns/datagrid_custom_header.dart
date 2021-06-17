import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

/// Renders custom header data grid sample
class CustomHeaderDataGrid extends SampleView {
  /// Creates custom header data grid sample
  const CustomHeaderDataGrid({Key? key}) : super(key: key);

  @override
  _CustomHeaderDataGridState createState() => _CustomHeaderDataGridState();
}

class _CustomHeaderDataGridState extends SampleViewState {
  GlobalKey key = GlobalKey();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _SortingDataSource source;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> columns;

  /// Default sorting operating in drop down widget
  List<String> showMenuItems = <String>[
    'Ascending',
    'Descending',
    'Clear Sorting'
  ];

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    columns = getColumns();
    source = _SortingDataSource();
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

  List<PopupMenuItem<String>> buildMenuItems(GridColumn column) {
    List<PopupMenuItem<String>> menuItems;
    final SortColumnDetails? sortColumn = source.sortedColumns.firstWhereOrNull(
        (SortColumnDetails sortColumn) => sortColumn.name == column.columnName);

    bool isEnabled(DataGridSortDirection direction) {
      if (sortColumn == null) {
        return true;
      }
      return sortColumn.sortDirection == direction;
    }

    menuItems = <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: showMenuItems[0],
        enabled: isEnabled(DataGridSortDirection.descending),
        child: buildMenuItem(column, showMenuItems[0]),
      ),
      PopupMenuItem<String>(
        value: showMenuItems[1],
        enabled: isEnabled(DataGridSortDirection.ascending),
        child: buildMenuItem(column, showMenuItems[1]),
      ),
    ];

    if (sortColumn != null) {
      menuItems.add(PopupMenuItem<String>(
        value: showMenuItems[2],
        enabled: source.sortedColumns.isNotEmpty,
        child: buildMenuItem(column, showMenuItems[2]),
      ));
    }

    return menuItems;
  }

  void processShowMenuFuctions(String value, GridColumn gridColumn) {
    switch (value) {
      case 'Ascending':
      case 'Descending':
        if (source.sortedColumns.isNotEmpty) {
          source.sortedColumns.clear();
        }
        source.sortedColumns.add(SortColumnDetails(
            name: gridColumn.columnName,
            sortDirection: value == 'Ascending'
                ? DataGridSortDirection.ascending
                : DataGridSortDirection.descending));
        source.sort();
        break;
      case 'Clear Sorting':
        if (source.sortedColumns.isNotEmpty) {
          source.sortedColumns.clear();
          source.sort();
        }
        break;
    }
  }

  Widget buildHeaderCell(Widget headerChild) {
    return Container(
        child: Row(
      children: <Widget>[
        Flexible(child: headerChild),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 25,
          color: Colors.grey,
        )
      ],
    ));
  }

  void buildShowMenu(BuildContext context, DataGridCellTapDetails details) {
    double dx = 0.0, dy = 0.0;
    const double rowHeight = 56.0;
    if (isWebOrDesktop) {
      final RenderBox getBox = context.findRenderObject()! as RenderBox;
      final Offset local = getBox.globalToLocal(details.globalPosition);
      dx = local.dx - details.localPosition.dx;
      dy = local.dy - details.localPosition.dy + rowHeight;
      // After Flutter v2.0, the 8.0 pixels added extra to the showMenu by default in the web and desktop.
      // Removed the extra pixels to aligned the pop up in the bottom of header cell.
      dy -= 8.0;
    } else {
      dx = details.globalPosition.dx - details.localPosition.dx;
      dy = details.globalPosition.dy - details.localPosition.dy + rowHeight;
      // After Flutter v2.0, the 24.0 pixels added extra to the showMenu by default in the mobile.
      // Removed the extra pixels to aligned the pop up in the bottom of header cell.
      dy -= 24.0;
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
      source: source,
      columns: columns,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      onCellTap: (DataGridCellTapDetails details) {
        if (details.rowColumnIndex.rowIndex == 0) {
          buildShowMenu(context, details);
        }
      },
    );
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridTextColumn(
          columnName: 'id',
          width: 140,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'productId',
          width: 150,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Product ID',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'name',
          width: 185,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Customer Name',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'product',
          width: 135,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Product',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'orderDate',
          width: 150,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Order Date',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'quantity',
          width: 135,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Quantity',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'city',
          width: 130,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'City',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridTextColumn(
          columnName: 'unitPrice',
          width: 140,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Unit Price',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
    ];
    return columns;
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

class _SortingDataSource extends DataGridSource {
  _SortingDataSource() {
    products = getProducts(20);
    buildDataGridRows();
  }

  final Random random = Random();
  List<_Product> products = <_Product>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRows() {
    dataGridRows = products.map<DataGridRow>((_Product product) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
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
    }).toList();
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
