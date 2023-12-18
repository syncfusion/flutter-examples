/// Package import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';

/// Renders datagrid with table summary row feature.
class TableSummaryDataGrid extends SampleView {
  /// Creates datagrid to show table summary rows.
  const TableSummaryDataGrid({Key? key}) : super(key: key);

  @override
  _TableSummaryDataGridState createState() => _TableSummaryDataGridState();
}

class _TableSummaryDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource dataSource;

  late bool isWebOrDesktop;

  bool isLandscapeInMobileView = false;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    dataSource =
        OrderInfoDataGridSource(isWebOrDesktop: true, orderDataCount: 100);
  }

  @override
  void didChangeDependencies() {
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: dataSource,
      columns: getColumns(),
      tableSummaryRows: getTableSummaryRows(),
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.auto,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
    );
  }

  List<GridTableSummaryRow> getTableSummaryRows() {
    final Color color =
        model.themeData.colorScheme.brightness == Brightness.light
            ? const Color(0xFFEBEBEB)
            : const Color(0xFF3B3B3B);
    return <GridTableSummaryRow>[
      GridTableSummaryRow(
          color: color,
          title: 'Total Order Count: {count}',
          columns: <GridSummaryColumn>[
            const GridSummaryColumn(
                name: 'count',
                columnName: 'id',
                summaryType: GridSummaryType.count),
          ],
          position: GridTableSummaryRowPosition.top),
      GridTableSummaryRow(
          color: color,
          showSummaryInRow: false,
          columns: <GridSummaryColumn>[
            const GridSummaryColumn(
                name: 'freight',
                columnName: 'freight',
                summaryType: GridSummaryType.sum),
            const GridSummaryColumn(
                name: 'price',
                columnName: 'price',
                summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom),
    ];
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width: (isWebOrDesktop && model.isMobileResolution) ? 120.0 : 100,
        columnName: 'id',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Order ID',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width: (isWebOrDesktop && model.isMobileResolution) ? 150.0 : 100,
        columnName: 'customerId',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Customer ID',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnName: 'name',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Name',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        width: (isWebOrDesktop && model.isMobileResolution) || !isWebOrDesktop
            ? 140.0
            : double.nan,
        columnName: 'freight',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Freight',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnName: 'city',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'City',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
          width: (isWebOrDesktop && model.isMobileResolution) || !isWebOrDesktop
              ? 120.0
              : double.nan,
          columnName: 'price',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Price',
              overflow: TextOverflow.ellipsis,
            ),
          ))
    ];
  }
}
