/// Package imports

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/product_datagridsource.dart';

/// Renders column drag and drop data grid sample
class DataGridColumnDragAndDrop extends SampleView {
  /// Creates column drag and drop data grid sample
  const DataGridColumnDragAndDrop({Key? key}) : super(key: key);

  @override
  _DataGridColumnDragAndDropState createState() =>
      _DataGridColumnDragAndDropState();
}

class _DataGridColumnDragAndDropState extends SampleViewState {
  GlobalKey key = GlobalKey();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late ProductDataGridSource _source;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> _columns;

  @override
  void initState() {
    super.initState();
    _columns = _obtainColumns();
    _source = ProductDataGridSource(
      'Column Drag and Drop',
      productDataCount: 20,
      columns: _columns,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: key,
      source: _source,
      columns: _columns,
      allowColumnsDragging: true,
      onColumnDragging: (details) {
        if (details.action == DataGridColumnDragAction.dropped) {
          if (details.to == null) {
            return true;
          }
          final GridColumn rearrangeColumn = _columns[details.from];
          _columns.removeAt(details.from);
          _columns.insert(details.to!, rearrangeColumn);
        }

        _source.updateDataSource();
        return true;
      },
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
    );
  }

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: 160,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'productId',
        width: 170,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: const Text('Product ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: 190,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: const Text('Customer Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'product',
        width: 140,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: const Text('Product', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'orderDate',
        width: 150,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: const Text('Order Date', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        width: 150,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: const Text('Quantity', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: 140,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'unitPrice',
        width: 140,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: const Text('Unit Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    return columns;
  }
}
