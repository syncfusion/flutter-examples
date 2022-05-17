/// Packages import
import 'package:flutter/material.dart';

/// Core import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
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
  late ProductDataGridSource columnResizingDataGridSource;
  late List<GridColumn> columns;
  late double orderIdColumnWidth;
  late double customerNameColumnWidth;
  late double productIdColumnWidth;
  late double productColumnWidth;
  late double quantityColumnWidth;
  late double cityColumnWidth;
  late double unitPriceColumnWidth;
  late double orderDateColumnWidth;

  Color _getHeaderCellBackgroundColor() {
    return model.themeData.colorScheme.brightness == Brightness.light
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF3A3A3A);
  }

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
          columnName: 'orderId',
          width: orderIdColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Order ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'productId',
          width: productIdColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Product ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'customerName',
          width: customerNameColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Customer Name',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'product',
          width: productColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Product',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'orderDate',
          width: orderDateColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Order Date',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'quantity',
          width: quantityColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Quantity',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'city',
          width: cityColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'City',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'unitPrice',
          width: unitPriceColumnWidth,
          minimumWidth: 15.0,
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: const Text(
                'Unit Price',
                overflow: TextOverflow.ellipsis,
              ))),
    ];
    return columns;
  }

  @override
  void initState() {
    super.initState();
    orderIdColumnWidth = model.isWeb ? 150 : 90;
    customerNameColumnWidth = model.isWeb ? 150 : 140;
    productIdColumnWidth = model.isWeb ? 150 : 120;
    productColumnWidth = model.isWeb ? 150 : 90;
    quantityColumnWidth = model.isWeb ? 150 : 90;
    cityColumnWidth = model.isWeb ? 150 : 90;
    unitPriceColumnWidth = model.isWeb ? 150 : 120;
    orderDateColumnWidth = model.isWeb ? 150 : 120;
    columns = _getColumns();
    columnResizingDataGridSource =
        ProductDataGridSource('Column Resizing', productDataCount: 30);
  }

  String _columnResizeMode = 'onResize';
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;

  final List<String> _columnResize = <String>[
    'onResize',
    'onResizeEnd',
  ];

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
      return ListView(shrinkWrap: true, children: <Widget>[
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
                      focusColor: Colors.transparent,
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _columnResizeMode,
                      items: _columnResize.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'onResize',
                            child: Text(value,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        _onColumnResizeModeChanged(value);
                        stateSetter(() {});
                      }),
                ),
              )
            ],
          ),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: model.themeData.colorScheme.brightness,
          headerColor: _getHeaderCellBackgroundColor(),
          headerHoverColor: _getHeaderCellBackgroundColor(),
          columnResizeIndicatorColor: model.backgroundColor),
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        source: columnResizingDataGridSource,
        columns: _getColumns(),
        allowColumnsResizing: true,
        columnResizeMode: columnResizeMode,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
          setState(() {
            if (args.column.columnName == 'orderId') {
              orderIdColumnWidth = args.width;
            } else if (args.column.columnName == 'productId') {
              productIdColumnWidth = args.width;
            } else if (args.column.columnName == 'customerName') {
              customerNameColumnWidth = args.width;
            } else if (args.column.columnName == 'product') {
              productColumnWidth = args.width;
            } else if (args.column.columnName == 'orderDate') {
              orderDateColumnWidth = args.width;
            } else if (args.column.columnName == 'quantity') {
              quantityColumnWidth = args.width;
            } else if (args.column.columnName == 'city') {
              cityColumnWidth = args.width;
            } else if (args.column.columnName == 'unitPrice') {
              unitPriceColumnWidth = args.width;
            }
          });
          return true;
        },
      ),
    );
  }
}
