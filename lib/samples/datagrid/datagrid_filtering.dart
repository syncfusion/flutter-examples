/// Package import
import 'package:flutter/cupertino.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/sample_view.dart';
import './datagridsource/orderinfo_datagridsource.dart';

/// Renders filtering data grid
class FilteringDataGrid extends SampleView {
  /// Creates filtering data grid
  const FilteringDataGrid({Key? key}) : super(key: key);

  @override
  _FilteringDataGridState createState() => _FilteringDataGridState();
}

class _FilteringDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late final OrderInfoDataGridSource _orderInfoDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait.
  bool _isLandscapeInMobileView = false;

  late bool _isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _orderInfoDataGridSource = OrderInfoDataGridSource(
      isWebOrDesktop: true,
      orderDataCount: 100,
      isFilteringSample: true,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !_isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      allowSorting: true,
      allowFiltering: true,
      source: _orderInfoDataGridSource,
      columns: _obtainColumns(),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: _isWebOrDesktop || _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
    );
  }

  List<GridColumn> _obtainColumns() {
    final bool isMobileView =
        !_isWebOrDesktop || (_isWebOrDesktop && model.isMobileResolution);
    return <GridColumn>[
      GridColumn(
        columnName: 'Order ID',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isMobileView ? 120.0 : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Customer ID',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: isMobileView ? 150.0 : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Customer ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Name',
        width: isMobileView ? 120.0 : double.nan,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Freight',
        width: isMobileView ? 120.0 : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Freight', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'City',
        width: isMobileView ? 120.0 : double.nan,
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
        width: isMobileView ? 120.0 : double.nan,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }
}
