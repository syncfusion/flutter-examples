/// Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class SelectionDataGrid extends SampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const SelectionDataGrid({Key? key}) : super(key: key);

  @override
  _SelectionDataGridPageState createState() => _SelectionDataGridPageState();
}

class _SelectionDataGridPageState extends SampleViewState {
  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  /// Determine the selection mode of SfDatGrid.
  SelectionMode selectionMode = SelectionMode.multiple;
  String _selectionMode = '';

  /// Determine the navigation mode of SfDatGrid.
  GridNavigationMode navigationMode = GridNavigationMode.cell;
  String _navigationMode = '';

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _SelectionDataGridSource selectionDataGridSource;

  final DataGridController _dataGridController = DataGridController();

  late bool isWebOrDesktop;

  /// Selection modes for drop down widget
  final List<String> _encoding = <String>[
    'None',
    'Single',
    'Single Deselect',
    'Multiple',
  ];

  /// Navigation modes for drop down widget
  final List<String> _navigation = <String>[
    'Cell',
    'Row',
  ];

  /// DataGridController to do the programmatical selection.
  DataGridController getDataGridController() {
    _dataGridController.selectedRows
        .add(selectionDataGridSource.dataGridRows[2]);
    _dataGridController.selectedRows
        .add(selectionDataGridSource.dataGridRows[4]);
    _dataGridController.selectedRows
        .add(selectionDataGridSource.dataGridRows[6]);
    return _dataGridController;
  }

  void _onSelectionModeChanged(String item) {
    _selectionMode = item;
    switch (_selectionMode) {
      case 'None':
        selectionMode = SelectionMode.none;
        break;
      case 'Single':
        selectionMode = SelectionMode.single;
        break;
      case 'Single Deselect':
        selectionMode = SelectionMode.singleDeselect;
        break;
      case 'Multiple':
        selectionMode = SelectionMode.multiple;
        break;
    }
    setState(() {
      /// update the selection mode changes
    });
  }

  void _onNavigationModeChanged(String item) {
    _navigationMode = item;
    switch (_navigationMode) {
      case 'Cell':
        navigationMode = GridNavigationMode.cell;
        break;
      case 'Row':
        navigationMode = GridNavigationMode.row;
        break;
    }
    setState(() {
      /// update the grid navigation changes
    });
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;

    columns = isWebOrDesktop
        ? <GridColumn>[
            GridTextColumn(
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
            GridTextColumn(
              width: (isWebOrDesktop && model.isMobileResolution)
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
            GridTextColumn(
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
                ))
          ]
        : <GridColumn>[
            GridTextColumn(
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
            GridTextColumn(
              columnName: 'customerId',
              width: 110,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Customer ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
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
            GridTextColumn(
                columnName: 'city',
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'City',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                columnWidthMode: ColumnWidthMode.lastColumnFill),
          ];
    return columns;
  }

  SfDataGrid _buildDataGrid(
      SelectionMode selectionMode, GridNavigationMode navigationMode) {
    return SfDataGrid(
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      source: selectionDataGridSource,
      selectionMode: selectionMode,
      navigationMode: navigationMode,
      controller: getDataGridController(),
      columns: getColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    _selectionMode = 'Multiple';
    selectionMode = SelectionMode.multiple;
    _navigationMode = isWebOrDesktop ? 'Cell' : 'Row';
    navigationMode =
        isWebOrDesktop ? GridNavigationMode.cell : GridNavigationMode.row;
    selectionDataGridSource =
        _SelectionDataGridSource(isWebOrDesktop: isWebOrDesktop);
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Selection mode:',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: model.textColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    height: 40,
                    alignment: Alignment.bottomLeft,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _selectionMode,
                        items: _encoding.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'Multiple',
                              child: Text(value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: model.textColor)));
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
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Navigation mode:',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: model.textColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    height: 40,
                    alignment: Alignment.bottomLeft,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _navigationMode,
                        items: _navigation.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: model.textColor)));
                        }).toList(),
                        onChanged: (dynamic value) {
                          _onNavigationModeChanged(value);
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
    return _buildDataGrid(selectionMode, navigationMode);
  }
}

class _Employee {
  _Employee(
      this.id, this.customerId, this.name, this.freight, this.city, this.price);
  final int id;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class _SelectionDataGridSource extends DataGridSource {
  _SelectionDataGridSource({required this.isWebOrDesktop}) {
    employees = getEmployees(100);
    buildDataGridRows();
  }

  final bool isWebOrDesktop;
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<_Employee> employees = <_Employee>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = isWebOrDesktop
        ? employees.map<DataGridRow>((_Employee employee) {
            return DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: employee.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: employee.customerId),
              DataGridCell<String>(columnName: 'name', value: employee.name),
              DataGridCell<double>(
                  columnName: 'freight', value: employee.freight),
              DataGridCell<String>(columnName: 'city', value: employee.city),
              DataGridCell<double>(columnName: 'price', value: employee.price),
            ]);
          }).toList(growable: false)
        : employees.map<DataGridRow>((_Employee employee) {
            return DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: employee.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: employee.customerId),
              DataGridCell<String>(columnName: 'name', value: employee.name),
              DataGridCell<String>(columnName: 'city', value: employee.city),
            ]);
          }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    if (isWebOrDesktop) {
      return DataGridRowAdapter(cells: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              row.getCells()[1].value.toString(),
              overflow: TextOverflow.ellipsis,
            )),
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              row.getCells()[2].value.toString(),
              overflow: TextOverflow.ellipsis,
            )),
        Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(row.getCells()[3].value)
                  .toString(),
              overflow: TextOverflow.ellipsis,
            )),
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              row.getCells()[4].value.toString(),
              overflow: TextOverflow.ellipsis,
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(row.getCells()[5].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]);
    } else {
      Widget buildWidget({
        AlignmentGeometry alignment = Alignment.centerLeft,
        EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
        TextOverflow textOverflow = TextOverflow.ellipsis,
        required Object value,
      }) {
        return Container(
          padding: padding,
          alignment: alignment,
          child: Text(
            value.toString(),
            overflow: textOverflow,
          ),
        );
      }

      return DataGridRowAdapter(
          cells: row.getCells().map<Widget>((DataGridCell dataCell) {
        if (dataCell.columnName == 'id' ||
            dataCell.columnName == 'customerId') {
          return buildWidget(
              alignment: Alignment.centerRight, value: dataCell.value!);
        } else {
          return buildWidget(value: dataCell.value!);
        }
      }).toList(growable: false));
    }
  }

  // Employee Data's

  final math.Random random = math.Random();

  final List<String> names = <String>[
    'Welli',
    'Blonp',
    'Folko',
    'Furip',
    'Folig',
    'Picco',
    'Frans',
    'Warth',
    'Linod',
    'Simop',
    'Merep',
    'Riscu',
    'Seves',
    'Vaffe',
    'Alfki',
  ];

  final List<String> cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende',
  ];

  List<_Employee> getEmployees(int count) {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(_Employee(
        1000 + i,
        1700 + i,
        names[i < names.length ? i : random.nextInt(names.length - 1)],
        random.nextInt(1000) + random.nextDouble(),
        cities[random.nextInt(cities.length - 1)],
        1500.0 + random.nextInt(100),
      ));
    }
    return employeeData;
  }
}
