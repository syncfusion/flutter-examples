/// Package import
import 'package:flutter/material.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import '../datagridsource/orderinfo_datagridsource.dart';

/// Renders Load more data grid
class LoadMoreDataGrid extends SampleView {
  /// Creates Load more data grid
  const LoadMoreDataGrid({Key? key}) : super(key: key);

  @override
  _LoadMoreDataGridState createState() => _LoadMoreDataGridState();
}

class _LoadMoreDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _employeeDataSource;

  late bool _isWebOrDesktop;

  /// Building the progress indicator when DataGrid scroller reach the bottom
  Widget _buildProgressIndicator(bool isLight) {
    return Container(
      height: 60.0,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _loadMoreBackgroundColor(),
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

  Color _loadMoreBackgroundColor() {
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
    final bool isLight =
        model.themeData.colorScheme.brightness == Brightness.light;
    bool showIndicator = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return showIndicator
            ? _buildProgressIndicator(isLight)
            : Container(
                height: 60.0,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _loadMoreBackgroundColor(),
                  border: BorderDirectional(
                    top: BorderSide(color: _topBorderColor()),
                  ),
                ),
                child: Container(
                  width: _isWebOrDesktop ? 350.0 : 142.0,
                  height: 36,
                  decoration: BoxDecoration(
                    color: model.primaryColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      // To avoid the "Error: setState() called after dispose():"
                      // while scrolling the datagrid vertically and displaying the
                      // load more view, current load more view is checked whether
                      // loaded widget is mounted or not.
                      if (context is StatefulElement &&
                          // Need to check whether the widget is available or not
                          // in the current widget tree.
                          context.renderObject != null &&
                          context.state != null &&
                          context.state.mounted) {
                        setState(() {
                          showIndicator = true;
                        });
                      }
                      // Call the loadMoreRows function to call the
                      // DataGridSource.handleLoadMoreRows method. So, additional
                      // rows can be added from handleLoadMoreRows method.
                      await loadMoreRows();
                      // To avoid the "Error: setState() called after dispose():"
                      // while scrolling the datagrid vertically and displaying the
                      // load more view, current load more view is checked whether
                      // loaded widget is mounted or not.
                      if (context is StatefulElement &&
                          // Need to check whether the widget is available or not
                          // in the current widget tree.
                          context.renderObject != null &&
                          context.state != null &&
                          context.state.mounted) {
                        setState(() {
                          showIndicator = false;
                        });
                      }
                    },
                    child: Text(
                      'LOAD MORE',
                      style: TextStyle(
                        letterSpacing: _isWebOrDesktop ? 1.35 : 0.35,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: !_isWebOrDesktop
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
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
            ? 150.0
            : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Customer ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'name',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'freight',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 110.0
            : double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Freight', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'city',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
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
        columnName: 'price',
        width: (_isWebOrDesktop && model.isMobileResolution)
            ? 120.0
            : double.nan,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
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

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _employeeDataSource,
      loadMoreViewBuilder: _buildLoadMoreView,
      columns: _obtainColumns(),
    );
  }
}
