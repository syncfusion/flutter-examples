/// Package imports
import 'package:flutter/material.dart';

/// Core import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
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
  final ProductDataGridSource stackedHeaderDataGridSource =
      ProductDataGridSource('Stacked Header', productDataCount: 30);

  late bool isWebOrDesktop;

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
          columnName: 'customerName',
          width: isWebOrDesktop ? 180 : 140,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Customer Name',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'city',
          width: isWebOrDesktop ? 140 : 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'City',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'orderId',
          width: isWebOrDesktop ? 140 : 90,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'orderDate',
          width: isWebOrDesktop ? 140 : 110,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Order Date',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'product',
          width: isWebOrDesktop ? 160 : 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Product',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'productId',
          width: isWebOrDesktop ? 150 : 100,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Product ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'quantity',
          width: isWebOrDesktop ? 150 : 90,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Quantity',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'unitPrice',
          width: isWebOrDesktop ? 140 : 100,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Unit Price',
              overflow: TextOverflow.ellipsis,
            ),
          )),
    ];
    return columns;
  }

  Color _getHeaderCellBackgroundColor() {
    return model.themeData.colorScheme.brightness == Brightness.light
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF3A3A3A);
  }

  Widget _getWidgetForStackedHeaderCell(String title) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(title));
  }

  List<StackedHeaderRow> _getStackedHeaderRows() {
    List<StackedHeaderRow> stackedHeaderRows;
    stackedHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: <StackedHeaderCell>[
        StackedHeaderCell(columnNames: <String>[
          'customerName',
          'city',
        ], child: _getWidgetForStackedHeaderCell('Customer Details')),
        StackedHeaderCell(columnNames: <String>[
          'orderId',
          'orderDate',
        ], child: _getWidgetForStackedHeaderCell('Order Details')),
        StackedHeaderCell(columnNames: <String>[
          'product',
          'productId',
          'quantity',
          'unitPrice'
        ], child: _getWidgetForStackedHeaderCell('Product Details'))
      ])
    ];
    return stackedHeaderRows;
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
        data: SfDataGridThemeData(
          brightness: model.themeData.colorScheme.brightness,
          headerColor: _getHeaderCellBackgroundColor(),
          headerHoverColor: Colors.transparent,
        ),
        child: SfDataGrid(
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          source: stackedHeaderDataGridSource,
          columns: _getColumns(),
          stackedHeaderRows: _getStackedHeaderRows(),
        ));
  }
}
