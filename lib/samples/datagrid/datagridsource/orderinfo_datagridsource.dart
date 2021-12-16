/// Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/samples/datagrid/model/orderinfo.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set order's data collection to data grid source.
class OrderInfoDataGridSource extends DataGridSource {
  /// Creates the order data source class with required details.
  OrderInfoDataGridSource(
      {this.model,
      required this.isWebOrDesktop,
      required this.orderDataCount}) {
    orders = getOrders(orders, orderDataCount);
    buildDataGridRows();
  }

  /// Determine to decide whether the platform is web or desktop.
  final bool isWebOrDesktop;

  /// Instance of SampleModel.
  final SampleModel? model;

  /// Get data count of an order.
  final int orderDataCount;
  final math.Random _random = math.Random();

  /// Instance of an order.
  List<OrderInfo> orders = <OrderInfo>[];

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Building DataGridRows
  void buildDataGridRows() {
    dataGridRows = isWebOrDesktop
        ? orders.map<DataGridRow>((OrderInfo order) {
            return DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: order.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: order.customerId),
              DataGridCell<String>(columnName: 'name', value: order.name),
              DataGridCell<double>(columnName: 'freight', value: order.freight),
              DataGridCell<String>(columnName: 'city', value: order.city),
              DataGridCell<double>(columnName: 'price', value: order.price),
            ]);
          }).toList()
        : orders.map<DataGridRow>((OrderInfo order) {
            return DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: order.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: order.customerId),
              DataGridCell<String>(columnName: 'name', value: order.name),
              DataGridCell<String>(columnName: 'city', value: order.city),
            ]);
          }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if (model != null && (rowIndex % 2) == 0) {
      backgroundColor = model!.backgroundColor.withOpacity(0.07);
    }
    if (isWebOrDesktop) {
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
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(NumberFormat.currency(locale: 'en_US', symbol: r'$')
              .format(row.getCells()[3].value)),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(NumberFormat.currency(
                  locale: 'en_US', symbol: r'$', decimalDigits: 0)
              .format(row.getCells()[5].value)),
        ),
      ]);
    } else {
      Widget buildWidget({
        AlignmentGeometry alignment = Alignment.centerLeft,
        EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
        TextOverflow textOverflow = TextOverflow.ellipsis,
        required Object value,
      }) {
        return Container(
          padding: padding,
          alignment: alignment,
          child: Text(
            value.toString(),
            overflow: textOverflow,
          ),
        );
      }

      return DataGridRowAdapter(
          color: backgroundColor,
          cells: row.getCells().map<Widget>((DataGridCell dataCell) {
            if (dataCell.columnName == 'id' ||
                dataCell.columnName == 'customerId') {
              return buildWidget(
                  alignment: Alignment.centerRight, value: dataCell.value!);
            } else {
              return buildWidget(value: dataCell.value!);
            }
          }).toList(growable: false));
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    orders = getOrders(orders, 15);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    orders = getOrders(orders, 15);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    Widget buildCell(String value, EdgeInsets padding, Alignment alignment) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500)),
      );
    }

    if (summaryRow.showSummaryInRow) {
      return buildCell(
          summaryValue, const EdgeInsets.all(16.0), Alignment.centerLeft);
    } else if (summaryValue.isNotEmpty) {
      if (summaryColumn!.columnName == 'freight') {
        summaryValue = double.parse(summaryValue).toStringAsFixed(2);
      }

      summaryValue = 'Sum: ' +
          NumberFormat.currency(locale: 'en_US', decimalDigits: 0, symbol: r'$')
              .format(double.parse(summaryValue));

      return buildCell(
          summaryValue, const EdgeInsets.all(8.0), Alignment.centerRight);
    }
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }

  //  Order Data's
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

  final List<String> _cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende',
  ];

  /// Get orders collection
  List<OrderInfo> getOrders(List<OrderInfo> orderData, int count) {
    final int startIndex = orderData.isNotEmpty ? orderData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      orderData.add(OrderInfo(
        1000 + i,
        1700 + i,
        _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
        _random.nextInt(1000) + _random.nextDouble(),
        _cities[_random.nextInt(_cities.length - 1)],
        1500.0 + _random.nextInt(100),
      ));
    }
    return orderData;
  }
}
