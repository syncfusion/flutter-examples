/// Packages import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/sample_view.dart';
import '../datagridsource/stockinfo_datagridsource.dart';

/// Renders custom grouping data grid
class CustomgroupingDataGrid extends SampleView {
  /// Creates custom grouping data grid
  const CustomgroupingDataGrid({Key? key}) : super(key: key);

  @override
  _CustomgroupingDataGridState createState() => _CustomgroupingDataGridState();
}

class _CustomgroupingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late final StockInfoDataGridSource customGroupingDataGridSource;

  late bool _isWebOrDesktop;

  late List<GridColumn> _columns;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _columns = _obtainColumns();
    customGroupingDataGridSource = StockInfoDataGridSource(
      isGroupingSample: true,
    );
    customGroupingDataGridSource.addColumnGroup(
      ColumnGroup(name: 'Total Sales', sortGroupRows: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: customGroupingDataGridSource,
      columns: _columns,
      selectionMode: SelectionMode.multiple,
      navigationMode: GridNavigationMode.cell,
      tableSummaryRows: _loadTableSummaryRows(),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      allowExpandCollapseGroup: true,
      groupCaptionTitleFormat: '{ColumnName} : {Key} - {ItemsCount} Item(s)',
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'Name',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text('Name', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Qs1',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text('Q1', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Qs2',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text('Q2', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Qs3',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text('Q3', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Qs4',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 150 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text('Q4', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Total Sales',
        width: 0,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text('Total Sales', overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    ];
  }

  List<GridTableSummaryRow> _loadTableSummaryRows() {
    return <GridTableSummaryRow>[
      GridTableSummaryRow(
        title: '{Sum}',
        columns: <GridSummaryColumn>[
          const GridSummaryColumn(
            name: 'Sum',
            columnName: 'Total Sales',
            summaryType: GridSummaryType.sum,
          ),
        ],
        position: GridTableSummaryRowPosition.bottom,
      ),
    ];
  }
}
