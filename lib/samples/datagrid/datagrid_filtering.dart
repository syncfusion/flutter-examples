/// Package import
import 'package:flutter/cupertino.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import './datagridsource/orderinfo_datagridsource.dart';
import '../../../model/sample_view.dart';

/// Renders filtering data grid
class FilteringDataGrid extends SampleView {
  /// Creates filtering data grid
  const FilteringDataGrid({Key? key}) : super(key: key);

  @override
  _FilteringDataGridState createState() => _FilteringDataGridState();
}

class _FilteringDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final OrderInfoDataGridSource orderInfoDataGridSource =
      OrderInfoDataGridSource(
          isWebOrDesktop: true, orderDataCount: 100, isFilteringSample: true);

  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      allowSorting: true,
      allowFiltering: true,
      source: orderInfoDataGridSource,
      columns: getColumns(),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
    );
  }

  List<GridColumn> getColumns() {
    final bool isMobileView =
        !isWebOrDesktop || (isWebOrDesktop && model.isMobileResolution);
    return <GridColumn>[
      GridColumn(
          columnName: 'Order ID',
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          width: isMobileView ? 120.0 : double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'Customer ID',
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          width: isMobileView ? 150.0 : double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Customer ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
          columnName: 'Name',
          width: isMobileView ? 120.0 : double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridColumn(
        columnName: 'Freight',
        width: isMobileView ? 120.0 : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Freight',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'City',
        width: isMobileView ? 120.0 : double.nan,
        columnWidthMode:
            !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'City',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Price',
        width: isMobileView ? 120.0 : double.nan,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Price',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
    ];
  }
}
