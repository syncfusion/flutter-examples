import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enum.dart';
import '../model/chart_data.dart';
import '../notifier/stock_chart_notifier.dart';
import '../stock_home/stock_chart_view/stock_chart.dart';
import '../stock_home/stock_panel_view/stock_panel.dart';

/// Mobile home screen for stock analysis application
/// Displays stock chart with draggable bottom sheet for stock listings
class StockMobileHomeScreen extends StatefulWidget {
  const StockMobileHomeScreen({
    super.key,
    required this.defaultStocks,
    required this.firstName,
    required this.lastName,
  });

  final Map<Stock, StockData> defaultStocks;
  final String firstName;
  final String lastName;

  @override
  State<StockMobileHomeScreen> createState() => _StockMobileHomeScreenState();
}

class _StockMobileHomeScreenState extends State<StockMobileHomeScreen> {
  final DraggableScrollableController _scrollController =
      DraggableScrollableController();

  double _dragStartPosition = 0.0;
  double _sheetStartSize = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return provider.isFullScreen ? _buildFullScreenView() : _buildDefaultView();
  }

  Widget _buildFullScreenView() {
    return StockChartViewer(
      defaultStocks: widget.defaultStocks,
      firstName: widget.firstName,
      lastName: widget.lastName,
    );
  }

  Widget _buildDefaultView() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: Stack(
        children: [
          // Main content - Stock chart
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StockChartViewer(
              defaultStocks: widget.defaultStocks,
              firstName: widget.firstName,
              lastName: widget.lastName,
            ),
          ),

          // Bottom sheet for stock listings
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: 0.03,
            minChildSize: 0.03,
            snap: true,
            snapSizes: const [0.2, 0.6, 0.9],
            builder: (BuildContext context, ScrollController scrollController) {
              return Material(
                elevation: 8.0,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle with mouse listener
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onVerticalDragStart: (details) {
                            _dragStartPosition = details.globalPosition.dy;
                            _sheetStartSize = _scrollController.size;
                          },
                          onVerticalDragUpdate: (details) {
                            final double dragDistance =
                                _dragStartPosition - details.globalPosition.dy;
                            final double screenHeight = MediaQuery.of(
                              context,
                            ).size.height;
                            final double newSize =
                                _sheetStartSize + (dragDistance / screenHeight);

                            // Clamp the size between min and max
                            final double clampedSize = newSize.clamp(0.1, 0.9);

                            // Update the sheet size
                            _scrollController.jumpTo(clampedSize);
                          },
                          child: Listener(
                            onPointerSignal: (pointerSignal) {
                              if (pointerSignal is PointerScrollEvent) {
                                // Handle mouse wheel scrolling
                                final double delta =
                                    pointerSignal.scrollDelta.dy;
                                final double newSize =
                                    _scrollController.size - (delta / 1000);
                                final double clampedSize = newSize.clamp(
                                  0.03,
                                  0.9,
                                );
                                _scrollController.jumpTo(clampedSize);
                              }
                            },
                            onPointerUp: (PointerUpEvent event) {
                              final double delta = event.localPosition.dy;
                              final double newSize =
                                  _scrollController.size - (delta / 1000);
                              final double clampedSize = newSize.clamp(
                                0.03,
                                0.9,
                              );
                              if (clampedSize > 0.5) {
                                _scrollController.jumpTo(0.9);
                              } else {
                                _scrollController.reset();
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: 17,
                              child: Center(
                                child: Container(
                                  width: 40.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha((0.4 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Stock panel content in a scrollable container
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: SizedBox(
                            // Set a fixed height to prevent overflow
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: StockSelectionPanel(
                              defaultStocks: widget.defaultStocks,
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              scrollController: _scrollController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
