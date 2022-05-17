/// Packages import
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/sample_view.dart';

/// Local import
import 'datagridsource/product_datagridsource.dart';

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
  late ProductDataGridSource source;

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
    source = ProductDataGridSource('Context Menu', productDataCount: 20);
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
        padding: EdgeInsets.zero,
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
                  details.globalPosition & Size.zero,
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
                  localPosition & Size.zero, renderObject.size),
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
