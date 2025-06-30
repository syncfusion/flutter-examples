/// Packages import
// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// DataGrid import
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
  late ProductDataGridSource _source;

  ///Decides whether the device in landscape or in portrait.
  bool _isLandscapeInMobileView = false;

  /// sorting options
  final List<String> _menuItems = <String>[
    'Sort Ascending',
    'Sort Descending',
    'Clear Sorting',
  ];

  late bool _isDesktop;

  @override
  void initState() {
    super.initState();
    _isDesktop = model.isDesktop;
    _source = ProductDataGridSource('Context Menu', productDataCount: 20);
  }

  ///create popup menu items
  List<PopupMenuItem<String>> _buildMenuItems(GridColumn column) {
    List<PopupMenuItem<String>> popupmenuItems;
    final SortColumnDetails? sortColumn = _source.sortedColumns
        .firstWhereOrNull(
          (SortColumnDetails sortColumn) =>
              sortColumn.name == column.columnName,
        );

    bool isEnabled(DataGridSortDirection direction) {
      if (sortColumn == null) {
        return true;
      }
      return sortColumn.sortDirection == direction;
    }

    PopupMenuItem<String> buildMenuItem(
      String itemName,
      IconData icon,
      GridColumn column, {
      DataGridSortDirection? sortDirection,
    }) {
      return PopupMenuItem<String>(
        padding: EdgeInsets.zero,
        value: itemName,
        enabled: sortDirection != null
            ? isEnabled(sortDirection)
            : _source.sortedColumns.isNotEmpty,
        child: GestureDetector(
          onTap: () {
            _handleMenuItemTap(itemName, column);
            Navigator.pop(context);
          },
          child: _buildItem(column, itemName, Icon(icon, size: 16)),
        ),
      );
    }

    popupmenuItems = <PopupMenuItem<String>>[
      ///create popup menu item
      buildMenuItem(
        _menuItems[0],
        Icons.arrow_upward,
        column,
        sortDirection: DataGridSortDirection.descending,
      ),
      buildMenuItem(
        _menuItems[1],
        Icons.arrow_downward,
        column,
        sortDirection: DataGridSortDirection.ascending,
      ),
      buildMenuItem(_menuItems[2], Icons.clear, column),
    ];
    return popupmenuItems;
  }

  Widget _buildItem(GridColumn column, String value, Icon icon) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      height: 50,
      color: Colors.transparent,
      width: 150,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 7),
          Center(child: icon),
          const SizedBox(width: 7),
          Center(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  void _handleMenuItemTap(String value, GridColumn gridColumn) {
    switch (value) {
      case 'Sort Ascending':
      case 'Sort Descending':
        if (_source.sortedColumns.isNotEmpty) {
          _source.sortedColumns.clear();
        }
        _source.sortedColumns.add(
          SortColumnDetails(
            name: gridColumn.columnName,
            sortDirection: value == 'Sort Ascending'
                ? DataGridSortDirection.ascending
                : DataGridSortDirection.descending,
          ),
        );
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

  /// build datagrid
  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      key: key,
      source: _source,
      columns: _obtainColumns(),
      columnWidthMode:
          ((_isDesktop || _isLandscapeInMobileView) &&
              !model.isMobileResolution)
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      onCellLongPress: (DataGridCellLongPressDetails details) {
        if (!_isDesktop) {
          ///Get the global position from renderObject while longPress in mobile platform.
          final RenderBox renderObject =
              context.findRenderObject()! as RenderBox;
          showMenu(
            context: context,
            position: RelativeRect.fromRect(
              details.globalPosition & Size.zero,
              Offset.zero & renderObject.size,
            ),
            items: _buildMenuItems(details.column),
          );
        }
      },
      onCellSecondaryTap: (DataGridCellTapDetails details) {
        if (_isDesktop) {
          ///Get the global position from renderObject while secondaryTap in desktop platform
          final RenderBox renderObject =
              context.findRenderObject()! as RenderBox;
          final Offset localPosition = renderObject.globalToLocal(
            details.globalPosition,
          );
          showMenu(
            context: context,
            position: RelativeRect.fromSize(
              localPosition & Size.zero,
              renderObject.size,
            ),
            items: _buildMenuItems(details.column),
          );
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !_isDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }

  ///column's collection
  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: (_isDesktop && model.isMobileResolution) ? 140 : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: const Text('Order ID'),
        ),
      ),
      GridColumn(
        columnName: 'productId',
        width: (_isDesktop && model.isMobileResolution) ? 150 : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Product ID'),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: (_isDesktop && model.isMobileResolution) ? 170 : 140,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('Customer Name'),
        ),
      ),
      GridColumn(
        columnName: 'product',
        width: (_isDesktop && model.isMobileResolution) ? 135 : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('Product'),
        ),
      ),
      GridColumn(
        columnName: 'orderDate',
        width: (_isDesktop && model.isMobileResolution) ? 185 : 140,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Order Date'),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        width: (_isDesktop && model.isMobileResolution) ? 135 : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Quantity'),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: (_isDesktop && model.isMobileResolution) ? 130 : double.nan,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: const Text('City'),
        ),
      ),
      GridColumn(
        columnName: 'unitPrice',
        width: (_isDesktop && model.isMobileResolution) ? 140 : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Unit Price'),
        ),
      ),
    ];
    return columns;
  }
}
