import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

/// Dart import
import 'dart:math' as math;

/// Renders column type data grid
class ListDataSourceDataGrid extends SampleView {
  /// Creates column type data grid
  const ListDataSourceDataGrid({Key key}) : super(key: key);

  @override
  _ListDataSourceDataGridState createState() => _ListDataSourceDataGridState();
}

List<Employee> _employeeData;

class _ListDataSourceDataGridState extends SampleViewState {
  _ListDataSourceDataGridState();

  Widget sampleWidget() => const ListDataSourceDataGrid();

  final math.Random _random = math.Random();
  bool _isLandscapeInMobileView;

  final _ListDataGridSource _listDataGridSource = _ListDataGridSource();

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

  List<Employee> generateList(int count) {
    final List<Employee> employeeData = <Employee>[];
    for (int i = 0; i < count; i++) {
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

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = kIsWeb
        ? ([
            GridNumericColumn(mappingName: 'id')
              ..headerText = 'Order ID'
              ..padding = const EdgeInsets.all(8)
              ..headerTextAlignment = Alignment.centerRight
              ..columnWidthMode =
                  model.isWeb ? ColumnWidthMode.none : ColumnWidthMode.auto,
            GridNumericColumn(mappingName: 'customerId')
              ..columnWidthMode =
                  model.isWeb ? ColumnWidthMode.none : ColumnWidthMode.header
              ..headerText = 'Customer ID'
              ..headerTextAlignment = Alignment.centerRight,
            GridTextColumn(mappingName: 'name')
              ..headerText = 'Name'
              ..headerTextAlignment = Alignment.centerLeft,
            GridNumericColumn(mappingName: 'freight')
              ..numberFormat =
                  NumberFormat.currency(locale: 'en_US', symbol: '\$')
              ..headerText = 'Freight'
              ..headerTextAlignment = Alignment.centerRight,
            GridTextColumn(mappingName: 'city')
              ..headerTextAlignment = Alignment.centerLeft
              ..headerText = 'City'
              ..columnWidthMode =
                  model.isWeb ? ColumnWidthMode.none : ColumnWidthMode.auto,
            GridNumericColumn(mappingName: 'price')
              ..numberFormat =
                  NumberFormat.currency(locale: 'en_US', symbol: '\$')
              ..headerText = 'Price'
          ])
        : ([
            GridNumericColumn(mappingName: 'id')
              ..headerText = 'ID'
              ..padding = const EdgeInsets.all(8)
              ..headerTextAlignment = Alignment.centerRight,
            GridNumericColumn(mappingName: 'customerId')
              ..headerTextAlignment = Alignment.centerRight
              ..columnWidthMode = _isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.header
              ..headerText = 'Customer ID',
            GridTextColumn(mappingName: 'name')
              ..headerTextAlignment = Alignment.centerLeft
              ..headerText = 'Name',
            GridTextColumn(mappingName: 'city')
              ..headerText = 'City'
              ..headerTextAlignment = Alignment.centerLeft
              ..columnWidthMode = ColumnWidthMode.lastColumnFill,
          ]);
    return columns;
  }

  @override
  void initState() {
    super.initState();
    _employeeData = generateList(100);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            source: _listDataGridSource,
            columns: getColumns()));
  }
}

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

class _ListDataGridSource extends DataGridSource<Employee> {
  _ListDataGridSource();
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
