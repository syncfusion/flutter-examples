/// Dart import
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/model.dart';
import '../model/orderinfo.dart';

/// Set order's data collection to data grid source.
class OrderInfoDataGridSource extends DataGridSource {
  /// Creates the order data source class with required details.
  OrderInfoDataGridSource({
    this.model,
    required this.isWebOrDesktop,
    this.orderDataCount,
    this.ordersCollection,
    this.culture,
    bool? isFilteringSample,
    bool isGrouping = false,
  }) {
    this.isFilteringSample = isFilteringSample ?? false;
    orders =
        ordersCollection ??
        _fetchOrders(orders, orderDataCount ?? 100, culture: culture ?? '');
    currencySymbol = _obtainCurrencySymbol();
    buildDataGridRows(isGrouping);
  }

  /// Determine to decide whether the platform is web or desktop.
  final bool isWebOrDesktop;

  /// Instance of SampleModel.
  final SampleModel? model;

  /// Localization Source.
  String? culture;

  /// Get data count of an order.
  int? orderDataCount;
  final math.Random _random = math.Random.secure();

  /// Instance of an order.
  List<OrderInfo> orders = <OrderInfo>[];

  /// Instance of an order collection for rtl sample
  List<OrderInfo>? ordersCollection;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Currency symbol for culture.
  String currencySymbol = '';

  /// Checks whether the source is used for the filtering sample or not.
  late bool isFilteringSample;

  /// Building DataGridRows.
  void buildDataGridRows(bool isGrouping) {
    dataGridRows = isWebOrDesktop
        ? orders.map<DataGridRow>((OrderInfo order) {
            if (isGrouping) {
              {
                return DataGridRow(
                  cells: <DataGridCell>[
                    DataGridCell<int>(
                      columnName: _fetchColumnName('ID'),
                      value: order.id,
                    ),
                    DataGridCell<int>(
                      columnName: _fetchColumnName('CustomerId'),
                      value: order.customerId,
                    ),
                    DataGridCell<String>(
                      columnName: _fetchColumnName('Name'),
                      value: order.name,
                    ),
                    DataGridCell<double>(
                      columnName: _fetchColumnName('Freight'),
                      value: order.freight,
                    ),
                    DataGridCell<String>(
                      columnName: _fetchColumnName('City'),
                      value: order.city,
                    ),
                    DataGridCell<double>(
                      columnName: _fetchColumnName('Price'),
                      value: order.price,
                    ),
                  ],
                );
              }
            } else {
              return DataGridRow(
                cells: <DataGridCell>[
                  DataGridCell<int>(
                    columnName: _fetchColumnName('id'),
                    value: order.id,
                  ),
                  DataGridCell<int>(
                    columnName: _fetchColumnName('customerId'),
                    value: order.customerId,
                  ),
                  DataGridCell<String>(
                    columnName: _fetchColumnName('name'),
                    value: order.name,
                  ),
                  DataGridCell<double>(
                    columnName: _fetchColumnName('freight'),
                    value: order.freight,
                  ),
                  DataGridCell<String>(
                    columnName: _fetchColumnName('city'),
                    value: order.city,
                  ),
                  DataGridCell<double>(
                    columnName: _fetchColumnName('price'),
                    value: order.price,
                  ),
                ],
              );
            }
          }).toList()
        : orders.map<DataGridRow>((OrderInfo order) {
            return DataGridRow(
              cells: <DataGridCell>[
                DataGridCell<int>(
                  columnName: _fetchColumnName('id'),
                  value: order.id,
                ),
                DataGridCell<int>(
                  columnName: _fetchColumnName('customerId'),
                  value: order.customerId,
                ),
                DataGridCell<String>(
                  columnName: _fetchColumnName('name'),
                  value: order.name,
                ),
                DataGridCell<String>(
                  columnName: _fetchColumnName('city'),
                  value: order.city,
                ),
              ],
            );
          }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if (model != null && (rowIndex % 2) == 0 && culture == null) {
      backgroundColor = model!.primaryColor.withValues(alpha: 0.07);
    }
    if (isWebOrDesktop) {
      return DataGridRowAdapter(
        color: backgroundColor,
        cells: <Widget>[
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
            child: Text(row.getCells()[2].value.toString()),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: Text(
              NumberFormat.currency(
                locale: 'en_US',
                symbol: currencySymbol,
              ).format(row.getCells()[3].value),
            ),
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
            child: Text(
              NumberFormat.currency(
                locale: 'en_US',
                symbol: currencySymbol,
                decimalDigits: 0,
              ).format(row.getCells()[5].value),
            ),
          ),
        ],
      );
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
          child: Text(value.toString(), overflow: textOverflow),
        );
      }

      return DataGridRowAdapter(
        color: backgroundColor,
        cells: row
            .getCells()
            .map<Widget>((DataGridCell dataCell) {
              if (dataCell.columnName == _fetchColumnName('id') ||
                  dataCell.columnName == _fetchColumnName('customerId')) {
                return buildWidget(
                  alignment: Alignment.centerRight,
                  value: dataCell.value!,
                );
              } else {
                return buildWidget(value: dataCell.value!);
              }
            })
            .toList(growable: false),
      );
    }
  }

  /// Currency symbol
  String _obtainCurrencySymbol() {
    if (culture != null) {
      final format = NumberFormat.compactSimpleCurrency(
        locale: model!.locale.toString(),
      );
      return format.currencySymbol;
    } else {
      final format = NumberFormat.simpleCurrency();
      return format.currencySymbol;
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    orders = _fetchOrders(orders, 15);
    buildDataGridRows(false);
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    orders = _fetchOrders(orders, 15);
    buildDataGridRows(false);
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(String value, EdgeInsets padding, Alignment alignment) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    if (summaryRow.showSummaryInRow) {
      widget = buildCell(
        summaryValue,
        const EdgeInsets.all(16.0),
        Alignment.centerLeft,
      );
    } else if (summaryValue.isNotEmpty) {
      if (summaryColumn!.columnName == 'freight') {
        summaryValue = double.parse(summaryValue).toStringAsFixed(2);
      }

      summaryValue =
          'Sum: ' +
          NumberFormat.currency(
            locale: 'en_US',
            decimalDigits: 0,
            symbol: r'$',
          ).format(double.parse(summaryValue));

      widget = buildCell(
        summaryValue,
        const EdgeInsets.all(8.0),
        Alignment.centerRight,
      );
    }
    return widget;
  }

  @override
  Widget? buildGroupCaptionCellWidget(
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text(summaryValue),
    );
  }

  /// Provides the column name.
  String _fetchColumnName(String columnName) {
    if (isFilteringSample) {
      switch (columnName) {
        case 'id':
          return 'Order ID';
        case 'customerId':
          return 'Customer ID';
        case 'name':
          return 'Name';
        case 'freight':
          return 'Freight';
        case 'city':
          return 'City';
        case 'price':
          return 'Price';
        default:
          return columnName;
      }
    }
    return columnName;
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }

  //  Order Data's
  final List<String> _names = <String>[
    'Crowley',
    'Blonp',
    'Folko',
    'Irvine',
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

  final List<String> _frenchNames = <String>[
    'Crowley',
    'Blonp',
    'Folko',
    'Irvine',
    'Folig',
    'Pico',
    'François',
    'Warth',
    'Linod',
    'Simop',
    'Merep',
    'Riscu',
    'Sèves',
    'Vaffé',
    'Alfki',
  ];

  final List<String> _spanishNames = <String>[
    'Crowley',
    'Blonp',
    'Folko',
    'Irvine',
    'Folig',
    'Cima',
    'francés',
    'Warth',
    'lindod',
    'Simop',
    'Merep',
    'Riesgo',
    'Suyas',
    'Gofre',
    'Alfki',
  ];

  final List<String> _chineseNames = <String>[
    '克勞利',
    '布隆普',
    '民間',
    '爾灣',
    '佛利格',
    '頂峰',
    '法語',
    '沃思',
    '林諾德',
    '辛普',
    '梅雷普',
    '風險',
    '塞維斯',
    '胡扯',
    '阿里基',
  ];

  final List<String> _arabicNames = <String>[
    'كراولي',
    'بلونب',
    'فولكو',
    'ايرفين',
    'فوليج',
    'بيكو',
    'فرانس',
    'وارث',
    'لينود',
    'سيموب',
    'مرحى',
    'ريسكو',
    'السباعيات',
    'فافي',
    'الفكي',
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

  final List<String> _chineseCties = <String>[
    '布魯塞爾',
    '羅薩里奧',
    '累西腓',
    '格拉茨',
    '蒙特利爾',
    '薩瓦森',
    '坎皮納斯',
    '重新發送',
  ];

  final List<String> _frenchCties = <String>[
    'Bruxelles',
    'Rosario',
    'Récife',
    'Graz',
    'Montréal',
    'Tsawassen',
    'Campinas',
    'Renvoyez',
  ];

  final List<String> _spanishCties = <String>[
    'Bruselas',
    'Rosario',
    'Recife',
    'Graz',
    'Montréal',
    'Tsawassen',
    'Campiñas',
    'Reenviar',
  ];

  final List<String> _arabicCties = <String>[
    ' بروكسل',
    'روزاريو',
    'ريسيفي',
    'غراتس',
    'مونتريال',
    'تساواسن',
    'كامبيناس',
    'ريسيندي',
  ];

  /// Get orders collection
  List<OrderInfo> _fetchOrders(
    List<OrderInfo> orderData,
    int count, {
    String? culture,
  }) {
    final int startIndex = orderData.isNotEmpty ? orderData.length : 0,
        endIndex = startIndex + count;
    List<String> city;
    List<String> names;

    if (culture == 'Chinese') {
      city = _chineseCties;
      names = _chineseNames;
    } else if (culture == 'Arabic') {
      city = _arabicCties;
      names = _arabicNames;
    } else if (culture == 'French') {
      city = _frenchCties;
      names = _frenchNames;
    } else if (culture == 'Spanish') {
      city = _spanishCties;
      names = _spanishNames;
    } else {
      city = _cities;
      names = _names;
    }

    for (int i = startIndex; i < endIndex; i++) {
      orderData.add(
        OrderInfo(
          1000 + i,
          1700 + i,
          names[i < names.length ? i : _random.nextInt(names.length - 1)],
          _random.nextInt(1000) + _random.nextDouble(),
          city[_random.nextInt(city.length - 1)],
          1500.0 + _random.nextInt(100),
        ),
      );
    }
    return orderData;
  }
}
