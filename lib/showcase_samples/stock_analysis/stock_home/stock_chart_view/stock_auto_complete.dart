import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../enum.dart';
import '../../helper/helper.dart';
import '../../model/chart_data.dart';
import '../../notifier/stock_chart_notifier.dart';

class StockAutoComplete extends StatefulWidget {
  const StockAutoComplete({
    super.key,
    required this.defaultStocks,
    required this.onSelected,
    required this.themeData,
    this.borderType = 'underline',
  });

  final Map<Stock, StockData> defaultStocks;
  final Function(Stock)? onSelected;
  final String borderType;
  final ThemeData themeData;

  @override
  State<StockAutoComplete> createState() => _StockAutoCompleteState();
}

class _StockAutoCompleteState extends State<StockAutoComplete> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textFieldKey = GlobalKey();

  bool _isDropdownOpen = false;
  String _searchQuery = '';
  List<Stock> _filteredStocks = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      return;
    }

    _isDropdownOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _isDropdownOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _removeOverlay();
    _showOverlay();
  }

  void _filterStocks(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredStocks = [];
      } else {
        _filteredStocks = widget.defaultStocks.keys
            .where((stock) => stock.name.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });

    if (_isDropdownOpen) {
      _updateOverlay();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
        _textFieldKey.currentContext!.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            elevation: 4.0,
            color: widget.themeData.colorScheme.surface,
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    60.0 *
                    (_filteredStocks.isEmpty
                        ? 1
                        : _filteredStocks.length.clamp(1, 5)),
              ),
              child: _searchQuery.isEmpty
                  ? const SizedBox.shrink()
                  : _filteredStocks.isEmpty
                  ? _buildNoResultsView()
                  : _buildResultsList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsView() {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'No Stocks Found',
          style: widget.themeData.textTheme.bodyMedium?.copyWith(
            color: widget.themeData.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _filteredStocks.length,
      itemBuilder: (context, index) {
        final stock = _filteredStocks[index];
        final stockData = _findSelectedStock(stock);
        return SizedBox(
          height: 60,
          child: ListTile(
            leading: _buildOptionLeadingIcon(stockData),
            title: _buildOptionTitle(stock),
            subtitle: _buildOptionSubTitle(stockData),
            onTap: () {
              _controller.text = '';
              if (widget.onSelected != null) {
                widget.onSelected!(stock);
              }
              _removeOverlay();
            },
          ),
        );
      },
    );
  }

  StockData _findSelectedStock(Stock option) {
    return context
        .read<StockChartProvider>()
        .viewModel
        .stockData
        .entries
        .firstWhere((entry) => entry.value.stock == option)
        .value;
  }

  Widget _buildOptionLeadingIcon(StockData selectedStock) {
    final ThemeData themeData = widget.themeData;

    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: themeData.colorScheme.outlineVariant),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: SvgPicture.asset(selectedStock.logoSvgPath)),
      ),
    );
  }

  Widget _buildOptionTitle(Stock option) {
    return Text(
      option.name.capitalizeFirst(),
      style: widget.themeData.textTheme.bodyMedium?.copyWith(
        color: widget.themeData.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildOptionSubTitle(StockData selectedStock) {
    return Text(
      selectedStock.officialName,
      style: widget.themeData.textTheme.bodySmall?.copyWith(
        color: widget.themeData.colorScheme.onSurfaceVariant,
      ),
    );
  }

  InputBorder _border() {
    switch (widget.borderType) {
      case 'underline':
        return const OutlineInputBorder(borderSide: BorderSide.none);
      case 'outline':
        return OutlineInputBorder(
          borderSide: BorderSide(color: widget.themeData.colorScheme.outline),
        );
      default:
        return const UnderlineInputBorder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: widget.borderType == 'underline'
                ? BorderSide(color: widget.themeData.colorScheme.outline)
                : BorderSide.none,
          ),
        ),
        child: TextField(
          key: _textFieldKey,
          controller: _controller,
          focusNode: _focusNode,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: 'Search Stocks',
            suffixIcon: SizedBox.square(
              dimension: 40,
              child: Icon(
                Icons.search,
                size: 20,
                color: widget.themeData.colorScheme.onSurface,
              ),
            ),
            border: _border(),
            enabledBorder: _border(),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          onChanged: _filterStocks,
        ),
      ),
    );
  }
}
