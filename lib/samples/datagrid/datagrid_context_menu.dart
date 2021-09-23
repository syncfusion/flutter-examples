import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Renders context menu data grid sample
class ContextMenuDataGrid extends SampleView {
  /// Creates context menu  data grid sample
  const ContextMenuDataGrid({Key? key}) : super(key: key);

  @override
  _ContextMenuDataGridState createState() => _ContextMenuDataGridState();
}

class _ContextMenuDataGridState extends SampleViewState {
  GlobalKey key = GlobalKey();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _ContextMenuDataSource source;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> columns;

  ///Decides whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  /// sorting options
  List<String> menuItems = <String>[
    'Sort Ascending',
    'Sort Descending',
    'Clear Sorting'
  ];

  late bool isDesktop;

  @override
  void initState() {
    super.initState();
    isDesktop = model.isDesktop;
    source = _ContextMenuDataSource();
  }

  ///create popup menu items
  List<PopupMenuItem<String>> buildMenuItems(GridColumn column) {
    List<PopupMenuItem<String>> popupmenuItems;
    final SortColumnDetails? sortColumn = source.sortedColumns.firstWhereOrNull(
        (SortColumnDetails sortColumn) => sortColumn.name == column.columnName);

    bool isEnabled(DataGridSortDirection direction) {
      if (sortColumn == null) {
        return true;
      }
      return sortColumn.sortDirection == direction;
    }

    PopupMenuItem<String> buildMenuItem(
        String itemName, IconData icon, GridColumn column,
        {DataGridSortDirection? sortDirection}) {
      return PopupMenuItem<String>(
        padding: const EdgeInsets.all(0),
        value: itemName,
        enabled: sortDirection != null
            ? isEnabled(sortDirection)
            : source.sortedColumns.isNotEmpty,
        child: GestureDetector(
          onTap: () {
            handleMenuItemTap(itemName, column);
            Navigator.pop(context);
          },
          child: buildItem(
              column,
              itemName,
              Icon(
                icon,
                size: 16,
              )),
        ),
      );
    }

    popupmenuItems = <PopupMenuItem<String>>[
      ///create popup menu item
      buildMenuItem(
        menuItems[0],
        Icons.arrow_upward,
        column,
        sortDirection: DataGridSortDirection.descending,
      ),
      buildMenuItem(
        menuItems[1],
        Icons.arrow_downward,
        column,
        sortDirection: DataGridSortDirection.ascending,
      ),
      buildMenuItem(menuItems[2], Icons.clear, column),
    ];
    return popupmenuItems;
  }

  Widget buildItem(GridColumn column, String value, Icon icon) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      height: 50,
      color: Colors.transparent,
      width: 150,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 7,
          ),
          Center(child: icon),
          const SizedBox(
            width: 7,
          ),
          Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void handleMenuItemTap(String value, GridColumn gridColumn) {
    switch (value) {
      case 'Sort Ascending':
      case 'Sort Descending':
        if (source.sortedColumns.isNotEmpty) {
          source.sortedColumns.clear();
        }
        source.sortedColumns.add(SortColumnDetails(
            name: gridColumn.columnName,
            sortDirection: value == 'Sort Ascending'
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

  /// build datagrid
  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      key: key,
      source: source,
      columns: getColumns(),
      columnWidthMode:
          ((isDesktop || isLandscapeInMobileView) && !model.isMobileResolution)
              ? ColumnWidthMode.fill
              : ColumnWidthMode.none,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      onCellLongPress: (DataGridCellLongPressDetails details) {
        if (!isDesktop) {
          ///Get the global position from renderObject while longPress in mobile platform.
          final RenderBox renderObject =
              context.findRenderObject()! as RenderBox;
          showMenu(
              context: context,
              position: RelativeRect.fromRect(
                  details.globalPosition & const Size(0, 0),
                  Offset.zero & renderObject.size),
              items: buildMenuItems(details.column));
        }
      },
      onCellSecondaryTap: (DataGridCellTapDetails details) {
        if (isDesktop) {
          ///Get the global position from renderObject while secondaryTap in desktop platform
          final RenderBox renderObject =
              context.findRenderObject()! as RenderBox;
          final Offset localPosition =
              renderObject.globalToLocal(details.globalPosition);
          showMenu(
              context: context,
              position: RelativeRect.fromSize(
                  localPosition & const Size(0, 0), renderObject.size),
              items: buildMenuItems(details.column));
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }

  ///column's collection
  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
          columnName: 'id',
          width: (isDesktop && model.isMobileResolution) ? 140 : double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Order ID',
            ),
          )),
      GridColumn(
          columnName: 'productId',
          width: (isDesktop && model.isMobileResolution) ? 150 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Product ID',
            ),
          )),
      GridColumn(
          columnName: 'name',
          width: (isDesktop && model.isMobileResolution) ? 170 : 140,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Customer Name',
            ),
          )),
      GridColumn(
          columnName: 'product',
          width: (isDesktop && model.isMobileResolution) ? 135 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Product',
            ),
          )),
      GridColumn(
          columnName: 'orderDate',
          width: (isDesktop && model.isMobileResolution) ? 185 : 140,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Order Date',
              ))),
      GridColumn(
          columnName: 'quantity',
          width: (isDesktop && model.isMobileResolution) ? 135 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Quantity',
            ),
          )),
      GridColumn(
          columnName: 'city',
          width: (isDesktop && model.isMobileResolution) ? 130 : double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'City',
            ),
          )),
      GridColumn(
          columnName: 'unitPrice',
          width: (isDesktop && model.isMobileResolution) ? 140 : double.nan,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Unit Price',
            ),
          )),
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

class _ContextMenuDataSource extends DataGridSource {
  _ContextMenuDataSource() {
    products = getProducts(20);
    buildDataGridRows();
  }

  final Random random = Random();
  List<_Product> products = <_Product>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Build DataGridRow collection
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

  /// override's
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
