import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/sample_view.dart';
import '../datagridsource/orderinfo_datagridsource.dart';

/// Renders column type data grid
class ListDataSourceDataGrid extends SampleView {
  /// Creates column type data grid
  const ListDataSourceDataGrid({Key? key}) : super(key: key);

  @override
  _ListDataSourceDataGridState createState() => _ListDataSourceDataGridState();
}

class _ListDataSourceDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _listDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait
  bool _isLandscapeInMobileView = false;

  late bool _isWebOrDesktop;

  Widget sampleWidget() => const ListDataSourceDataGrid();

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;
    columns = _isWebOrDesktop
        ? <GridColumn>[
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Order ID', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
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
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('Name', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              columnName: 'freight',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Freight', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('City', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'price',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('Price', overflow: TextOverflow.ellipsis),
              ),
            ),
          ]
        : <GridColumn>[
            GridColumn(
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text('ID', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'customerId',
              columnWidthMode: _isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
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
                child: const Text('Name', overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text('City', overflow: TextOverflow.ellipsis),
              ),
              columnWidthMode: ColumnWidthMode.lastColumnFill,
            ),
          ];
    return columns;
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _listDataGridSource = OrderInfoDataGridSource(
      isWebOrDesktop: _isWebOrDesktop,
      orderDataCount: 100,
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
      columnWidthMode: ColumnWidthMode.fill,
      source: _listDataGridSource,
      columns: _obtainColumns(),
    );
  }
}
