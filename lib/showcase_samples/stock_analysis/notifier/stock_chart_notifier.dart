import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

import '../enum.dart';
import '../model/chart_data.dart';
import '../model/chart_settings.dart';
import '../model/user_detail.dart';
import '../model/watchlist.dart';
import '../stock_home/stock_chart_view/stock_chart_interaction.dart';

/// Provider for managing stock data.
class StockChartProvider extends ChangeNotifier {
  // Load initial data when provider is created.
  StockChartProvider() {
    // Create default watchlist
    final Watchlist defaultWatchlist = Watchlist(
      id: 'default',
      name: 'Watchlist 1',
    );
    _watchlists.add(defaultWatchlist);
    _selectedWatchlist = defaultWatchlist;
  }

  Map<Stock, StockData> get stockData => _stockData;
  final Map<Stock, StockData> _stockData = {};
  set stockData(Map<Stock, StockData> newStockData) {
    if (_stockData != newStockData) {
      _stockData.clear();
      _stockData.addAll(newStockData);
      notifyListeners();
    }
  }

  // Add these properties to the StockChartProvider class
  final List<Watchlist> _watchlists = [];
  List<Watchlist> get watchlists => _watchlists;

  Watchlist? _selectedWatchlist;
  Watchlist? get selectedWatchlist => _selectedWatchlist;
  set selectedWatchlist(Watchlist? watchlist) {
    if (_selectedWatchlist != watchlist) {
      _selectedWatchlist = watchlist;
      notifyListeners();
    }
  }

  // Add these methods
  void addWatchlist(String name) {
    final id = 'watchlist_${DateTime.now().millisecondsSinceEpoch}';
    final watchlist = Watchlist(id: id, name: name);
    _watchlists.add(watchlist);
    notifyListeners();
  }

  void removeWatchlist(String id) {
    _watchlists.removeWhere((watchlist) => watchlist.id == id);
    if (_selectedWatchlist?.id == id) {
      _removeFavorites();
      _updateFavoritesAfterRemove();
      _selectedWatchlist = _watchlists.isNotEmpty ? _watchlists.first : null;
    }
    notifyListeners();
  }

  void _removeFavorites() {
    if (_selectedWatchlist != null) {
      for (final Stock stock in _selectedWatchlist!.stocks) {
        stockData[stock]?.isFavorite = false;
      }
    }
  }

  void _updateFavoritesAfterRemove() {
    if (_watchlists.isNotEmpty) {
      for (final Watchlist watchlist in _watchlists) {
        for (final Stock stock in watchlist.stocks) {
          stockData[stock]?.isFavorite = false;
        }
      }
    }
  }

  void addStockToWatchlist(
    Stock stock,
    Watchlist watchlist, {
    bool isNotify = true,
  }) {
    watchlist.addStock(stock);
    stockData[stock]?.isFavorite = true;
    if (isNotify) {
      notifyListeners();
    }
  }

  void removeStockFromWatchlist(
    Stock stock,
    Watchlist watchlist, {
    bool isNotify = true,
  }) {
    watchlist.removeStock(stock);
    stockData[stock]?.isFavorite = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  bool isStockInWatchlist(StockData stockData) {
    return _selectedWatchlist?.containsStock(stockData.stock) ?? false;
  }

  void toggleStockInWatchlist(Stock stock) {
    if (_selectedWatchlist != null) {
      if (_selectedWatchlist!.containsStock(stock)) {
        _selectedWatchlist!.removeStock(stock);
        stockData[stock]?.isFavorite = false;
      } else {
        _selectedWatchlist!.addStock(stock);
        stockData[stock]?.isFavorite = true;
      }
      // This ensures UI updates properly
      isWatchListAdded = !isWatchListAdded;
      notifyListeners();
    }
  }

  List<StockData> get watchListedStocks => _watchListedStocks;
  final List<StockData> _watchListedStocks = [];
  set watchListedStocks(List<StockData> newWatchListedStocks) {
    if (_watchListedStocks != newWatchListedStocks) {
      _watchListedStocks.clear();
      _watchListedStocks.addAll(newWatchListedStocks);
      notifyListeners();
    }
  }

  // List<Data> _data = <Data>[];

  // Temporary settings used while in dialog.
  ChartSettings get chartSettings => _chartSettings;
  ChartSettings _chartSettings = ChartSettings();

  ChartSettings get tempSettings => _tempSettings;
  ChartSettings _tempSettings = ChartSettings();

  bool _isFiltering = false;
  bool get isFiltering => _isFiltering;

  bool _isRangeControllerUpdate = false;
  bool get isRangeControllerUpdate => _isRangeControllerUpdate;
  set isRangeControllerUpdate(bool value) {
    _isRangeControllerUpdate = value;
    notifyListeners();
  }

  RangeController? _chartRangeController;
  RangeController? get chartRangeController => _chartRangeController;
  set chartRangeController(RangeController? value) {
    if (_chartRangeController != value) {
      _chartRangeController = value;
    }
  }

  List<int> _trendlineHideIndexes = [];
  List<int> get trendlineHideIndexes => _trendlineHideIndexes;
  set trendlineHideIndexes(List<int> value) {
    _trendlineHideIndexes = value;
    notifyListeners();
  }

  Map<String, DateTimeAxisController?> _zoomingHandlerList = {};
  Map<String, DateTimeAxisController?> get zoomingHandlerList =>
      _zoomingHandlerList;
  set zoomingHandlerList(Map<String, DateTimeAxisController?> newList) {
    _zoomingHandlerList = newList;
    notifyListeners();
  }

  Map<String, TrackballBehavior?> _indicatorTrackballList = {};
  Map<String, TrackballBehavior?> get indicatorTrackballList =>
      _indicatorTrackballList;
  set indicatorTrackballList(Map<String, TrackballBehavior?> newList) {
    _indicatorTrackballList = newList;
    notifyListeners();
  }

  Map<String, CrosshairBehavior?> _indicatorCrosshairList = {};
  Map<String, CrosshairBehavior?> get indicatorCrosshairList =>
      _indicatorCrosshairList;
  set indicatorCrosshairList(Map<String, CrosshairBehavior?> newList) {
    _indicatorCrosshairList = newList;
    notifyListeners();
  }

  Map<String, bool> _underlayIndicatorHandlerList = {};
  Map<String, bool> get underlayIndicatorHandlerList =>
      _underlayIndicatorHandlerList;
  set underlayIndicatorHandlerList(Map<String, bool> value) {
    _underlayIndicatorHandlerList = value;
    notifyListeners();
  }

  Map<String, bool> _overlayIndicatorHandlerList = {};
  Map<String, bool> get overlayIndicatorHandlerList =>
      _overlayIndicatorHandlerList;
  set overlayIndicatorHandlerList(Map<String, bool> value) {
    _overlayIndicatorHandlerList = value;
    notifyListeners();
  }

  Map<String, bool> _trendlineHandlerList = {};
  Map<String, bool> get trendlineHandlerList => _trendlineHandlerList;
  set trendlineHandlerList(Map<String, bool> value) {
    _trendlineHandlerList = value;
    notifyListeners();
  }

  Map<String, DateTimeAxisController> _indicatorAxisController = {};
  Map<String, DateTimeAxisController> get indicatorAxisController =>
      _indicatorAxisController;
  set indicatorAxisController(Map<String, DateTimeAxisController> value) {
    if (_indicatorAxisController != value) {
      _indicatorAxisController = value;
    }
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  final List<TrendlineInstance<TrendlineType>> _stockTrendlines = [];
  List<TrendlineInstance<TrendlineType>> get stockTrendlines =>
      _stockTrendlines;

  Stock get selectedStock => _selectedStock;
  Stock _selectedStock = Stock.apple;
  set selectedStock(Stock stock) {
    if (_selectedStock != stock) {
      _selectedStock = stock;
      // _loadChartData();
    }
  }

  bool get isFullScreen => _isFullScreen;
  bool _isFullScreen = false;
  set isFullScreen(bool value) {
    if (_isFullScreen != value) {
      _isFullScreen = value;
      notifyListeners();
    }
  }

  UserDetail _user = UserDetail(firstName: 'Guest', lastName: '');
  UserDetail get user => _user;
  set user(UserDetail userDetail) {
    _user = userDetail;
    notifyListeners();
  }

  bool get isPopupMenuItemChanged => _isPopupMenuItemChanged;
  bool _isPopupMenuItemChanged = false;
  set isPopupMenuItemChanged(bool value) {
    _isPopupMenuItemChanged = value;
    notifyListeners();
  }

  bool get enableReset => _enableReset;
  bool _enableReset = false;
  set enableReset(bool value) {
    _enableReset = value;
    notifyListeners();
  }

  bool get isTrendlineTypeChanged => _isTrendlineTypeChanged;
  bool _isTrendlineTypeChanged = false;
  set isTrendlineTypeChanged(bool value) {
    _isTrendlineTypeChanged = value;
    notifyListeners();
  }

  Map<String, bool> _isEditableTextMap = {'First': false, 'Last': false};
  Map<String, bool> get isEditableTextMap => _isEditableTextMap;
  set isEditableTextMap(Map<String, bool> value) {
    if (_isEditableTextMap != value) {
      _isEditableTextMap = value;
    }
  }

  bool get isWatchListAdded => _isListTileSelected;
  bool _isListTileSelected = false;
  set isWatchListAdded(bool value) {
    _isListTileSelected = value;
    notifyListeners();
  }

  SeriesType get selectedSeriesType => _selectedSeriesType;
  SeriesType _selectedSeriesType = SeriesType.candle;
  set selectedSeriesType(SeriesType seriesType) {
    if (_selectedSeriesType != seriesType) {
      _selectedSeriesType = seriesType;
      notifyListeners();
    }
  }

  List<IndicatorInstance<OverlayIndicatorType>> get overlayIndicators =>
      _overlayIndicators;
  final List<IndicatorInstance<OverlayIndicatorType>> _overlayIndicators = [];

  List<IndicatorInstance<UnderlayIndicatorType>> get underlayIndicators =>
      _underlayIndicators;
  final List<IndicatorInstance<UnderlayIndicatorType>> _underlayIndicators = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  bool _isUnderlayIndicatorPopupUpdate = false;
  bool get isUnderlayIndicatorPopupUpdate => _isUnderlayIndicatorPopupUpdate;
  set isUnderlayIndicatorPopupUpdate(bool value) {
    if (_isUnderlayIndicatorPopupUpdate != value) {
      _isUnderlayIndicatorPopupUpdate = value;
      notifyListeners();
    }
  }

  bool _isOverlayIndicatorPopupUpdate = false;
  bool get isOverlayPopupUpdate => _isOverlayIndicatorPopupUpdate;
  set isOverlayPopupUpdate(bool value) {
    if (_isOverlayIndicatorPopupUpdate != value) {
      _isOverlayIndicatorPopupUpdate = value;
      notifyListeners();
    }
  }

  CustomDateRange _customDateRange = const CustomDateRange();
  CustomDateRange get customDateRange => _customDateRange;
  set customDateRange(CustomDateRange value) {
    if (_customDateRange != value) {
      _customDateRange = value;
      notifyListeners();
    }
  }

  TrendlineType get trendlineType => _trendlineType;
  TrendlineType _trendlineType = TrendlineType.linear;
  set trendlineType(TrendlineType trendline) {
    if (_trendlineType != trendline) {
      _trendlineType = trendline;
    }
  }

  DateRange _selectedDateRange = DateRange.oneMonth;
  DateRange get selectedDateRange => _selectedDateRange;
  set selectedDateRange(DateRange dateRange) {
    if (_selectedDateRange != dateRange) {
      _selectedDateRange = dateRange;
      notifyListeners();
    }
  }

  Future<void> loadAllStocks() async {
    final Map<Stock, String> stockAssets = <Stock, String>{
      Stock.apple: 'assets/stock_data/apple.json',
      // Stock.asianPaints: 'assets/stock_data/asian_paints.json',
      // Stock.colgate: 'assets/stock_data/colgate.json',
      Stock.facebook: 'assets/stock_data/facebook.json',
      Stock.google: 'assets/stock_data/google.json',
      // Stock.hdfc: 'assets/stock_data/hdfc_bank.json',
      // Stock.indianOil: 'assets/stock_data/indian_oil.json',
      // Stock.infosys: 'assets/stock_data/infosys.json',
      Stock.microsoft: 'assets/stock_data/microsoft.json',
      Stock.nestle: 'assets/stock_data/nestle.json',
      Stock.tesla: 'assets/stock_data/tesla.json',
      // Stock.ultratech: 'assets/stock_data/ultratech_cement.json',
    };

    for (final entry in stockAssets.entries) {
      _stockData[entry.key] = await loadStockDataFromJson(entry.value);
    }
    notifyListeners();
  }

  void addIndicator<T extends Enum>(T indicator) {
    if (indicator is OverlayIndicatorType) {
      _addOverlayIndicator(indicator);
    } else if (indicator is UnderlayIndicatorType) {
      _addUnderlayIndicator(indicator);
    }
    notifyListeners();
  }

  void _addUnderlayIndicator(indicator) {
    if (!_underlayIndicators.contains(indicator)) {
      _underlayIndicators.add(IndicatorInstance(indicator));
    }
  }

  void _addOverlayIndicator(indicator) {
    if (!_overlayIndicators.contains(indicator)) {
      _overlayIndicators.add(IndicatorInstance(indicator));
    }
  }

  void addTrendline(TrendlineType trendline) {
    _stockTrendlines.add(TrendlineInstance(trendline));
    notifyListeners();
  }

  void isFilteringRange(bool enabled) {
    _isFiltering = enabled;
    notifyListeners();
  }

  void clearAllIndicators() {
    _overlayIndicators.clear();
    _underlayIndicators.clear();
    notifyListeners();
  }

  void clearAllTrendlines() {
    _stockTrendlines.clear();
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void zoomIn() {
    // _zoomPanBehavior.zoomIn();
  }

  void zoomOut() {
    // _zoomPanBehavior.zoomOut();
  }

  void panToDirection(String direction) {
    // _zoomPanBehavior.panToDirection(direction);
  }

  void resetZoom() {
    // _zoomPanBehavior.reset();
  }

  void resetData() {
    stockData.clear();
  }

  void addTrendlineHandler(TrendlineInstance<TrendlineType> trendlineInstance) {
    _trendlineHandlerList.addAll(<String, bool>{trendlineInstance.id: false});
  }

  void removeTrendlineHandler(
    TrendlineInstance<TrendlineType> trendlineInstance,
  ) {
    _trendlineHandlerList.remove(trendlineInstance.id);
    _stockTrendlines.remove(trendlineInstance);
  }

  void addOverlayIndicatorHandler(
    IndicatorInstance<OverlayIndicatorType> indicatorInstance,
  ) {
    _overlayIndicatorHandlerList.addAll(<String, bool>{
      indicatorInstance.id: false,
    });
  }

  void removeOverlayIndicatorHandler(
    IndicatorInstance<OverlayIndicatorType> indicatorInstance,
  ) {
    _overlayIndicatorHandlerList.remove(indicatorInstance.id);
    _overlayIndicators.remove(indicatorInstance);
  }

  void addUnderlayIndicatorHandler(
    IndicatorInstance<UnderlayIndicatorType> indicatorInstance,
  ) {
    _underlayIndicatorHandlerList.addAll(<String, bool>{
      indicatorInstance.id: false,
    });
    _zoomingHandlerList.addAll({indicatorInstance.id: null});
    _indicatorCrosshairList.addAll({
      indicatorInstance.id: stockCrosshairBehavior(),
    });
    _indicatorTrackballList.addAll({
      indicatorInstance.id: stockTrackballBehavior(),
    });
  }

  void removeUnderlayIndicatorHandler(
    IndicatorInstance<UnderlayIndicatorType> indicatorInstance,
  ) {
    _underlayIndicatorHandlerList.remove(indicatorInstance.id);
    _underlayIndicators.remove(indicatorInstance);
    _zoomingHandlerList.remove(indicatorInstance.id);
    _indicatorTrackballList.remove(indicatorInstance.id);
    _indicatorCrosshairList.remove(indicatorInstance.id);
  }

  void updateRangeController(DateTimeAxisController? controller) {
    _chartRangeController?.start = controller?.visibleMinimum;
    _chartRangeController?.end = controller?.visibleMaximum;
  }

  void updateRangeControllerViaSelector(DateTime? start, DateTime? end) {
    _chartRangeController?.start = start;
    _chartRangeController?.end = end;
  }

  /// Initialize temporary settings with current settings.
  void initTempSettings() {
    _tempSettings = ChartSettings(
      trackballEnabled: _chartSettings.trackballEnabled,
      crosshairEnabled: _chartSettings.crosshairEnabled,
      tooltipEnabled: _chartSettings.tooltipEnabled,
      logarithmicYAxis: _chartSettings.logarithmicYAxis,
      opposedAxis: _chartSettings.opposedAxis,
      invertedAxis: _chartSettings.invertedAxis,
      rangeSelectorEnabled: _chartSettings.rangeSelectorEnabled,
    );
    notifyListeners();
  }

  /// Update the temporary settings.
  void updateTempSetting({
    bool? trackballEnabled,
    bool? crosshairEnabled,
    bool? tooltipEnabled,
    bool? logarithmicYAxis,
    bool? opposedAxis,
    bool? invertedAxis,
    bool? selectionZoomingEnabled,
    bool? showZoomPanel,
    ZoomMode? zoomMode,
    bool? rangeSelectorEnabled,
  }) {
    _tempSettings = _tempSettings.copyWith(
      trackballEnabled: trackballEnabled,
      crosshairEnabled: crosshairEnabled,
      tooltipEnabled: tooltipEnabled,
      logarithmicYAxis: logarithmicYAxis,
      opposedAxis: opposedAxis,
      invertedAxis: invertedAxis,
      rangeSelectorEnabled: rangeSelectorEnabled,
    );
    notifyListeners();
  }

  /// Reset temporary settings to match current settings.
  void resetTempSettings() {
    _tempSettings = ChartSettings(
      trackballEnabled: _chartSettings.trackballEnabled,
      crosshairEnabled: _chartSettings.crosshairEnabled,
      tooltipEnabled: _chartSettings.tooltipEnabled,
      logarithmicYAxis: _chartSettings.logarithmicYAxis,
      opposedAxis: _chartSettings.opposedAxis,
      invertedAxis: _chartSettings.invertedAxis,
      rangeSelectorEnabled: _chartSettings.rangeSelectorEnabled,
    );
    notifyListeners();
  }

  /// Apply temporary settings to the actual settings.
  void applySettings() {
    // Remove BuildContext parameter
    _chartSettings = _tempSettings;
    notifyListeners();
  }

  /// Update all chart settings at once.
  void updateChartSettings(ChartSettings newSettings) {
    _chartSettings = newSettings;
    notifyListeners();
  }

  List<Data> getSampledMonthlyData(List<Data> allData) {
    // Sort data by date ascending
    allData.sort(
      (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
    );

    // Group potential data points by month
    final Map<String, List<Data>> pointsByMonth = {};
    for (final data in allData) {
      final DateTime dataDate = DateTime.parse(data.date);
      final String yearMonth =
          "${dataDate.year}-${dataDate.month.toString().padLeft(2, '0')}";

      if (!pointsByMonth.containsKey(yearMonth)) {
        pointsByMonth[yearMonth] = [];
      }
      pointsByMonth[yearMonth]!.add(data);
    }

    // For each month, pick the first business day (skip weekends)
    final Map<String, Data> monthlyPoints = {};
    for (final monthKey in pointsByMonth.keys) {
      final List<Data> monthData = pointsByMonth[monthKey]!;
      monthData.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
      );

      for (final data in monthData) {
        final DateTime dataDate = DateTime.parse(data.date);
        if (dataDate.weekday != DateTime.saturday &&
            dataDate.weekday != DateTime.sunday) {
          monthlyPoints[monthKey] = data;
          break;
        }
      }

      // Fallback if no business days found
      if (!monthlyPoints.containsKey(monthKey) && monthData.isNotEmpty) {
        monthlyPoints[monthKey] = monthData.first;
      }
    }

    return monthlyPoints.values.toList()..sort(
      (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
    );
  }

  StockChartViewModel get viewModel {
    List<Data> dataToUse = [];

    // if (_stockData[_selectedStock] != null) {
    //   if (_selectedDateRange == DateRange.all) {
    //     // Use sampled monthly data for "All" view
    //     dataToUse = getSampledMonthlyData(_stockData[_selectedStock]!.data);
    //   } else {
    //     // Use all data points for other views
    //     dataToUse = _stockData[_selectedStock]!.data;
    //   }
    // }
    dataToUse = _stockData[_selectedStock]!.data;

    return StockChartViewModel(
      stockData: _stockData,
      dataCollections: dataToUse,
      selectedStock: _selectedStock,
      selectedSeriesType: _selectedSeriesType,
      customDateRange: _customDateRange,
      trendlineType: _trendlineType,
      chartSettings: _chartSettings,
      overlayIndicators: List<IndicatorInstance<OverlayIndicatorType>>.from(
        _overlayIndicators,
      ),
      underlayIndicators: List<IndicatorInstance<UnderlayIndicatorType>>.from(
        _underlayIndicators,
      ),
      stockTrendlines: stockTrendlines,
      isFiltering: _isFiltering,
    );
  }

  Future<StockData> loadStockDataFromJson(String assetPath) async {
    final String jsonStr = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    return StockData.fromJson(jsonMap);
  }

  // /// Load chart data for the selected stock.
  // Future<void> _loadChartData() async {
  //   _data.clear();
  //   final String jsonString = await _loadJsonFromAssets();
  //   final List<dynamic> jsonResponse = json.decode(jsonString) as List<dynamic>;
  //   _data = List.generate(jsonResponse.length, (int index) {
  //     return Data.fromJson(jsonResponse[index] as Map<String, Data>);
  //   });
  //   notifyListeners();
  // }

  /// Retrieve JSON data from the assets based on the selected stock.
  // Future<String> _loadJsonFromAssets() async {
  //   return rootBundle.loadString(
  //     'assets/stock_data/${selectedStock.name}.json',
  //   );
  // }
}

@immutable
class StockChartViewModel {
  const StockChartViewModel({
    required this.stockData,
    required this.selectedStock,
    required this.selectedSeriesType,
    required this.customDateRange,
    required this.trendlineType,
    required this.chartSettings,
    required this.overlayIndicators,
    required this.underlayIndicators,
    required this.stockTrendlines,
    required this.isFiltering,
    required this.dataCollections,
  });

  final Map<Stock, StockData> stockData;
  final Stock selectedStock;
  final SeriesType selectedSeriesType;
  final CustomDateRange customDateRange;
  final TrendlineType trendlineType;
  final ChartSettings chartSettings;
  final List<IndicatorInstance<OverlayIndicatorType>> overlayIndicators;
  final List<IndicatorInstance<UnderlayIndicatorType>> underlayIndicators;
  final List<TrendlineInstance<TrendlineType>> stockTrendlines;
  final bool isFiltering;
  final List<Data> dataCollections;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StockChartViewModel &&
            runtimeType == other.runtimeType &&
            mapEquals(stockData, other.stockData) &&
            selectedStock == other.selectedStock &&
            selectedSeriesType == other.selectedSeriesType &&
            customDateRange == other.customDateRange &&
            trendlineType == other.trendlineType &&
            chartSettings == other.chartSettings &&
            listEquals(overlayIndicators, other.overlayIndicators) &&
            listEquals(underlayIndicators, other.underlayIndicators) &&
            listEquals(stockTrendlines, other.stockTrendlines) &&
            listEquals(dataCollections, other.dataCollections) &&
            isFiltering == other.isFiltering;
  }

  @override
  int get hashCode {
    return stockData.hashCode ^
        selectedStock.hashCode ^
        customDateRange.hashCode ^
        trendlineType.hashCode ^
        selectedSeriesType.hashCode ^
        chartSettings.hashCode ^
        overlayIndicators.hashCode ^
        underlayIndicators.hashCode ^
        stockTrendlines.hashCode ^
        dataCollections.hashCode ^
        isFiltering.hashCode;
  }
}

@immutable
class IndicatorInstance<T> {
  IndicatorInstance(this.indicatorType)
    : id = '${indicatorType}_${DateTime.now().millisecondsSinceEpoch}';

  // The property [indicatorType] is used to identify both the
  // overlay and underlay indicators.
  final T indicatorType;
  final String id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is IndicatorInstance &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

@immutable
class TrendlineInstance<T> {
  TrendlineInstance(this.trendlineType)
    : id = '${trendlineType}_${DateTime.now().millisecondsSinceEpoch}';

  final T trendlineType;
  final String id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TrendlineInstance &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
