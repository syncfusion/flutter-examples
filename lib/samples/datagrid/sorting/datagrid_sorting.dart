import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:math';

List<Employee> _employeeData;
Random _random = Random();

class SortingDataGrid extends SampleView {
  SortingDataGrid({Key key}) : super(key: key);

  @override
  _SortingDataGridState createState() => _SortingDataGridState();
}

class _SortingDataGridState extends SampleViewState {
  _SortingDataSource _sortingDataGridSource;
  bool _allowSorting = true;
  bool _allowMultiSorting = false;
  bool _allowTriStateSorting = false;
  bool _allowColumnSorting = true;
  bool _showSortNumbers = false;
  bool _isLandscapeInMobileView;

  @override
  void initState() {
    super.initState();
    _employeeData = generateList();
    _sortingDataGridSource = _SortingDataSource();
    _sortingDataGridSource.sortedColumns.add(SortColumnDetails(
        name: 'id', sortDirection: DataGridSortDirection.descending));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _sortingDataGridSource,
      columns: getColumns(),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: kIsWeb || _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.header,
      allowSorting: _allowSorting,
      allowMultiColumnSorting: _allowMultiSorting,
      allowTriStateSorting: _allowTriStateSorting,
      showSortNumbers: _showSortNumbers,
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
                  value: _allowSorting,
                  onChanged: (bool value) {
                    setState(() {
                      _allowSorting = value;
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
                    value: _allowMultiSorting,
                    onChanged: (bool value) {
                      setState(() {
                        _allowMultiSorting = value;
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
                    value: _allowTriStateSorting,
                    onChanged: (bool value) {
                      setState(() {
                        _allowTriStateSorting = value;
                        stateSetter(() {});
                      });
                    },
                  ))),
          ListTile(
            trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: _allowColumnSorting,
                  onChanged: (bool value) {
                    setState(() {
                      _allowColumnSorting = value;
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
                    value: _showSortNumbers,
                    onChanged: (bool value) {
                      setState(() {
                        _showSortNumbers = value;
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
      GridNumericColumn(
          mappingName: 'id',
          columnWidthMode:
              !kIsWeb ? ColumnWidthMode.header : ColumnWidthMode.fill,
          headerText: 'Order ID'),
      GridNumericColumn(
          mappingName: 'customerId',
          columnWidthMode:
              !kIsWeb ? ColumnWidthMode.header : ColumnWidthMode.fill,
          headerText: 'Customer ID'),
      GridTextColumn(
          mappingName: 'name',
          headerText: 'Name',
          allowSorting: _allowColumnSorting),
      GridNumericColumn(
          mappingName: 'freight',
          numberFormat: NumberFormat.currency(locale: 'en_US', symbol: '\$'),
          headerText: 'Freight'),
      GridTextColumn(
          mappingName: 'city',
          columnWidthMode:
              !kIsWeb ? ColumnWidthMode.auto : ColumnWidthMode.fill,
          headerText: 'City'),
      GridNumericColumn(
          mappingName: 'price',
          numberFormat: NumberFormat.currency(
              locale: 'en_US', symbol: '\$', decimalDigits: 0),
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          headerText: 'Price')
    ];
  }
}

List<Employee> generateList() {
  final List<Employee> employeeData = <Employee>[];
  for (int i = 0; i < 30; i++) {
    employeeData.add(Employee(
      1000 + i,
      1700 + i,
      _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
      _random.nextInt(1000) + _random.nextDouble(),
      _citys[_random.nextInt(_citys.length - 1)],
      1500.0 + _random.nextInt(100),
    ));
  }
  return employeeData;
}

final List<String> _names = <String>[
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

final List<String> _citys = <String>[
  'Bruxelles',
  'Rosario',
  'Recife',
  'Graz',
  'Montreal',
  'Tsawassen',
  'Campinas',
  'Resende',
];

class Employee {
  Employee(
      this.id, this.customerId, this.name, this.freight, this.city, this.price);
  final int id;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class _SortingDataSource extends DataGridSource<Employee> {
  _SortingDataSource();
  @override
  List<Employee> get dataSource => _employeeData;
  @override
  Object getValue(Employee _employee, String columnName) {
    switch (columnName) {
      case 'id':
        return _employee.id;
        break;
      case 'name':
        return _employee.name;
        break;
      case 'customerId':
        return _employee.customerId;
        break;
      case 'freight':
        return _employee.freight;
        break;
      case 'price':
        return _employee.price;
        break;
      case 'city':
        return _employee.city;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
