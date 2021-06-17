///Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// DataGrid Package
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Render data pager
class PagingDataGrid extends SampleView {
  /// Create data pager
  const PagingDataGrid({Key? key}) : super(key: key);

  @override
  _PagingDataGridState createState() => _PagingDataGridState();
}

class _PagingDataGridState extends SampleViewState {
  // Default pager height
  static const double dataPagerHeight = 60;

  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  late bool isWebOrDesktop;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  _OrderInfoDataSource orderInfoDataSource = _OrderInfoDataSource();

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

  Widget _buildDataGrid() {
    return SfDataGrid(
        source: orderInfoDataSource,
        columnWidthMode: (isWebOrDesktop && model.isMobileResolution)
            ? ColumnWidthMode.none
            : ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridTextColumn(
              columnName: 'orderID',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Order ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none),
          GridTextColumn(
              columnName: 'customerID',
              width: 130.0,
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Customer Name',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridTextColumn(
            columnName: 'orderDate',
            width: !isWebOrDesktop
                ? 110
                : (isWebOrDesktop && model.isMobileResolution)
                    ? 120.0
                    : double.nan,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Order Date',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridTextColumn(
            columnName: 'freight',
            width: (isWebOrDesktop && model.isMobileResolution)
                ? 120.0
                : double.nan,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Freight',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnWidthMode: isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none,
          ),
          GridTextColumn(
            columnName: 'shippingDate',
            width: !isWebOrDesktop
                ? 120
                : (isWebOrDesktop && model.isMobileResolution)
                    ? 140.0
                    : double.nan,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Shipped Date',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridTextColumn(
              columnName: 'shipCountry',
              width: !isWebOrDesktop
                  ? 120
                  : (isWebOrDesktop && model.isMobileResolution)
                      ? 120.0
                      : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Ship Country',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ]);
  }

  Widget _buildDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        brightness: model.themeData.brightness,
        selectedItemColor: model.backgroundColor,
      ),
      child: SfDataPager(
        delegate: orderInfoDataSource,
        pageCount:
            orderInfoDataSource.orders.length / orderInfoDataSource.rowsPerPage,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildLayoutBuilder() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      return Column(
        children: <Widget>[
          SizedBox(
              height: constraint.maxHeight - dataPagerHeight,
              width: constraint.maxWidth,
              child: _buildDataGrid()),
          Container(
            height: dataPagerHeight,
            decoration: BoxDecoration(
                color: SfTheme.of(context).dataPagerThemeData.backgroundColor,
                border: Border(
                    top: BorderSide(
                        width: .5,
                        color: SfTheme.of(context)
                            .dataGridThemeData
                            .gridLineColor),
                    bottom: BorderSide.none,
                    left: BorderSide.none,
                    right: BorderSide.none)),
            child: Align(alignment: Alignment.center, child: _buildDataPager()),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayoutBuilder();
  }
}

class _OrderInfoDataSource extends DataGridSource {
  _OrderInfoDataSource() {
    orders = getOrders(300);
    paginatedOrders = orders.getRange(0, 19).toList(growable: false);
    buildPaginateDataGridRows();
  }

  final int rowsPerPage = 15;
  List<_OrderInfo> orders = <_OrderInfo>[];
  List<_OrderInfo> paginatedOrders = <_OrderInfo>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Building PaginateDataGridRows

  void buildPaginateDataGridRows() {
    dataGridRows = paginatedOrders.map<DataGridRow>((_OrderInfo orderInfo) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'orderID', value: orderInfo.orderID),
        DataGridCell<String>(
            columnName: 'customerID', value: orderInfo.customerID),
        DataGridCell<DateTime>(
            columnName: 'orderDate', value: orderInfo.orderData),
        DataGridCell<double>(columnName: 'freight', value: orderInfo.freight),
        DataGridCell<DateTime>(
            columnName: 'shippingDate', value: orderInfo.shippingDate),
        DataGridCell<String>(
            columnName: 'shipCountry', value: orderInfo.shipCountry),
      ]);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerRight,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Text(
            DateFormat.yMd().format(row.getCells()[2].value).toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: r'$')
                .format(row.getCells()[3].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Text(
            DateFormat.yMd().format(row.getCells()[4].value).toString(),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          )),
    ]);
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * rowsPerPage;
    final int endIndex = startIndex + rowsPerPage;
    paginatedOrders =
        orders.getRange(startIndex, endIndex).toList(growable: false);
    buildPaginateDataGridRows();
    notifyListeners();
    return true;
  }

  // Order Data's

  final Random random = Random();
  final List<DateTime> shippedDate = <DateTime>[];
  final Map<String, List<String>> shipCity = <String, List<String>>{
    'Argentina': <String>['Rosario'],
    'Austria': <String>['Graz', 'Salzburg'],
    'Belgium': <String>['Bruxelles', 'Charleroi'],
    'Brazil': <String>['Campinas', 'Resende', 'Recife', 'Manaus'],
    'Canada': <String>['Montréal', 'Tsawassen', 'Vancouver'],
    'Denmark': <String>['Århus', 'København'],
    'Finland': <String>['Helsinki', 'Oulu'],
    'France': <String>[
      'Lille',
      'Lyon',
      'Marseille',
      'Nantes',
      'Paris',
      'Reims',
      'Strasbourg',
      'Toulouse',
      'Versailles'
    ],
    'Germany': <String>[
      'Aachen',
      'Berlin',
      'Brandenburg',
      'Cunewalde',
      'Frankfurt',
      'Köln',
      'Leipzig',
      'Mannheim',
      'München',
      'Münster',
      'Stuttgart'
    ],
    'Ireland': <String>['Cork'],
    'Italy': <String>['Bergamo', 'Reggio', 'Torino'],
    'Mexico': <String>['México D.F.'],
    'Norway': <String>['Stavern'],
    'Poland': <String>['Warszawa'],
    'Portugal': <String>['Lisboa'],
    'Spain': <String>['Barcelona', 'Madrid', 'Sevilla'],
    'Sweden': <String>['Bräcke', 'Luleå'],
    'Switzerland': <String>['Bern', 'Genève'],
    'UK': <String>['Colchester', 'Hedge End', 'London'],
    'USA': <String>[
      'Albuquerque',
      'Anchorage',
      'Boise',
      'Butte',
      'Elgin',
      'Eugene',
      'Kirkland',
      'Lander',
      'Portland',
      'San Francisco',
      'Seattle',
    ],
    'Venezuela': <String>[
      'Barquisimeto',
      'Caracas',
      'I. de Margarita',
      'San Cristóbal'
    ]
  };

  List<String> genders = <String>[
    'Male',
    'Female',
    'Female',
    'Female',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Female',
    'Female',
    'Female',
    'Male',
    'Male',
    'Male',
    'Female',
    'Female',
    'Female',
    'Male',
    'Male',
    'Male',
    'Male'
  ];

  List<String> firstNames = <String>[
    'Kyle',
    'Gina',
    'Irene',
    'Katie',
    'Michael',
    'Torrey',
    'William',
    'Bill',
    'Daniel',
    'Frank',
    'Brenda',
    'Danielle',
    'Fiona',
    'Howard',
    'Jack',
    'Larry',
    'Holly',
    'Jennifer',
    'Liz',
    'Pete',
    'Steve',
    'Vince',
    'Zeke',
    'Oscar',
    'Ralph',
  ];

  List<String> lastNames = <String>[
    'Adams',
    'Crowley',
    'Ellis',
    'Gable',
    'Irvine',
    'Keefe',
    'Mendoza',
    'Owens',
    'Rooney',
    'Waddell',
    'Thomas',
    'Betts',
    'Doran',
    'Holmes',
    'Jefferson',
    'Landry',
    'Newberry',
    'Perez',
    'Spencer',
    'Vargas',
    'Grimes',
    'Edwards',
    'Stark',
    'Cruise',
    'Fitz',
    'Chief',
    'Blanc',
    'Perry',
    'Stone',
    'Williams',
    'Lane',
    'Jobs'
  ];

  List<String> customerID = <String>[
    'Alfki',
    'Frans',
    'Merep',
    'Folko',
    'Simob',
    'Warth',
    'Vaffe',
    'Furib',
    'Seves',
    'Linod',
    'Riscu',
    'Picco',
    'Blonp',
    'Welli',
    'Folig'
  ];

  List<String> shipCountry = <String>[
    'Argentina',
    'Austria',
    'Belgium',
    'Brazil',
    'Canada',
    'Denmark',
    'Finland',
    'France',
    'Germany',
    'Ireland',
    'Italy',
    'Mexico',
    'Norway',
    'Poland',
    'Portugal',
    'Spain',
    'Sweden',
    'UK',
    'USA',
  ];

  List<_OrderInfo> getOrders(int count) {
    shippedDate
      ..clear()
      ..addAll(_getDateBetween(2000, 2014, count));
    final List<_OrderInfo> orderDetails = <_OrderInfo>[];

    for (int i = 10001; i <= count + 10000; i++) {
      final String _shipCountry =
          shipCountry[random.nextInt(shipCountry.length)];
      final List<String> _shipCityColl = shipCity[_shipCountry]!;
      final DateTime shippedData = shippedDate[i - 10001];
      final DateTime orderedData =
          DateTime(shippedData.year, shippedData.month, shippedData.day - 2);
      orderDetails.add(_OrderInfo(
        orderID: i.toString(),
        customerID: customerID[random.nextInt(15)],
        employeeID: next(1700, 1800).toString(),
        firstName: firstNames[random.nextInt(15)],
        lastName: lastNames[random.nextInt(15)],
        gender: genders[random.nextInt(5)],
        shipCountry: _shipCountry,
        orderData: orderedData,
        shippingDate: shippedData,
        freight: random.nextInt(1000) + random.nextDouble(),
        isClosed: (i + random.nextInt(10)) > 2,
        shipCity: _shipCityColl[random.nextInt(_shipCityColl.length)],
      ));
    }

    return orderDetails;
  }

  int next(int min, int max) => min + random.nextInt(max - min);

  List<DateTime> _getDateBetween(int startYear, int endYear, int count) {
    final List<DateTime> date = <DateTime>[];

    for (int i = 0; i < count; i++) {
      final int year = next(startYear, endYear);
      final int month = random.nextInt(13);
      final int day = random.nextInt(31);

      date.add(DateTime(year, month, day));
    }

    return date;
  }
}

/// Order Details
class _OrderInfo {
  _OrderInfo(
      {required this.orderID,
      required this.employeeID,
      required this.customerID,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.shipCity,
      required this.shipCountry,
      required this.freight,
      required this.shippingDate,
      required this.orderData,
      required this.isClosed});

  final String orderID;
  final String employeeID;
  final String customerID;
  final String firstName;
  final String lastName;
  final String gender;
  final String shipCity;
  final String shipCountry;
  final double freight;
  final DateTime shippingDate;
  final DateTime orderData;
  final bool isClosed;
}
