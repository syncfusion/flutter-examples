/// Package imports
import 'dart:ui';

import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';

/// Renders pull refresh data grid
class PullToRefreshDataGrid extends SampleView {
  /// Creates pull refresh data grid
  const PullToRefreshDataGrid({Key? key}) : super(key: key);

  @override
  _PullToRefreshDataGridState createState() => _PullToRefreshDataGridState();
}

class _PullToRefreshDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _employeeDataSource;

  late bool _isWebOrDesktop;

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'customerId',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: !_isWebOrDesktop
            ? 120
            : (_isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Customer ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'freight',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 110.0
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Freight', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'price',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _employeeDataSource = OrderInfoDataGridSource(
      isWebOrDesktop: true,
      orderDataCount: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
      child: SfDataGrid(
        source: _employeeDataSource,
        allowPullToRefresh: true,
        columns: _obtainColumns(),
      ),
    );
  }
}
