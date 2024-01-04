/// Packages import
import 'package:flutter/cupertino.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/sample_view.dart';
import '../datagridsource/orderinfo_datagridsource.dart';

/// Renders sorting data grid
class SortingDataGrid extends SampleView {
  /// Creates sorting data grid
  const SortingDataGrid({Key? key}) : super(key: key);

  @override
  _SortingDataGridState createState() => _SortingDataGridState();
}

class _SortingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final OrderInfoDataGridSource sortingDataGridSource =
      OrderInfoDataGridSource(isWebOrDesktop: true, orderDataCount: 100);

  /// Decide to perform sorting in SfDataGrid.
  bool allowSorting = true;

  /// Decide to perform multi column sorting in SfDataGrid.
  bool allowMultiSorting = false;

  /// Decide to perform tri column sorting in SfDataGrid.
  bool allowTriStateSorting = false;

  /// Decide to perform sorting.
  bool allowColumnSorting = true;

  /// Determine the show the sorting number in header.
  bool showSortNumbers = false;

  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    sortingDataGridSource.sortedColumns.add(const SortColumnDetails(
        name: 'id', sortDirection: DataGridSortDirection.descending));
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
      source: sortingDataGridSource,
      columns: getColumns(),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      allowSorting: allowSorting,
      allowMultiColumnSorting: allowMultiSorting,
      allowTriStateSorting: allowTriStateSorting,
      showSortNumbers: showSortNumbers,
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Allow sorting',
                  softWrap: false,
                  style: TextStyle(fontSize: 16, color: model.textColor)),
              Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: model.backgroundColor,
                    value: allowSorting,
                    onChanged: (bool value) {
                      setState(() {
                        allowSorting = value;
                        stateSetter(() {});
                      });
                    },
                  ))
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    model.isWebFullView
                        ? 'Allow multiple \ncolumn sorting'
                        : 'Allow multiple column sorting',
                    softWrap: false,
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: model.backgroundColor,
                      value: allowMultiSorting,
                      onChanged: (bool value) {
                        setState(() {
                          allowMultiSorting = value;
                          stateSetter(() {});
                        });
                      },
                    ))
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    model.isWebFullView
                        ? 'Allow tri-state \nsorting'
                        : 'Allow tri-state sorting',
                    softWrap: false,
                    style: TextStyle(fontSize: 16, color: model.textColor)),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: model.backgroundColor,
                      value: allowTriStateSorting,
                      onChanged: (bool value) {
                        setState(() {
                          allowTriStateSorting = value;
                          stateSetter(() {});
                        });
                      },
                    ))
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    model.isWebFullView
                        ? 'Allow sorting for the \nName column'
                        : 'Allow sorting for the Name column',
                    softWrap: false,
                    style: TextStyle(fontSize: 16, color: model.textColor)),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: model.backgroundColor,
                      value: allowColumnSorting,
                      onChanged: (bool value) {
                        setState(() {
                          allowColumnSorting = value;
                          stateSetter(() {});
                        });
                      },
                    )),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    model.isWebFullView
                        ? 'Display sort \nsequence numbers'
                        : 'Display sort sequence numbers',
                    softWrap: false,
                    style: TextStyle(fontSize: 16, color: model.textColor)),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: model.backgroundColor,
                      value: showSortNumbers,
                      onChanged: (bool value) {
                        setState(() {
                          showSortNumbers = value;
                          stateSetter(() {});
                        });
                      },
                    ))
              ]),
        ],
      );
    });
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'id',
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          width: !isWebOrDesktop
              ? 100
              : (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
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
            ),
          )),
      GridColumn(
          columnName: 'name',
          width: !isWebOrDesktop
              ? 80
              : (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          allowSorting: allowColumnSorting),
      GridColumn(
        columnName: 'freight',
        width: !isWebOrDesktop
            ? 120
            : (isWebOrDesktop && model.isMobileResolution)
                ? 110.0
                : double.nan,
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
        columnName: 'city',
        width: !isWebOrDesktop
            ? 90
            : (isWebOrDesktop && model.isMobileResolution)
                ? 120.0
                : double.nan,
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
          ),
        ),
      )
    ];
  }
}
