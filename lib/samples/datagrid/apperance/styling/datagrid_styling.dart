///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// render data grid widget
class StylingDataGrid extends SampleView {
  /// Creates data grid widget
  const StylingDataGrid({Key? key}) : super(key: key);

  @override
  _StylingDataGridState createState() => _StylingDataGridState();
}

class _StylingDataGridState extends SampleViewState {
  /// Supported to notify the panel visibility
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;
  bool panelOpen = false;

  /// Determine to decide whether the device in landscape or in portrait
  bool isLandscapeInMobileView = false;

  /// Required for SfDataGrid to obtain the row data.
  late _StylingDataGridSource stylingDataGridSource;

  /// Determine to set the gridLineVisibility of SfDataGrid.
  late String gridLinesVisibility;

  /// Determine to set the gridLineVisibility of SfDataGrid.
  late GridLinesVisibility gridLineVisibility;

  late bool isWebOrDesktop;

  /// GridLineVisibility strings for drop down widget.
  final List<String> _encoding = <String>[
    'Both',
    'Horizontal',
    'None',
    'Vertical',
  ];

  void _onGridLinesVisibilityChanges(String item) {
    gridLinesVisibility = item;
    switch (gridLinesVisibility) {
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
    const TextStyle textStyle =
        TextStyle(color: Color.fromRGBO(255, 255, 255, 1));
    return isWebOrDesktop
        ? <GridColumn>[
            GridTextColumn(
              columnName: 'orderId',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Order ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'customerId',
              width: 120.0,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Customer ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'name',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Name',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'freight',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 100.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Freight',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'city',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 100.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'City',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'price',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 115.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Price',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ]
        : <GridColumn>[
            GridTextColumn(
              columnName: 'orderId',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Order ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              width: 100,
              columnName: 'customerId',
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Customer ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Name',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'City',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ];
  }

  SfDataGridTheme _buildDataGrid(GridLinesVisibility gridLineVisibility) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: model.themeData.brightness,
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: model.backgroundColor),
      child: SfDataGrid(
        source: stylingDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: gridLineVisibility,
        columns: getColumns(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    stylingDataGridSource =
        _StylingDataGridSource(model: model, isWebOrDesktop: isWebOrDesktop);
    gridLinesVisibility = 'None';
    gridLineVisibility = GridLinesVisibility.horizontal;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

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
                value: gridLinesVisibility,
                items: _encoding.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'None',
                      child: Text(value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (dynamic value) {
                  _onGridLinesVisibilityChanges(value);
                  stateSetter(() {});
                }),
          ),
        ),
      ]);
    });
  }

  BoxDecoration drawBorder() {
    final BorderSide borderSide = BorderSide(
        width: 1.0,
        color: model.themeData.brightness == Brightness.light
            ? const Color.fromRGBO(0, 0, 0, 0.26)
            : const Color.fromRGBO(255, 255, 255, 0.26));
    return BoxDecoration(
        border:
            Border(left: borderSide, right: borderSide, bottom: borderSide));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: model.themeData.brightness == Brightness.light
            ? const Color(0xFFFAFAFA)
            : null,
        child: Card(
            margin: isWebOrDesktop
                ? const EdgeInsets.all(24.0)
                : const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            elevation: 1.0,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: drawBorder(),
                    child: _buildDataGrid(gridLineVisibility)))));
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

class _StylingDataGridSource extends DataGridSource {
  _StylingDataGridSource({required this.model, required this.isWebOrDesktop}) {
    employees = getEmployees(100);
    buildDataGridRows();
  }

  final math.Random random = math.Random();
  final SampleModel model;
  List<_Employee> employees = <_Employee>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  final bool isWebOrDesktop;

  /// Build DataGridRow collection

  void buildDataGridRows() {
    dataGridRows = isWebOrDesktop
        ? employees.map<DataGridRow>((_Employee dataGridRow) {
            return DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(
                  columnName: 'orderId', value: dataGridRow.orderId),
              DataGridCell<int>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<double>(
                  columnName: 'freight', value: dataGridRow.freight),
              DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
              DataGridCell<double>(
                  columnName: 'price', value: dataGridRow.price),
            ]);
          }).toList(growable: false)
        : employees.map<DataGridRow>((_Employee dataGridRow) {
            return DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(
                  columnName: 'orderId', value: dataGridRow.orderId),
              DataGridCell<int>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
            ]);
          }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = model.backgroundColor.withOpacity(0.07);
    }

    if (isWebOrDesktop) {
      return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
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
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(row.getCells()[5].value)
                  .toString(),
              overflow: TextOverflow.ellipsis,
            )),
      ]);
    } else {
      return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
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
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]);
    }
  }

  // _Employee data sets

  final List<String> names = <String>[
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
  final List<String> cities = <String>[
    'Graz',
    'Bruxelles',
    'Rosario',
    'Recife',
    'Campinas',
    'Montreal',
    'Tsawassen',
    'Resende',
  ];

  List<_Employee> getEmployees(int count) {
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(_Employee(
        1000 + i,
        1700 + i,
        names[i < names.length ? i : random.nextInt(names.length - 1)],
        cities[random.nextInt(cities.length - 1)],
        random.nextInt(1000) + random.nextDouble(),
        1500.0 + random.nextInt(100),
      ));
    }
    return employeeData;
  }
}
