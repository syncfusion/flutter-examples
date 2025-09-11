// Create this file: flutter_examples/lib/showcase_samples/stock_analysis/stock_home/stock_panel_view/watchlist_action_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dialogs/mobile_dialog.dart';
import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../model/watchlist.dart';
import '../../notifier/stock_chart_notifier.dart';

class WatchlistActionDialog extends StatefulWidget {
  const WatchlistActionDialog({
    super.key,
    required this.stock,
    this.isRemoving = false,
  });

  final Stock stock;
  final bool isRemoving;

  @override
  State<WatchlistActionDialog> createState() => _WatchlistActionDialogState();
}

class _WatchlistActionDialogState extends State<WatchlistActionDialog> {
  Map<String, bool> _selectedWatchlists = {};
  Watchlist? _containingWatchlist;

  @override
  void initState() {
    super.initState();

    // Initialize all watchlists as unselected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StockChartProvider>(context, listen: false);
      final watchlists = provider.watchlists;

      if (widget.isRemoving) {
        // Find the watchlist containing this stock
        for (final watchlist in watchlists) {
          if (watchlist.containsStock(widget.stock)) {
            _containingWatchlist = watchlist;
            break;
          }
        }
      }

      if (watchlists.isNotEmpty) {
        _selectedWatchlists = {
          for (final watchlist in watchlists)
            watchlist.id:
                widget.isRemoving && _containingWatchlist == watchlist,
        };
        setState(() {});
      }
    });
  }

  void _toggleWatchlist(String watchlistId, bool selected) {
    setState(() {
      if (widget.isRemoving) {
        // In remove mode, only one watchlist can be selected at a time
        _selectedWatchlists.forEach((key, value) {
          _selectedWatchlists[key] = value;
        });
      }
      _selectedWatchlists[watchlistId] = selected;
    });
  }

  void _handleWatchlistAction(BuildContext context) {
    final provider = Provider.of<StockChartProvider>(context, listen: false);

    if (widget.isRemoving) {
      // Get all selected watchlists
      final selectedWatchlistIds = _selectedWatchlists.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Remove stock from each selected watchlist
      for (final watchlistId in selectedWatchlistIds) {
        final watchlist = provider.watchlists.firstWhere(
          (watchlist) => watchlist.id == watchlistId,
        );
        provider.removeStockFromWatchlist(widget.stock, watchlist);
      }
    } else {
      // Get selected watchlists
      final selectedWatchlistIds = _selectedWatchlists.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Add stock to each selected watchlist
      for (final watchlistId in selectedWatchlistIds) {
        final watchlist = provider.watchlists.firstWhere(
          (watchlist) => watchlist.id == watchlistId,
        );
        provider.addStockToWatchlist(widget.stock, watchlist);
      }
    }

    // Notify that watchlist has been updated
    provider.isWatchListAdded = !provider.isWatchListAdded;

    // Close dialog
    Navigator.of(context).pop();
  }

  Widget _buildDialogHeader(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // final StockData? stockData =
    //     context.read<StockChartProvider>().stockData[widget.stock];
    // final String stockName = stockData?.companyName ?? widget.stock.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.isRemoving
              ? 'Remove Stock in Watchlist'
              : 'Add Stock in Watchlist',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
        buildCloseIconButton(context, () {
          context.read<StockChartProvider>().resetTempSettings();
          Navigator.of(context).pop();
        }),
      ],
    );
  }

  Widget _buildSelectWatchlistText(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Text(
      widget.isRemoving
          ? 'Select Watchlist to Remove From'
          : 'Select Watchlist',
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
    );
  }

  Widget _buildWatchlistCheckboxes(
    List<Watchlist> watchlists,
    BuildContext context,
  ) {
    final ThemeData themeData = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: watchlists.map((watchlist) {
            // When removing, only show watchlists that contain the stock
            if (widget.isRemoving && !watchlist.containsStock(widget.stock)) {
              return const SizedBox.shrink();
            }

            return CheckboxListTile(
              title: Text(
                watchlist.name,
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.onSurface,
                ),
              ),
              value: _selectedWatchlists[watchlist.id] ?? false,
              onChanged: (bool? value) {
                if (value != null) {
                  _toggleWatchlist(watchlist.id, value);
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return [_buildCancelButton(context), _buildActionButton(context)];
  }

  Widget _buildCancelButton(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text('Cancel', style: TextStyle(color: colorScheme.primary)),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: !_selectedWatchlists.values.contains(true)
          ? null
          : () => _handleWatchlistAction(context),
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text(
        widget.isRemoving ? 'Remove' : 'Add',
        style: TextStyle(
          color: _selectedWatchlists.values.contains(true)
              ? colorScheme.primary
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDialogContent(List<Watchlist> watchlists) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSelectWatchlistText(context),
        const SizedBox(height: 8),
        _buildWatchlistCheckboxes(watchlists, context),
      ],
    );
  }

  Widget _buildMobileView(List<Watchlist> watchlists) {
    return MobileDialog(
      dialogType: widget.isRemoving
          ? 'Remove Stock in Watchlist'
          : 'Add Stock in Watchlist',
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildDialogContent(watchlists),
      ),
      action: _buildActionButton(context),
    );
  }

  Widget _buildDesktopView(List<Watchlist> watchlists) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: _buildDialogHeader(context),
      actions: _buildActionButtons(context),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * (1 / 4),
        child: _buildDialogContent(watchlists),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = deviceType(context) == DeviceType.desktop;
    final List<Watchlist> watchlists = context
        .watch<StockChartProvider>()
        .watchlists;

    return isDesktop
        ? _buildDesktopView(watchlists)
        : _buildMobileView(watchlists);
  }
}
