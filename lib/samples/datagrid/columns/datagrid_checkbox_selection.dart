/// Packages import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/orderinfo_datagridsource.dart';

/// Renders datagrid with Checkbox column option
class CheckboxSelectionDataGrid extends SampleView {
  /// Creates datagrid with Checkbox column option
  const CheckboxSelectionDataGrid({Key? key}) : super(key: key);

  @override
  _CheckboxSelectionDataGridState createState() =>
      _CheckboxSelectionDataGridState();
}

class _CheckboxSelectionDataGridState extends SampleViewState {
  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource checkboxDataGridSource;

  final DataGridController _dataGridController = DataGridController();

  late bool isWebOrDesktop;

  /// DataGridController to do the programmatical selection.
  DataGridController getDataGridController() {
    _dataGridController.selectedRows
        .add(checkboxDataGridSource.dataGridRows[2]);
    _dataGridController.selectedRows
        .add(checkboxDataGridSource.dataGridRows[4]);
    _dataGridController.selectedRows
        .add(checkboxDataGridSource.dataGridRows[6]);
    return _dataGridController;
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;

    columns = isWebOrDesktop
        ? <GridColumn>[
            GridColumn(
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
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
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 150.0
                  : double.nan,
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
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
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
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
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
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
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
                width: (isWebOrDesktop && model.isMobileResolution)
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
          ]
        : <GridColumn>[
            GridColumn(
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
              columnName: 'customerId',
              width: 110,
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
                columnName: 'city',
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'City',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                columnWidthMode: ColumnWidthMode.lastColumnFill),
          ];
    return columns;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      source: checkboxDataGridSource,
      showCheckboxColumn: true,
      selectionMode: SelectionMode.multiple,
      controller: getDataGridController(),
      columns: getColumns(),
    );
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    checkboxDataGridSource = OrderInfoDataGridSource(
        isWebOrDesktop: isWebOrDesktop, orderDataCount: 100);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid();
  }
}
