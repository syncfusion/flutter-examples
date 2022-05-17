/// Package imports
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
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
  late ProductDataGridSource source;

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
    source = ProductDataGridSource('Custom Header', productDataCount: 20);
  }

  Widget buildMenuItem(GridColumn column, String value) {
    return GestureDetector(
        onTap: () {
          setState(() {
            processShowMenuFuctions(value, column);
          });
          Navigator.pop(context);
        },
        child: SizedBox(width: 130, height: 30, child: Text(value)));
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
    return Row(
      children: <Widget>[
        Flexible(child: headerChild),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 25,
          color: Colors.grey,
        )
      ],
    );
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
      GridColumn(
          columnName: 'id',
          width: 140,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'productId',
          width: 150,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Product ID',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'name',
          width: 185,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Customer Name',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'product',
          width: 135,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Product',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'orderDate',
          width: 150,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Order Date',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'quantity',
          width: 135,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Quantity',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'city',
          width: 130,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'City',
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
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
