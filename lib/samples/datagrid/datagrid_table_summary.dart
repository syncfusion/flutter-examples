/// Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../model/sample_view.dart';

/// Renders datagrid with table summary row feature.
class TableSummaryDataGrid extends SampleView {
  /// Creates datagrid to show table summary rows.
  const TableSummaryDataGrid({Key? key}) : super(key: key);

  @override
  _TableSummaryDataGridState createState() => _TableSummaryDataGridState();
}

class _TableSummaryDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _TableSummaryDataSource dataSource;

  late bool isWebOrDesktop;

  bool isLandscapeInMobileView = false;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    dataSource =
        _TableSummaryDataSource(brightness: model.themeData.brightness);
  }

  @override
  void didChangeDependencies() {
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: dataSource,
      columns: getColumns(),
      tableSummaryRows: getTableSummaryRows(),
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.auto,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
    );
  }

  List<GridTableSummaryRow> getTableSummaryRows() {
    final Color color = model.themeData.brightness == Brightness.light
        ? const Color(0xFFEBEBEB)
        : const Color(0xFF3B3B3B);
    return <GridTableSummaryRow>[
      GridTableSummaryRow(
          color: color,
          showSummaryInRow: true,
          title: 'Total Order Count: {count}',
          columns: <GridSummaryColumn>[
            const GridSummaryColumn(
                name: 'count',
                columnName: 'Order ID',
                summaryType: GridSummaryType.count),
          ],
          position: GridTableSummaryRowPosition.top),
      GridTableSummaryRow(
          color: color,
          showSummaryInRow: false,
          columns: <GridSummaryColumn>[
            const GridSummaryColumn(
                name: 'freight',
                columnName: 'Freight',
                summaryType: GridSummaryType.sum),
            const GridSummaryColumn(
                name: 'price',
                columnName: 'Price',
                summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom),
    ];
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnName: 'Order ID',
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
        autoFitPadding: const EdgeInsets.all(8.0),
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 150.0 : double.nan,
        columnName: 'Customer ID',
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
        autoFitPadding: const EdgeInsets.all(8.0),
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnName: 'Name',
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
        width: (isWebOrDesktop && model.isMobileResolution) || !isWebOrDesktop
            ? 140.0
            : double.nan,
        columnName: 'Freight',
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
        autoFitPadding: const EdgeInsets.all(8.0),
        width:
            (isWebOrDesktop && model.isMobileResolution) ? 120.0 : double.nan,
        columnName: 'City',
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
          width: (isWebOrDesktop && model.isMobileResolution) || !isWebOrDesktop
              ? 120.0
              : double.nan,
          columnName: 'Price',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Price',
              overflow: TextOverflow.ellipsis,
            ),
          ))
    ];
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

class _TableSummaryDataSource extends DataGridSource {
  _TableSummaryDataSource({required this.brightness}) {
    employees = getEmployees(100);
    buildDataGridRows();
  }

  final Brightness brightness;

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<_Employee> employees = <_Employee>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((_Employee employee) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'Order ID', value: employee.id),
        DataGridCell<int>(
            columnName: 'Customer ID', value: employee.customerId),
        DataGridCell<String>(columnName: 'Name', value: employee.name),
        DataGridCell<double>(columnName: 'Freight', value: employee.freight),
        DataGridCell<String>(columnName: 'City', value: employee.city),
        DataGridCell<double>(columnName: 'Price', value: employee.price),
      ]);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
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
                .format(row.getCells()[3].value),
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
          NumberFormat.currency(locale: 'en_US', decimalDigits: 0, symbol: r'$')
              .format(row.getCells()[5].value),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    Widget buildCell(String value, EdgeInsets padding, Alignment alignment) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500)),
      );
    }

    if (summaryRow.showSummaryInRow) {
      return buildCell(
          summaryValue, const EdgeInsets.all(16.0), Alignment.centerLeft);
    } else {
      if (summaryColumn!.columnName == 'Freight') {
        summaryValue = double.parse(summaryValue).toStringAsFixed(2);
      }

      summaryValue = 'Sum: ' +
          NumberFormat.currency(locale: 'en_US', decimalDigits: 0, symbol: r'$')
              .format(double.parse(summaryValue));

      return buildCell(
          summaryValue, const EdgeInsets.all(8.0), Alignment.centerRight);
    }
  }

  // Employee's data

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
    'Campinas',
    'Resende',
  ];

  List<_Employee> getEmployees(int count) {
    final Random random = Random();
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
