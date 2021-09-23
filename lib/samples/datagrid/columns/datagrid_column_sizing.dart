///Dart import
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders column sizing data grid
class ColumnSizingDataGrid extends SampleView {
  /// Creates column sizing data grid
  const ColumnSizingDataGrid({Key? key}) : super(key: key);

  @override
  _ColumnSizingDataGridState createState() => _ColumnSizingDataGridState();
}

class _ColumnSizingDataGridState extends SampleViewState {
  /// Required for SfDataGrid to obtain the row data.
  late final _ColumnSizingDataGridSource columnSizingDataGridSource;

  /// Determine to decide whether the device in landscape or in portrait
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  String _columnWidthMode = '';

  late ColumnWidthMode columnWidthMode;

  final CustomColumnSizer _columnSizer = CustomColumnSizer();

  /// Column width modes
  final List<String> _encoding = <String>[
    'fill',
    'auto',
    'fitByCellValue',
    'fitByColumnName',
    'lastColumnFill',
    'none'
  ];

  void _onSelectionModeChanged(String item) {
    _columnWidthMode = item;
    switch (_columnWidthMode) {
      case 'none':
        columnWidthMode = ColumnWidthMode.none;
        break;
      case 'auto':
        columnWidthMode = ColumnWidthMode.auto;
        break;
      case 'fill':
        columnWidthMode = ColumnWidthMode.fill;
        break;
      case 'fitByCellValue':
        columnWidthMode = ColumnWidthMode.fitByCellValue;
        break;
      case 'fitByColumnName':
        columnWidthMode = ColumnWidthMode.fitByColumnName;
        break;
      case 'lastColumnFill':
        columnWidthMode = ColumnWidthMode.lastColumnFill;
        break;
    }
    setState(() {
      /// update the column width mode changes
    });
  }

  List<GridColumn> _getColumns() {
    if (isWebOrDesktop) {
      return <GridColumn>[
        GridColumn(
            columnName: 'Dealer',
            autoFitPadding: const EdgeInsets.all(8.0),
            width: 90,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Dealer',
              ),
            )),
        GridColumn(
          columnName: 'ID',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'ID',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Name',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Freight',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Freight',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Shipped Date',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Shipped Date',
            ),
          ),
        ),
        GridColumn(
          columnName: 'City',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'City',
            ),
          ),
        ),
        GridColumn(
            columnName: 'Price',
            autoFitPadding: const EdgeInsets.all(8.0),
            label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Price',
              ),
            ))
      ];
    } else {
      return <GridColumn>[
        GridColumn(
          columnName: 'ID',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'ID',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Name',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Name',
            ),
          ),
        ),
        GridColumn(
          columnName: 'Shipped Date',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Shipped Date',
            ),
          ),
        ),
        GridColumn(
          columnName: 'City',
          autoFitPadding: const EdgeInsets.all(8.0),
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'City',
            ),
          ),
        ),
      ];
    }
  }

  SfDataGrid _buildDataGrid(BuildContext context) {
    return SfDataGrid(
        source: columnSizingDataGridSource,
        columnWidthMode: columnWidthMode,
        columnSizer: _columnSizer,
        columns: _getColumns());
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    columnWidthMode = ColumnWidthMode.fill;
    _columnWidthMode = 'fill';
    columnSizingDataGridSource = _ColumnSizingDataGridSource(isWebOrDesktop);
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: isWebOrDesktop ? 100 : 150,
                  child: Text(
                    'Column width mode',
                    softWrap: true,
                    style: TextStyle(fontSize: 15.0, color: model.textColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.bottomLeft,
                    child: DropdownButton<String>(
                        underline: Container(
                            color: const Color(0xFFBDBDBD), height: 1),
                        value: _columnWidthMode,
                        items: _encoding.map((String value) {
                          return DropdownMenuItem<String>(
                              value: (value != null) ? value : 'none',
                              child: Text(value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: model.textColor,
                                    fontSize: 15.0,
                                  )));
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
      ]);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildDataGrid(context));
  }
}

class _Employee {
  _Employee(
    this.id,
    this.name,
    this.dealer,
    this.freight,
    this.shippedDate,
    this.city,
    this.price,
  );
  final int id;
  final String name;
  final double price;
  final DateTime shippedDate;
  final Image dealer;
  final double freight;
  final String city;
}

class _ColumnSizingDataGridSource extends DataGridSource {
  _ColumnSizingDataGridSource(this.isWebOrDesktop) {
    employees = getEmployees(100);
    buildDataGridRows();
  }

  final math.Random random = math.Random();
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<_Employee> employees = <_Employee>[];
  bool isWebOrDesktop;

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((_Employee dataGridRow) {
      return isWebOrDesktop
          ? DataGridRow(cells: <DataGridCell>[
              DataGridCell<Image>(
                  columnName: 'Dealer', value: dataGridRow.dealer),
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<double>(
                  columnName: 'Freight', value: dataGridRow.freight),
              DataGridCell<DateTime>(
                  columnName: 'Shipped Date', value: dataGridRow.shippedDate),
              DataGridCell<String>(columnName: 'City', value: dataGridRow.city),
              DataGridCell<double>(
                  columnName: 'Price', value: dataGridRow.price),
            ])
          : DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<DateTime>(
                  columnName: 'Shipped Date', value: dataGridRow.shippedDate),
              DataGridCell<String>(columnName: 'City', value: dataGridRow.city),
            ]);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  Widget buildDealer(dynamic value) {
    return Container(
      padding: const EdgeInsets.all(3),
      alignment: Alignment.center,
      child: value,
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return isWebOrDesktop
        ? DataGridRowAdapter(cells: <Widget>[
            buildDealer(row.getCells()[0].value),
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
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                NumberFormat.currency(
                        locale: 'en_US', symbol: r'$', decimalDigits: 2)
                    .format(row.getCells()[3].value)
                    .toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMd().format(row.getCells()[4].value).toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[5].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                NumberFormat.currency(
                        locale: 'en_US', symbol: r'$', decimalDigits: 2)
                    .format(row.getCells()[6].value)
                    .toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ])
        : DataGridRowAdapter(cells: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[0].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[1].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMd().format(row.getCells()[2].value).toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[3].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]);
  }

  // _Employee Data set

  final List<Image> dealers = <Image>[
    Image.asset('images/People_Circle2.png'),
    Image.asset('images/People_Circle18.png'),
    Image.asset('images/People_Circle3.png'),
    Image.asset('images/People_Circle4.png'),
    Image.asset('images/People_Circle7.png'),
    Image.asset('images/People_Circle23.png'),
    Image.asset('images/People_Circle6.png'),
    Image.asset('images/People_Circle8.png'),
    Image.asset('images/People_Circle9.png'),
    Image.asset('images/People_Circle10.png'),
    Image.asset('images/People_Circle11.png'),
    Image.asset('images/People_Circle13.png'),
    Image.asset('images/People_Circle14.png'),
    Image.asset('images/People_Circle15.png'),
    Image.asset('images/People_Circle16.png'),
    Image.asset('images/People_Circle17.png'),
    Image.asset('images/People_Circle19.png'),
    Image.asset('images/People_Circle20.png'),
    Image.asset('images/People_Circle21.png'),
    Image.asset('images/People_Circle22.png'),
    Image.asset('images/People_Circle23.png'),
    Image.asset('images/People_Circle24.png'),
    Image.asset('images/People_Circle25.png'),
    Image.asset('images/People_Circle26.png'),
    Image.asset('images/People_Circle27.png'),
  ];

  final List<String> names = <String>[
    'Betts',
    'Adams',
    'Crowley',
    'Stark',
    'Keefe',
    'Doran',
    'Newberry',
    'Blanc',
    'Gable',
    'Balnc',
    'Perry',
    'Lane',
    'Grimes'
  ];

  final List<DateTime> shippedDates = <DateTime>[
    DateTime.now(),
    DateTime(2002, 8, 27),
    DateTime(2015, 7, 4),
    DateTime(2007, 4, 15),
    DateTime(2010, 12, 23),
    DateTime(2010, 4, 20),
    DateTime(2004, 6, 13),
    DateTime(2008, 11, 11),
    DateTime(2005, 7, 29),
    DateTime(2009, 4, 5),
    DateTime(2003, 3, 20),
    DateTime(2011, 3, 8),
    DateTime(2013, 10, 22),
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
        1100 + i,
        names[i < names.length ? i : random.nextInt(names.length - 1)],
        dealers[i < dealers.length ? i : random.nextInt(dealers.length - 1)],
        random.nextInt(1000) + random.nextDouble(),
        shippedDates[random.nextInt(shippedDates.length - 1)],
        cities[random.nextInt(cities.length - 1)],
        1500.0 + random.nextInt(100),
      ));
    }
    return employeeData;
  }
}

/// custom column sizer class
class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    if (column.columnName == 'Shipped Date') {
      cellValue = DateFormat.yMd().format(cellValue! as DateTime);
    } else if (column.columnName == 'Freight' || column.columnName == 'Price') {
      cellValue =
          NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2)
              .format(cellValue);
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}
