import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../common_theme_configurations/sf_widget_theme.dart';
import '../helper/responsive_layout.dart';

/// Custom data grid to display tabular data with pagination.
class CustomDataGrid extends StatelessWidget {
  const CustomDataGrid({
    required this.dataSource,
    required this.dataGridController,
    required this.columnHeaders,
    required this.totalRecords,
    super.key,
    this.rowsPerPage,
    this.showCheckboxColumn = true,
    this.rowHeight,
    this.headerRowHeight,
    this.onSelectionChanged,
    this.onPageNavigationEnd,
    this.emptyWidget,
    this.columnWidthMode,
    this.allowExpandCollapseGroup = false,
    this.onSelectionChanging,
    this.gridHeight,
  });

  final DataGridSource dataSource;
  final DataGridController dataGridController;
  final List<String> columnHeaders;
  final int totalRecords;
  final int? rowsPerPage;
  final bool showCheckboxColumn;
  final double? rowHeight;
  final double? headerRowHeight;
  final Widget? emptyWidget;
  final ColumnWidthMode? columnWidthMode;
  final bool allowExpandCollapseGroup;
  final bool Function(List<DataGridRow>, List<DataGridRow>)?
  onSelectionChanging;
  final void Function(List<DataGridRow>, List<DataGridRow>)? onSelectionChanged;
  final void Function(int)? onPageNavigationEnd;
  final double? gridHeight;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final int pageCount = totalRecords > 0
        ? (totalRecords / (rowsPerPage ?? 8)).ceil()
        : 1;

    final Color gridColor = themeData.colorScheme.outlineVariant;

    return SizedBox(
      height: gridHeight ?? 500.0,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: DataGridWidget(
                  dataSource: dataSource,
                  dataGridController: dataGridController,
                  columnHeaders: columnHeaders,
                  totalRecords: totalRecords,
                  gridColor: gridColor,
                  onSelectionChanged: onSelectionChanged,
                ),
              ),
              DataPagerWidget(
                gridColor: gridColor,
                dataSource: dataSource,
                pageCount: pageCount.toDouble(),
                onPageNavigationEnd: onPageNavigationEnd,
              ),
            ],
          ),
          if (totalRecords == 0 && emptyWidget != null)
            Center(child: emptyWidget),
        ],
      ),
    );
  }
}

class DataGridWidget extends StatelessWidget {
  const DataGridWidget({
    required this.dataSource,
    required this.dataGridController,
    required this.columnHeaders,
    required this.totalRecords,
    required this.gridColor,
    super.key,
    this.rowsPerPage,
    this.showCheckboxColumn = true,
    this.rowHeight,
    this.headerRowHeight,
    this.onSelectionChanged,
    this.onPageNavigationEnd,
    this.emptyWidget,
    this.columnWidthMode,
    this.allowExpandCollapseGroup = false,
    this.onSelectionChanging,
    this.gridHeight,
  });

  final DataGridSource dataSource;
  final DataGridController dataGridController;
  final List<String> columnHeaders;
  final int totalRecords;
  final int? rowsPerPage;
  final bool showCheckboxColumn;
  final double? rowHeight;
  final double? headerRowHeight;
  final Widget? emptyWidget;
  final ColumnWidthMode? columnWidthMode;
  final bool allowExpandCollapseGroup;
  final bool Function(List<DataGridRow>, List<DataGridRow>)?
  onSelectionChanging;
  final void Function(List<DataGridRow>, List<DataGridRow>)? onSelectionChanged;
  final void Function(int)? onPageNavigationEnd;
  final double? gridHeight;
  final Color gridColor;

  CheckboxTheme _buildSfDataGrid(BuildContext context, ThemeData themeData) {
    return CheckboxTheme(
      data: CheckboxThemeData(
        side: BorderSide(color: themeData.colorScheme.outline, width: 2.0),
      ),
      child: SfDataGrid(
        shrinkWrapRows: true,
        source: dataSource,
        rowsPerPage: rowsPerPage,
        headerRowHeight: headerRowHeight ?? 45.0,
        controller: dataGridController,
        selectionMode: SelectionMode.multiple,
        columnWidthMode:
            columnWidthMode ??
            (isMobile(context) ? ColumnWidthMode.none : ColumnWidthMode.fill),
        showCheckboxColumn: showCheckboxColumn,
        rowHeight: rowHeight ?? 64.0,
        allowExpandCollapseGroup: allowExpandCollapseGroup,
        onSelectionChanging: onSelectionChanging,
        onSelectionChanged: onSelectionChanged,
        columns: _buildGridColumns(themeData),
      ),
    );
  }

  /// Builds the grid columns.
  List<GridColumn> _buildGridColumns(ThemeData themeData) {
    return List<GridColumn>.generate(columnHeaders.length, (int index) {
      return GridColumn(
        columnName: columnHeaders[index],
        label: Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 30.0)
              : const EdgeInsets.only(left: 12.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              columnHeaders[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: themeData.textTheme.titleMedium!.copyWith(
                color: themeData.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Builds the data grid.
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: gridColor)),
      child: SfDataGridTheme(
        data: dataGridTheme(context),
        child: _buildSfDataGrid(context, themeData),
      ),
    );
  }
}

/// Builds the data pager for pagination.
class DataPagerWidget extends StatelessWidget {
  const DataPagerWidget({
    required this.gridColor,
    required this.dataSource,
    required this.pageCount,
    super.key,
    this.onPageNavigationEnd,
  });

  final Color gridColor;
  final DataPagerDelegate dataSource;
  final double pageCount;
  final void Function(int)? onPageNavigationEnd;

  SfDataPager _buildSfDataPager(BuildContext context) {
    return SfDataPager(
      visibleItemsCount: isMobile(context) ? 3 : 5,
      delegate: dataSource,
      pageCount: pageCount,
      onPageNavigationEnd: onPageNavigationEnd,
      navigationItemHeight: isMobile(context) ? 48.0 : 54.0,
      itemHeight: 46,
      itemWidth: 46,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: gridColor),
          right: BorderSide(color: gridColor),
          bottom: BorderSide(color: gridColor),
        ),
      ),
      child: SfDataPagerTheme(
        data: dataPagerTheme(context),
        child: _buildSfDataPager(context),
      ),
    );
  }
}

/// Custom data grid source to handle data loading and pagination.
class CustomDataGridSource<T> extends DataGridSource {
  CustomDataGridSource({
    required this.context,
    required this.data,
    required this.columns,
    required this.buildCell,
    required this.rowsPerPage,
  }) {
    _paginatedData = data
        .getRange(0, data.length < rowsPerPage ? data.length : rowsPerPage)
        .toList();
    _buildDataGridRows();
  }

  final BuildContext context;
  final List<T> data;
  final List<String> columns;
  final Widget Function(T item, String column, BuildContext context) buildCell;
  final int rowsPerPage;
  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  List<DataGridRow> _dataGridRows = [];
  List<T> _paginatedData = [];

  /// Builds the DataGridRow objects.
  void _buildDataGridRows() {
    _dataGridRows = List<DataGridRow>.generate(_paginatedData.length, (
      int paginatedDataIndex,
    ) {
      return DataGridRow(
        cells: List<DataGridCell>.generate(columns.length, (int index) {
          return DataGridCell(
            columnName: columns[index],
            value: _paginatedData[paginatedDataIndex],
          );
        }),
      );
    });
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final List<DataGridCell> rows = row.getCells();
    return DataGridRowAdapter(
      cells: List<Widget>.generate(rows.length, (int index) {
        return buildCell(
          rows[index].value as T,
          rows[index].columnName,
          context,
        );
      }),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    final int length = data.length;
    if (startIndex < length) {
      if (endIndex > length) {
        endIndex = length;
      }
      _paginatedData = data.getRange(startIndex, endIndex).toList();
      _currentPageIndex = newPageIndex;
      _buildDataGridRows();
      notifyListeners();
    }
    return true;
  }
}
