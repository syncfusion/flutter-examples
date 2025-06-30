import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dialogs/mobile_dialog.dart';
import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../model/chart_data.dart';
import '../../model/watchlist.dart';
import '../../notifier/stock_chart_notifier.dart';
import '../stock_chart_view/stock_auto_complete.dart';
import 'create_watchlist_dialog.dart';

class AddStockDialog extends StatefulWidget {
  const AddStockDialog({super.key, required this.defaultStocks});

  final Map<Stock, StockData> defaultStocks;

  @override
  State<AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<Stock> _selectedStocks = [];
  Map<String, bool> _selectedWatchlists = {};
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();
    // Initialize with default watchlist selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StockChartProvider>(context, listen: false);
      final watchlists = provider.watchlists;

      if (watchlists.isNotEmpty) {
        // Default to first watchlist selected
        _selectedWatchlists = {
          for (final watchlist in watchlists)
            watchlist.id: watchlist.id == watchlists.first.id,
        };
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _addSelectedStock(Stock stock) {
    if (!_selectedStocks.contains(stock)) {
      setState(() {
        _selectedStocks.add(stock);
      });
    }
  }

  void _removeSelectedStock(Stock stock) {
    setState(() {
      _selectedStocks.remove(stock);
    });
  }

  void _toggleWatchlist(String watchlistId, bool selected) {
    setState(() {
      _selectedWatchlists[watchlistId] = selected;
    });
  }

  void _addStocksToWatchlists(BuildContext context) {
    final provider = Provider.of<StockChartProvider>(context, listen: false);

    // Get selected watchlists
    final selectedWatchlistIds = _selectedWatchlists.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Add each selected stock to each selected watchlist
    for (final watchlistId in selectedWatchlistIds) {
      final watchlist = provider.watchlists.firstWhere(
        (watchlist) => watchlist.id == watchlistId,
      );

      for (final stock in _selectedStocks) {
        provider.addStockToWatchlist(stock, watchlist);
      }
    }

    // Notify that watchlist has been updated
    provider.isWatchListAdded = !provider.isWatchListAdded;

    // Close dialog
    Navigator.of(context).pop();
  }

  void _showCreateWatchlistDialog(BuildContext context) {
    switch (deviceType(context)) {
      case DeviceType.desktop:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateWatchlistDialog(defaultStocks: widget.defaultStocks);
          },
        ).then((_) {
          // Refresh watchlist selection after creating a new watchlist
          setState(() {
            final StockChartProvider provider = Provider.of<StockChartProvider>(
              context,
              listen: false,
            );
            final List<Watchlist> watchlists = provider.watchlists;
            // Update selected watchlists map with any new watchlists
            for (final watchlist in watchlists) {
              if (!_selectedWatchlists.containsKey(watchlist.id)) {
                _selectedWatchlists[watchlist.id] = false;
              }
            }
          });
        });
        break;
      case DeviceType.mobile:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CreateWatchlistDialog(defaultStocks: widget.defaultStocks);
            },
          ),
        );
        break;
    }
  }

  Widget _buildDialogHeader(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add stock',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
        buildCloseIconButton(context, () {
          Navigator.of(context).pop();
        }),
      ],
    );
  }

  Widget _buildMobileContent(List<Watchlist> watchlists, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchStockText(context),
          const SizedBox(height: 8),
          _buildStockAutoComplete(),
          if (_selectedStocks.isNotEmpty) _buildSelectedStocks(),
          const SizedBox(height: 24),
          _buildSelectWatchlistText(context),
          const SizedBox(height: 8),
          _buildWatchlistCheckboxes(watchlists, context),
          _buildNewWatchlistButton(context),
        ],
      ),
    );
  }

  Widget _buildDesktopContent(
    List<Watchlist> watchlists,
    BuildContext context,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 3),
      child: _buildBody(context, watchlists),
    );
  }

  Column _buildBody(BuildContext context, List<Watchlist> watchlists) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSearchStockText(context),
        const SizedBox(height: 8),
        _buildStockAutoComplete(),
        if (_selectedStocks.isNotEmpty) _buildSelectedStocks(),
        const SizedBox(height: 24),
        _buildSelectWatchlistText(context),
        const SizedBox(height: 8),
        _buildWatchlistCheckboxes(watchlists, context),
        _buildNewWatchlistButton(context),
      ],
    );
  }

  Widget _buildSearchStockText(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Search stock',
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
    );
  }

  Widget _buildStockAutoComplete() {
    return StockAutoComplete(
      defaultStocks: widget.defaultStocks,
      onSelected: (Stock selection) {
        _addSelectedStock(selection);
      },
      borderType: 'outline',
      themeData: Theme.of(context),
    );
  }

  Widget _buildSelectedStocks() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 120),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _selectedStocks.map((stock) {
              final stockData = widget.defaultStocks[stock];
              if (stockData == null) {
                return const SizedBox.shrink();
              }
              return Chip(
                label: Text(stockData.officialName),
                deleteIcon: const Icon(
                  IconData(0xe717, fontFamily: stockFontIconFamily),
                  size: 18,
                ),
                onDeleted: () => _removeSelectedStock(stock),
              );
            }).toList(),
          ),
        ),
      ),
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

  Widget _buildNewWatchlistButton(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: TextButton.icon(
        icon: Icon(Icons.add, color: colorScheme.onSurfaceVariant),
        label: Text(
          'New Watchlist',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        onPressed: () {
          switch (deviceType(context)) {
            case DeviceType.mobile:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CreateWatchlistDialog(
                      defaultStocks: widget.defaultStocks,
                    );
                  },
                ),
              );
              break;
            case DeviceType.desktop:
              _showCreateWatchlistDialog(context);
              break;
          }
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
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
      onPressed:
          _selectedStocks.isEmpty || !_selectedWatchlists.values.contains(true)
          ? null
          : () => _addStocksToWatchlists(context),
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text('Add', style: TextStyle(color: colorScheme.primary)),
    );
  }

  Widget _buildDesktopView(List<Watchlist> watchlists) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: _buildDialogHeader(context),
      actions: _buildActionButtons(context),
      content: _buildDesktopContent(watchlists, context),
    );
  }

  Widget _buildMobileView(List<Watchlist> watchlists) {
    return MobileDialog(
      dialogType: 'Add Stock',
      content: _buildMobileContent(watchlists, context),
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
