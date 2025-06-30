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

class EditWatchlistDialog extends StatefulWidget {
  const EditWatchlistDialog({
    super.key,
    required this.defaultStocks,
    required this.selectedWatchlist,
  });

  final Map<Stock, StockData> defaultStocks;
  final Watchlist selectedWatchlist;

  @override
  State<EditWatchlistDialog> createState() => _EditWatchlistDialogState();
}

class _EditWatchlistDialogState extends State<EditWatchlistDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<Stock> _selectedStocks = [];
  bool _isDesktop = false;

  @override
  void initState() {
    _selectedStocks.addAll(widget.selectedWatchlist.stocks);
    _nameController.text = widget.selectedWatchlist.name;
    super.initState();
  }

  void _addSelectedStock(Stock stock) {
    if (!_selectedStocks.contains(stock)) {
      setState(() {
        _selectedStocks.add(stock);
      });
    }
  }

  void _removeSelectedStock(Stock stock) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    provider.removeStockFromWatchlist(
      stock,
      widget.selectedWatchlist,
      isNotify: false,
    );
    setState(() {
      _selectedStocks.remove(stock);
    });
  }

  void _editNewWatchlist(BuildContext context) {
    if (_nameController.text.isEmpty) {
      return;
    }
    final StockChartProvider provider = context.read<StockChartProvider>();
    for (final stock in _selectedStocks) {
      provider.addStockToWatchlist(stock, widget.selectedWatchlist);
    }
    if (_nameController.text != widget.selectedWatchlist.name) {
      widget.selectedWatchlist.name = _nameController.text;
    }
    provider.isWatchListAdded = !provider.isWatchListAdded;
    Navigator.of(context).pop();
  }

  Widget _buildWatchlistHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildWatchlistTitle(context), _buildCloseButton(context)],
    );
  }

  Widget _buildWatchlistTitle(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Edit Watchlist',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: fontWeight500(),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return buildCloseIconButton(context, () {
      context.read<StockChartProvider>().resetTempSettings();
      Navigator.of(context).pop();
    });
  }

  Widget _buildDesktopWatchlistContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWatchlistNameText(context),
          const SizedBox(height: 8),
          _buildNameTextField(),
          const SizedBox(height: 24),
          _buildSelectStockText(context),
          const SizedBox(height: 8),
          _buildStockAutocomplete(),
          if (_selectedStocks.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSelectedStocksChips(),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileWatchlistContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWatchlistNameText(context),
          const SizedBox(height: 8),
          _buildNameTextField(),
          const SizedBox(height: 24),
          _buildSelectStockText(context),
          const SizedBox(height: 8),
          _buildStockAutocomplete(),
          if (_selectedStocks.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSelectedStocksChips(),
          ],
        ],
      ),
    );
  }

  Widget _buildWatchlistNameText(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Edit Watchlist',
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildNameTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Watchlist Name',
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildSelectStockText(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Select stock to add to your new watchlist',
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildStockAutocomplete() {
    return StockAutoComplete(
      defaultStocks: widget.defaultStocks,
      onSelected: (Stock selection) {
        _addSelectedStock(selection);
      },
      borderType: 'outline',
      themeData: Theme.of(context),
    );
  }

  Widget _buildSelectedStocksChips() {
    return Wrap(
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
    );
  }

  List<Widget> _buildActionButtons() {
    return [_buildCancelButton(), _buildEditButton()];
  }

  Widget _buildCancelButton() {
    final ThemeData themeData = Theme.of(context);
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text(
        'Cancel',
        style: themeData.textTheme.labelLarge?.copyWith(
          color: themeData.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    final ThemeData themeData = Theme.of(context);
    return TextButton(
      onPressed: _handleEditButtonPressed,
      style: TextButton.styleFrom(elevation: 1.0),
      child: Text(
        'Edit',
        style: themeData.textTheme.labelLarge?.copyWith(
          color: themeData.colorScheme.primary,
        ),
      ),
    );
  }

  void _handleEditButtonPressed() {
    if (_nameController.text.isNotEmpty) {
      _editNewWatchlist(context);
    }
  }

  Widget _buildDesktopView(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      contentPadding: const EdgeInsets.all(24.0),
      title: _buildWatchlistHeader(context),
      content: _buildDesktopWatchlistContent(context),
      actions: _buildActionButtons(),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return MobileDialog(
      dialogType: 'Edit Watchlist',
      content: _buildMobileWatchlistContent(context),
      action: _buildEditButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isDesktop = deviceType(context) == DeviceType.desktop;
    return _isDesktop ? _buildDesktopView(context) : _buildMobileView(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
