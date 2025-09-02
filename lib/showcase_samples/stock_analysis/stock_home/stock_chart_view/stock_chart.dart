import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;

import '../../dialogs/settings.dart';
import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../model/chart_data.dart';
import '../../model/chart_settings.dart';
import '../../notifier/stock_chart_notifier.dart';
import '../stock_panel_view/watchlist_action_dialog.dart';
import 'stock_auto_complete.dart';
import 'stock_chart_interaction.dart';
import 'stock_popup.dart';
import 'stock_underlay_indicator.dart';

DateTimeAxisController? primaryChartAxisController;

CrosshairBehavior? primaryCrosshairBehavior;
CrosshairBehavior? indicatorCrosshairBehavior;

TrackballBehavior? primaryTrackballBehavior;
TrackballBehavior? indicatorTrackballBehavior;

ChartSeriesController<Data, DateTime>? primarySeriesController;
ChartSeriesController<Data, DateTime>? indicatorSeriesController;

Offset? position;

// In the StockChartViewer class:

class StockChartViewer extends StatelessWidget {
  const StockChartViewer({
    super.key,
    this.isFullScreen = false,
    required this.defaultStocks,
    required this.firstName,
    required this.lastName,
  });

  final bool isFullScreen;
  final Map<Stock, StockData> defaultStocks;
  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Only show headers in desktop mode or when not in fullscreen
            if (!isFullScreen || deviceType(context) == DeviceType.desktop) ...[
              StockChartPrimaryHeader(
                isFullScreen: isFullScreen,
                defaultStocks: defaultStocks,
                firstName: firstName,
                lastName: lastName,
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              StockChartSecondaryHeader(
                isFullScreen: isFullScreen,
                firstName: firstName,
                lastName: lastName,
              ),
            ],
            Expanded(child: StockChartView(key: ValueKey<bool>(isFullScreen))),
          ],
        ),
      ),
    );
  }
}

class StockChartPrimaryHeader extends StatelessWidget {
  const StockChartPrimaryHeader({
    super.key,
    this.isFullScreen = false,
    required this.firstName,
    required this.lastName,
    required this.defaultStocks,
  });

  final bool isFullScreen;
  final Map<Stock, StockData> defaultStocks;
  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return StockTitle(
      defaultStocks: defaultStocks,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

class StockTitle extends StatelessWidget {
  const StockTitle({
    super.key,
    required this.defaultStocks,
    required this.firstName,
    required this.lastName,
  });
  final Map<Stock, StockData> defaultStocks;
  final String firstName;
  final String lastName;

  Widget _stockHeader(
    BuildContext context,
    ThemeData themeData,
    StockData stock,
  ) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return provider.isFullScreen
        ? _buildNavigationHeader(context, themeData, stock)
        : _buildStockHeader(themeData, stock);
  }

  Widget _buildNavigationHeader(
    BuildContext context,
    ThemeData themeData,
    StockData stock,
  ) {
    return deviceType(context) == DeviceType.desktop
        ? SymbolDropdown(
            firstName: firstName,
            lastName: lastName,
            child: _buildInteractiveStockHeader(themeData, stock),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SearchStockPage(
                      firstName: firstName,
                      lastName: lastName,
                    );
                  },
                ),
              );
            },
            child: _buildStockHeader(themeData, stock),
          );
  }

  Widget _buildStockHeader(ThemeData themeData, StockData stock) {
    return Row(
      spacing: 6,
      children: [
        Text(
          stock.companyName.capitalizeFirst(),
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        Text(
          stock.exchange,
          style: themeData.textTheme.bodySmall?.copyWith(
            color: themeData.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveStockHeader(ThemeData themeData, StockData stock) {
    return Row(
      spacing: 6,
      children: [
        Text(
          stock.companyName.capitalizeFirst(),
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: <Widget>[
            Text(
              stock.exchange,
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
            const Icon(
              IconData(0xe704, fontFamily: stockFontIconFamily),
              size: 12,
            ),
          ],
        ),
      ],
    );
  }

  Widget _stockSubHeader(ThemeData themeData, StockData stock) {
    final Data data = stock.data.last;
    final bool isStockValueIncreased = !data.percentageChange.isNegative;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '\$${data.currentPrice} ',
            style: themeData.textTheme.labelMedium?.copyWith(
              color: themeData.colorScheme.onSurface,
              fontWeight: fontWeight500(),
            ),
          ),
          TextSpan(
            text:
                ' ${isStockValueIncreased ? '+' : ''}${data.priceChange} (${data.percentageChange}%)',
            style: themeData.textTheme.labelMedium?.copyWith(
              color: isStockValueIncreased
                  ? const Color.fromRGBO(59, 163, 26, 1)
                  : themeData.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcons(
    BuildContext context,
    Map<Stock, StockData> stockData,
    StockData selectedStock,
  ) {
    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.isStockInWatchlist(selectedStock),
      builder: (BuildContext context, bool isInWatchlist, Widget? child) {
        return Row(
          children: [
            SizedBox.square(
              dimension: 36,
              child: IconButton(
                onPressed: () {
                  // Show appropriate dialog based on whether stock is in watchlist
                  if (isInWatchlist) {
                    _showWatchlistActionDialog(
                      context,
                      selectedStock.stock,
                      true,
                    );
                  } else {
                    _showWatchlistActionDialog(
                      context,
                      selectedStock.stock,
                      false,
                    );
                  }
                },
                icon: _buildWatchListIcon(context, isInWatchlist),
              ),
            ),
            SizedBox.square(
              dimension: 36,
              child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                color: Theme.of(context).colorScheme.surface,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                tooltip: '',
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'disclaimer',
                      child: Text(
                        'The stock data displayed here is for demonstration purposes only and represents the period from January 01, 2023 to January 01, 2025. This information does not reflect any actual market values or investment performances.',
                      ),
                    ),
                  ];
                },
                icon: Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWatchlistActionDialog(
    BuildContext context,
    Stock stock,
    bool isRemoving,
  ) {
    final DeviceType currentDeviceType = deviceType(context);

    if (currentDeviceType == DeviceType.desktop) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) =>
            WatchlistActionDialog(stock: stock, isRemoving: isRemoving),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext dialogContext) =>
              WatchlistActionDialog(stock: stock, isRemoving: isRemoving),
        ),
      );
    }
  }

  Widget _buildWatchListIcon(BuildContext context, bool isInWatchlist) {
    return isInWatchlist
        ? _buildWatchListedIcon()
        : _buildNonWatchListedIcon(context);
  }

  Widget _buildWatchListedIcon() {
    return const Icon(
      IconData(0xe70c, fontFamily: stockFontIconFamily),
      color: Color.fromRGBO(255, 180, 0, 1),
      size: 18,
    );
  }

  Widget _buildNonWatchListedIcon(BuildContext context) {
    return Icon(
      const IconData(0xe70b, fontFamily: stockFontIconFamily),
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      size: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Consumer<StockChartProvider>(
      builder:
          (
            BuildContext context,
            StockChartProvider stockProvider,
            Widget? child,
          ) {
            if (defaultStocks[stockProvider.selectedStock] == null)
              return const SizedBox.shrink();
            final StockData stock = defaultStocks[stockProvider.selectedStock]!;
            return Row(
              spacing: 18,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _stockHeader(context, themeData, stock),
                    _stockSubHeader(themeData, stock),
                  ],
                ),
                _buildIcons(context, {
                  stockProvider.selectedStock: stock,
                }, stock),
              ],
            );
          },
    );
  }
}

class StockChartControls extends StatelessWidget {
  const StockChartControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 8.0,
      children: <Widget>[
        StockIndicatorDropdown(),
        StockSeriesDropdown(),
        StockTrendlineDropdown(),
      ],
    );
  }
}

class StockSeriesDropdown extends StatelessWidget {
  const StockSeriesDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<StockChartProvider, SeriesType>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.selectedSeriesType,
      builder:
          (BuildContext context, SeriesType selectedSeriesType, Widget? child) {
            const List<SeriesType> seriesTypes = SeriesType.values;
            return StockDropdown<SeriesType>(
              selectedType: selectedSeriesType,
              hintText: 'Series',
              items: seriesTypes,
              onChanged: (SeriesType? selectedSeriesType) {
                if (selectedSeriesType != null) {
                  context.read<StockChartProvider>()
                    ..selectedSeriesType = selectedSeriesType
                    ..isFilteringRange(false);
                }
              },
              iconData: const IconData(0xe73a, fontFamily: stockFontIconFamily),
            );
          },
    );
  }
}

class StockIndicatorDropdown extends StatelessWidget {
  const StockIndicatorDropdown({super.key});

  // Add this function to a helper file or directly in stock_popup.dart

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    final List<Enum> indicatorTypes =
        <Enum>[...OverlayIndicatorType.values, ...UnderlayIndicatorType.values]
          ..sort((Enum overlayIndicators, Enum underlayIndicators) {
            return overlayIndicators.name.compareTo(underlayIndicators.name);
          });

    return StockDropdown<Enum>(
      hintText: 'Indicator',
      items: indicatorTypes,
      onChanged: (Enum? selectedIndicatorType) {
        if (selectedIndicatorType is OverlayIndicatorType) {
          provider.addIndicator(selectedIndicatorType);
          provider.addOverlayIndicatorHandler(provider.overlayIndicators.last);
        } else if (selectedIndicatorType is UnderlayIndicatorType) {
          provider.addIndicator(selectedIndicatorType);
          provider.addUnderlayIndicatorHandler(
            provider.underlayIndicators.last,
          );
        }
      },
      iconData: const IconData(0xe73b, fontFamily: stockFontIconFamily),
    );
  }
}

class StockTrendlineDropdown extends StatelessWidget {
  const StockTrendlineDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    const List<TrendlineType> trendlineTypes = TrendlineType.values;

    return StockDropdown<TrendlineType>(
      hintText: 'Trendline',
      items: trendlineTypes,
      onChanged: (TrendlineType? newValue) {
        if (newValue != null) {
          final StockChartProvider provider = context
              .read<StockChartProvider>();
          provider.trendlineType = newValue;
          provider.addTrendline(newValue);
          provider.addTrendlineHandler(provider.stockTrendlines.last);
          provider.isTrendlineTypeChanged = !provider.isTrendlineTypeChanged;
        }
      },
      iconData: const IconData(0xe73c, fontFamily: stockFontIconFamily),
    );
  }
}

class StockChartSettings extends StatelessWidget {
  const StockChartSettings({super.key});

  void _showChartSettingsDialog(BuildContext context) {
    // Get the existing provider
    final provider = Provider.of<StockChartProvider>(context, listen: false);
    // Initialize temp settings
    provider.initTempSettings();

    switch (deviceType(context)) {
      case DeviceType.desktop:
        showDialog(
          context: context,
          builder: (BuildContext context) => ChangeNotifierProvider.value(
            value: provider, // Use existing provider
            child: const SettingsDialog(),
          ),
        );
        break;
      case DeviceType.mobile:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const SettingsDialog();
            },
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      icon: Icon(
        const IconData(0xe70d, fontFamily: stockFontIconFamily),
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () => _showChartSettingsDialog(context),
      tooltip: 'Chart Settings',
    );
  }
}

class StockChartView extends StatelessWidget {
  const StockChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<StockChartProvider, StockChartViewModel>(
      selector: (BuildContext context, StockChartProvider provider) {
        return provider.viewModel;
      },
      builder:
          (BuildContext context, StockChartViewModel viewModel, Widget? child) {
            return _buildChartView(viewModel, context);
          },
    );
  }

  DateTime _startRange(StockChartProvider provider, DateTime endDate) {
    switch (provider.selectedDateRange) {
      case DateRange.oneMonth:
        return DateTime(endDate.year, endDate.month - 1, endDate.day);
      case DateRange.threeMonth:
        return DateTime(endDate.year, endDate.month - 3, endDate.day);
      case DateRange.fiveMonth:
        return DateTime(endDate.year, endDate.month - 5, endDate.day);
      case DateRange.oneYear:
        return DateTime(endDate.year - 1, endDate.month, endDate.day);
      case DateRange.customRange:
        return endDate;
      case DateRange.all:
        return DateTime.parse(provider.viewModel.dataCollections.first.date);
    }
  }

  Widget _buildChartView(StockChartViewModel viewModel, BuildContext context) {
    final bool showMainChartXAxis = viewModel.underlayIndicators.isEmpty;
    final StockChartProvider provider = context.read<StockChartProvider>();
    final DateTime endDate = DateTime(2025);
    provider.chartRangeController ??= RangeController(
      start: _startRange(provider, endDate),
      end: endDate,
    );
    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) {
        return provider.isRangeControllerUpdate;
      },
      builder: (BuildContext context, bool value, Widget? child) {
        return Selector<StockChartProvider, bool>(
          selector: (BuildContext context, StockChartProvider provider) {
            return provider.isTrendlineTypeChanged;
          },
          builder: (BuildContext context, bool value, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Main chart with overlay indicators.
                Flexible(
                  flex: 3,
                  child: Selector<StockChartProvider, bool>(
                    selector:
                        (BuildContext context, StockChartProvider provider) {
                          return provider.isOverlayPopupUpdate;
                        },
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Stack(
                        children: [
                          StockPrimaryCartesianChart(
                            viewModel: viewModel,
                            showXAxis: showMainChartXAxis,
                          ),
                          if (context
                              .read<StockChartProvider>()
                              .overlayIndicators
                              .isNotEmpty)
                            OverlayIndicatorPopup(
                              indicatorTypes: context
                                  .read<StockChartProvider>()
                                  .overlayIndicators,
                            ),
                          if (context
                              .read<StockChartProvider>()
                              .stockTrendlines
                              .isNotEmpty)
                            OverlayTrendlinePopup(
                              trendlineTypes: context
                                  .read<StockChartProvider>()
                                  .stockTrendlines,
                            ),
                          Selector<StockChartProvider, bool>(
                            selector:
                                (
                                  BuildContext context,
                                  StockChartProvider provider,
                                ) => provider.enableReset,
                            builder:
                                (
                                  BuildContext context,
                                  bool enableReset,
                                  Widget? child,
                                ) {
                                  return Visibility(
                                    visible:
                                        enableReset &&
                                        provider.underlayIndicators.isEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 30,
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: _buildResetButton(context),
                                      ),
                                    ),
                                  );
                                },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ..._buildUnderlayIndicatorCharts(context, viewModel),
                if (provider.isFullScreen &&
                    provider.chartSettings.rangeSelectorEnabled)
                  _buildRangeSelector(viewModel),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRangeSelector(StockChartViewModel viewModel) {
    final DateTime min = DateTime.parse(viewModel.dataCollections.first.date);
    final DateTime max = DateTime(2025);
    return Selector(
      selector: (BuildContext context, StockChartProvider provider) {
        return provider.isFullScreen;
      },
      builder: (BuildContext context, bool isFullScreen, Widget? child) {
        final StockChartProvider provider = context.read<StockChartProvider>();
        final ThemeData themeData = Theme.of(context);
        if (isFullScreen) {
          return SfRangeSelectorTheme(
            data: SfRangeSelectorThemeData(
              activeLabelStyle: themeData.textTheme.labelMedium?.copyWith(
                color: themeData.colorScheme.onSurface,
              ),
              inactiveLabelStyle: themeData.textTheme.labelMedium?.copyWith(
                color: themeData.colorScheme.outline,
              ),
              inactiveRegionColor: themeData.colorScheme.surface.withAlpha(220),
              inactiveTrackColor: provider.themeMode == ThemeMode.light
                  ? const Color.fromRGBO(6, 174, 224, 1)
                  : const Color.fromRGBO(255, 245, 0, 1),
              thumbStrokeColor: provider.themeMode == ThemeMode.light
                  ? const Color.fromRGBO(49, 90, 116, 1)
                  : const Color.fromRGBO(218, 150, 70, 1),
              activeTrackColor: provider.themeMode == ThemeMode.light
                  ? const Color.fromRGBO(49, 90, 116, 1)
                  : const Color.fromRGBO(218, 150, 70, 1),
              thumbStrokeWidth: 2,
              thumbColor: Colors.white,
              overlayRadius: 0,
            ),
            child: slider.SfRangeSelector(
              min: min,
              max: max,
              edgeLabelPlacement: slider.EdgeLabelPlacement.inside,
              controller: provider.chartRangeController,
              enableTooltip: true,
              enableDeferredUpdate: true,
              showLabels: true,
              showTicks: true,
              dateIntervalType: slider.DateIntervalType.years,
              dateFormat: DateFormat.yMMM(),
              interval: deviceType(context) == DeviceType.desktop ? 1 : 2,
              onChanged: (slider.SfRangeValues values) {
                final DateTime desiredMinDate = _startRange(provider, max);
                for (final DateTimeAxisController? axisController
                    in provider.zoomingHandlerList.values) {
                  axisController?.visibleMinimum = values.start;
                  axisController?.visibleMaximum = values.end;
                }
                if (values.start != desiredMinDate || values.end != max) {
                  provider.enableReset = true;
                } else {
                  provider.enableReset = false;
                }
              },
              child: SizedBox(
                height: 60,
                child: SfCartesianChart(
                  margin: EdgeInsets.zero,
                  primaryXAxis: const DateTimeAxis(isVisible: false),
                  primaryYAxis: const NumericAxis(isVisible: false),
                  plotAreaBorderWidth: 0,
                  series: [
                    SplineAreaSeries<Data, DateTime>(
                      animationDuration: 0.0,
                      dataSource: viewModel.dataCollections,
                      xValueMapper: (Data data, int index) =>
                          DateTime.parse(data.date),
                      yValueMapper: (Data data, int index) => data.close,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildResetButton(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    final ThemeData themeData = Theme.of(context);

    return Material(
      elevation: 3.0,
      shape: const CircleBorder(),
      child: IconButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeData.colorScheme.onPrimary,
        ),
        icon: const Icon(Icons.refresh),
        onPressed: () {
          updateDateRange(context, provider.selectedDateRange);
          provider.enableReset = false;
        },
      ),
    );
  }

  List<Widget> _buildUnderlayIndicatorCharts(
    BuildContext context,
    StockChartViewModel viewModel,
  ) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return List<Widget>.generate(viewModel.underlayIndicators.length, (index) {
      return _buildUnderLineIndicatorChart(provider, viewModel, index);
    });
  }

  Widget _buildUnderLineIndicatorChart(
    StockChartProvider provider,
    StockChartViewModel viewModel,
    int index,
  ) {
    final bool isLastIndicator =
        index == viewModel.underlayIndicators.length - 1;
    final IndicatorInstance<UnderlayIndicatorType> indicatorInstance =
        viewModel.underlayIndicators[index];
    return Expanded(
      child: Selector<StockChartProvider, bool>(
        selector: (BuildContext context, StockChartProvider provider) =>
            provider.isUnderlayIndicatorPopupUpdate,
        builder: (BuildContext context, bool value, Widget? child) {
          return UnderlayIndicatorChartAndPopup(
            indicatorInstance: indicatorInstance,
            viewModel: viewModel,
            index: index,
            showIndicator:
                !provider.underlayIndicatorHandlerList[indicatorInstance.id]!,
            isLastIndicator: isLastIndicator,
          );
        },
      ),
    );
  }
}

class StockPrimaryCartesianChart extends StatefulWidget {
  const StockPrimaryCartesianChart({
    super.key,
    required this.viewModel,
    required this.showXAxis,
  });

  final StockChartViewModel viewModel;
  final bool showXAxis;

  @override
  State<StockPrimaryCartesianChart> createState() =>
      _StockPrimaryCartesianChartState();
}

class _StockPrimaryCartesianChartState extends State<StockPrimaryCartesianChart>
    with ChartBehaviorMixin {
  // bool _isInteractive = false;

  CartesianSeries<Data, DateTime> _buildCartesianSeries(
    StockChartViewModel viewModel,
  ) {
    switch (viewModel.selectedSeriesType) {
      case SeriesType.area:
        return _buildAreaSeries(viewModel);
      case SeriesType.candle:
        return _buildCandleSeries(viewModel);
      case SeriesType.hollowCandle:
        return _buildHollowCandleSeries(viewModel);
      case SeriesType.column:
        return _buildColumnSeries(viewModel);
      case SeriesType.hilo:
        return _buildHiloSeries(viewModel);
      case SeriesType.line:
        return _buildFastLineSeries(viewModel);
      case SeriesType.ohlc:
        return _buildHiloOpenCloseSeries(viewModel);
      case SeriesType.rangeColumn:
        return _buildRangeColumnSeries(viewModel);
      case SeriesType.stepArea:
        return _buildStepAreaSeries(viewModel);
      case SeriesType.stepLine:
        return _buildStepLineSeries(viewModel);
    }
  }

  List<Trendline> _buildTrendlines(StockChartViewModel viewModel) {
    final List<Trendline> trendlines = <Trendline>[];
    final StockChartProvider provider = context.read<StockChartProvider>();
    for (final TrendlineInstance<TrendlineType> trendlineInstance
        in viewModel.stockTrendlines) {
      trendlines.add(
        Trendline(
          type: trendlineInstance.trendlineType,
          isVisible: !provider.trendlineHandlerList[trendlineInstance.id]!,
        ),
      );
    }
    return trendlines;
  }

  AreaSeries<Data, DateTime> _buildAreaSeries(StockChartViewModel viewModel) {
    return AreaSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      yValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  CandleSeries<Data, DateTime> _buildCandleSeries(
    StockChartViewModel viewModel,
  ) {
    return CandleSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      enableSolidCandles: true,
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      openValueMapper: (Data data, int index) => data.open,
      closeValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  CandleSeries<Data, DateTime> _buildHollowCandleSeries(
    StockChartViewModel viewModel,
  ) {
    return CandleSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      openValueMapper: (Data data, int index) => data.open,
      closeValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  ColumnSeries<Data, DateTime> _buildColumnSeries(
    StockChartViewModel viewModel,
  ) {
    return ColumnSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      yValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  LineSeries<Data, DateTime> _buildFastLineSeries(
    StockChartViewModel viewModel,
  ) {
    return LineSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      yValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  HiloSeries<Data, DateTime> _buildHiloSeries(StockChartViewModel viewModel) {
    return HiloSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  HiloOpenCloseSeries<Data, DateTime> _buildHiloOpenCloseSeries(
    StockChartViewModel viewModel,
  ) {
    return HiloOpenCloseSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      openValueMapper: (Data data, int index) => data.open,
      closeValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  RangeColumnSeries<Data, DateTime> _buildRangeColumnSeries(
    StockChartViewModel viewModel,
  ) {
    return RangeColumnSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  StepAreaSeries<Data, DateTime> _buildStepAreaSeries(
    StockChartViewModel viewModel,
  ) {
    return StepAreaSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      yValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  StepLineSeries<Data, DateTime> _buildStepLineSeries(
    StockChartViewModel viewModel,
  ) {
    return StepLineSeries<Data, DateTime>(
      animationDuration: 0.0,
      onRendererCreated: (ChartSeriesController<Data, DateTime> controller) {
        primarySeriesController = controller;
      },
      dataSource: viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      yValueMapper: (Data data, int index) => data.close,
      trendlines: _buildTrendlines(viewModel),
      enableTooltip: viewModel.chartSettings.tooltipEnabled,
      name: 'Price',
    );
  }

  List<TechnicalIndicator<Data, DateTime>> _buildOverlayIndicators(
    StockChartViewModel viewModel,
  ) {
    final List<TechnicalIndicator<Data, DateTime>> indicators = [];
    final StockChartProvider provider = context.read<StockChartProvider>();

    for (final IndicatorInstance<OverlayIndicatorType> indicatorInstance
        in viewModel.overlayIndicators) {
      final OverlayIndicatorType indicator = indicatorInstance.indicatorType;
      final bool hide =
          provider.overlayIndicatorHandlerList[indicatorInstance.id]!;
      switch (indicator) {
        case OverlayIndicatorType.sma:
          indicators.add(
            SmaIndicator<Data, DateTime>(
              isVisible: !hide,
              animationDuration: 0.0,
              seriesName: 'Price',
              yAxisName: 'primaryYAxis',
            ),
          );
          break;

        case OverlayIndicatorType.ema:
          indicators.add(
            EmaIndicator<Data, DateTime>(
              isVisible: !hide,
              animationDuration: 0.0,
              seriesName: 'Price',
              yAxisName: 'primaryYAxis',
            ),
          );
          break;

        case OverlayIndicatorType.tma:
          indicators.add(
            TmaIndicator<Data, DateTime>(
              isVisible: !hide,
              animationDuration: 0.0,
              seriesName: 'Price',
              yAxisName: 'primaryYAxis',
            ),
          );
          break;

        case OverlayIndicatorType.wma:
          indicators.add(
            WmaIndicator<Data, DateTime>(
              isVisible: !hide,
              animationDuration: 0.0,
              seriesName: 'Price',
              yAxisName: 'primaryYAxis',
            ),
          );
          break;

        case OverlayIndicatorType.bollingerBand:
          indicators.add(
            BollingerBandIndicator<Data, DateTime>(
              isVisible: !hide,
              animationDuration: 0.0,
              standardDeviation: 3,
              seriesName: 'Price',
              yAxisName: 'primaryYAxis',
              upperLineColor: Colors.green,
              lowerLineColor: Colors.red,
            ),
          );
          break;
      }
    }

    return indicators;
  }

  @override
  void initState() {
    primaryCrosshairBehavior = stockCrosshairBehavior();
    primaryTrackballBehavior = stockTrackballBehavior();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTimeAxis buildPrimaryXAxis(
      BuildContext context,
      bool showXAxis,
      CustomDateRange customRange,
      bool isFiltering,
    ) {
      final List<Data> dataCollections = widget.viewModel.dataCollections;
      final ThemeData themeData = Theme.of(context);
      final ColorScheme colorScheme = themeData.colorScheme;
      final TextTheme textTheme = themeData.textTheme;
      final StockChartProvider provider = context.read<StockChartProvider>();

      if (dataCollections.isEmpty) {
        return const DateTimeAxis();
      }
      return DateTimeAxis(
        axisLabelFormatter: (AxisLabelRenderDetails axisLabelRenderArgs) {
          return provider.underlayIndicators.isNotEmpty
              ? ChartAxisLabel('', axisLabelRenderArgs.textStyle)
              : ChartAxisLabel(
                  axisLabelRenderArgs.text,
                  axisLabelRenderArgs.textStyle,
                );
        },
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        // rangePadding: ChartRangePadding.round,
        rangeController: provider.chartRangeController,
        minimum: DateTime.parse(dataCollections.first.date),
        maximum: DateTime(2025),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(
          width: provider.underlayIndicators.isNotEmpty ? 0.0 : 0.5,
          color: colorScheme.outlineVariant,
        ),
        majorGridLines: MajorGridLines(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        onRendererCreated: (DateTimeAxisController axisController) {
          primaryChartAxisController = axisController;
        },
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      );
    }

    final StockChartViewModel viewModel = widget.viewModel;
    final StockChartProvider provider = context.read<StockChartProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 16.0),
        Expanded(
          child: SfCartesianChart(
            key: widget.key,
            margin: EdgeInsets.zero,
            plotAreaBorderWidth: 0.5,
            primaryXAxis: buildPrimaryXAxis(
              context,
              widget.showXAxis,
              viewModel.customDateRange,
              viewModel.isFiltering,
            ),
            onZooming: (ZoomPanArgs zoomingArgs) {
              if (!zoomingArgs.axis!.isVertical) {
                for (final DateTimeAxisController? axisController
                    in provider.zoomingHandlerList.values) {
                  axisController?.zoomFactor = zoomingArgs.currentZoomFactor;
                  axisController?.zoomPosition =
                      zoomingArgs.currentZoomPosition;
                }
                if (zoomingArgs.currentZoomFactor == 1 &&
                    provider.selectedDateRange == DateRange.all) {
                  provider.enableReset = false;
                } else {
                  provider.enableReset = true;
                }
              }
            },
            onZoomStart: (ZoomPanArgs zoomingArgs) {
              if (!zoomingArgs.axis!.isVertical) {
                for (final DateTimeAxisController? axisController
                    in provider.zoomingHandlerList.values) {
                  axisController?.zoomFactor = zoomingArgs.currentZoomFactor;
                  axisController?.zoomPosition =
                      zoomingArgs.currentZoomPosition;
                }
                if (zoomingArgs.currentZoomFactor == 1 &&
                    provider.selectedDateRange == DateRange.all) {
                  provider.enableReset = false;
                } else {
                  provider.enableReset = true;
                }
              }
            },
            onZoomEnd: (ZoomPanArgs zoomingArgs) {
              if (!zoomingArgs.axis!.isVertical) {
                for (final DateTimeAxisController? axisController
                    in provider.zoomingHandlerList.values) {
                  axisController?.zoomFactor = zoomingArgs.currentZoomFactor;
                  axisController?.zoomPosition =
                      zoomingArgs.currentZoomPosition;
                }
                if (zoomingArgs.currentZoomFactor == 1 &&
                    provider.selectedDateRange == DateRange.all) {
                  provider.enableReset = false;
                } else {
                  provider.enableReset = true;
                }
              }
            },
            // onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
            //   _isInteractive = true;
            // },
            // onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
            //   _isInteractive = false;
            //   indicatorTrackballBehavior?.hide();
            // },
            // onTrackballPositionChanging: (TrackballArgs trackballArgs) {
            //   if (viewModel.underlayIndicators.isNotEmpty &&
            //       indicatorSeriesController != null &&
            //       _isInteractive) {
            //     final CartesianChartPoint<dynamic> chartPoint =
            //         trackballArgs.chartPointInfo.chartPoint!;
            //     final CartesianChartPoint<DateTime> point =
            //         CartesianChartPoint<DateTime>(
            //           x: chartPoint.x as DateTime,
            //           y: chartPoint.y,
            //         );
            //     position = indicatorSeriesController!.pointToPixel(point);
            //     indicatorTrackballBehavior?.show(
            //       position!.dx,
            //       position!.dy,
            //       'pixel',
            //     );
            //   }
            // },
            primaryYAxis: buildYAxis(context, viewModel.chartSettings),
            trackballBehavior: viewModel.chartSettings.trackballEnabled
                ? primaryTrackballBehavior
                : null,
            crosshairBehavior: viewModel.chartSettings.crosshairEnabled
                ? primaryCrosshairBehavior
                : null,
            tooltipBehavior: stockToolTipBehavior(viewModel.chartSettings),
            zoomPanBehavior: ZoomPanBehavior(
              enableDoubleTapZooming: true,
              enablePanning: true,
              enablePinching: true,
              enableMouseWheelZooming: true,
              zoomMode: ZoomMode.x,
            ),
            isTransposed: viewModel.chartSettings.invertedAxis,
            series: [_buildCartesianSeries(viewModel)],
            indicators: _buildOverlayIndicators(viewModel),
          ),
        ),
      ],
    );
  }
}

class StockChartSecondaryHeader extends StatelessWidget {
  const StockChartSecondaryHeader({
    super.key,
    this.isFullScreen = false,
    required this.firstName,
    required this.lastName,
  });

  final bool isFullScreen;
  final String firstName;
  final String lastName;

  Widget _buildFullScreenButton(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    final ThemeData themeData = Theme.of(context);

    return IconButton(
      iconSize: 20,
      icon: provider.isFullScreen
          ? Icon(
              const IconData(0xe742, fontFamily: stockFontIconFamily),
              color: themeData.colorScheme.onSurfaceVariant,
              size: 20,
            )
          : Icon(
              const IconData(0xe746, fontFamily: stockFontIconFamily),
              color: themeData.colorScheme.onSurfaceVariant,
              size: 20,
            ),
      onPressed: () {
        provider.isFullScreen = !provider.isFullScreen;
      },
    );
  }

  // Widget _buildFullScreenButton(BuildContext context) {
  // final StockChartProvider provider = context.read<StockChartProvider>();
  // final ThemeData themeData = Theme.of(context);
  // return IconButton(
  // iconSize: 20,
  // icon:
  // provider.isFullScreen
  // ? Icon(
  // const IconData(0xe742, fontFamily: fontIconFamily),
  // color: themeData.colorScheme.onSurfaceVariant,
  // size: 20,
  // )
  // : Icon(
  // const IconData(0xe746, fontFamily: fontIconFamily),
  // color: themeData.colorScheme.onSurfaceVariant,
  // size: 20,
  // ),
  // onPressed: () {
  // provider.isFullScreen = !provider.isFullScreen;
  // },
  // );
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const DateRangeFilters(),
        Row(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const StockChartControls(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const StockChartSettings(),
                _buildFullScreenButton(context),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// String _formatDateRangeName(DateRange dateRange) {
//   switch (dateRange) {
//     case DateRange.oneMonth:
//       return '1M';
//     case DateRange.threeMonth:
//       return '3M';
//     case DateRange.fiveMonth:
//       return '5M';
//     case DateRange.oneYear:
//       return '1Y';
//     case DateRange.fiveYear:
//       return '5Y';
//     case DateRange.customRange:
//       return 'Custom Range';
//     case DateRange.all:
//       return 'All';
//   }
// }

class DateRangeFilters extends StatelessWidget {
  const DateRangeFilters({super.key});

  Widget _buildDateRangeIntervalDropdown(
    BuildContext context,
    List<DateRange> dateRangeIntervals,
  ) {
    return Selector(
      selector: (BuildContext context, StockChartProvider provider) {
        return provider.selectedDateRange;
      },
      builder:
          (BuildContext context, DateRange selectedDateRange, Widget? child) =>
              StockDropdown<DateRange>(
                hintText: 'Day Range',
                selectedType: context
                    .read<StockChartProvider>()
                    .selectedDateRange,
                items: dateRangeIntervals,
                onChanged: (DateRange? selectedDateRange) {
                  if (selectedDateRange != null) {
                    context.read<StockChartProvider>().selectedDateRange =
                        selectedDateRange;
                    _updateDateRange(context, selectedDateRange);
                  }
                },
                iconData: Icons.date_range,
              ),
    );
  }

  void _updateDateRange(BuildContext context, DateRange selectedDateRange) {
    final DateTime now = DateTime(2025);
    final StockChartProvider provider = context.read<StockChartProvider>();
    primaryChartAxisController?.visibleMaximum = now;
    switch (selectedDateRange) {
      case DateRange.oneMonth:
        primaryChartAxisController?.visibleMinimum = DateTime(
          now.year,
          now.month - 1,
          now.day,
        );
        for (final DateTimeAxisController? axisController
            in provider.zoomingHandlerList.values) {
          axisController?.visibleMinimum = DateTime(
            now.year,
            now.month - 1,
            now.day,
          );
          axisController?.visibleMaximum = now;
        }
        break;
      case DateRange.threeMonth:
        primaryChartAxisController?.visibleMinimum = DateTime(
          now.year,
          now.month - 3,
          now.day,
        );
        for (final DateTimeAxisController? axisController
            in provider.zoomingHandlerList.values) {
          axisController?.visibleMinimum = DateTime(
            now.year,
            now.month - 3,
            now.day,
          );
          axisController?.visibleMaximum = now;
        }
        break;
      case DateRange.fiveMonth:
        primaryChartAxisController?.visibleMinimum = DateTime(
          now.year,
          now.month - 5,
          now.day,
        );
        for (final DateTimeAxisController? axisController
            in provider.zoomingHandlerList.values) {
          axisController?.visibleMinimum = DateTime(
            now.year,
            now.month - 5,
            now.day,
          );
          axisController?.visibleMaximum = now;
        }
        break;
      case DateRange.oneYear:
        primaryChartAxisController?.visibleMinimum = DateTime(
          now.year - 1,
          now.month,
          now.day,
        );
        for (final DateTimeAxisController? axisController
            in provider.zoomingHandlerList.values) {
          axisController?.visibleMinimum = DateTime(
            now.year - 1,
            now.month,
            now.day,
          );
          axisController?.visibleMaximum = now;
        }
        break;
      case DateRange.customRange:
        break;
      case DateRange.all:
        primaryChartAxisController?.visibleMinimum = DateTime.parse(
          provider.viewModel.dataCollections.first.date,
        );
        for (final DateTimeAxisController? axisController
            in provider.zoomingHandlerList.values) {
          axisController?.visibleMinimum = DateTime.parse(
            provider.viewModel.dataCollections.first.date,
          );
          axisController?.visibleMaximum = now;
        }
        // // For "All" view, we still want to set the range to show all data
        // final List<Data> dataToUse = provider.viewModel.dataCollections;
        // if (dataToUse.isNotEmpty) {
        //   primaryChartAxisController?.visibleMinimum = DateTime.parse(
        //     dataToUse.first.date,
        //   );

        //   for (final DateTimeAxisController? axisController
        //       in provider.zoomingHandlerList.values) {
        //     axisController?.visibleMinimum = DateTime.parse(
        //       dataToUse.first.date,
        //     );
        //     axisController?.visibleMaximum = now;
        //   }
        // }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<DateRange> dateRanges = DateRange.values;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildDateRangeIntervalDropdown(context, dateRanges),
        // _buildCustomDateFilter(context),
      ],
    );
  }
}

class DateRangeMenu extends StatelessWidget {
  const DateRangeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DateRange>(
      position: PopupMenuPosition.under,
      color: Theme.of(context).colorScheme.surface,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.date_range),
      itemBuilder: (BuildContext context) {
        return DateRange.values
            .skip(5)
            .map(
              (DateRange range) =>
                  PopupMenuItem(value: range, child: Text(range.name)),
            )
            .toList();
      },
      onSelected: (DateRange range) {},
    );
  }
}

class OverlayIndicatorPopup extends StatelessWidget {
  const OverlayIndicatorPopup({super.key, required this.indicatorTypes});

  final List<IndicatorInstance<OverlayIndicatorType>> indicatorTypes;

  Widget _buildTitle(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        indicatorTypes[index].indicatorType.name.capitalizeFirst(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: fontWeight500(),
        ),
      ),
    );
  }

  Widget _buildHideIcon(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        icon: _buildIcon(context, index),
        onPressed: () {
          final String indicatorId = indicatorTypes[index].id;
          provider.overlayIndicatorHandlerList[indicatorId] =
              !provider.overlayIndicatorHandlerList[indicatorId]!;
          provider.isOverlayPopupUpdate = !provider.isOverlayPopupUpdate;
        },
      ),
    );
  }

  Widget _buildCloseIcon(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        icon: const Icon(
          IconData(0xe717, fontFamily: stockFontIconFamily),
          size: 16,
        ),
        onPressed: () {
          provider.removeOverlayIndicatorHandler(indicatorTypes[index]);
          provider.isOverlayPopupUpdate = !provider.isOverlayPopupUpdate;
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext context, int index) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return provider.overlayIndicatorHandlerList[indicatorTypes[index].id]!
        ? const Icon(
            IconData(0xe71d, fontFamily: stockFontIconFamily),
            size: 16,
          )
        : const Icon(
            IconData(0xe71c, fontFamily: stockFontIconFamily),
            size: 16,
          );
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(indicatorTypes.length, (int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(context, provider, index),
                _buildHideIcon(context, provider, index),
                _buildCloseIcon(context, provider, index),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class OverlayTrendlinePopup extends StatelessWidget {
  const OverlayTrendlinePopup({super.key, required this.trendlineTypes});

  final List<TrendlineInstance<TrendlineType>> trendlineTypes;

  Widget _buildTitle(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        trendlineTypes[index - provider.overlayIndicators.length]
            .trendlineType
            .name
            .capitalizeFirst(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: fontWeight500(),
        ),
      ),
    );
  }

  Widget _buildHideIcon(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        icon: _buildIcon(context, index - provider.overlayIndicators.length),
        onPressed: () {
          provider.trendlineHandlerList[trendlineTypes[index -
                      provider.overlayIndicators.length]
                  .id] =
              !provider.trendlineHandlerList[trendlineTypes[index -
                      provider.overlayIndicators.length]
                  .id]!;
          provider.isOverlayPopupUpdate = !provider.isOverlayPopupUpdate;
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext context, int index) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return provider.trendlineHandlerList[trendlineTypes[index].id]!
        ? const Icon(
            IconData(0xe71d, fontFamily: stockFontIconFamily),
            size: 16,
          )
        : const Icon(
            IconData(0xe71c, fontFamily: stockFontIconFamily),
            size: 16,
          );
  }

  Widget _buildCloseIcon(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        icon: const Icon(
          IconData(0xe717, fontFamily: stockFontIconFamily),
          size: 16,
        ),
        onPressed: () {
          provider.removeTrendlineHandler(
            trendlineTypes[index - provider.overlayIndicators.length],
          );
          provider.isOverlayPopupUpdate = !provider.isOverlayPopupUpdate;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        trendlineTypes.length + provider.overlayIndicators.length,
        (int index) {
          if (index < provider.overlayIndicators.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 4),
              child: SizedBox(height: 32),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(context, provider, index),
                  _buildHideIcon(context, provider, index),
                  _buildCloseIcon(context, provider, index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SymbolDropdown extends StatefulWidget {
  const SymbolDropdown({
    super.key,
    required this.child,
    required this.firstName,
    required this.lastName,
  });

  final Widget child;
  final String firstName;
  final String lastName;

  @override
  State<SymbolDropdown> createState() => _SymbolDropdownState();
}

class _SymbolDropdownState extends State<SymbolDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return Column(
      children: [
        PopupMenuButton<Stock>(
          tooltip: '',
          padding: EdgeInsets.zero,
          position: PopupMenuPosition.under,
          color: Theme.of(context).colorScheme.surface,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          constraints: const BoxConstraints(maxHeight: 244),
          onSelected: (Stock value) {
            context.read<StockChartProvider>()
              ..selectedStock = value
              ..isFilteringRange(false);
          },
          offset: const Offset(0, 30),
          popUpAnimationStyle: AnimationStyle.noAnimation,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<Stock>(
                value: Stock.apple,
                enabled: false,
                child: StockAutoComplete(
                  defaultStocks: provider.stockData,
                  onSelected: (Stock stock) {
                    context.read<StockChartProvider>()
                      ..selectedStock = stock
                      ..isFilteringRange(false);
                    Navigator.pop(context);
                  },
                  borderType: 'outline',
                  themeData: Theme.of(context),
                ),
              ),
            ];
          },
          child: widget.child,
        ),
      ],
    );
  }
}

mixin ChartBehaviorMixin {
  /// Builds Y axis based on chart settings.
  ChartAxis buildYAxis(BuildContext context, ChartSettings settings) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (settings.logarithmicYAxis) {
      return LogarithmicAxis(
        axisLine: const AxisLine(width: 0),
        opposedPosition: settings.opposedAxis,
        name: 'primaryYAxis',
        majorTickLines: MajorTickLines(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        majorGridLines: MajorGridLines(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        labelStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
        axisLabelFormatter: (AxisLabelRenderDetails axisLabelRenderArgs) {
          return ChartAxisLabel(
            '\$${axisLabelRenderArgs.text}',
            axisLabelRenderArgs.textStyle.copyWith(
              fontWeight: fontWeight500(),
              color: colorScheme.onSurface,
            ),
          );
        },
      );
    } else {
      return NumericAxis(
        opposedPosition: settings.opposedAxis,
        rangePadding: ChartRangePadding.round,
        majorTickLines: MajorTickLines(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        majorGridLines: MajorGridLines(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        name: 'primaryYAxis',
        labelStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
        axisLine: const AxisLine(width: 0),
        axisLabelFormatter: (AxisLabelRenderDetails axisLabelRenderArgs) {
          return ChartAxisLabel(
            '\$${axisLabelRenderArgs.text}',
            axisLabelRenderArgs.textStyle.copyWith(
              color: colorScheme.onSurface,
            ),
          );
        },
      );
    }
  }
}

class SearchStockPage extends StatefulWidget {
  const SearchStockPage({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  State<SearchStockPage> createState() => _SearchStockPageState();
}

class _SearchStockPageState extends State<SearchStockPage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _searchQuery = '';

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    final List<Stock> stocks = provider.stockData.keys.toList();
    final ThemeData themeData = Theme.of(context);
    final List<Stock> filteredStocks = _searchQuery.isEmpty
        ? stocks
        : stocks
              .where(
                (stock) => stock.toString().toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          shadowColor: const Color(0xff000026),
          surfaceTintColor: Colors.transparent,
          titleSpacing: 16.0,
          actionsPadding: const EdgeInsets.only(right: 16),
          automaticallyImplyLeading: false,
          actions: [
            buildCloseIconButton(context, () {
              context.read<StockChartProvider>().resetTempSettings();
              Navigator.of(context).pop();
            }),
          ],
          title: const Text('Search Stock'),
          backgroundColor: themeData.colorScheme.surface,
          elevation: 2.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          children: List.generate(filteredStocks.length + 1, (index) {
            if (index == 0) {
              return TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  hintText: 'Search',
                  suffixIcon: SizedBox.square(
                    dimension: 40,
                    child: Icon(Icons.search, size: 20),
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              );
            }

            final StockData stockData =
                provider.stockData[filteredStocks[index - 1]]!;
            return ListTile(
              onTap: () {
                context.read<StockChartProvider>()
                  ..selectedStock = filteredStocks[index - 1]
                  ..isFilteringRange(false);
                Navigator.pop(context);
              },
              titleTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: fontWeight500(),
              ),
              subtitleTextStyle: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              leading: SizedBox.square(
                child: SvgPicture.asset(stockData.logoSvgPath),
              ),
              title: Text(stockData.companyName),
              subtitle: Text(stockData.officialName),
            );
          }),
        ),
      ),
    );
  }
}
