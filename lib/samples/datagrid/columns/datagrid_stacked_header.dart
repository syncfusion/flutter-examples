/// Package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

/// Core import
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/product_datagridsource.dart';

/// Renders stacked header data grid
class StackedHeaderDataGrid extends SampleView {
  /// Creates stacked header data grid
  const StackedHeaderDataGrid({Key? key}) : super(key: key);

  @override
  _StackedHeaderDataGridState createState() => _StackedHeaderDataGridState();
}

class _StackedHeaderDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late final ProductDataGridSource _stackedHeaderDataGridSource;

  late bool _isWebOrDesktop;

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'customerName',
        width: _isWebOrDesktop ? 180 : 140,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Customer Name', overflow: TextOverflow.ellipsis),
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
        columnName: 'orderId',
        width: _isWebOrDesktop ? 140 : 90,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
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
        columnName: 'product',
        width: _isWebOrDesktop ? 160 : 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Product', overflow: TextOverflow.ellipsis),
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
        columnName: 'quantity',
        width: _isWebOrDesktop ? 150 : 90,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Quantity', overflow: TextOverflow.ellipsis),
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

  Color _headerCellBackgroundColor() {
    final bool isMaterial3 = model.themeData.useMaterial3;
    return isMaterial3
        ? model.themeData.colorScheme.surface.withValues(alpha: 0.0001)
        : model.themeData.colorScheme.brightness == Brightness.light
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF3A3A3A);
  }

  Widget _buildStackedHeaderWidget(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(title),
    );
  }

  List<StackedHeaderRow> _buildStackedHeaderRows() {
    List<StackedHeaderRow> stackedHeaderRows;
    stackedHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(
        cells: <StackedHeaderCell>[
          StackedHeaderCell(
            columnNames: <String>['customerName', 'city'],
            child: _buildStackedHeaderWidget('Customer Details'),
          ),
          StackedHeaderCell(
            columnNames: <String>['orderId', 'orderDate'],
            child: _buildStackedHeaderWidget('Order Details'),
          ),
          StackedHeaderCell(
            columnNames: <String>[
              'product',
              'productId',
              'quantity',
              'unitPrice',
            ],
            child: _buildStackedHeaderWidget('Product Details'),
          ),
        ],
      ),
    ];
    return stackedHeaderRows;
  }

  @override
  void initState() {
    super.initState();
    _stackedHeaderDataGridSource = ProductDataGridSource(
      'Stacked Header',
      productDataCount: 30,
    );
    _isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: _headerCellBackgroundColor(),
        headerHoverColor: Colors.transparent,
      ),
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        source: _stackedHeaderDataGridSource,
        columns: _obtainColumns(),
        stackedHeaderRows: _buildStackedHeaderRows(),
      ),
    );
  }
}
