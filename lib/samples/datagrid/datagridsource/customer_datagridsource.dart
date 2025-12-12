/// Dart import
import 'dart:math' as math;

/// Packages import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/customer.dart';

/// Set customer's data collection to data grid source.
class CustomerDataGridSource extends DataGridSource {
  /// Creates the customer data source class with required details.
  CustomerDataGridSource({required this.isWebOrDesktop}) {
    customerInfo = _obtainCustomerDetails(100);
    _buildDataGridRows();
  }

  /// Determine to decide whether the platform is web or desktop.
  final bool isWebOrDesktop;

  final math.Random _random = math.Random.secure();

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Instance of customer info.
  List<Customer> customerInfo = <Customer>[];

  /// Building DataGridRows
  void _buildDataGridRows() {
    dataGridRows = customerInfo
        .map<DataGridRow>((Customer dataGridRow) {
          return isWebOrDesktop
              ? DataGridRow(
                  cells: <DataGridCell>[
                    DataGridCell<Image>(
                      columnName: 'Dealer',
                      value: dataGridRow.dealer,
                    ),
                    DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
                    DataGridCell<String>(
                      columnName: 'Name',
                      value: dataGridRow.name,
                    ),
                    DataGridCell<double>(
                      columnName: 'Freight',
                      value: dataGridRow.freight,
                    ),
                    DataGridCell<DateTime>(
                      columnName: 'Shipped Date',
                      value: dataGridRow.shippedDate,
                    ),
                    DataGridCell<String>(
                      columnName: 'City',
                      value: dataGridRow.city,
                    ),
                    DataGridCell<double>(
                      columnName: 'Price',
                      value: dataGridRow.price,
                    ),
                  ],
                )
              : DataGridRow(
                  cells: <DataGridCell>[
                    DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
                    DataGridCell<String>(
                      columnName: 'Name',
                      value: dataGridRow.name,
                    ),
                    DataGridCell<DateTime>(
                      columnName: 'Shipped Date',
                      value: dataGridRow.shippedDate,
                    ),
                    DataGridCell<String>(
                      columnName: 'City',
                      value: dataGridRow.city,
                    ),
                  ],
                );
        })
        .toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  Widget _buildDealer(dynamic value) {
    return Container(
      padding: const EdgeInsets.all(3),
      alignment: Alignment.center,
      child: value,
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return isWebOrDesktop
        ? DataGridRowAdapter(
            cells: <Widget>[
              _buildDealer(row.getCells()[0].value),
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
                    locale: 'en_US',
                    symbol: r'$',
                    decimalDigits: 2,
                  ).format(row.getCells()[3].value),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat.yMd().format(row.getCells()[4].value),
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
                    locale: 'en_US',
                    symbol: r'$',
                    decimalDigits: 2,
                  ).format(row.getCells()[6].value),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : DataGridRowAdapter(
            cells: <Widget>[
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
                  DateFormat.yMd().format(row.getCells()[2].value),
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
            ],
          );
  }

  // CustomerInfo Data set

  final List<Image> _dealers = <Image>[
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

  final List<String> _names = <String>[
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
    'Grimes',
  ];

  final List<DateTime> _shippedDates = <DateTime>[
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

  final List<String> _cities = <String>[
    'Graz',
    'Bruxelles',
    'Rosario',
    'Recife',
    'Campinas',
    'Montreal',
    'Tsawassen',
    'Resende',
  ];

  /// Get customer info collection.
  List<Customer> _obtainCustomerDetails(int count) {
    final List<Customer> employeeData = <Customer>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(
        Customer(
          _dealers[i < _dealers.length
              ? i
              : _random.nextInt(_dealers.length - 1)],
          1100 + i,
          _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
          _random.nextInt(1000) + _random.nextDouble(),
          _shippedDates[_random.nextInt(_shippedDates.length - 1)],
          _cities[_random.nextInt(_cities.length - 1)],
          1500.0 + _random.nextInt(100),
        ),
      );
    }
    return employeeData;
  }
}
