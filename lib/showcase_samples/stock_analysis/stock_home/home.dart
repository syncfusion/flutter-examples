// Stock Home Screen Module
// Handles main application interface and layout management
// Provides responsive views for desktop and mobile devices

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/disclaimer_popup.dart';
import '../enum.dart';
import '../helper/responsive_layout.dart';
import '../mobile/home.dart';
import '../model/chart_data.dart';
import '../model/user_detail.dart';
import '../notifier/stock_chart_notifier.dart';
import 'stock_chart_view/profile_menu_popup.dart';
import 'stock_chart_view/stock_chart.dart';
import 'stock_panel_view/stock_panel.dart';

/// Main screen for stock analysis application.
/// Displays stock data, charts, and user profile information.
class StockHomeScreen extends StatefulWidget {
  /// Creates a stock home screen with required data.
  const StockHomeScreen({
    super.key,
    required this.defaultStocks,
    required this.firstName,
    required this.lastName,
  });

  /// Stock data to display in the application.
  final Map<Stock, StockData> defaultStocks;

  /// User's first name.
  final String firstName;

  /// User's last name.
  final String lastName;

  @override
  State<StockHomeScreen> createState() => _StockHomeScreenState();
}

class _StockHomeScreenState extends State<StockHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Show the disclaimer popup after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDisclaimerPopup(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<StockChartProvider, UserDetail>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.user,
      builder: (BuildContext context, UserDetail user, Widget? child) {
        return _StockDataWorkspace(
          firstName: user.firstName,
          lastName: user.lastName,
          defaultStocks: widget.defaultStocks,
        );
      },
    );
  }
}

/// Internal workspace widget that handles the main layout and UI components.
class _StockDataWorkspace extends StatelessWidget {
  /// Creates a stock data workspace with required data.
  const _StockDataWorkspace({
    required this.firstName,
    required this.lastName,
    required this.defaultStocks,
  });

  /// Stock data to display in the workspace.
  final Map<Stock, StockData> defaultStocks;

  /// User's first name.
  final String firstName;

  /// User's last name.
  final String lastName;

  /// Returns standard padding for UI elements.
  EdgeInsets _getPadding() {
    return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0);
  }

  /// Creates a box shadow with specified parameters.
  BoxShadow _getBoxShadow(
    double blurRadius,
    Color color, [
    double spreadRadius = 1.0,
  ]) {
    return BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      color: color,
    );
  }

  /// Builds the default app bar with title and profile menu.
  Widget _buildDefaultAppBar(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final String firstNameFirstLetter = firstName.characters.first
        .toUpperCase();
    final String lastNameFirstLetter = lastName.isNotEmpty
        ? lastName.characters.first.toUpperCase()
        : '';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        boxShadow: [
          _getBoxShadow(3.0, const Color(0xff000026)),
          _getBoxShadow(2.0, const Color(0xff00004D), 0.0),
        ],
      ),
      child: Padding(
        padding: _getPadding(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Stock Chart'),
            ProfileMenuPopup(
              firstNameFirstLetter,
              lastNameFirstLetter,
              firstName,
              lastName,
              themeData,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the body content based on device type.
  Widget _buildBody(BuildContext context, DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopLayout(context);
      case DeviceType.mobile:
        return _buildMobileLayout(context);
    }
  }

  /// Builds the desktop layout with side panel and chart.
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: context.read<StockChartProvider>().isFullScreen
          ? _buildFullScreenView()
          : _buildSplitView(),
    );
  }

  /// Builds the split view with panel and chart.
  Widget _buildSplitView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: StockSelectionPanel(
            defaultStocks: defaultStocks,
            firstName: firstName,
            lastName: lastName,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: StockChartViewer(
            defaultStocks: defaultStocks,
            firstName: firstName,
            lastName: lastName,
          ),
        ),
      ],
    );
  }

  /// Builds the full screen chart view.
  Widget _buildFullScreenView() {
    return StockChartViewer(
      defaultStocks: defaultStocks,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Builds the mobile layout.
  Widget _buildMobileLayout(BuildContext context) {
    return context.read<StockChartProvider>().isFullScreen
        ? _buildMobileFullScreenView()
        : _buildMobileDefaultView();
  }

  Widget _buildMobileFullScreenView() {
    return SafeArea(
      child: Material(
        child: StockChartViewer(
          defaultStocks: defaultStocks,
          firstName: firstName,
          lastName: lastName,
        ),
      ),
    );
  }

  Widget _buildMobileDefaultView() {
    return StockMobileHomeScreen(
      defaultStocks: defaultStocks,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DeviceType currentDeviceType = deviceType(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.isFullScreen,
      builder: (BuildContext context, bool isFullScreen, Widget? child) =>
          Scaffold(
            backgroundColor: colorScheme.surfaceContainerLow,
            appBar: !isFullScreen
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: AppBar(
                      leadingWidth: 0.0,
                      shadowColor: const Color(0xff000026),
                      surfaceTintColor: Colors.transparent,
                      titleSpacing: 0.0,
                      title: _buildDefaultAppBar(context),
                      backgroundColor: colorScheme.surface,
                      elevation: 2.0,
                      automaticallyImplyLeading: false,
                    ),
                  )
                : null,
            body: _buildBody(context, currentDeviceType),
          ),
    );
  }
}
