/// Dart import
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Renders column type data grid
class ListDataSourceDataGrid extends SampleView {
  /// Creates column type data grid
  const ListDataSourceDataGrid({Key? key}) : super(key: key);

  @override
  _ListDataSourceDataGridState createState() => _ListDataSourceDataGridState();
}

class _ListDataSourceDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _ListDataGridSource listDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  Widget sampleWidget() => const ListDataSourceDataGrid();

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = isWebOrDesktop
        ? ([
            GridTextColumn(
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
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
                child: Text(
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
                child: Text(
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
                child: Text(
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
                child: Text(
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
                child: Text(
                  'Price',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ])
        : ([
            GridTextColumn(
                columnName: 'id',
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridTextColumn(
              columnName: 'customerId',
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
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
                child: Text(
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
                  child: Text(
                    'City',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                columnWidthMode: ColumnWidthMode.lastColumnFill),
          ]);
    return columns;
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = (model.isWeb || model.isDesktop);
    listDataGridSource = _ListDataGridSource(isWebOrDesktop: isWebOrDesktop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            source: listDataGridSource,
            columns: getColumns()));
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

class _ListDataGridSource extends DataGridSource {
  _ListDataGridSource({required this.isWebOrDesktop}) {
    employees = getEmployees(100);
    buildDataGridRows();
  }

  final bool isWebOrDesktop;
  final math.Random random = math.Random();
  List<_Employee> employees = [];
  List<DataGridRow> dataGridRows = [];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = isWebOrDesktop
        ? employees.map<DataGridRow>((dataGridRow) {
            return DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<double>(
                  columnName: 'freight', value: dataGridRow.freight),
              DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
              DataGridCell<double>(
                  columnName: 'price', value: dataGridRow.price),
            ]);
          }).toList()
        : employees.map<DataGridRow>((dataGridRow) {
            return DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
            ]);
          }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    if (isWebOrDesktop) {
      return DataGridRowAdapter(cells: [
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
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(NumberFormat.currency(locale: 'en_US', symbol: '\$')
              .format(row.getCells()[3].value)
              .toString()),
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
          child: Text(NumberFormat.currency(locale: 'en_US', symbol: '\$')
              .format(row.getCells()[5].value)
              .toString()),
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
          cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'id' ||
            dataCell.columnName == 'customerId') {
          return buildWidget(
              alignment: Alignment.centerRight, value: dataCell.value);
        } else {
          return buildWidget(value: dataCell.value);
        }
      }).toList(growable: false));
    }
  }

  //  Employee Data's

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
