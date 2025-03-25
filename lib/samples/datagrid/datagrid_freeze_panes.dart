/// Package imports
import 'package:flutter/material.dart';

/// Barcode import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/product_datagridsource.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class FreezePanesDataGrid extends SampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const FreezePanesDataGrid({Key? key}) : super(key: key);

  @override
  _FreezePanesDataGridPageState createState() =>
      _FreezePanesDataGridPageState();
}

class _FreezePanesDataGridPageState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late ProductDataGridSource _freezePanesDataGridSource;

  late bool _isWebOrDesktop;

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: _isWebOrDesktop ? 140 : 90,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'productId',
        width: _isWebOrDesktop ? 150 : 100,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Product ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: _isWebOrDesktop ? 180 : 140,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Customer Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'product',
        width: _isWebOrDesktop ? 160 : 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Product', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'orderDate',
        width: _isWebOrDesktop ? 140 : 110,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Order Date', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        width: _isWebOrDesktop ? 150 : 90,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Quantity', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: _isWebOrDesktop ? 140 : 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'unitPrice',
        width: _isWebOrDesktop ? 140 : 100,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Unit Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    return columns;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: _freezePanesDataGridSource,
      frozenRowsCount: 1,
      frozenColumnsCount: 1,
      columns: _obtainColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _freezePanesDataGridSource = ProductDataGridSource(
      'FreezePanes',
      productDataCount: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }
}
