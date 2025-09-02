// Stock Selection Panel Module
// Handles stock browsing, filtering, and watchlist management
// Provides tabbed interface for viewing all stocks and user watchlists

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../model/chart_data.dart';
import '../../model/watchlist.dart';
import '../../notifier/stock_chart_notifier.dart';
import '../stock_chart_view/stock_auto_complete.dart';
import 'add_stock_dialog.dart';
import 'create_watchlist_dialog.dart';
import 'edit_watchlist_dialog.dart';
import 'select_watchlist_dialog.dart';
import 'watchlist_action_dialog.dart';

/// Main panel for stock selection and watchlist management.
/// Provides tabbed interface for browsing stocks and managing watchlists.
class StockSelectionPanel extends StatefulWidget {
  /// Creates a stock selection panel with required data.
  const StockSelectionPanel({
    super.key,
    required this.defaultStocks,
    required this.firstName,
    required this.lastName,
    this.scrollController,
  });

  /// Stock data to display in the panel.
  final Map<Stock, StockData> defaultStocks;

  /// User's first name.
  final String firstName;

  /// User's last name.
  final String lastName;

  /// Controller for scrollable sheet (used in mobile view).
  final DraggableScrollableController? scrollController;

  @override
  State<StockSelectionPanel> createState() => _StockSelectionPanelState();
}

class _StockSelectionPanelState extends State<StockSelectionPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Builds the tab bar for switching between all stocks and watchlist.
  Widget _buildTabBar() {
    final ThemeData themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        height: 40.0,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Stock'),
            Tab(text: 'Watchlist'),
          ],
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.zero,
          dividerHeight: 1.0,
          dividerColor: themeData.colorScheme.outlineVariant,
          labelStyle: themeData.textTheme.labelLarge?.copyWith(
            fontWeight: fontWeight500(),
          ),
          labelColor: themeData.colorScheme.primary,
          unselectedLabelColor: themeData.colorScheme.onSurfaceVariant,
          indicatorColor: themeData.colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.label,
          splashBorderRadius: const BorderRadius.all(Radius.circular(12.0)),
          onTap: (int value) => setState(() {}),
          unselectedLabelStyle: themeData.textTheme.labelLarge?.copyWith(
            fontWeight: fontWeight500(),
          ),
        ),
      ),
    );
  }

  /// Builds the watchlist controls section if on watchlist tab.
  Widget _buildWatchlistControls() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
          child: StockWatchList(defaultStocks: widget.defaultStocks),
        ),
        Divider(
          thickness: 1.0,
          height: 1.0,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ],
    );
  }

  /// Builds the search field for finding stocks.
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 12.0, right: 12.0),
      child: StockAutoComplete(
        defaultStocks: widget.defaultStocks,
        onSelected: _handleOptionSelected,
        themeData: Theme.of(context),
      ),
    );
  }

  /// Handles selection of a stock from the autocomplete.
  void _handleOptionSelected(Stock selection) {
    final StockChartProvider provider = context.read<StockChartProvider>();

    switch (deviceType(context)) {
      case DeviceType.desktop:
        provider
          ..selectedStock = selection
          ..isFilteringRange(false);
        break;
      case DeviceType.mobile:
        provider
          ..selectedStock = selection
          ..isFilteringRange(false);
        widget.scrollController?.reset();
        break;
    }
  }

  /// Builds the stock list view with tabs.
  Widget _buildStockListView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _StockList(
            searchQuery: '',
            defaultStocks: widget.defaultStocks,
            scrollController: widget.scrollController,
          ),
          _StockList(
            searchQuery: '',
            isWatchListTab: true,
            defaultStocks: widget.defaultStocks,
            scrollController: widget.scrollController,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.isWatchListAdded,
      builder: (BuildContext context, bool value, Widget? child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                blurRadius: 2.0,
                offset: Offset(0, 1.0),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              _buildTabBar(),
              if (_tabController.index == 1) _buildWatchlistControls(),
              _buildSearchField(),
              _buildStockListView(),
            ],
          ),
        );
      },
    );
  }
}

/// Internal widget for displaying a filtered list of stocks.
class _StockList extends StatelessWidget {
  /// Creates a stock list with the given parameters.
  const _StockList({
    required this.searchQuery,
    this.isWatchListTab = false,
    required this.defaultStocks,
    this.scrollController,
  });

  /// Search query for filtering stocks.
  final String searchQuery;

  /// Whether this list is in the watchlist tab.
  final bool isWatchListTab;

  /// Stock data to display.
  final Map<Stock, StockData> defaultStocks;

  /// Controller for scrollable sheet (used in mobile view).
  final DraggableScrollableController? scrollController;

  /// Filters stocks based on search query.
  List<Stock> _filterStocks(List<Stock> stocks) {
    return searchQuery.isEmpty
        ? stocks
        : stocks
              .where(
                (stock) => stock.toString().toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
  }

  /// Builds the watchlist stocks view.
  Widget _buildWatchlistStocks(BuildContext context) {
    final StockChartProvider provider = context.watch<StockChartProvider>();
    final Watchlist? selectedWatchlist = provider.selectedWatchlist;

    if (selectedWatchlist == null || selectedWatchlist.stocks.isEmpty) {
      return const Center(child: Text('No stocks in this watchlist'));
    }

    final List<Stock> filteredStocks = _filterStocks(selectedWatchlist.stocks);

    if (filteredStocks.isEmpty) {
      return const Center(child: Text('No matching stocks found'));
    }

    return _buildStocksListView(filteredStocks);
  }

  /// Builds the all stocks view.
  Widget _buildAllStocks(BuildContext context) {
    const List<Stock> stockItems = Stock.values;
    final List<Stock> filteredStocks = _filterStocks(stockItems);
    return _buildStocksListView(filteredStocks);
  }

  /// Builds the list view of stocks.
  Widget _buildStocksListView(List<Stock> stocks) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (BuildContext context, int index) {
        final Stock stock = stocks[index];
        final StockData? stockData = defaultStocks[stock];

        if (stockData == null) {
          return const SizedBox.shrink();
        } else {
          return StockListItem(
            key: ValueKey<Stock>(stock),
            stockItem: stock,
            stock: stockData,
            defaultStocks: defaultStocks,
            scrollableController: scrollController,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isWatchListTab
        ? _buildWatchlistStocks(context)
        : _buildAllStocks(context);
  }
}

/// Widget for displaying a single stock item in the list.
class StockListItem extends StatefulWidget {
  /// Creates a stock list item with the given stock data.
  const StockListItem({
    super.key,
    required this.stockItem,
    required this.stock,
    required this.defaultStocks,
    this.scrollableController,
  });

  final Stock stockItem;

  /// Stock data to display.
  final StockData stock;

  /// All available stock data.
  final Map<Stock, StockData> defaultStocks;

  /// Controller for scrollable sheet (used in mobile view).
  final DraggableScrollableController? scrollableController;

  @override
  State<StockListItem> createState() => _StockListItemState();
}

class _StockListItemState extends State<StockListItem> {
  final GlobalKey _tileKey = GlobalKey();
  bool _isHovered = false;

  Widget _buildPopup(StockChartProvider provider) {
    return SizedBox.square(
      dimension: 32,
      child: PopupMenuButton(
        tooltip: '',
        icon: const Icon(
          IconData(0xe716, fontFamily: stockFontIconFamily),
          size: 16.0,
        ),
        onSelected: (value) {},
        itemBuilder: (BuildContext context) =>
            _menuItems(widget.stock.isFavorite),
      ),
    );
  }

  List<PopupMenuEntry<String>> _menuItems(bool isFavorite) {
    return [
      PopupMenuItem(
        value: 'toggle_watchlist',
        child: Text(isFavorite ? 'Remove from Watchlist' : 'Add to Watchlist'),
        onTap: () {
          _showWatchlistActionDialog(context, widget.stockItem, isFavorite);
        },
      ),
    ];
  }

  void _showWatchlistActionDialog(
    BuildContext buildContext,
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

  // Add this function to a utility file or the relevant class

  /// Shows the watchlist selection dialog.
  /// Only shows dialog if multiple watchlists exist, otherwise adds directly to the default watchlist.
  void showWatchlistSelectionDialog(BuildContext context, Stock stock) {
    final StockChartProvider provider = Provider.of<StockChartProvider>(
      context,
      listen: false,
    );
    final List<Watchlist> watchlists = provider.watchlists;

    if (watchlists.length <= 1) {
      // If only one or no watchlists, add directly to the default watchlist
      if (watchlists.isNotEmpty) {
        provider.addStockToWatchlist(stock, watchlists.first);
        provider.isWatchListAdded = !provider.isWatchListAdded;
      }
      return;
    }

    // If multiple watchlists, show selection dialog
    switch (deviceType(context)) {
      case DeviceType.desktop:
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              SelectWatchlistDialog(stock: stock),
        );
        break;
      case DeviceType.mobile:
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                SelectWatchlistDialog(stock: stock),
          ),
        );
        break;
    }
  }

  /// Builds the stock price and change display.
  Widget _buildStockPriceInfo(
    BuildContext context,
    Data data,
    bool isIncreased,
  ) {
    final ThemeData themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${data.currentPrice}',
          style: themeData.textTheme.labelLarge?.copyWith(
            color: themeData.colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        Text(
          '${isIncreased ? '+' : ''}${data.percentageChange} %',
          style: themeData.textTheme.labelMedium?.copyWith(
            color: isIncreased ? Colors.green : themeData.colorScheme.error,
            fontWeight: fontWeight500(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Data data = widget.stock.data.last;
    final bool isStockValueIncreased = !data.percentageChange.isNegative;
    final StockChartProvider provider = context.read<StockChartProvider>();
    final ThemeData themeData = Theme.of(context);
    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.selectedStock == widget.stock.stock,
      builder: (BuildContext context, bool isSelected, Widget? child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Material(
            child: ListTile(
              key: _tileKey,
              selectedTileColor: widget.stock.stock == provider.selectedStock
                  ? themeData.colorScheme.primaryContainer
                  : themeData.colorScheme.surface,
              selectedColor: themeData.colorScheme.onSurface,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              minVerticalPadding: 0.0,
              minTileHeight: 0.0,
              leading: _buildStockLogo(context),
              title: Text(
                widget.stock.companyName,
                style: themeData.textTheme.labelLarge?.copyWith(
                  color: themeData.colorScheme.onSurface,
                  fontWeight: fontWeight500(),
                ),
              ),
              onLongPress: deviceType(context) == DeviceType.mobile
                  ? () {
                      final RenderBox renderBox =
                          _tileKey.currentContext!.findRenderObject()!
                              as RenderBox;
                      final Offset offset = renderBox.localToGlobal(
                        Offset.zero,
                      );
                      final RelativeRect position = RelativeRect.fromLTRB(
                        renderBox.size.width,
                        offset.dy,
                        renderBox.size.width,
                        offset.dy + renderBox.size.height,
                      );
                      showMenu(
                        context: context,
                        position: position,
                        items: _menuItems(widget.stock.isFavorite),
                      );
                    }
                  : null,
              subtitle: Text(
                widget.stock.officialName,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                  fontWeight: fontWeight400(),
                ),
              ),
              trailing: !_isHovered
                  ? _buildStockPriceInfo(context, data, isStockValueIncreased)
                  : _buildPopup(provider),
              onTap: () => _handleStockSelection(provider),
            ),
          ),
        );
      },
    );
  }

  /// Builds the stock logo display with circular design.
  Widget _buildStockLogo(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: 40.0, // Slightly larger for better visibility
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: themeData.colorScheme.outlineVariant),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: SvgPicture.asset(widget.stock.logoSvgPath)),
      ),
    );
  }

  /// Handles selection of a stock from the list.
  void _handleStockSelection(StockChartProvider provider) {
    provider
      ..selectedStock = widget.stock.stock
      ..isFilteringRange(false);
    widget.scrollableController?.reset();
  }
}

class StockWatchList extends StatefulWidget {
  const StockWatchList({required this.defaultStocks, super.key});

  final Map<Stock, StockData> defaultStocks;

  @override
  State<StockWatchList> createState() => _StockWatchListState();
}

class _StockWatchListState extends State<StockWatchList> {
  Widget _buildPopupMenuButton(
    BuildContext context,
    StockChartProvider provider,
    List<Watchlist> watchlists,
    Watchlist? selectedWatchlist,
  ) {
    final ThemeData themeData = Theme.of(context);

    return PopupMenuButton<Watchlist>(
      tooltip: '',
      position: PopupMenuPosition.under,
      color: Theme.of(context).colorScheme.surface,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),

      onSelected: (Watchlist watchlist) {
        if (watchlist.id == 'Add Watchlist') {
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
        } else {
          provider.selectedWatchlist = watchlist;
        }
      },
      menuPadding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context) =>
          _buildPopupMenuItem(watchlists, selectedWatchlist),
      icon: _buildPopupTitle(context, selectedWatchlist, themeData),
    );
  }

  /// Builds the popup menu items for watchlist selection.
  List<PopupMenuEntry<Watchlist>> _buildPopupMenuItem(
    List<Watchlist> watchlists,
    Watchlist? selectedWatchlist,
  ) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final List<PopupMenuEntry<Watchlist>> watchlistData = watchlists.map((
      watchlist,
    ) {
      return PopupMenuItem<Watchlist>(
        value: watchlist,
        child: Text(
          watchlist.name,
          style: themeData.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      );
    }).toList();
    watchlistData.add(
      PopupMenuItem<Watchlist>(
        value: Watchlist(id: 'Add Watchlist', name: 'Add Watchlist'),
        child: _buildNewWatchlistButton(context, selectedWatchlist),
      ),
    );
    return watchlistData;
  }

  Widget _buildNewWatchlistButton(
    BuildContext context,
    Watchlist? selectedWatchlist,
  ) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Icon(Icons.add, color: colorScheme.onSurface),
        Text(
          'Add Watchlist',
          style: themeData.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _showCreateWatchlistDialog(BuildContext context) {
    switch (deviceType(context)) {
      case DeviceType.desktop:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateWatchlistDialog(defaultStocks: widget.defaultStocks);
          },
        );
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

  /// Builds the title for the watchlist popup menu.
  Widget _buildPopupTitle(
    BuildContext context,
    Watchlist? selectedWatchlist,
    ThemeData themeData,
  ) {
    final double width = deviceType(context) == DeviceType.desktop
        ? MediaQuery.of(context).size.width * 0.079
        : double.infinity;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              selectedWatchlist?.name ?? 'Default watchlist',
              style: themeData.textTheme.titleMedium?.copyWith(
                color: themeData.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8.0),
          const Icon(
            IconData(0xe704, fontFamily: stockFontIconFamily),
            size: 12.0,
          ),
        ],
      ),
    );
  }

  /// Builds the add stock button.
  Widget _buildAddStockButton(
    BuildContext context,
    StockChartProvider provider,
  ) {
    final ThemeData themeData = Theme.of(context);
    final double width = deviceType(context) == DeviceType.desktop
        ? MediaQuery.of(context).size.width * 0.085
        : 108.0;

    return SizedBox(
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: themeData.colorScheme.primary),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.add),
            Flexible(child: Text('Add stock', overflow: TextOverflow.ellipsis)),
          ],
        ),
        onPressed: () => _handleAddStockPressed(context, provider),
      ),
    );
  }

  /// Handles pressing the add stock button.
  void _handleAddStockPressed(
    BuildContext context,
    StockChartProvider provider,
  ) {
    switch (deviceType(context)) {
      case DeviceType.mobile:
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return AddStockDialog(defaultStocks: provider.stockData);
            },
          ),
        );
        break;
      case DeviceType.desktop:
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AddStockDialog(defaultStocks: provider.stockData);
          },
        );
        break;
    }
  }

  /// Builds the more options popup menu.
  Widget _buildMoreVertPopup(
    BuildContext context,
    Watchlist? selectedWatchlist,
    List<Watchlist> watchlists,
  ) {
    return SizedBox.square(
      dimension: 32.0,
      child: PopupMenuButton<String>(
        tooltip: '',
        position: PopupMenuPosition.under,
        color: Theme.of(context).colorScheme.surface,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: const Icon(
          IconData(0xe716, fontFamily: stockFontIconFamily),
          size: 16.0,
        ),
        onSelected: (String value) =>
            _handleMoreVertOptionSelected(context, selectedWatchlist, value),
        itemBuilder: (BuildContext context) =>
            _buildMoreVertPopupMenuItem(watchlists),
      ),
    );
  }

  /// Handles selection from the more options menu.
  void _handleMoreVertOptionSelected(
    BuildContext context,
    Watchlist? selectedWatchlist,
    String value,
  ) {
    if (selectedWatchlist == null) {
      return;
    }

    if (value == 'edit_watchlist') {
      switch (deviceType(context)) {
        case DeviceType.desktop:
          _showEditWatchlistDialog(context, selectedWatchlist);
          break;
        case DeviceType.mobile:
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return EditWatchlistDialog(
                  defaultStocks: context.read<StockChartProvider>().stockData,
                  selectedWatchlist: selectedWatchlist,
                );
              },
            ),
          );
          break;
      }
    } else if (value == 'delete_watchlist') {
      _showDeleteWatchlistDialog(context, selectedWatchlist);
    }
  }

  /// Builds the more options menu items.
  List<PopupMenuEntry<String>> _buildMoreVertPopupMenuItem(
    List<Watchlist> watchlists,
  ) {
    return [
      const PopupMenuItem<String>(
        value: 'edit_watchlist',
        child: Text('Edit Watchlist'),
      ),
      if (watchlists.length > 1)
        const PopupMenuItem<String>(
          value: 'delete_watchlist',
          child: Text('Delete Watchlist'),
        ),
    ];
  }

  /// Shows the edit watchlist dialog.
  void _showEditWatchlistDialog(BuildContext context, Watchlist watchlist) {
    final StockChartProvider provider = context.read<StockChartProvider>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return EditWatchlistDialog(
          defaultStocks: provider.stockData,
          selectedWatchlist: watchlist,
        );
      },
    );
  }

  /// Shows the delete watchlist confirmation dialog.
  void _showDeleteWatchlistDialog(BuildContext context, Watchlist watchlist) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Watchlist'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text('Are you sure you want to delete "${watchlist.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<StockChartProvider>().removeWatchlist(
                  watchlist.id,
                );
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: DefaultTextStyle.of(context).style.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.watch<StockChartProvider>();
    final List<Watchlist> watchlists = provider.watchlists;
    final Watchlist? selectedWatchlist = provider.selectedWatchlist;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPopupMenuButton(context, provider, watchlists, selectedWatchlist),
        Row(
          children: [
            _buildAddStockButton(context, provider),
            const SizedBox(width: 6.0),
            _buildMoreVertPopup(context, selectedWatchlist, watchlists),
          ],
        ),
      ],
    );
  }
}
