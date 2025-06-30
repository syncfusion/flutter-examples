/// Package imports
import 'package:flutter/material.dart';

/// Barcode import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';
import 'model/orderinfo.dart';

/// Renders datagrid with selection option(single/multiple and select/unselect)
class RTLModeDataGrid extends DirectionalitySampleView {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  const RTLModeDataGrid({Key? key}) : super(key: key);

  @override
  _SelectionDataGridPageState createState() => _SelectionDataGridPageState();
}

class _SelectionDataGridPageState extends DirectionalitySampleViewState {
  /// Determine to decide whether the device in landscape or in portrait.
  bool _isLandscapeInMobileView = false;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _rtlDataGridSource;

  late bool _isWebOrDesktop;

  late String _customerName, _price, _orderID, _customerID, _freight, _city;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
  }

  List<GridColumn> _obtainColumns() {
    List<GridColumn> columns;

    columns = _isWebOrDesktop
        ? <GridColumn>[
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(_orderID, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 150.0
                  : double.nan,
              columnName: 'customerId',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(_customerID, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(_customerName, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              columnName: 'freight',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(_freight, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(_city, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              width: (_isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              columnName: 'price',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(_price, overflow: TextOverflow.ellipsis),
              ),
            ),
          ]
        : <GridColumn>[
            GridColumn(
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(_orderID, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'customerId',
              width: 110,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(_customerID, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(_customerName, overflow: TextOverflow.ellipsis),
              ),
            ),
            GridColumn(
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(_city, overflow: TextOverflow.ellipsis),
              ),
              columnWidthMode: ColumnWidthMode.lastColumnFill,
            ),
          ];
    return columns;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      columnWidthMode: _isWebOrDesktop || _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      source: _rtlDataGridSource,
      isScrollbarAlwaysShown: true,
      columns: _obtainColumns(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !_isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget buildSample(BuildContext context) {
    _loadDataGridSource();
    return _buildDataGrid();
  }

  void _loadDataGridSource() {
    final String selectedLangauge = model.locale.toString();
    switch (selectedLangauge) {
      case 'en_US':
        _customerName = 'Name';
        _customerID = 'Customer ID';
        _orderID = 'Order ID';
        _price = 'Price';
        _city = 'City';
        _freight = 'Freight';
        _rtlDataGridSource = OrderInfoDataGridSource(
          isWebOrDesktop: _isWebOrDesktop,
          ordersCollection: _fetchOrdersInEnglish(),
        );
        break;
      case 'ar_AE':
        _customerName = 'اسم';
        _customerID = 'هوية الزبون';
        _orderID = 'رقم الطلب';
        _price = 'السعر';
        _city = 'مدينة';
        _freight = 'شحن';
        _rtlDataGridSource = OrderInfoDataGridSource(
          isWebOrDesktop: _isWebOrDesktop,
          ordersCollection: _fetchOrdersInArabic(),
        );
    }
  }

  List<OrderInfo> _fetchOrdersInArabic() {
    return [
      OrderInfo(1000, 1700, 'بيكو', 1270, 'لندن', 1569),
      OrderInfo(1001, 1701, 'كيفي', 1570, 'بويز', 1559),
      OrderInfo(1002, 1702, 'كيفي', 1370, 'بوت', 1599),
      OrderInfo(1003, 1703, 'كيفي', 1560, 'إلجين', 1549),
      OrderInfo(1004, 1704, 'روني', 1670, 'يوجين', 1562),
      OrderInfo(1005, 1705, 'لاندري', 1890, 'كيركلاند', 1581),
      OrderInfo(1006, 1706, 'بيري', 2860, 'لاندر', 1533),
      OrderInfo(1007, 1707, 'بيريز', 3780, 'بورتلاند', 1538),
      OrderInfo(1008, 1708, 'نيوبيري', 1200, 'سان فرانسيسكو', 1541),
      OrderInfo(1009, 1709, 'بيتس', 1680, 'سياتل', 1522),
      OrderInfo(1010, 1710, 'أوينز', 1470, 'برشلونة', 1512),
      OrderInfo(1011, 1711, 'توماس', 2370, 'مدريد', 1518),
      OrderInfo(1012, 1712, 'جيفرسون', 4470, 'بيلبوا', 1528),
      OrderInfo(1013, 1713, 'فارغاس', 1770, 'آخن', 1532),
      OrderInfo(1014, 1714, 'غرايمز', 6760, 'برلين', 1511),
      OrderInfo(1015, 1715, 'ستارك', 4770, 'براندنبورغ', 1505),
      OrderInfo(1016, 1716, 'كراولي', 3070, 'كونوالد', 1503),
      OrderInfo(1017, 1717, 'فولكو', 4970, 'لايبزيغ', 1577),
      OrderInfo(1018, 1718, 'ايرفين', 60770, 'مانهايم', 1572),
      OrderInfo(1019, 1719, 'فوليج', 3330, 'مونستر', 1579),
      OrderInfo(1020, 1720, 'واديل', 2900, 'البوكيرك', 1555),
      OrderInfo(1021, 1721, 'فرانس', 1850, 'باريس', 1556),
      OrderInfo(1022, 1722, 'وارث', 4580, ' بروكسل', 1524),
      OrderInfo(1023, 1723, 'لينود', 3970, 'روزاريو', 1540),
      OrderInfo(1024, 1724, 'سيموب', 1040, 'ريسيفي', 1501),
      OrderInfo(1025, 1725, 'مرحى', 1130, 'غراتس', 1598),
      OrderInfo(1026, 1726, 'ريسكو', 8970, 'مونتريال', 1592),
      OrderInfo(1027, 1727, 'السباعيات', 5900, 'تساواسن', 1580),
      OrderInfo(1028, 1728, 'فافي', 4390, 'كامبيناس', 1570),
      OrderInfo(1029, 1729, 'الفكي', 2910, 'ريسيندي', 1560),
    ];
  }

  List<OrderInfo> _fetchOrdersInEnglish() {
    return [
      OrderInfo(1000, 1700, 'Picco', 1270, 'London', 1569),
      OrderInfo(1001, 1701, 'Keefe', 1570, 'Boise', 1559),
      OrderInfo(1002, 1702, 'Ellis', 1370, 'Butte', 1599),
      OrderInfo(1003, 1703, 'Mendoza', 1560, 'Elgin', 1549),
      OrderInfo(1004, 1704, 'Rooney', 1670, 'Eugene', 1562),
      OrderInfo(1005, 1705, 'Landry', 1890, 'Kirkland', 1581),
      OrderInfo(1006, 1706, 'Perry', 2860, 'Lander', 1533),
      OrderInfo(1007, 1707, 'Perez', 3780, 'Portland', 1538),
      OrderInfo(1008, 1708, 'Newberry', 1200, 'San Francisco', 1541),
      OrderInfo(1009, 1709, 'Betts', 1680, 'Seattle', 1522),
      OrderInfo(1010, 1710, 'Owens', 1470, 'Barcelona', 1512),
      OrderInfo(1011, 1711, 'Thomas', 2370, 'Madrid', 1518),
      OrderInfo(1012, 1712, 'Jefferson', 4470, 'Bilboa', 1528),
      OrderInfo(1013, 1713, 'Vargas', 1770, 'Aachen', 1532),
      OrderInfo(1014, 1714, 'Grimes', 6760, 'Berlin', 1511),
      OrderInfo(1015, 1715, 'Stark', 4770, 'Brandenburg', 1505),
      OrderInfo(1016, 1716, 'Crowley', 3070, 'Cunewalde', 1503),
      OrderInfo(1017, 1717, 'Volco', 4970, 'Leipzig', 1577),
      OrderInfo(1018, 1718, 'Irvine', 60770, 'Mannheim', 1572),
      OrderInfo(1019, 1719, 'Folig', 3330, 'Münster', 1579),
      OrderInfo(1020, 1720, 'Waddell', 2900, 'Albuquerque', 1555),
      OrderInfo(1021, 1721, 'Frans', 1850, 'Paris', 1556),
      OrderInfo(1022, 1722, 'Warth', 4580, 'Bruxelles', 1524),
      OrderInfo(1023, 1723, 'Linod', 3970, 'Rosario', 1540),
      OrderInfo(1024, 1724, 'Simop', 1040, 'Recife', 1501),
      OrderInfo(1025, 1725, 'Merep', 1130, 'Graz', 1598),
      OrderInfo(1026, 1726, 'Riscu', 8970, 'Montreal', 1592),
      OrderInfo(1027, 1727, 'Seves', 5900, 'Tsawassen', 1580),
      OrderInfo(1028, 1728, 'Vaffe', 4390, 'Campinas', 1570),
      OrderInfo(1029, 1729, 'Alfki', 2910, 'Resende', 1560),
    ];
  }
}
