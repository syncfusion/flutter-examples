// flutter_examples/lib/showcase_samples/stock_analysis/stock_home/stock_panel_view/select_watchlist_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dialogs/mobile_dialog.dart';
import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../model/chart_data.dart';
import '../../model/watchlist.dart';
import '../../notifier/stock_chart_notifier.dart';

class SelectWatchlistDialog extends StatefulWidget {
  const SelectWatchlistDialog({super.key, required this.stock});

  final Stock stock;

  @override
  State<SelectWatchlistDialog> createState() => _SelectWatchlistDialogState();
}

class _SelectWatchlistDialogState extends State<SelectWatchlistDialog> {
  Map<String, bool> _selectedWatchlists = {};
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();
    // Initialize all watchlists as unselected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StockChartProvider>(context, listen: false);
      final watchlists = provider.watchlists;

      if (watchlists.isNotEmpty) {
        _selectedWatchlists = {
          for (final watchlist in watchlists) watchlist.id: false,
        };
        setState(() {});
      }
    });
  }

  void _toggleWatchlist(String watchlistId, bool selected) {
    setState(() {
      _selectedWatchlists[watchlistId] = selected;
    });
  }

  void _addStockToWatchlists(BuildContext context) {
    final provider = Provider.of<StockChartProvider>(context, listen: false);

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

    // Notify that watchlist has been updated
    provider.isWatchListAdded = !provider.isWatchListAdded;

    // Close dialog
    Navigator.of(context).pop();
  }

  Widget _buildDialogHeader(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final StockData? stockData = context
        .read<StockChartProvider>()
        .stockData[widget.stock];
    final String stockName = stockData?.companyName ?? widget.stock.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add $stockName to Watchlist',
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
      'Select Watchlist',
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
    return [_buildCancelButton(context), _buildAddButton(context)];
  }

  Widget _buildCancelButton(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text('Cancel', style: TextStyle(color: colorScheme.primary)),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: !_selectedWatchlists.values.contains(true)
          ? null
          : () => _addStockToWatchlists(context),
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text('Add', style: TextStyle(color: colorScheme.primary)),
    );
  }

  Widget _buildDesktopContent(List<Watchlist> watchlists) {
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

  Widget _buildMobileContent(List<Watchlist> watchlists) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectWatchlistText(context),
          const SizedBox(height: 8),
          _buildWatchlistCheckboxes(watchlists, context),
        ],
      ),
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
        child: _buildDesktopContent(watchlists),
      ),
    );
  }

  Widget _buildMobileView(List<Watchlist> watchlists) {
    return MobileDialog(
      dialogType: 'Add to Watchlist',
      content: _buildMobileContent(watchlists),
      action: _buildAddButton(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isDesktop = deviceType(context) == DeviceType.desktop;
    final List<Watchlist> watchlists = context
        .watch<StockChartProvider>()
        .watchlists;

    return _isDesktop
        ? _buildDesktopView(watchlists)
        : _buildMobileView(watchlists);
  }
}
