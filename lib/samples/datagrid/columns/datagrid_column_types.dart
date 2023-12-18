/// Package imports
import 'package:flutter/material.dart';

/// Barcode imports
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../datagridsource/customer_datagridsource.dart';

/// Renders column type data grid
class ColumnTypeDataGrid extends SampleView {
  /// Creates column type data grid
  const ColumnTypeDataGrid({Key? key}) : super(key: key);

  @override
  _ColumnTypesDataGridState createState() => _ColumnTypesDataGridState();
}

class _ColumnTypesDataGridState extends SampleViewState {
  /// Required for SfDataGrid to obtain the row data.
  late final CustomerDataGridSource columnTypesDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait
  late bool isLandscapeInMobileView;

  late bool isWebOrDesktop;

  SfDataGrid _buildDataGrid(BuildContext context) {
    return SfDataGrid(
        source: columnTypesDataGridSource,
        columnWidthMode: isWebOrDesktop
            ? (isWebOrDesktop && model.isMobileResolution)
                ? ColumnWidthMode.none
                : ColumnWidthMode.fill
            : ColumnWidthMode.none,
        columns: <GridColumn>[
          GridColumn(
              columnName: 'dealer',
              width: 90,
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Dealer',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridColumn(
              columnName: 'id',
              width: !isWebOrDesktop
                  ? 50
                  : (isWebOrDesktop && model.isMobileResolution)
                      ? 110
                      : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none),
          GridColumn(
            columnName: 'name',
            width:
                (isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Name',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'freight',
            width:
                (isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
            columnWidthMode: isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none,
            label: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Freight',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'shippedDate',
            width: 110,
            label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Shipped Date',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //dateFormat: DateFormat.yMd()
          ),
          GridColumn(
            columnName: 'city',
            width: isWebOrDesktop ? 110.0 : double.nan,
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
              columnName: 'price',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnWidthMode: ColumnWidthMode.lastColumnFill,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Price',
                  overflow: TextOverflow.ellipsis,
                ),
              ))
        ]);
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    columnTypesDataGridSource = CustomerDataGridSource(isWebOrDesktop: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataGrid(context);
  }
}
