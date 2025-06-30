/// Packages import
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

/// Core import
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/sample_view.dart';

/// Local import
import 'datagridsource/product_datagridsource.dart';

/// Renders column resizing data grid sample
class ColumnResizingDataGrid extends SampleView {
  /// Creates column resizing data grid sample
  const ColumnResizingDataGrid({Key? key}) : super(key: key);

  @override
  _ColumnResizingDataGridState createState() => _ColumnResizingDataGridState();
}

class _ColumnResizingDataGridState extends SampleViewState {
  late ProductDataGridSource _columnResizingDataGridSource;
  late double _orderIdColumnWidth;
  late double _customerNameColumnWidth;
  late double _productIdColumnWidth;
  late double _productColumnWidth;
  late double _quantityColumnWidth;
  late double _cityColumnWidth;
  late double _unitPriceColumnWidth;
  late double _orderDateColumnWidth;

  Color _headerCellBackgroundColor() {
    final bool isMaterial3 = model.themeData.useMaterial3;
    return isMaterial3
        ? model.themeData.colorScheme.surface.withValues(alpha: 0.0001)
        : model.themeData.colorScheme.brightness == Brightness.light
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF3A3A3A);
  }

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'orderId',
        width: _orderIdColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'productId',
        width: _productIdColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: const Text('Product ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'customerName',
        width: _customerNameColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: const Text('Customer Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'product',
        width: _productColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: const Text('Product', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'orderDate',
        width: _orderDateColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: const Text('Order Date', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        width: _quantityColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: const Text('Quantity', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: _cityColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'unitPrice',
        width: _unitPriceColumnWidth,
        minimumWidth: 15.0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: const Text('Unit Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    return columns;
  }

  @override
  void initState() {
    super.initState();
    _orderIdColumnWidth = model.isWeb ? 150 : 90;
    _customerNameColumnWidth = model.isWeb ? 150 : 140;
    _productIdColumnWidth = model.isWeb ? 150 : 120;
    _productColumnWidth = model.isWeb ? 150 : 90;
    _quantityColumnWidth = model.isWeb ? 150 : 90;
    _cityColumnWidth = model.isWeb ? 150 : 90;
    _unitPriceColumnWidth = model.isWeb ? 150 : 120;
    _orderDateColumnWidth = model.isWeb ? 150 : 120;
    _columnResizingDataGridSource = ProductDataGridSource(
      'Column Resizing',
      productDataCount: 30,
    );
  }

  String _columnResizeMode = 'onResize';
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;

  final List<String> _columnResize = <String>['onResize', 'onResizeEnd'];

  void _onColumnResizeModeChanged(String item) {
    _columnResizeMode = item;
    switch (_columnResizeMode) {
      case 'onResize':
        columnResizeMode = ColumnResizeMode.onResize;
        break;
      case 'onResizeEnd':
        columnResizeMode = ColumnResizeMode.onResizeEnd;
        break;
    }
    setState(() {});
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Column resize \nmode',
                      softWrap: false,
                      style: TextStyle(fontSize: 16.0, color: model.textColor),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.bottomLeft,
                      child: DropdownButton<String>(
                        dropdownColor: model.drawerBackgroundColor,
                        focusColor: Colors.transparent,
                        underline: Container(
                          color: const Color(0xFFBDBDBD),
                          height: 1,
                        ),
                        value: _columnResizeMode,
                        items: _columnResize.map((String value) {
                          return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'onResize',
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: model.textColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onColumnResizeModeChanged(value);
                          stateSetter(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: _headerCellBackgroundColor(),
        headerHoverColor: _headerCellBackgroundColor(),
        columnResizeIndicatorColor: model.primaryColor,
      ),
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        source: _columnResizingDataGridSource,
        columns: _obtainColumns(),
        allowColumnsResizing: true,
        columnResizeMode: columnResizeMode,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
          setState(() {
            if (args.column.columnName == 'orderId') {
              _orderIdColumnWidth = args.width;
            } else if (args.column.columnName == 'productId') {
              _productIdColumnWidth = args.width;
            } else if (args.column.columnName == 'customerName') {
              _customerNameColumnWidth = args.width;
            } else if (args.column.columnName == 'product') {
              _productColumnWidth = args.width;
            } else if (args.column.columnName == 'orderDate') {
              _orderDateColumnWidth = args.width;
            } else if (args.column.columnName == 'quantity') {
              _quantityColumnWidth = args.width;
            } else if (args.column.columnName == 'city') {
              _cityColumnWidth = args.width;
            } else if (args.column.columnName == 'unitPrice') {
              _unitPriceColumnWidth = args.width;
            }
          });
          return true;
        },
      ),
    );
  }
}
