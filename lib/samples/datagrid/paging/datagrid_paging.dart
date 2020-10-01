///Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid Package
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Local import
import '../../../model/sample_view.dart';

/// Render data pager
class PagingDataGrid extends SampleView {
  /// Create data pager
  const PagingDataGrid({Key key}) : super(key: key);

  @override
  _PagingDataGridState createState() => _PagingDataGridState();
}

List<_OrderInfo> _dataSource = [];
List<_OrderInfo> _paginatedDataSource = [];

class _PagingDataGridState extends SampleViewState {
  static const double _kMobileModeInWeb = 767.0;
  static const double dataPagerHeight = 60;
  bool _isLandscapeInMobileView;

  final _OrderInfoRepository _repository = _OrderInfoRepository();
  final _OrderInfoDataSource _orderInfoDataSource = _OrderInfoDataSource();

  @override
  void initState() {
    super.initState();
    _dataSource = _repository.getOrderDetails(300);
    _paginatedDataSource = _dataSource.getRange(0, 19).toList(growable: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView = !model.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  Widget _getDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
        source: _orderInfoDataSource,
        columnWidthMode: constraint.maxWidth < _kMobileModeInWeb
            ? ColumnWidthMode.auto
            : ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridNumericColumn(mappingName: 'orderID', headerText: 'Order ID')
            ..columnWidthMode = _isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none
            ..headerTextAlignment = Alignment.centerRight,
          GridTextColumn(
              mappingName: 'customerID', headerText: 'Customer Name'),
          GridDateTimeColumn(mappingName: 'orderDate', headerText: 'Order Date')
            ..dateFormat = DateFormat.yMd(),
          GridNumericColumn(mappingName: 'freight', headerText: 'Freight')
            ..columnWidthMode = _isLandscapeInMobileView
                ? ColumnWidthMode.fill
                : ColumnWidthMode.none
            ..headerTextAlignment = Alignment.center
            ..textAlignment = Alignment.center
            ..numberFormat =
                NumberFormat.currency(locale: 'en_US', symbol: '\$'),
          GridDateTimeColumn(
              mappingName: 'shippingDate', headerText: 'Shipped Date')
            ..dateFormat = DateFormat.yMd(),
          GridTextColumn(
              mappingName: 'shipCountry', headerText: 'Ship Country'),
        ]);
  }

  Widget _getDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
          brightness: model.themeData.brightness,
          selectedItemColor: model.backgroundColor,
          selectedItemTextStyle: TextStyle(
              color: model.textColor,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400)),
      child: SfDataPager(
        delegate: _orderInfoDataSource,
        rowsPerPage: 20,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _getChild() {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        children: [
          SizedBox(
              height: constraint.maxHeight - dataPagerHeight,
              width: constraint.maxWidth,
              child: _getDataGrid(constraint)),
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
            child: Align(alignment: Alignment.center, child: _getDataPager()),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getChild();
  }
}

class _OrderInfoDataSource extends DataGridSource<_OrderInfo> {
  @override
  List<_OrderInfo> get dataSource => _paginatedDataSource;

  @override
  Object getValue(_OrderInfo _orderInfo, String columnName) {
    switch (columnName) {
      case 'orderID':
        return _orderInfo.orderID;
        break;
      case 'employeeID':
        return _orderInfo.employeeID;
        break;
      case 'customerID':
        return _orderInfo.customerID;
        break;
      case 'firstName':
        return _orderInfo.firstName;
        break;
      case 'lastName':
        return _orderInfo.lastName;
        break;
      case 'gender':
        return _orderInfo.gender;
        break;
      case 'shipCity':
        return _orderInfo.shipCity;
        break;
      case 'shipCountry':
        return _orderInfo.shipCountry;
        break;
      case 'freight':
        return _orderInfo.freight;
        break;
      case 'shippingDate':
        return _orderInfo.shippingDate;
        break;
      case 'orderDate':
        return _orderInfo.orderData;
        break;
      case 'isClosed':
        return _orderInfo.isClosed;
        break;
      default:
        return '';
        break;
    }
  }

  @override
  int get rowCount => _dataSource.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    _paginatedDataSource = _dataSource
        .getRange(startRowIndex, startRowIndex + rowsPerPage)
        .toList(growable: false);
    notifyDataSourceListeners();
    return true;
  }
}

/// Order Details
class _OrderInfo {
  _OrderInfo(
      {this.orderID,
      this.employeeID,
      this.customerID,
      this.firstName,
      this.lastName,
      this.gender,
      this.shipCity,
      this.shipCountry,
      this.freight,
      this.shippingDate,
      this.orderData,
      this.isClosed});

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

class _OrderInfoRepository {
  final List<DateTime> shippedDate = [];
  final Random random = Random();
  final Map<String, List<String>> shipCity = {
    'Argentina': ['Rosario'],
    'Austria': ['Graz', 'Salzburg'],
    'Belgium': ['Bruxelles', 'Charleroi'],
    'Brazil': ['Campinas', 'Resende', 'Recife', 'Manaus'],
    'Canada': ['Montréal', 'Tsawassen', 'Vancouver'],
    'Denmark': ['Århus', 'København'],
    'Finland': ['Helsinki', 'Oulu'],
    'France': [
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
    'Germany': [
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
    'Ireland': ['Cork'],
    'Italy': ['Bergamo', 'Reggio', 'Torino'],
    'Mexico': ['México D.F.'],
    'Norway': ['Stavern'],
    'Poland': ['Warszawa'],
    'Portugal': ['Lisboa'],
    'Spain': ['Barcelona', 'Madrid', 'Sevilla'],
    'Sweden': ['Bräcke', 'Luleå'],
    'Switzerland': ['Bern', 'Genève'],
    'UK': ['Colchester', 'Hedge End', 'London'],
    'USA': [
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
    'Venezuela': ['Barquisimeto', 'Caracas', 'I. de Margarita', 'San Cristóbal']
  };

  List<String> genders = [
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

  List<String> firstNames = [
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

  List<String> lastNames = [
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

  List<String> customerID = [
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

  List<String> shipCountry = [
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

  List<_OrderInfo> getOrderDetails(int count) {
    shippedDate
      ..clear()
      ..addAll(_getDateBetween(2000, 2014, count));
    List<_OrderInfo> orderDetails = [];

    for (int i = 10001; i <= count + 10000; i++) {
      final String ship_Country =
          shipCountry[random.nextInt(shipCountry.length)];
      final List<String> ship_CityColl = shipCity[ship_Country];
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
        shipCountry: ship_Country,
        orderData: orderedData,
        shippingDate: shippedData,
        freight: (random.nextInt(1000) + random.nextDouble()),
        isClosed: (i + (random.nextInt(10)) > 2) ? true : false,
        shipCity: ship_CityColl[random.nextInt(ship_CityColl.length)],
      ));
    }

    return orderDetails;
  }

  int next(int min, int max) => min + random.nextInt(max - min);

  List<DateTime> _getDateBetween(int startYear, int endYear, int count) {
    List<DateTime> date = [];

    for (int i = 0; i < count; i++) {
      int year = next(startYear, endYear);
      int month = random.nextInt(13);
      int day = random.nextInt(31);

      date.add(DateTime(year, month, day));
    }

    return date;
  }
}
