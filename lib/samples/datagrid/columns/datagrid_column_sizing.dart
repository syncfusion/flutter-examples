/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Barcode imports
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../datagridsource/customer_datagridsource.dart';

/// Renders column sizing data grid
class ColumnSizingDataGrid extends SampleView {
  /// Creates column sizing data grid
  const ColumnSizingDataGrid({Key? key}) : super(key: key);

  @override
  _ColumnSizingDataGridState createState() => _ColumnSizingDataGridState();
}

class _ColumnSizingDataGridState extends SampleViewState {
  /// Required for SfDataGrid to obtain the row data.
  late final CustomerDataGridSource columnSizingDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  String _columnWidthMode = '';

  late ColumnWidthMode columnWidthMode;

  final CustomColumnSizer _columnSizer = CustomColumnSizer();

  /// Column width modes
  final List<String> _encoding = <String>[
    'fill',
    'auto',
    'fitByCellValue',
    'fitByColumnName',
    'lastColumnFill',
    'none'
  ];

  void _onSelectionModeChanged(String item) {
    _columnWidthMode = item;
    switch (_columnWidthMode) {
      case 'none':
        columnWidthMode = ColumnWidthMode.none;
        break;
      case 'auto':
        columnWidthMode = ColumnWidthMode.auto;
        break;
      case 'fill':
        columnWidthMode = ColumnWidthMode.fill;
        break;
      case 'fitByCellValue':
        columnWidthMode = ColumnWidthMode.fitByCellValue;
        break;
      case 'fitByColumnName':
        columnWidthMode = ColumnWidthMode.fitByColumnName;
        break;
      case 'lastColumnFill':
        columnWidthMode = ColumnWidthMode.lastColumnFill;
        break;
    }
    setState(() {
      /// update the column width mode changes
    });
  }

  List<GridColumn> _getColumns() {
    if (isWebOrDesktop) {
      return <GridColumn>[
        GridColumn(
            columnName: 'Dealer',
            autoFitPadding: const EdgeInsets.all(8.0),
            width: 90,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Dealer',
              ),
            )),
        GridColumn(
          columnName: 'ID',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'ID',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Name',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Freight',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Freight',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Shipped Date',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Shipped Date',
            ),
          ),
        ),
        GridColumn(
          columnName: 'City',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'City',
            ),
          ),
        ),
        GridColumn(
            columnName: 'Price',
            autoFitPadding: const EdgeInsets.all(8.0),
            label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Price',
              ),
            ))
      ];
    } else {
      return <GridColumn>[
        GridColumn(
          columnName: 'ID',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'ID',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Name',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Shipped Date',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Shipped Date',
            ),
          ),
        ),
        GridColumn(
          columnName: 'City',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'City',
            ),
          ),
        ),
      ];
    }
  }

  SfDataGrid _buildDataGrid(BuildContext context) {
    return SfDataGrid(
        source: columnSizingDataGridSource,
        columnWidthMode: columnWidthMode,
        columnSizer: _columnSizer,
        columns: _getColumns());
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    columnWidthMode = ColumnWidthMode.fill;
    _columnWidthMode = 'fill';
    columnSizingDataGridSource =
        CustomerDataGridSource(isWebOrDesktop: isWebOrDesktop);
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: SizedBox(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: isWebOrDesktop ? 100 : 150,
                  child: Text(
                    'Column width mode',
                    softWrap: true,
                    style: TextStyle(fontSize: 15.0, color: model.textColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.bottomLeft,
                    child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _columnWidthMode,
                        items: _encoding.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'none',
                              child: Text(value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: model.textColor,
                                    fontSize: 15.0,
                                  )));
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onSelectionModeChanged(value);
                          stateSetter(() {});
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ]);
    });
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

/// custom column sizer class
class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    if (column.columnName == 'Shipped Date') {
      cellValue = DateFormat.yMd().format(cellValue! as DateTime);
    } else if (column.columnName == 'Freight' || column.columnName == 'Price') {
      cellValue =
          NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2)
              .format(cellValue);
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}
