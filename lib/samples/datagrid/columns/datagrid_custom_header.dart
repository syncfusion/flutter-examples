/// Package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/product_datagridsource.dart';

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
  late ProductDataGridSource _source;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> _columns;

  /// Default sorting operating in drop down widget
  final List<String> _showMenuItems = <String>[
    'Ascending',
    'Descending',
    'Clear Sorting',
  ];

  @override
  void initState() {
    super.initState();
    _columns = _obtainColumns();
    _source = ProductDataGridSource('Custom Header', productDataCount: 20);
  }

  Widget _buildMenuItem(GridColumn column, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _processShowMenuFunctions(value, column);
        });
        Navigator.pop(context);
      },
      child: SizedBox(width: 130, height: 30, child: Text(value)),
    );
  }

  List<PopupMenuItem<String>> _buildMenuItems(GridColumn column) {
    List<PopupMenuItem<String>> menuItems;
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

    menuItems = <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: _showMenuItems[0],
        enabled: isEnabled(DataGridSortDirection.descending),
        child: _buildMenuItem(column, _showMenuItems[0]),
      ),
      PopupMenuItem<String>(
        value: _showMenuItems[1],
        enabled: isEnabled(DataGridSortDirection.ascending),
        child: _buildMenuItem(column, _showMenuItems[1]),
      ),
    ];

    if (sortColumn != null) {
      menuItems.add(
        PopupMenuItem<String>(
          value: _showMenuItems[2],
          enabled: _source.sortedColumns.isNotEmpty,
          child: _buildMenuItem(column, _showMenuItems[2]),
        ),
      );
    }

    return menuItems;
  }

  void _processShowMenuFunctions(String value, GridColumn gridColumn) {
    switch (value) {
      case 'Ascending':
      case 'Descending':
        if (_source.sortedColumns.isNotEmpty) {
          _source.sortedColumns.clear();
        }
        _source.sortedColumns.add(
          SortColumnDetails(
            name: gridColumn.columnName,
            sortDirection: value == 'Ascending'
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

  Widget _buildHeaderCell(Widget headerChild) {
    final bool isMaterial3 = model.themeData.useMaterial3;
    return Row(
      children: <Widget>[
        Flexible(child: headerChild),
        Icon(
          Icons.keyboard_arrow_down,
          size: 25,
          color: isMaterial3
              ? model.themeData.colorScheme.onSurfaceVariant
              : Colors.grey,
        ),
      ],
    );
  }

  void _buildShowMenu(BuildContext context, DataGridCellTapDetails details) {
    const double rowHeight = 56.0;
    final RenderBox renderBox =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final Offset newPosition = renderBox.globalToLocal(details.globalPosition);
    final double dx = newPosition.dx - details.localPosition.dx;
    final double dy = newPosition.dy - details.localPosition.dy + rowHeight;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx + 200, dy + 200),
      items: _buildMenuItems(details.column),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: key,
      source: _source,
      columns: _columns,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      onCellTap: (DataGridCellTapDetails details) {
        if (details.rowColumnIndex.rowIndex == 0) {
          _buildShowMenu(context, details);
        }
      },
    );
  }

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: 140,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Order ID', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'productId',
        width: 150,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Product ID', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: 185,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Customer Name', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'product',
        width: 135,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Product', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'orderDate',
        width: 150,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Order Date', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        width: 135,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Quantity', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: 130,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('City', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'unitPrice',
        width: 140,
        label: _buildHeaderCell(
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Unit Price', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    ];
    return columns;
  }
}
