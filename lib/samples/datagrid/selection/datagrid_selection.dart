/// Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class SelectionDataGrid extends SampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const SelectionDataGrid({Key key}) : super(key: key);

  @override
  _SelectionDataGridPageState createState() => _SelectionDataGridPageState();
}

List<_Employee> _employeeData;

class _SelectionDataGridPageState extends SampleViewState {
  _SelectionDataGridPageState();
  bool _isLandscapeInMobileView;
  final math.Random _random = math.Random();

  final _SelectionDataGridSource _selectionDataGridSource =
      _SelectionDataGridSource();

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

  List<_Employee> generateList(int count) {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(_Employee(
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

    columns = model.isWeb
        ? <GridColumn>[
            GridNumericColumn(
                mappingName: 'id',
                headerText: 'Order ID',
                padding: const EdgeInsets.all(8),
                headerTextAlignment: Alignment.centerRight,
                columnWidthMode:
                    model.isWeb ? ColumnWidthMode.none : ColumnWidthMode.auto),
            GridNumericColumn(
                mappingName: 'customerId',
                columnWidthMode:
                    model.isWeb ? ColumnWidthMode.none : ColumnWidthMode.header,
                headerText: 'Customer ID',
                headerTextAlignment: Alignment.centerRight),
            GridTextColumn(
                mappingName: 'name',
                headerText: 'Name',
                headerTextAlignment: Alignment.centerLeft),
            GridNumericColumn(
                mappingName: 'freight',
                numberFormat:
                    NumberFormat.currency(locale: 'en_US', symbol: '\$'),
                headerText: 'Freight',
                headerTextAlignment: Alignment.centerRight),
            GridTextColumn(
                mappingName: 'city',
                headerTextAlignment: Alignment.centerLeft,
                headerText: 'City',
                columnWidthMode:
                    model.isWeb ? ColumnWidthMode.none : ColumnWidthMode.auto),
            GridNumericColumn(
                mappingName: 'price',
                numberFormat:
                    NumberFormat.currency(locale: 'en_US', symbol: '\$'),
                headerText: 'Price')
          ]
        : <GridColumn>[
            GridNumericColumn(
                mappingName: 'id',
                headerText: 'Order ID',
                padding: const EdgeInsets.all(8),
                headerTextAlignment: Alignment.centerRight),
            GridNumericColumn(
                mappingName: 'customerId',
                headerTextAlignment: Alignment.centerRight,
                headerText: 'Customer ID'),
            GridTextColumn(
                mappingName: 'name',
                headerTextAlignment: Alignment.centerLeft,
                headerText: 'Name'),
            GridTextColumn(
                mappingName: 'city',
                headerText: 'City',
                headerTextAlignment: Alignment.centerLeft,
                columnWidthMode: ColumnWidthMode.lastColumnFill),
          ];
    return columns;
  }

  SfDataGrid _dataGridSample(
      [SelectionMode selectionMode, GridNavigationMode navigationMode]) {
    return SfDataGrid(
      columnWidthMode: model.isWeb || _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.header,
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
    _navigationMode = model.isWeb ? 'Cell' : 'Row';
    navigationMode =
        model.isWeb ? GridNavigationMode.cell : GridNavigationMode.row;
    _employeeData = generateList(100);
  }

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

  final List<String> _navigation = <String>[
    'Cell',
    'Row',
  ];
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
                        underline:
                            Container(color: Color(0xFFBDBDBD), height: 1),
                        value: _selectionMode,
                        items: _encoding.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'Multiple',
                              child: Text('$value',
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
                        underline:
                            Container(color: Color(0xFFBDBDBD), height: 1),
                        value: _navigationMode,
                        items: _navigation.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'Cell',
                              child: Text('$value',
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
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return _dataGridSample(selectionMode, navigationMode);
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

class _SelectionDataGridSource extends DataGridSource<_Employee> {
  _SelectionDataGridSource();
  @override
  List<_Employee> get dataSource => _employeeData;
  @override
  Object getValue(_Employee _employee, String columnName) {
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
