/// Dart import
import 'dart:math';

/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders pull refresh data grid
class PullToRefreshDataGrid extends SampleView {
  /// Creates pull refresh data grid
  const PullToRefreshDataGrid({Key? key}) : super(key: key);

  @override
  _PullToRefreshDataGridState createState() => _PullToRefreshDataGridState();
}

class _PullToRefreshDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final _EmployeeDataSource employeeDataSource = _EmployeeDataSource();

  late bool isWebOrDesktop;

  List<GridColumn> _getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'id',
          width:
              (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
          columnWidthMode:
              !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Order ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
        columnName: 'customerId',
        columnWidthMode:
            !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
        width: !isWebOrDesktop
            ? 120
            : (isWebOrDesktop && model.isMobileResolution)
                ? 150.0
                : double.nan,
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
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
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
        columnName: 'freight',
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 110.0 : double.nan,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Freight',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'city',
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnWidthMode:
            !isWebOrDesktop ? ColumnWidthMode.none : ColumnWidthMode.fill,
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
        columnName: 'price',
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Price',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          brightness: model.themeData.brightness,
          accentColor: model.backgroundColor,
        ),
        child: SfDataGrid(
            source: employeeDataSource,
            allowPullToRefresh: true,
            columns: _getColumns()));
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

class _EmployeeDataSource extends DataGridSource {
  _EmployeeDataSource() {
    employees = getEmployees(employees, 25);
    buildDataGridRows();
  }

  List<_Employee> employees = <_Employee>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((_Employee employee) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: employee.id),
        DataGridCell<int>(columnName: 'customerId', value: employee.customerId),
        DataGridCell<String>(columnName: 'name', value: employee.name),
        DataGridCell<double>(columnName: 'freight', value: employee.freight),
        DataGridCell<String>(columnName: 'city', value: employee.city),
        DataGridCell<double>(columnName: 'price', value: employee.price),
      ]);
    }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          NumberFormat.currency(locale: 'en_US', symbol: r'$')
              .format(row.getCells()[3].value)
              .toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(
                    locale: 'en_US', symbol: r'$', decimalDigits: 0)
                .format(row.getCells()[5].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          ))
    ]);
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    employees = getEmployees(employees, 15);
    buildDataGridRows();
    notifyListeners();
  }

  // Employee Data's

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

  List<_Employee> getEmployees(List<_Employee> employeeData, int count) {
    final Random random = Random();
    final int startIndex = employeeData.isNotEmpty ? employeeData.length : 0,
        endIndex = startIndex + count;

    for (int i = startIndex; i < endIndex; i++) {
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
