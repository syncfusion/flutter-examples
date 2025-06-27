import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../enum.dart';
import '../../helper/helper.dart';
import '../../model/chart_data.dart';
import '../../model/chart_settings.dart';
import '../../notifier/stock_chart_notifier.dart';
import 'stock_chart.dart';
import 'stock_chart_interaction.dart';

class UnderlayIndicatorChartAndPopup extends StatelessWidget {
  const UnderlayIndicatorChartAndPopup({
    super.key,
    required this.indicatorInstance,
    required this.viewModel,
    this.index = -1,
    this.isLastIndicator = false,
    this.showIndicator = true,
  });

  final IndicatorInstance<UnderlayIndicatorType> indicatorInstance;
  final StockChartViewModel viewModel;
  final int index;
  final bool isLastIndicator;
  final bool showIndicator;

  Widget _buildIcon(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return provider.underlayIndicatorHandlerList[indicatorInstance.id]!
        ? const Icon(
            IconData(0xe71d, fontFamily: stockFontIconFamily),
            size: 16,
          )
        : const Icon(
            IconData(0xe71c, fontFamily: stockFontIconFamily),
            size: 16,
          );
  }

  Widget _buildTitle(
    BuildContext context,
    StockChartProvider provider,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        indicatorInstance.indicatorType.name.capitalizeFirst(),
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
        icon: _buildIcon(context),
        onPressed: () {
          provider.underlayIndicatorHandlerList[indicatorInstance.id] =
              !provider.underlayIndicatorHandlerList[indicatorInstance.id]!;
          provider.isUnderlayIndicatorPopupUpdate =
              !provider.isUnderlayIndicatorPopupUpdate;
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
          provider.removeUnderlayIndicatorHandler(indicatorInstance);
          provider.isUnderlayIndicatorPopupUpdate =
              !provider.isUnderlayIndicatorPopupUpdate;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Stack(
        children: [
          Builder(
            builder: (context) {
              return UnderlayIndicatorChart(
                indicatorInstance: viewModel.underlayIndicators[index],
                viewModel: viewModel,
                showIndicator: showIndicator,
                isLastIndicator: isLastIndicator,
              );
            },
          ),
          Container(
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
        ],
      ),
    );
  }
}

class UnderlayIndicatorChart extends StatefulWidget {
  const UnderlayIndicatorChart({
    Key? key,
    required this.indicatorInstance,
    required this.viewModel,
    required this.isLastIndicator,
    this.showIndicator = true,
  }) : super(key: key);
  final IndicatorInstance<UnderlayIndicatorType> indicatorInstance;
  final StockChartViewModel viewModel;
  final bool isLastIndicator;
  final bool showIndicator;

  @override
  State<UnderlayIndicatorChart> createState() => _UnderlayIndicatorChartState();
}

class _UnderlayIndicatorChartState extends State<UnderlayIndicatorChart>
    with ChartBehaviorMixin {
  // bool _isHover = false;
  @override
  void initState() {
    indicatorCrosshairBehavior = stockCrosshairBehavior();
    indicatorTrackballBehavior = stockTrackballBehavior();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    final ThemeData themeData = Theme.of(context);
    return SfCartesianChart(
      margin: EdgeInsets.zero,
      plotAreaBorderWidth: 0.5,
      primaryXAxis: DateTimeAxis(
        axisLabelFormatter: (AxisLabelRenderDetails axisLabelRenderArgs) {
          return widget.isLastIndicator
              ? ChartAxisLabel(
                  axisLabelRenderArgs.text,
                  axisLabelRenderArgs.textStyle,
                )
              : ChartAxisLabel('', axisLabelRenderArgs.textStyle);
        },
        rangePadding: ChartRangePadding.round,
        minimum: DateTime.parse(provider.viewModel.dataCollections.first.date),
        maximum: DateTime(2025),
        labelStyle: themeData.textTheme.labelMedium?.copyWith(
          color: themeData.colorScheme.onSurface,
        ),
        initialVisibleMinimum: primaryChartAxisController?.visibleMinimum,
        initialVisibleMaximum: primaryChartAxisController?.visibleMaximum,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        onRendererCreated: (DateTimeAxisController axisController) {
          provider.zoomingHandlerList[widget.indicatorInstance.id] =
              axisController;
        },
      ),
      onZooming: (ZoomPanArgs zoomingArgs) {
        if (!zoomingArgs.axis!.isVertical) {
          primaryChartAxisController?.zoomFactor =
              zoomingArgs.currentZoomFactor;
          primaryChartAxisController?.zoomPosition =
              zoomingArgs.currentZoomPosition;
          for (final DateTimeAxisController? axisController
              in provider.zoomingHandlerList.values) {
            axisController?.zoomFactor = zoomingArgs.currentZoomFactor;
            axisController?.zoomPosition = zoomingArgs.currentZoomPosition;
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
          primaryChartAxisController?.zoomFactor =
              zoomingArgs.currentZoomFactor;
          primaryChartAxisController?.zoomPosition =
              zoomingArgs.currentZoomPosition;
          for (final DateTimeAxisController? axisController
              in provider.zoomingHandlerList.values) {
            axisController?.zoomFactor = zoomingArgs.currentZoomFactor;
            axisController?.zoomPosition = zoomingArgs.currentZoomPosition;
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
          primaryChartAxisController?.zoomFactor =
              zoomingArgs.currentZoomFactor;
          primaryChartAxisController?.zoomPosition =
              zoomingArgs.currentZoomPosition;
          for (final DateTimeAxisController? axisController
              in provider.zoomingHandlerList.values) {
            axisController?.zoomFactor = zoomingArgs.currentZoomFactor;
            axisController?.zoomPosition = zoomingArgs.currentZoomPosition;
          }
          if (zoomingArgs.currentZoomFactor == 1 &&
              provider.selectedDateRange == DateRange.all) {
            provider.enableReset = false;
          } else {
            provider.enableReset = true;
          }
        }
      },
      primaryYAxis: buildYAxis(context, widget.viewModel.chartSettings),
      zoomPanBehavior: ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePanning: true,
        enablePinching: true,
        enableMouseWheelZooming: true,
        zoomMode: ZoomMode.x,
      ),
      tooltipBehavior: stockToolTipBehavior(widget.viewModel.chartSettings),
      trackballBehavior: widget.viewModel.chartSettings.trackballEnabled
          ? provider.indicatorTrackballList[widget.indicatorInstance.id]
          : null,
      crosshairBehavior: widget.viewModel.chartSettings.crosshairEnabled
          ? provider.indicatorCrosshairList[widget.indicatorInstance.id]
          : null,
      indicators: [_buildTechnicalIndicator(widget.viewModel.chartSettings)],
    );
  }

  /// Creates the appropriate technical indicator based on the
  /// selected indicator type.
  TechnicalIndicator<Data, DateTime> _buildTechnicalIndicator(
    ChartSettings settings,
  ) {
    final UnderlayIndicatorType indicator =
        widget.indicatorInstance.indicatorType;
    switch (indicator) {
      case UnderlayIndicatorType.macd:
        return _buildMACDIndicator();
      case UnderlayIndicatorType.rsi:
        return _buildRSIIndicator();
      case UnderlayIndicatorType.atr:
        return _buildATRIndicator();
      case UnderlayIndicatorType.momentum:
        return _buildMomentumIndicator();
      case UnderlayIndicatorType.ad:
        return _buildAccumulationDistributionIndicator();
      case UnderlayIndicatorType.stochastic:
        return _buildStochasticIndicator();
      case UnderlayIndicatorType.roc:
        return _buildROCIndicator();
    }
  }

  /// Creates a Moving Average Convergence Divergence (MACD) indicator.
  MacdIndicator<Data, DateTime> _buildMACDIndicator() {
    return MacdIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      closeValueMapper: (Data data, int index) => data.close,
      // name: 'MACD',
      seriesName: 'Price',
      yAxisName: 'primaryYAxis',
    );
  }

  /// Creates a Relative Strength Index (RSI) indicator.
  RsiIndicator<Data, DateTime> _buildRSIIndicator() {
    return RsiIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      closeValueMapper: (Data data, int index) => data.close,
      name: 'RSI',
    );
  }

  /// Creates an Average True Range (ATR) indicator.
  AtrIndicator<Data, DateTime> _buildATRIndicator() {
    return AtrIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      closeValueMapper: (Data data, int index) => data.close,
      name: 'ATR',
    );
  }

  /// Creates a Momentum indicator.
  MomentumIndicator<Data, DateTime> _buildMomentumIndicator() {
    return MomentumIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      openValueMapper: (Data data, int index) => data.open,
      closeValueMapper: (Data data, int index) => data.close,
      name: 'Momentum',
    );
  }

  /// Creates an Accumulation/Distribution (A/D) indicator.
  AccumulationDistributionIndicator<Data, DateTime>
  _buildAccumulationDistributionIndicator() {
    return AccumulationDistributionIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      closeValueMapper: (Data data, int index) => data.close,
    );
  }

  /// Creates a Stochastic Oscillator indicator.
  StochasticIndicator<Data, DateTime> _buildStochasticIndicator() {
    return StochasticIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      closeValueMapper: (Data data, int index) => data.close,
      openValueMapper: (Data datum, int index) => datum.open,
    );
  }

  /// Creates a Rate of Change (ROC) indicator.
  RocIndicator<Data, DateTime> _buildROCIndicator() {
    return RocIndicator<Data, DateTime>(
      isVisible: widget.showIndicator,
      animationDuration: 0.0,
      dataSource: widget.viewModel.dataCollections,
      xValueMapper: (Data data, int index) => DateTime.parse(data.date),
      highValueMapper: (Data data, int index) => data.high,
      lowValueMapper: (Data data, int index) => data.low,
      closeValueMapper: (Data data, int index) => data.close,
      openValueMapper: (Data datum, int index) => datum.open,
    );
  }
}
