/// Packages import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/sample_view.dart';
import '../datagridsource/orderinfo_datagridsource.dart';

/// Renders grouping data grid
class GroupingDataGrid extends SampleView {
  /// Creates grouping data grid
  const GroupingDataGrid({Key? key}) : super(key: key);

  @override
  _GroupingDataGridState createState() => _GroupingDataGridState();
}

class _GroupingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late final OrderInfoDataGridSource groupingDataGridSource;

  late bool _isWebOrDesktop;

  late List<GridColumn> _columns;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _columns = _obtainColumns();
    groupingDataGridSource = OrderInfoDataGridSource(
      isWebOrDesktop: true,
      orderDataCount: 100,
      isGrouping: true,
    );
    groupingDataGridSource.addColumnGroup(
      ColumnGroup(name: 'City', sortGroupRows: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: groupingDataGridSource,
      columns: _columns,
      selectionMode: SelectionMode.multiple,
      navigationMode: GridNavigationMode.cell,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      allowExpandCollapseGroup: true,
      groupCaptionTitleFormat: '{ColumnName} : {Key} - {ItemsCount} Item(s)',
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'ID',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'CustomerId',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: !_isWebOrDesktop
            ? 120
            : (_isWebOrDesktop && model.isMobileResolution)
            ? 150.0
            : 160,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Customer ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Name',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnName: 'Freight',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Freight', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnName: 'City',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Price',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }
}
