//
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import '../../../widgets/customDropDown.dart';

class SelectionDataGrid extends SampleView {
  const SelectionDataGrid({Key key}) : super(key: key);

  @override
  _SelectionDataGridPageState createState() => _SelectionDataGridPageState();
}

List<Employee> _employeeData;

class _SelectionDataGridPageState extends SampleViewState {
  _SelectionDataGridPageState();

  Widget sampleWidget(SampleModel model) => const SelectionDataGrid();

  final math.Random _random = math.Random();

  final SelectionDataGridSource _selectionDataGridSource =
      SelectionDataGridSource();

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

  DataGridController getDataGridController() {
    final DataGridController _dataGridController = DataGridController();
    _dataGridController.selectedRows.add(_employeeData[2]);
    _dataGridController.selectedRows.add(_employeeData[4]);
    _dataGridController.selectedRows.add(_employeeData[6]);

    return _dataGridController;
  }

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
    if (kIsWeb) {
      columns = <GridColumn>[
        GridNumericColumn(mappingName: 'id')
          ..headerText = 'Order ID'
          ..padding = const EdgeInsets.all(8)
          ..headerTextAlignment = Alignment.centerRight
          ..columnWidthMode =
              kIsWeb ? ColumnWidthMode.none : ColumnWidthMode.auto,
        GridNumericColumn(mappingName: 'customerId')
          ..columnWidthMode =
              kIsWeb ? ColumnWidthMode.none : ColumnWidthMode.header
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
          ..headerTextAlignment = Alignment.centerLeft
          ..headerText = 'City'
          ..columnWidthMode =
              kIsWeb ? ColumnWidthMode.none : ColumnWidthMode.auto,
        GridNumericColumn(mappingName: 'price')
          ..numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          ..headerText = 'Price'
      ];
    } else {
      columns = <GridColumn>[
        GridNumericColumn(mappingName: 'id')
          ..headerText = 'Order ID'
          ..padding = const EdgeInsets.all(8)
          ..headerTextAlignment = Alignment.centerRight,
        GridNumericColumn(mappingName: 'customerId')
          ..headerTextAlignment = Alignment.centerRight
          ..headerText = 'Customer ID',
        GridTextColumn(mappingName: 'name')
          ..headerTextAlignment = Alignment.centerLeft
          ..headerText = 'Name',
        GridTextColumn(mappingName: 'city')
          ..headerText = 'City'
          ..headerTextAlignment = Alignment.centerLeft
          ..columnWidthMode = ColumnWidthMode.lastColumnFill,
      ];
    }
    return columns;
  }

  SfDataGrid _dataGridSample(
      [SelectionMode selectionMode, GridNavigationMode navigationMode]) {
    return SfDataGrid(
      columnWidthMode: kIsWeb ? ColumnWidthMode.fill : ColumnWidthMode.header,
      source: _selectionDataGridSource,
      selectionMode: selectionMode,
      navigationMode: navigationMode,
      controller: getDataGridController(),
      columns: getColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectionMode = 'Multiple';
    selectionMode = SelectionMode.multiple;
    _navigationMode = kIsWeb ? 'Cell' : 'Row';
    navigationMode = kIsWeb ? GridNavigationMode.cell : GridNavigationMode.row;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _employeeData = generateList(100);
  }

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  String _selectionMode;
  SelectionMode selectionMode = SelectionMode.multiple;

  String _navigationMode;
  GridNavigationMode navigationMode;

  final List<String> _encoding = <String>[
    'None',
    'Single',
    'Single Deselect',
    'Multiple',
  ];
  void _onSelectionModeChanged(String item, SampleModel model) {
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
    setState(() {});
  }

  final List<String> _navigation = <String>[
    'Cell',
    'Row',
  ];
  void _onNavigationModeChanged(String item, SampleModel model) {
    _navigationMode = item;
    switch (_navigationMode) {
      case 'Cell':
        navigationMode = GridNavigationMode.cell;
        break;
      case 'Row':
        navigationMode = GridNavigationMode.row;
        break;
    }
    setState(() {});
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;
  @override
  Widget buildSettings(BuildContext context) {
    return ListView(children: <Widget>[
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
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: DropDown(
                            value: _selectionMode,
                            item: _encoding.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: (value != null) ? value : 'Multiple',
                                  child: Text('$value',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: model.textColor)));
                            }).toList(),
                            valueChanged: (dynamic value) {
                              _onSelectionModeChanged(value, model);
                            }),
                      ),
                    )),
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
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: DropDown(
                            value: _navigationMode,
                            item: _navigation.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: (value != null) ? value : 'Cell',
                                  child: Text('$value',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: model.textColor)));
                            }).toList(),
                            valueChanged: (dynamic value) {
                              _onNavigationModeChanged(value, model);
                            }),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _dataGridSample(selectionMode, navigationMode);
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

class SelectionDataGridSource extends DataGridSource {
  SelectionDataGridSource();
  @override
  List<Object> get dataSource => _employeeData;
  @override
  Object getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'id':
        return _employeeData[rowIndex].id;
        break;
      case 'name':
        return _employeeData[rowIndex].name;
        break;
      case 'customerId':
        return _employeeData[rowIndex].customerId;
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
