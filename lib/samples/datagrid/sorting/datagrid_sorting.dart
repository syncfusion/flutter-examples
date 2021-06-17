import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Renders sorting data grid
class SortingDataGrid extends SampleView {
  /// Creates sorting data grid
  const SortingDataGrid({Key? key}) : super(key: key);

  @override
  _SortingDataGridState createState() => _SortingDataGridState();
}

class _SortingDataGridState extends SampleViewState {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  final _SortingDataSource sortingDataGridSource = _SortingDataSource();

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
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title:
                Text('Allow sorting', style: TextStyle(color: model.textColor)),
            trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: allowSorting,
                  onChanged: (bool value) {
                    setState(() {
                      allowSorting = value;
                      stateSetter(() {});
                    });
                  },
                )),
          ),
          ListTile(
              title: Text('Allow multiple column sorting',
                  style: TextStyle(color: model.textColor)),
              trailing: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: allowMultiSorting,
                    onChanged: (bool value) {
                      setState(() {
                        allowMultiSorting = value;
                        stateSetter(() {});
                      });
                    },
                  ))),
          ListTile(
              title: Text('Allow tri-state sorting',
                  style: TextStyle(color: model.textColor)),
              trailing: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: allowTriStateSorting,
                    onChanged: (bool value) {
                      setState(() {
                        allowTriStateSorting = value;
                        stateSetter(() {});
                      });
                    },
                  ))),
          ListTile(
            trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: allowColumnSorting,
                  onChanged: (bool value) {
                    setState(() {
                      allowColumnSorting = value;
                      stateSetter(() {});
                    });
                  },
                )),
            title: Text('Allow sorting for the Name column',
                style: TextStyle(color: model.textColor)),
          ),
          ListTile(
              title: Text('Display sort sequence numbers',
                  style: TextStyle(color: model.textColor)),
              trailing: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: showSortNumbers,
                    onChanged: (bool value) {
                      setState(() {
                        showSortNumbers = value;
                        stateSetter(() {});
                      });
                    },
                  ))),
        ],
      );
    });
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
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
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Customer ID',
              overflow: TextOverflow.ellipsis,
            ),
          )),
      GridTextColumn(
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
      GridTextColumn(
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
      GridTextColumn(
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
      GridTextColumn(
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

class _SortingDataSource extends DataGridSource {
  _SortingDataSource() {
    employees = getEmployees();
    buildDataGridRows();
  }

  List<_Employee> employees = <_Employee>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

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
    }).toList(growable: false);
  }

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
        ),
      ),
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
            NumberFormat.currency(
                    locale: 'en_US', symbol: r'$', decimalDigits: 0)
                .format(row.getCells()[5].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          )),
    ]);
  }

  Random random = Random();

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

  List<_Employee> getEmployees() {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < 30; i++) {
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
