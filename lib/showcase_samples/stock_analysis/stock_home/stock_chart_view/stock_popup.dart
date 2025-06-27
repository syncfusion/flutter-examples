import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../notifier/stock_chart_notifier.dart';

class StockDropdown<T extends Enum> extends StatelessWidget {
  const StockDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    required this.iconData,
    this.selectedType,
  });

  final String hintText;
  final List<T> items;
  final void Function(T?) onChanged;
  final IconData iconData;
  final T? selectedType;

  Widget _buildDropdown(BuildContext context) {
    return StockResponsiveDropdown<T>(
      hintText: hintText,
      items: items,
      onChanged: onChanged,
      iconData: iconData,
      selectedType: selectedType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDropdown(context);
  }
}

class StockResponsiveDropdown<T extends Enum> extends StatelessWidget {
  const StockResponsiveDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.isDateRangeDropdown = false,
    required this.iconData,
    this.selectedType,
  });

  final String hintText;
  final List<T> items;
  final void Function(T?) onChanged;
  final bool isDateRangeDropdown;
  final IconData iconData;
  final T? selectedType;

  Icon _iconForSeriesType(
    SeriesType type,
    BuildContext context, [
    double? iconSize,
  ]) {
    switch (type) {
      case SeriesType.area:
        return Icon(
          const IconData(0xe734, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.candle:
        return Icon(
          const IconData(0xe733, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.hollowCandle:
        return Icon(
          const IconData(0xe733, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.column:
        return Icon(
          const IconData(0xe735, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.line:
        return Icon(
          const IconData(0xe73a, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.hilo:
        return Icon(
          const IconData(0xe732, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.ohlc:
        return Icon(
          const IconData(0xe731, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.rangeColumn:
        return Icon(
          const IconData(0xe738, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.stepArea:
        return Icon(
          const IconData(0xe737, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case SeriesType.stepLine:
        return Icon(
          const IconData(0xe736, fontFamily: stockFontIconFamily),
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    }
  }

  Widget _menuItem(BuildContext context, T item) {
    String text;
    switch (item.runtimeType) {
      case DateRange:
        text = _formatDateRangeName(item as DateRange).capitalizeFirst();
        break;
      case OverlayIndicatorType:
      case UnderlayIndicatorType:
        text = _formatIndicatorName(item);
        break;
      case SeriesType:
        text = _formatSeriesName(item as SeriesType);
        break;
      default:
        text = item.name.capitalizeFirst();
        break;
    }

    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  String _formatIndicatorName(Enum indicatorType) {
    if (indicatorType is OverlayIndicatorType) {
      switch (indicatorType) {
        case OverlayIndicatorType.bollingerBand:
          return 'Bollinger Band';
        case OverlayIndicatorType.ema:
          return 'Exponential Moving Average';
        case OverlayIndicatorType.sma:
          return 'Simple Moving Average';
        case OverlayIndicatorType.tma:
          return 'Triangular Moving Average';
        case OverlayIndicatorType.wma:
          return 'Weighted Moving Average';
      }
    } else if (indicatorType is UnderlayIndicatorType) {
      switch (indicatorType) {
        case UnderlayIndicatorType.ad:
          return 'Accumulation Distribution';
        case UnderlayIndicatorType.atr:
          return 'Average True Range';
        case UnderlayIndicatorType.macd:
          return 'Moving Average Convergence Divergence';
        case UnderlayIndicatorType.momentum:
          return 'Momentum';
        case UnderlayIndicatorType.rsi:
          return 'Relative Strength Index';
        case UnderlayIndicatorType.roc:
          return 'Rate of Change';
        case UnderlayIndicatorType.stochastic:
          return 'Stochastic';
      }
    }

    // Fallback to capitalized name if not found
    return indicatorType.name.capitalizeFirst();
  }

  String _formatSeriesName(SeriesType type) {
    switch (type) {
      case SeriesType.area:
        return 'Area';
      case SeriesType.candle:
        return 'Candle';
      case SeriesType.hollowCandle:
        return 'Hollow Candle';
      case SeriesType.column:
        return 'Column';
      case SeriesType.line:
        return 'Line';
      case SeriesType.hilo:
        return 'Hilo';
      case SeriesType.ohlc:
        return 'OHLC';
      case SeriesType.rangeColumn:
        return 'Range Column';
      case SeriesType.stepArea:
        return 'Step Area';
      case SeriesType.stepLine:
        return 'Step Line';
    }
  }

  String _formatDateRangeName(DateRange dateRange) {
    switch (dateRange) {
      case DateRange.oneMonth:
        return '1M';
      case DateRange.threeMonth:
        return '3M';
      case DateRange.fiveMonth:
        return '5M';
      case DateRange.oneYear:
        return '1Y';
      // case DateRange.fiveYear:
      //   return '5Y';
      case DateRange.customRange:
        return 'Custom';
      case DateRange.all:
        return 'All';
    }
  }

  Widget _buildMobilePopup(BuildContext context, ThemeData themeData) {
    return PopupMenuButton<T>(
      icon: Icon(iconData, size: 18),
      position: PopupMenuPosition.under,
      color: Theme.of(context).colorScheme.surface,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      tooltip: '',
      itemBuilder: (BuildContext context) {
        return List.generate(items.length, (int index) {
          final T item = items[index];
          return PopupMenuItem<T>(
            height: 40,
            padding: EdgeInsets.zero,
            value: item,
            child: Container(
              height: 40,
              color: (selectedType != null && selectedType == item)
                  ? themeData.colorScheme.primaryContainer
                  : Colors.transparent,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                spacing: 10,
                children: [
                  if (hintText == 'Series')
                    _iconForSeriesType(item as SeriesType, context),
                  Flexible(child: _menuItem(context, item)),
                ],
              ),
            ),
          );
        });
      },
      onSelected: (T type) {
        if (type is DateRange && type == DateRange.customRange) {
          showDatePickerDialog(context);
        } else {
          onChanged(type);
        }
      },
    );
  }

  Widget _buildDesktopPopup(BuildContext context, ThemeData themeData) {
    return SizedBox(
      width: 120,
      child: PopupMenuButton<T>(
        position: PopupMenuPosition.under,
        color: Theme.of(context).colorScheme.surface,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        padding: EdgeInsets.zero,
        menuPadding: EdgeInsets.zero,
        tooltip: '',
        borderRadius: BorderRadius.circular(8.0),
        itemBuilder: (BuildContext context) {
          return List.generate(items.length, (int index) {
            final T item = items[index];
            return PopupMenuItem<T>(
              height: 40,
              padding: EdgeInsets.zero,
              value: item,
              child: Container(
                height: 40,
                color: (selectedType != null && selectedType == item)
                    ? themeData.colorScheme.primaryContainer
                    : Colors.transparent,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  spacing: 10,
                  children: [
                    if (hintText == 'Series')
                      _iconForSeriesType(item as SeriesType, context),
                    Flexible(child: _menuItem(context, item)),
                  ],
                ),
              ),
            );
          });
        },
        onSelected: (T type) {
          if (type is DateRange && type == DateRange.customRange) {
            showDatePickerDialog(context);
          } else {
            onChanged(type);
          }
        },
        child: SizedBox(
          height: 32,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: themeData.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 6,
                      children: [
                        if (hintText != 'Day Range')
                          _buildPopupIcon(iconData, context),
                        Flexible(
                          child: Text(
                            _formattedName(selectedType, hintText),
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              letterSpacing: 0.1,
                              fontWeight: fontWeight500(),
                              color: themeData.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    IconData(0xe704, fontFamily: stockFontIconFamily),
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formattedName(T? selectedType, String hintText) {
    if (selectedType != null) {
      switch (selectedType.runtimeType) {
        case DateRange:
          return _formatDateRangeName(
            selectedType as DateRange,
          ).capitalizeFirst();
        case SeriesType:
          return _formatSeriesName(selectedType as SeriesType);
        default:
          return selectedType.name.capitalizeFirst();
      }
    }
    return hintText;
  }

  Widget _buildPopupMenu(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = deviceType(context) == DeviceType.desktop;
    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) {
        return provider.isPopupMenuItemChanged;
      },
      builder: (BuildContext buildContext, bool value, Widget? child) {
        return isDesktop
            ? _buildDesktopPopup(context, themeData)
            : _buildMobilePopup(context, themeData);
      },
    );
  }

  Widget _buildPopupIcon(IconData iconData, BuildContext context) {
    if (hintText == 'Series') {
      return _iconForSeriesType(selectedType! as SeriesType, context, 16);
    }
    return Icon(
      iconData,
      size: 16,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPopupMenu(context);
  }
}

class StockResponsivePopup<T extends Enum> extends StatelessWidget {
  const StockResponsivePopup({
    super.key,
    required this.hintText,
    required this.items,
    required this.onSelected,
    required this.iconData,
  });

  final String hintText;
  final List<T> items;
  final void Function(T?) onSelected;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      position: PopupMenuPosition.under,
      color: Theme.of(context).colorScheme.surface,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      padding: EdgeInsets.zero,
      icon: Icon(iconData),
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<T>>.generate(items.length, (int index) {
          return PopupMenuItem<T>(
            value: items[index],
            child: Text(items[index].name.capitalizeFirst()),
          );
        });
      },
      onSelected: onSelected,
    );
  }
}
