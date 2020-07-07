import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_examples/model/sample_view.dart';

class StylesDataGrid extends SampleView {
  const StylesDataGrid({Key key}) : super(key: key);

  @override
  _StylesDataGridState createState() => _StylesDataGridState();
}

List<Employee> _employeeData;

class _StylesDataGridState extends SampleViewState {
  _StylesDataGridState();

  Widget sampleWidget(SampleModel model) => const StylesDataGrid();

  final math.Random _random = math.Random();

  final StylesDataGridSource _stylesDataGridSource = StylesDataGridSource();

  final List<String> _names = <String>[
    'Folko',
    'Warth',
    'Alfki',
    'Frans',
    'Welli',
    'Folig',
    'Seves',
    'Furib',
    'Picco',
    'Linod',
    'Simob',
    'Vaffe',
    'Rascu',
    'Blonp',
    'Merep'
  ];
  final List<String> _citys = <String>[
    'Graz',
    'Bruxelles',
    'Rosario',
    'Recife',
    'Campinas',
    'Montreal',
    'Tsawassen',
    'Resende',
  ];

  List<Employee> generateList(int count) {
    final List<Employee> employeeData = <Employee>[];
    for (int i = 1; i < count; i++) {
      employeeData.add(Employee(
        1000 + i,
        1700 + i,
        _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
        _citys[_random.nextInt(_citys.length - 1)],
        _random.nextInt(1000) + _random.nextDouble() ,
        1500.0 + _random.nextInt(100),
      ));
    }
    return employeeData;
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    if (kIsWeb) {
      columns = <GridColumn>[
        GridNumericColumn(mappingName: 'orderId')
          ..headerText = 'Order ID'
          ..headerTextAlignment = Alignment.centerRight,
        GridNumericColumn(mappingName: 'customerId')
          ..headerText = 'Customer ID'
          ..headerTextAlignment = Alignment.centerRight,
        GridTextColumn(mappingName: 'name')
          ..headerText = 'Name'
          ..headerTextAlignment = Alignment.centerLeft,
        GridNumericColumn(mappingName: 'freight')
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..headerText = 'Freight'
          ..headerTextAlignment = Alignment.centerRight,
        GridTextColumn(mappingName: 'city')
          ..headerText = 'City'
          ..headerTextAlignment = Alignment.centerLeft,
        GridNumericColumn(mappingName: 'price')
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..headerText = 'Price'
      ];
    } else {
      columns = <GridColumn>[
        GridNumericColumn(mappingName: 'orderId')
          ..headerTextAlignment = Alignment.centerRight
          ..headerText = 'Order ID',
        GridNumericColumn(mappingName: 'customerId')
          ..padding = const EdgeInsets.all(8)
          ..columnWidthMode = ColumnWidthMode.header
          ..headerTextAlignment = Alignment.centerRight
          ..headerText = 'Customer ID',
        GridTextColumn(mappingName: 'name')
          ..headerTextAlignment = Alignment.centerLeft
          ..headerText = 'Name',
        GridTextColumn(mappingName: 'city')
          ..headerTextAlignment = Alignment.centerLeft
          ..headerText = 'City'
      ];
    }
    return columns;
  }

  SfDataGridTheme _dataGridSample() {
    return SfDataGridTheme(
        data: SfDataGridThemeData(
            brightness: model.themeData.brightness,
            headerStyle: const DataGridHeaderCellStyle(
                backgroundColor: Color(0xFF6C59CF),
                textStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ))),
        child: SfDataGrid(
          source: _stylesDataGridSource,
          columnWidthMode: ColumnWidthMode.fill,
          onQueryRowStyle: (QueryRowStyleArgs args) {
            if ((args.rowIndex) % 2 == 0) {
              return DataGridCellStyle(
                backgroundColor: model.themeData.brightness == Brightness.dark
                    ? const Color(0xFF2E2946)
                    : const Color.fromRGBO(245, 244, 255, 1),
              );
            } else {
              return null;
            }
          },
          columns: getColumns(),
        ));
  }

  @override
  void initState() {
    super.initState();

    _employeeData = generateList(100);
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _dataGridSample());
  }
}

class Employee {
  Employee(this.orderId, this.customerId, this.name, this.city, this.freight,
      this.price);
  final int orderId;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class StylesDataGridSource extends DataGridSource {
  StylesDataGridSource();
  @override
  List<Object> get dataSource => _employeeData;
  @override
  Object getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'orderId':
        return _employeeData[rowIndex].orderId;
        break;
      case 'customerId':
        return _employeeData[rowIndex].customerId;
        break;
      case 'name':
        return _employeeData[rowIndex].name;
        break;
      case 'freight':
        return _employeeData[rowIndex].freight;
        break;
      case 'price':
        return _employeeData[rowIndex].price;
        break;
      case 'city':
        return _employeeData[rowIndex].city;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
