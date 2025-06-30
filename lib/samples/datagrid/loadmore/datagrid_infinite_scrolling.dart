/// Packages import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/orderinfo_datagridsource.dart';

/// Renders Load More Infinite Scrolling Data Grid
class LoadMoreInfiniteScrollingDataGrid extends SampleView {
  /// Creates Load More Infinite Scrolling Data Grid
  const LoadMoreInfiniteScrollingDataGrid({Key? key}) : super(key: key);

  @override
  _LoadMoreInfiniteScrollingDataGridState createState() =>
      _LoadMoreInfiniteScrollingDataGridState();
}

class _LoadMoreInfiniteScrollingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _employeeDataSource;

  late bool _isWebOrDesktop;

  /// Building the progress indicator when DataGrid scroller reach the bottom
  Widget _buildProgressIndicator() {
    return Container(
      height: 60.0,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _loadingIndicatorBackgroundColor(),
        border: BorderDirectional(top: BorderSide(color: _topBorderColor())),
      ),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(model.primaryColor),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Color _topBorderColor() {
    final bool isMaterial3 = model.themeData.useMaterial3;
    final bool isLight =
        model.themeData.colorScheme.brightness == Brightness.light;
    return isMaterial3
        ? model.themeData.colorScheme.outlineVariant
        : isLight
        ? const Color.fromRGBO(0, 0, 0, 0.26)
        : const Color.fromRGBO(255, 255, 255, 0.26);
  }

  Color _loadingIndicatorBackgroundColor() {
    final bool isMaterial3 = model.themeData.useMaterial3;
    final bool isLight =
        model.themeData.colorScheme.brightness == Brightness.light;
    if (isLight) {
      return isMaterial3 ? const Color(0xFFFFFBFF) : const Color(0xFFFFFFFF);
    } else {
      return isMaterial3 ? const Color(0xFF212121) : const Color(0xFF212121);
    }
  }

  /// Callback method for load more builder
  Widget _buildLoadMoreView(BuildContext context, LoadMoreRows loadMoreRows) {
    Future<String> loadRows() async {
      // Call the loadMoreRows function to call the
      // DataGridSource.handleLoadMoreRows method. So, additional
      // rows can be added from handleLoadMoreRows method.
      await loadMoreRows();
      return Future<String>.value('Completed');
    }

    return FutureBuilder<String>(
      initialData: 'Loading',
      future: loadRows(),
      builder: (BuildContext context, AsyncSnapshot<String> snapShot) {
        return snapShot.data == 'Loading'
            ? _buildProgressIndicator()
            : SizedBox.fromSize(size: Size.zero);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _employeeDataSource,
      loadMoreViewBuilder: _buildLoadMoreView,
      columns: _obtainColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _employeeDataSource = OrderInfoDataGridSource(
      isWebOrDesktop: true,
      orderDataCount: 25,
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 120 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Order ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'customerId',
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        width: !_isWebOrDesktop
            ? 120
            : (_isWebOrDesktop && model.isMobileResolution)
            ? 150
            : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Customer ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 120 : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        width: (_isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
        columnName: 'freight',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Freight', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: (_isWebOrDesktop && model.isMobileResolution) ? 120 : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text('City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        width: (_isWebOrDesktop && model.isMobileResolution) ? 120 : double.nan,
        columnName: 'price',
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }
}
