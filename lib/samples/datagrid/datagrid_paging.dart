///Package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid Package
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';

/// Render data pager
class PagingDataGrid extends SampleView {
  /// Create data pager
  const PagingDataGrid({Key? key}) : super(key: key);

  @override
  _PagingDataGridState createState() => _PagingDataGridState();
}

class _PagingDataGridState extends SampleViewState {
  // Default pager height
  static const double _dataPagerHeight = 60;

  /// Determine to decide whether the device in landscape or in portrait.
  bool _isLandscapeInMobileView = false;

  late bool _isWebOrDesktop;

  int _rowsPerPage = 15;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _orderInfoDataSource;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _orderInfoDataSource = OrderInfoDataGridSource(
      isWebOrDesktop: true,
      orderDataCount: 300,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !_isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  Widget _buildDataGrid() {
    return SfDataGrid(
      source: _orderInfoDataSource,
      rowsPerPage: _rowsPerPage,
      allowSorting: true,
      columnWidthMode:
          (_isWebOrDesktop && !model.isMobileResolution) ||
              _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      columns: <GridColumn>[
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
          columnWidthMode: (_isWebOrDesktop && model.isMobileResolution)
              ? ColumnWidthMode.none
              : ColumnWidthMode.fitByColumnName,
          autoFitPadding: const EdgeInsets.all(8),
          columnName: 'customerId',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text('Customer ID', overflow: TextOverflow.ellipsis),
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
      ],
    );
  }

  Widget _buildDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(selectedItemColor: model.primaryColor),
      child: SfDataPager(
        delegate: _orderInfoDataSource,
        availableRowsPerPage: const <int>[15, 20, 25],
        pageCount: _orderInfoDataSource.orders.length / _rowsPerPage,
        onRowsPerPageChanged: (int? rowsPerPage) {
          setState(() {
            _rowsPerPage = rowsPerPage!;
          });
        },
      ),
    );
  }

  Widget _buildLayoutBuilder() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: constraint.maxHeight - _dataPagerHeight,
              width: constraint.maxWidth,
              child: _buildDataGrid(),
            ),
            Container(
              height: _dataPagerHeight,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.12),
                border: Border(
                  top: BorderSide(
                    width: .5,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
              ),
              child: Align(child: _buildDataPager()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayoutBuilder();
  }
}
