///Dart imports
// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

///Package imports
import 'package:flutter/material.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// DataGrid Package
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';

/// Render data pager
class LocalizationDataGrid extends LocalizationSampleView {
  /// Create data pager
  const LocalizationDataGrid({Key? key}) : super(key: key);

  @override
  _LocalizationDataGridState createState() => _LocalizationDataGridState();
}

class _LocalizationDataGridState extends LocalizationSampleViewState {
  /// Default pager height
  static const double _dataPagerHeight = 60;

  /// Determine to decide whether the device in landscape or in portrait.
  bool _isLandscapeInMobileView = false;

  /// Either desktop  or windows platforms
  late bool _isWebOrDesktop;

  /// Number of rows per page
  int _rowsPerPage = 15;

  /// DataGrid column names
  late String _customerName, _price, _orderID, _customerID, _freight, _city;

  /// Selected locale
  late String _selectedLocale;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource _orderInfoDataSource;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _orderInfoDataSource = OrderInfoDataGridSource(
      isWebOrDesktop: true,
      orderDataCount: 300,
      model: model,
      culture: 'English',
    );

    _customerName = 'Name';
    _customerID = 'Customer ID';
    _orderID = 'Order ID';
    _price = 'Price';
    _city = 'City';
    _freight = 'Freight';
    _selectedLocale = model.locale.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLandscapeInMobileView =
        !_isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  Widget _buildDataGrid() {
    return SfDataGrid(
      source: _orderInfoDataSource,
      rowsPerPage: _rowsPerPage,
      allowSorting: true,
      columnWidthMode:
          (_isWebOrDesktop && !model.isMobileResolution) ||
              _isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,
      columns: <GridColumn>[
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
          columnWidthMode: (_isWebOrDesktop && model.isMobileResolution)
              ? ColumnWidthMode.none
              : ColumnWidthMode.fitByColumnName,
          autoFitPadding: const EdgeInsets.all(8),
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
      ],
    );
  }

  Widget _buildDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(selectedItemColor: model.primaryColor),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SfDataPager(
          delegate: _orderInfoDataSource,
          availableRowsPerPage: const <int>[15, 20, 25],
          pageCount: _orderInfoDataSource.orders.length / _rowsPerPage,
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _rowsPerPage = rowsPerPage!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLayoutBuilder() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: constraint.maxHeight - _dataPagerHeight,
              width: constraint.maxWidth,
              child: _buildDataGrid(),
            ),
            Container(
              height: _dataPagerHeight,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.12),
                border: Border(
                  top: BorderSide(
                    width: .5,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
              ),
              child: Align(child: _buildDataPager()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSample(BuildContext context) {
    if (_selectedLocale != model.locale.toString()) {
      _loadDataGridSource();
    }

    return _buildLayoutBuilder();
  }

  void _loadDataGridSource() {
    _selectedLocale = model.locale.toString();
    switch (_selectedLocale) {
      case 'en_US':
        _orderInfoDataSource = OrderInfoDataGridSource(
          isWebOrDesktop: true,
          orderDataCount: 300,
          model: model,
          culture: 'English',
        );
        _customerName = 'Name';
        _customerID = 'Customer ID';
        _orderID = 'Order ID';
        _price = 'Price';
        _city = 'City';
        _freight = 'Freight';
        break;
      case 'ar_AE':
        _orderInfoDataSource = OrderInfoDataGridSource(
          isWebOrDesktop: true,
          orderDataCount: 300,
          culture: 'Arabic',
          model: model,
        );
        _customerName = 'اسم';
        _customerID = 'هوية الزبون';
        _orderID = 'رقم الطلب';
        _price = 'السعر';
        _city = 'مدينة';
        _freight = 'شحن';
        break;
      case 'es_ES':
        _orderInfoDataSource = OrderInfoDataGridSource(
          isWebOrDesktop: true,
          orderDataCount: 300,
          culture: 'Spanish',
          model: model,
        );
        _customerName = 'Nombre';
        _customerID = 'Clienteb ID';
        _orderID = 'Pedido ID ';
        _price = 'Precio';
        _city = 'Ciudad';
        _freight = 'Transporte';
        break;
      case 'fr_FR':
        _orderInfoDataSource = OrderInfoDataGridSource(
          isWebOrDesktop: true,
          orderDataCount: 300,
          culture: 'French',
          model: model,
        );
        _customerName = 'Nom';
        _customerID = 'Client ID ';
        _orderID = 'Commande ID ';
        _price = 'Prix';
        _city = 'Ville';
        _freight = 'Cargaison';
        break;
      case 'zh_CN':
        _orderInfoDataSource = OrderInfoDataGridSource(
          isWebOrDesktop: true,
          orderDataCount: 300,
          culture: 'Chinese',
          model: model,
        );
        _customerName = '姓名';
        _customerID = '顧客 身份 ';
        _orderID = '訂單編號 ';
        _price = '價錢';
        _city = '城';
        _freight = '貨運';
        break;
    }
  }
}
