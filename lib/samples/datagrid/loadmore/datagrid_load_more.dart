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
  late OrderInfoDataGridSource employeeDataSource;

  late bool isWebOrDesktop;

  /// Building the progress indicator when DataGrid scroller reach the bottom
  Widget _buildProgressIndicator(bool isLight) {
    return Container(
        height: 60.0,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF212121),
            border: BorderDirectional(
                top: BorderSide(
                    color: isLight
                        ? const Color.fromRGBO(0, 0, 0, 0.26)
                        : const Color.fromRGBO(255, 255, 255, 0.26)))),
        child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color?>(model.backgroundColor),
              backgroundColor: Colors.transparent,
            )));
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
                  color: isLight
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF212121),
                  border: BorderDirectional(
                      top: BorderSide(
                          color: isLight
                              ? const Color.fromRGBO(0, 0, 0, 0.26)
                              : const Color.fromRGBO(255, 255, 255, 0.26)))),
              child: Container(
                width: isWebOrDesktop ? 350.0 : 142.0,
                height: 36,
                decoration: BoxDecoration(
                    color: model.backgroundColor,
                    borderRadius: BorderRadius.circular(4.0)),
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
                  child: Text('LOAD MORE',
                      style: TextStyle(
                          letterSpacing: isWebOrDesktop ? 1.35 : 0.35,
                          fontSize: 14,
                          color: Colors.white)),
                ),
              ));
    });
  }

  List<GridColumn> _getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'id',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Order ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'customerId',
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          width: !isWebOrDesktop
              ? 120
              : (isWebOrDesktop && model.isMobileResolution)
                  ? 150.0
                  : double.nan,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Customer ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'name',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
          label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Name',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'freight',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 110.0 : double.nan,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Freight',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'city',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'City',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'price',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Price',
                overflow: TextOverflow.ellipsis,
              )))
    ];
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    employeeDataSource =
        OrderInfoDataGridSource(isWebOrDesktop: true, orderDataCount: 25);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
        source: employeeDataSource,
        loadMoreViewBuilder: _buildLoadMoreView,
        columns: _getColumns());
  }
}
