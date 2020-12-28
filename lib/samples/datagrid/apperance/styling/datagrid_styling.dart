///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// render data grid widget
class StylingDataGrid extends SampleView {
  /// Creates data grid widget
  const StylingDataGrid({Key key}) : super(key: key);

  @override
  _StylingDataGridState createState() => _StylingDataGridState();
}

List<_Employee> _employeeData;

class _StylingDataGridState extends SampleViewState {
  _StylingDataGridState();

  final math.Random _random = math.Random();

  final _StylingDataGridSource _stylingDataGridSource =
      _StylingDataGridSource();

  bool panelOpen;
  bool _isLandscapeInMobileView;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  String _gridLinesVisibility;

  GridLinesVisibility gridLineVisibility;

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

  List<_Employee> _generateList(int count) {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 1; i < count; i++) {
      employeeData.add(_Employee(
        1000 + i,
        1700 + i,
        _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
        _citys[_random.nextInt(_citys.length - 1)],
        _random.nextInt(1000) + _random.nextDouble(),
        1500.0 + _random.nextInt(100),
      ));
    }
    return employeeData;
  }

  final List<String> _encoding = <String>[
    'Both',
    'Horizontal',
    'None',
    'Vertical',
  ];

  void _onGridLinesVisibilitychanges(String item) {
    _gridLinesVisibility = item;
    switch (_gridLinesVisibility) {
      case 'Both':
        gridLineVisibility = GridLinesVisibility.both;
        break;
      case 'Horizontal':
        gridLineVisibility = GridLinesVisibility.horizontal;
        break;
      case 'None':
        gridLineVisibility = GridLinesVisibility.none;
        break;
      case 'Vertical':
        gridLineVisibility = GridLinesVisibility.vertical;
        break;
    }
    setState(() {});
  }

  List<GridColumn> getColumns() {
    return model.isWeb
        ? <GridColumn>[
            GridNumericColumn(
                mappingName: 'orderId',
                headerText: 'Order ID',
                headerTextAlignment: Alignment.centerRight),
            GridNumericColumn(
                mappingName: 'customerId',
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
                headerText: 'City',
                headerTextAlignment: Alignment.centerLeft),
            GridNumericColumn(
                mappingName: 'price',
                numberFormat:
                    NumberFormat.currency(locale: 'en_US', symbol: '\$'),
                headerText: 'Price')
          ]
        : <GridColumn>[
            GridNumericColumn(
                mappingName: 'orderId',
                headerTextAlignment: Alignment.centerRight,
                headerText: 'Order ID'),
            GridNumericColumn(
                mappingName: 'customerId',
                padding: const EdgeInsets.all(8),
                columnWidthMode: _isLandscapeInMobileView
                    ? ColumnWidthMode.fill
                    : ColumnWidthMode.header,
                headerTextAlignment: Alignment.centerRight,
                headerText: 'Customer ID'),
            GridTextColumn(
                mappingName: 'name',
                headerTextAlignment: Alignment.centerLeft,
                headerText: 'Name'),
            GridTextColumn(
                mappingName: 'city',
                headerTextAlignment: Alignment.centerLeft,
                headerText: 'City')
          ];
  }

  SfDataGridTheme _dataGridSample([GridLinesVisibility gridLineVisibility]) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: model.themeData.brightness,
          headerStyle: DataGridHeaderCellStyle(
              backgroundColor: Color(0xFF6C59CF),
              textStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              hoverColor: Color(0xFF9588D7).withOpacity(0.6))),
      child: SfDataGrid(
        source: _stylingDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: gridLineVisibility,
        onQueryRowStyle: (QueryRowStyleArgs args) {
          return ((args.rowIndex % 2) != 0)
              ? DataGridCellStyle(
                  backgroundColor: model.themeData.brightness == Brightness.dark
                      ? const Color(0xFF2E2946)
                      : const Color.fromRGBO(245, 244, 255, 1),
                )
              : null;
        },
        columns: getColumns(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _gridLinesVisibility = 'None';
    gridLineVisibility = GridLinesVisibility.horizontal;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _employeeData = _generateList(100);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;
  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        ListTile(
          title: Text(
            'Grid lines visibility:',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: model.textColor),
          ),
          trailing: Theme(
            data: ThemeData(canvasColor: model.bottomSheetBackgroundColor),
            child: DropdownButton<String>(
                value: _gridLinesVisibility,
                items: _encoding.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'None',
                      child: Text('$value',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (dynamic value) {
                  _onGridLinesVisibilitychanges(value);
                  stateSetter(() {});
                }),
          ),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _dataGridSample(gridLineVisibility);
  }
}

class _Employee {
  _Employee(this.orderId, this.customerId, this.name, this.city, this.freight,
      this.price);
  final int orderId;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class _StylingDataGridSource extends DataGridSource<_Employee> {
  _StylingDataGridSource();
  @override
  List<_Employee> get dataSource => _employeeData;
  @override
  Object getValue(_Employee _employee, String columnName) {
    switch (columnName) {
      case 'orderId':
        return _employee.orderId;
        break;
      case 'customerId':
        return _employee.customerId;
        break;
      case 'name':
        return _employee.name;
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
