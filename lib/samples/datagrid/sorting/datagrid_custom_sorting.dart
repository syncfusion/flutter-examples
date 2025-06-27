/// Packages import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/product_datagridsource.dart';

/// Renders custom sorting data grid sample
class CustomSortingDataGrid extends SampleView {
  /// Creates custom sorting data grid sample
  const CustomSortingDataGrid({Key? key}) : super(key: key);

  @override
  _CustomSortingDataGridState createState() => _CustomSortingDataGridState();
}

class _CustomSortingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late ProductDataGridSource _customSortingDataGridSource;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> _columns;

  late bool _isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _columns = _obtainColumns();
    _customSortingDataGridSource = ProductDataGridSource(
      'Custom Sorting',
      productDataCount: 20,
    );

    /// Programmaticaly sorting based on string length for 'customer name' GirdColumn

    _customSortingDataGridSource.sortedColumns.add(
      const SortColumnDetails(
        name: 'name',
        sortDirection: DataGridSortDirection.ascending,
      ),
    );
    _customSortingDataGridSource.sort();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _customSortingDataGridSource,
      columns: _columns,
      allowSorting: true,
      columnWidthMode: _isWebOrDesktop
          ? (_isWebOrDesktop && model.isMobileResolution)
                ? ColumnWidthMode.none
                : ColumnWidthMode.fill
          : ColumnWidthMode.none,
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'id',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'productId',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Product ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: _isWebOrDesktop ? 170 : 150,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: const Text('Customer Name'),
        ),
      ),
      GridColumn(
        columnName: 'product',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('Product', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'orderDate',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Order Date', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Quantity', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'unitPrice',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Unit Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }
}
