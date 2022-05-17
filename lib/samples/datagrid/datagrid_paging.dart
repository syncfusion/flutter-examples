///Package imports
import 'package:flutter/material.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid Package
// ignore: depend_on_referenced_packages
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
  static const double dataPagerHeight = 60;

  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  int _rowsPerPage = 15;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource orderInfoDataSource;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    orderInfoDataSource =
        OrderInfoDataGridSource(isWebOrDesktop: true, orderDataCount: 300);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  Widget _buildDataGrid() {
    return SfDataGrid(
        source: orderInfoDataSource,
        rowsPerPage: _rowsPerPage,
        allowSorting: true,
        columnWidthMode: (isWebOrDesktop && !model.isMobileResolution) ||
                isLandscapeInMobileView
            ? ColumnWidthMode.fill
            : ColumnWidthMode.none,
        columns: <GridColumn>[
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
            columnWidthMode: (isWebOrDesktop && model.isMobileResolution)
                ? ColumnWidthMode.none
                : ColumnWidthMode.fitByColumnName,
            autoFitPadding: const EdgeInsets.all(8),
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
            ),
          )
        ]);
  }

  Widget _buildDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        brightness: model.themeData.colorScheme.brightness,
        selectedItemColor: model.backgroundColor,
      ),
      child: SfDataPager(
        delegate: orderInfoDataSource,
        availableRowsPerPage: const <int>[15, 20, 25],
        pageCount: orderInfoDataSource.orders.length / _rowsPerPage,
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
              height: constraint.maxHeight - dataPagerHeight,
              width: constraint.maxWidth,
              child: _buildDataGrid()),
          Container(
            height: dataPagerHeight,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.12),
                border: Border(
                    top: BorderSide(
                        width: .5,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.12)))),
            child: Align(child: _buildDataPager()),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayoutBuilder();
  }
}
