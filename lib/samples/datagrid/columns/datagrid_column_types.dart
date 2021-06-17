///Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Barcode imports
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders column type data grid
class ColumnTypeDataGrid extends SampleView {
  /// Creates column type data grid
  const ColumnTypeDataGrid({Key? key}) : super(key: key);

  @override
  _ColumnTypesDataGridState createState() => _ColumnTypesDataGridState();
}

class _ColumnTypesDataGridState extends SampleViewState {
  /// Required for SfDataGrid to obtain the row data.
  final _ColumnTypesDataGridSource columnTypesDataGridSource =
      _ColumnTypesDataGridSource();

  /// Determine to decide whether the device in landscape or in portrait
  late bool isLandscapeInMobileView;

  late bool isWebOrDesktop;

  SfDataGrid _buildDataGrid(BuildContext context) {
    return SfDataGrid(
        source: columnTypesDataGridSource,
        columnWidthMode: isWebOrDesktop
            ? (isWebOrDesktop && model.isMobileResolution)
                ? ColumnWidthMode.none
                : ColumnWidthMode.fill
            : ColumnWidthMode.none,
        columns: <GridColumn>[
          GridTextColumn(
              columnName: 'dealer',
              width: 90,
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Dealer',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridTextColumn(
              columnName: 'id',
              width: !isWebOrDesktop
                  ? 50
                  : (isWebOrDesktop && model.isMobileResolution)
                      ? 110
                      : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none),
          GridTextColumn(
            columnName: 'name',
            width:
                (isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Name',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridTextColumn(
            columnName: 'freight',
            width:
                (isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
            columnWidthMode: isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none,
            label: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Freight',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridTextColumn(
            columnName: 'shippedDate',
            width: 110,
            label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Shipped Date',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //dateFormat: DateFormat.yMd()
          ),
          GridTextColumn(
            columnName: 'city',
            width: isWebOrDesktop ? 110.0 : double.nan,
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
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnWidthMode: ColumnWidthMode.lastColumnFill,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Price',
                  overflow: TextOverflow.ellipsis,
                ),
              ))
        ]);
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
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

class _ColumnTypesDataGridSource extends DataGridSource {
  _ColumnTypesDataGridSource() {
    employees = getEmployees(100);
    buildDataGridRows();
  }

  final math.Random random = math.Random();
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<_Employee> employees = <_Employee>[];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((_Employee dataGridRow) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<Image>(columnName: 'dealer', value: dataGridRow.dealer),
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<double>(columnName: 'freight', value: dataGridRow.freight),
        DataGridCell<DateTime>(
            columnName: 'shippedDate', value: dataGridRow.shippedDate),
        DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
        DataGridCell<double>(columnName: 'price', value: dataGridRow.price),
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
    return DataGridRowAdapter(cells: <Widget>[
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
          NumberFormat.currency(locale: 'en_US', symbol: r'$')
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
          NumberFormat.currency(locale: 'en_US', symbol: r'$')
              .format(row.getCells()[6].value)
              .toString(),
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
