/// dart imports
import 'dart:io' show Platform;

/// package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

///Local imports
import 'model/helper.dart';
import 'model/model.dart';
import 'model/web_view.dart';
import 'widgets/animate_opacity_widget.dart';
import 'widgets/search_bar.dart';

/// Root widget of the sample browser.
/// Contains the Homepage wrapped with a MaterialApp widget.
class SampleBrowser extends StatefulWidget {
  /// Creates sample browser widget.
  const SampleBrowser();

  @override
  _SampleBrowserState createState() => _SampleBrowserState();
}

class _SampleBrowserState extends State<SampleBrowser> {
  late SampleModel _sampleListModel;
  bool _isMaterial3 = false;
  Brightness? _brightness;

  void _refresh(bool isMaterial3, Brightness brightness) {
    setState(() {
      // To refresh the app when switching M2 and M3 theme.
      _isMaterial3 = isMaterial3;
      _brightness = brightness;
    });
  }

  /// Add the palette colors
  void _addColors() {
    _sampleListModel.paletteColors.add(Colors.transparent);
    _sampleListModel.paletteColors.add(const Color.fromRGBO(230, 74, 25, 1));
    _sampleListModel.paletteColors.add(const Color.fromRGBO(216, 27, 96, 1));
    _sampleListModel.paletteColors.add(const Color.fromRGBO(2, 137, 123, 1));

    _sampleListModel.darkPaletteColors.add(Colors.transparent);
    _sampleListModel.darkPaletteColors
        .add(const Color.fromRGBO(255, 110, 64, 1));
    _sampleListModel.darkPaletteColors
        .add(const Color.fromRGBO(238, 79, 132, 1));
    _sampleListModel.darkPaletteColors
        .add(const Color.fromRGBO(29, 233, 182, 1));
  }

  void _updateBaseColor(ThemeData themeData) {
    _sampleListModel.paletteColors[0] = themeData.colorScheme.primary;
    _sampleListModel.darkPaletteColors[0] = themeData.colorScheme.primary;
    if (themeData.colorScheme.brightness == Brightness.light) {
      _sampleListModel.paletteBorderColors[selectedColorPaletteIndex] =
          _sampleListModel.paletteColors[selectedColorPaletteIndex];
    } else {
      _sampleListModel.paletteBorderColors[selectedColorPaletteIndex] =
          _sampleListModel.darkPaletteColors[selectedColorPaletteIndex];
    }
  }

  @override
  void initState() {
    _sampleListModel = SampleModel.instance;
    _addColors();
    _initializeProperties();
    _sampleListModel.searchBar = CustomSearchBar(
        key: GlobalKey<SearchBarState>(), sampleListModel: _sampleListModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _sampleListModel.systemTheme = Theme.of(context);
    if (_brightness == null) {
      if (_sampleListModel.isWebFullView) {
        _brightness ??= Brightness.light;
      } else {
        _brightness ??= _sampleListModel.systemTheme.brightness;
      }
    }
    final ThemeData themeData = _brightness == Brightness.light
        ? ThemeData.light(useMaterial3: _isMaterial3)
        : ThemeData.dark(useMaterial3: _isMaterial3);
    _updateBaseColor(themeData);
    if (selectedColorPaletteIndex != 0) {
      _sampleListModel.primaryColor =
          _sampleListModel.paletteColors[selectedColorPaletteIndex];
    } else {
      _sampleListModel.primaryColor =
          ThemeData.light(useMaterial3: _isMaterial3).colorScheme.primary;
    }
    final Map<String, WidgetBuilder> navigationRoutes = <String, WidgetBuilder>{
      _sampleListModel.isWebFullView ? '/' : '/demos': (BuildContext context) =>
          HomePage(refresh: _refresh)
    };
    for (int i = 0; i < _sampleListModel.routes!.length; i++) {
      final SampleRoute sampleRoute = _sampleListModel.routes![i];
      WidgetCategory? category;
      for (int j = 0; j < _sampleListModel.categoryList.length; j++) {
        if (sampleRoute.subItem!.categoryName ==
            _sampleListModel.categoryList[j].categoryName) {
          category = _sampleListModel.categoryList[j];
          break;
        }
      }

      navigationRoutes[sampleRoute.routeName!] =
          (BuildContext context) => WebLayoutPage(
                key: GlobalKey<State>(),
                routeName: sampleRoute.routeName,
                sampleModel: _sampleListModel,
                category: category,
                subItem: sampleRoute.subItem,
                refresh: _refresh,
              );
    }

    _sampleListModel.themeData = _themeData(_sampleListModel.primaryColor);
    _sampleListModel.changeTheme(
        _sampleListModel.themeData, _sampleListModel.themeData.useMaterial3);

    /// Avoiding page popping on escape key press.
    final Map<ShortcutActivator, Intent> shortcuts =
        Map<ShortcutActivator, Intent>.of(WidgetsApp.defaultShortcuts)
          ..remove(LogicalKeySet(LogicalKeyboardKey.escape));
    if (_sampleListModel.isWebFullView) {
      return _buildWebOrDesktopView(shortcuts, navigationRoutes);
    } else {
      return _buildMobileView(navigationRoutes);
    }
  }

  MaterialApp _buildWebOrDesktopView(Map<ShortcutActivator, Intent> shortcuts,
      Map<String, WidgetBuilder> navigationRoutes) {
    return MaterialApp(
      shortcuts: shortcuts,
      initialRoute: '/',
      routes: navigationRoutes,
      // ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const <Locale>[Locale('en', 'US'), Locale('ar', 'AE')],
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Demos & Examples of Syncfusion Flutter Widgets',
      theme: _sampleListModel.themeData.copyWith(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(
            const Color.fromRGBO(128, 128, 128, 0.3),
          ),
        ),
      ),
      darkTheme: _sampleListModel.themeData.copyWith(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(
            const Color.fromRGBO(255, 255, 255, 0.3),
          ),
        ),
      ),
    );
  }

  MaterialApp _buildMobileView(Map<String, WidgetBuilder> navigationRoutes) {
    return MaterialApp(
      initialRoute: '/demos',
      routes: navigationRoutes,
      debugShowCheckedModeBanner: false,
      title: 'Demos & Examples of Syncfusion Flutter Widgets',
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const <Locale>[Locale('en', 'US'), Locale('ar', 'AE')],
      locale: const Locale('en', 'US'),
      theme: _sampleListModel.themeData,
      darkTheme: _sampleListModel.themeData,
      home: HomePage(refresh: _refresh),
    );
  }

  ThemeData _themeData(Color paletteColor) {
    if (_isMaterial3) {
      return ThemeData(
        useMaterial3: true,
        brightness: _brightness,
        colorSchemeSeed: paletteColor,
      );
    } else {
      return ThemeData(
        useMaterial3: false,
        brightness: _brightness,
        colorScheme: _brightness == Brightness.light
            ? ColorScheme.light(primary: paletteColor)
            : ColorScheme.dark(primary: paletteColor),
      );
    }
  }

  void _initializeProperties() {
    final SampleModel model = SampleModel.instance;
    model.isWebFullView =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    if (kIsWeb) {
      model.isWeb = true;
    } else {
      model.isAndroid = Platform.isAndroid;
      model.isIOS = Platform.isIOS;
      model.isLinux = Platform.isLinux;
      model.isWindows = Platform.isWindows;
      model.isMacOS = Platform.isMacOS;
      model.isDesktop =
          Platform.isLinux || Platform.isMacOS || Platform.isWindows;
      model.isMobile = Platform.isAndroid || Platform.isIOS;
    }
  }
}

/// Home page of the sample browser for both mobile and web.
class HomePage extends StatefulWidget {
  /// Creates the home page layout.
  const HomePage({
    required this.refresh,
  });

  /// Refresh the app when switching M2 and M3 theme.
  final ChangeThemeCallback refresh;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController controller = ScrollController();
  late SampleModel sampleListModel;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDownloadButtonHover = false;
  bool _isGetPackageButtonHover = false;

  @override
  void initState() {
    sampleListModel = SampleModel.instance;
    sampleListModel.addListener(_handleChange);
    super.initState();
  }

  // Notify the framework by calling this method
  void _handleChange() {
    if (mounted) {
      setState(() {
        // The listenable's state was changed already.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMaxXSize = MediaQuery.of(context).size.width >= 1000;
    final SampleModel model = sampleListModel;
    model.isMobileResolution = (MediaQuery.of(context).size.width) < 768;
    return SafeArea(
      child: model.isMobileResolution
          ? Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: false,
              drawer: (!model.isWebFullView && Platform.isIOS)
                  ? null // Avoiding drawer in iOS platform.
                  : buildLeftSideDrawer(model),
              backgroundColor: model.backgroundColor,
              endDrawerEnableOpenDragGesture: false,
              endDrawer: model.isWebFullView
                  ? buildWebThemeSettings(model, context, widget.refresh)
                  : null,
              appBar: _buildMobileAppBar(model, context),
              body: _buildScrollableWidget(model),
            )
          : Scaffold(
              key: scaffoldKey,
              bottomNavigationBar: buildFooter(context, model),
              backgroundColor: model.backgroundColor,
              endDrawerEnableOpenDragGesture: false,
              endDrawer: buildWebThemeSettings(model, context, widget.refresh),
              resizeToAvoidBottomInset: false,
              appBar: _buildDesktopAppBar(model, context, isMaxXSize),
              body: _CategorizedCards(),
            ),
    );
  }

  PreferredSize _buildMobileAppBar(SampleModel model, BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(46.0),
      child: AppBar(
        leading: (!model.isWebFullView && Platform.isIOS) ? Container() : null,
        elevation: 0.0,
        bottomOpacity: 0.0,
        backgroundColor: model.primaryColor,
        title: AnimateOpacityWidget(
          controller: controller,
          opacity: 0,
          child: const Text(
            'Flutter UI Widgets',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'HeeboMedium',
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          SizedBox(
            height: 40,
            width: 40,
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                model.isWebFullView
                    ? scaffoldKey.currentState!.openEndDrawer()
                    : showBottomSettingsPanel(model, context, widget.refresh);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildDesktopAppBar(
    SampleModel model,
    BuildContext context,
    bool isMaxXSize,
  ) {
    final bool isMaterial3 = model.themeData.useMaterial3;
    final bool haveSpace = MediaQuery.of(context).size.width >= 1050;
    return PreferredSize(
      preferredSize: Size.fromHeight(isMaterial3 ? 100 : 90.0),
      child: AppBar(
        elevation: 0.0,
        backgroundColor: model.primaryColor,
        flexibleSpace: Padding(
          padding:
              isMaterial3 ? EdgeInsets.zero : const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _sampleName(),
              _sampleNameDescription(),
              const SizedBox(height: 15),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 1),
                  child: SizedBox(
                    width: double.infinity,
                    height: kIsWeb ? 16 : 14,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: model.backgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          if (haveSpace)
            Padding(
              padding: EdgeInsets.only(top: 20, right: isMaterial3 ? 20 : 13),
              child: buildM2ToM3SwapOption(model, context, MainAxisSize.min,
                  Colors.white, widget.refresh),
            ),
          // if (haveSpace && isMaterial3) _buildVerticalDivider(),
          if (MediaQuery.of(context).size.width < 500)
            const SizedBox(height: 0, width: 9)
          else
            _buildSearchBar(context, model),
          // if (haveSpace && isMaterial3) _buildVerticalDivider(),
          // Download option.
          if (model.isMobileResolution)
            Container()
          else
            _buildDownloadButton(isMaxXSize, model),
          // Get package from pub.dev option.
          if (model.isMobileResolution)
            Container()
          else
            _buildGetPackageButton(isMaxXSize, model),
          _buildSettingsButton(isMaxXSize, context),
        ],
      ),
    );
  }

  Padding _sampleName() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 10, 0, 0),
      child: Text(
        'Flutter UI Widgets ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          letterSpacing: 0.53,
          fontFamily: 'Roboto-Bold',
        ),
      ),
    );
  }

  Padding _sampleNameDescription() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
      child: Text(
        'Fast . Fluid . Flexible',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Roboto-Regular',
          letterSpacing: 0.26,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, SampleModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 25),
      child: SizedBox(
        height: 35,
        width: MediaQuery.of(context).size.width >= 920
            ? 300
            : MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.width < 820 ? 5 : 4),
        child: CustomSearchBar(
          sampleListModel: model,
        ),
      ),
    );
  }

  // Widget _buildVerticalDivider() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20, right: 15),
  //     child: Container(
  //       height: 25,
  //       width: 1,
  //       color: Colors.white,
  //     ),
  //   );
  // }

  Widget _buildDownloadButton(bool isMaxXSize, SampleModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 35,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return MouseRegion(
                  onHover: (PointerHoverEvent event) {
                    setState(() => _isDownloadButtonHover = true);
                  },
                  onExit: (PointerExitEvent event) {
                    setState(() => _isDownloadButtonHover = false);
                  },
                  child: InkWell(
                    hoverColor: Colors.white,
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                            'https://www.syncfusion.com/downloads/flutter/confirm'),
                      );
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'DOWNLOAD NOW',
                          style: TextStyle(
                            color: _isDownloadButtonHover
                                ? model.themeData.colorScheme.primary
                                : Colors.white,
                            fontSize: 12,
                            fontFamily: 'Roboto-Medium',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetPackageButton(bool isMaxXSize, SampleModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 35,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return MouseRegion(
                  onHover: (PointerHoverEvent event) {
                    setState(() => _isGetPackageButtonHover = true);
                  },
                  onExit: (PointerExitEvent event) {
                    setState(() => _isGetPackageButtonHover = false);
                  },
                  child: InkWell(
                    hoverColor: Colors.white,
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://pub.dev/publishers/syncfusion.com/packages'));
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset(
                                'images/pub_logo.png',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Get Packages',
                              style: TextStyle(
                                color: _isGetPackageButtonHover
                                    ? model.themeData.colorScheme.primary
                                    : Colors.white,
                                fontSize: 12,
                                fontFamily: 'Roboto-Medium',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(bool isMaxXSize, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 3),
      child: IconButton(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, right: 20),
        icon: const Icon(Icons.settings),
        onPressed: () {
          scaffoldKey.currentState!.openEndDrawer();
        },
      ),
    );
  }

  /// Get scrollable widget to getting stickable view with scrollbar
  /// depends on platform.
  Widget _buildScrollableWidget(SampleModel model) {
    return model.isWeb
        ? Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: _buildCustomScrollWidget(model),
          )
        : _buildCustomScrollWidget(model);
  }

  /// Get scrollable widget to getting stickable view.
  Widget _buildCustomScrollWidget(SampleModel model) {
    final List<Widget> searchResults = _buildSearchedItems(model);
    return ColoredBox(
      color: model.primaryColor,
      child: GlowingOverscrollIndicator(
        color: model.primaryColor,
        axisDirection: AxisDirection.down,
        child: CustomScrollView(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Flutter UI Widgets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 0.53,
                        fontFamily: 'HeeboBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 0, 0),
                    child: Text(
                      'Fast . Fluid . Flexible',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.26,
                        fontFamily: 'HeeboBold',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _PersistentHeaderDelegate(model),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  ColoredBox(
                    color: model.backgroundColor,
                    child: searchResults.isNotEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView(children: searchResults))
                        : _CategorizedCards(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchedItems(SampleModel model) {
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < model.sampleList.length; i++) {
      items.add(
        Material(
          color: model.backgroundColor,
          child: InkWell(
            hoverColor: model.hoverColor,
            highlightColor: model.splashColor,
            splashColor: model.splashColor,
            onTap: () {
              Feedback.forLongPress(context);
              onTapExpandSample(context, model.sampleList[i], model);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                maxLines: 1,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: model.sampleList[i].control!.title,
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontWeight: FontWeight.normal,
                        color: model.textColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    TextSpan(
                      text: ' - ' + model.sampleList[i].title!,
                      style: TextStyle(
                        fontFamily: 'HeeboMedium',
                        fontWeight: FontWeight.normal,
                        color: model.textColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      items.add(Divider(
        color: model.dividerColor,
        thickness: 1,
      ));
    }

    if (model.sampleList.isEmpty &&
        model.controlList.isEmpty &&
        model.editingController.text.trim() != '') {
      items.add(
        Container(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          color: model.backgroundColor,
          child: Center(
            child: Text(
              'No results found',
              style: TextStyle(color: model.textColor, fontSize: 15),
            ),
          ),
        ),
      );
    }
    return items;
  }
}

/// Search bar, rounded corner
class _PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PersistentHeaderDelegate(SampleModel sampleModel) {
    _sampleListModel = sampleModel;
  }
  SampleModel? _sampleListModel;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 90,
      child: Container(
        color: _sampleListModel!.primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 70,
              child: _sampleListModel!.searchBar,
            ),
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: _sampleListModel!.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: _sampleListModel!.backgroundColor,
                    offset: const Offset(0, 2.0),
                    blurRadius: 0.25,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(_PersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// Positioning/aligning the categories as  cards
/// based on the screen width.
class _CategorizedCards extends StatefulWidget {
  @override
  _CategorizedCardsState createState() => _CategorizedCardsState();
}

class _CategorizedCardsState extends State<_CategorizedCards> {
  SampleModel model = SampleModel.instance;
  late double _cardWidth;

  @override
  Widget build(BuildContext context) {
    return model.isWeb
        ? Scrollbar(
            thumbVisibility: model.isWeb, child: _buildCategorizedCards())
        : _buildCategorizedCards();
  }

  Widget _buildCategorizedCards() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double padding;
    Widget? organizedCardWidget;
    double sidePadding = deviceWidth > 1060
        ? deviceWidth * 0.038
        : deviceWidth >= 768
            ? deviceWidth * 0.041
            : deviceWidth * 0.05;

    if (deviceWidth > 1060) {
      padding = deviceWidth * 0.011;
      _cardWidth = (deviceWidth * 0.9) / 3;

      // Setting max cardwidth, spacing between cards in higher resolutions.
      if (deviceWidth > 3000) {
        _cardWidth = deviceWidth / 3.5;
        sidePadding = (_cardWidth / 2) * 0.125;
        padding = 30;
      }
      final List<Widget> firstColumnWidgets = <Widget>[];
      final List<Widget> secondColumnWidgets = <Widget>[];
      final List<Widget> thirdColumnWidgets = <Widget>[];
      int firstColumnControlCount = 0;
      int secondColumnControlCount = 0;
      for (int i = 0; i < model.categoryList.length; i++) {
        if (firstColumnControlCount < model.controlList.length / 3) {
          firstColumnWidgets.add(_buildCategoryWidget(model.categoryList[i]));
          firstColumnWidgets
              .add(Padding(padding: EdgeInsets.only(top: padding)));
          firstColumnControlCount += model.categoryList[i].controlList!.length;
        } else if (secondColumnControlCount < model.controlList.length / 3 &&
            (secondColumnControlCount +
                    model.categoryList[i].controlList!.length <
                model.controlList.length / 3)) {
          secondColumnWidgets.add(_buildCategoryWidget(model.categoryList[i]));
          secondColumnWidgets
              .add(Padding(padding: EdgeInsets.only(top: padding)));
          secondColumnControlCount += model.categoryList[i].controlList!.length;
        } else {
          thirdColumnWidgets.add(_buildCategoryWidget(model.categoryList[i]));
          thirdColumnWidgets
              .add(Padding(padding: EdgeInsets.only(top: padding)));
        }
        organizedCardWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: sidePadding)),
            Column(children: firstColumnWidgets),
            Padding(padding: EdgeInsets.only(left: padding)),
            Column(children: secondColumnWidgets),
            Padding(padding: EdgeInsets.only(left: padding)),
            Column(children: thirdColumnWidgets),
            Padding(
              padding: EdgeInsets.only(left: sidePadding),
            )
          ],
        );
      }
    } else if (deviceWidth >= 768) {
      padding = deviceWidth * 0.018;
      _cardWidth = (deviceWidth * 0.9) / 2;
      final List<Widget> firstColumnWidgets = <Widget>[];
      final List<Widget> secondColumnWidgets = <Widget>[];
      int firstColumnControlCount = 0;
      for (int i = 0; i < model.categoryList.length; i++) {
        if (firstColumnControlCount < model.controlList.length / 2) {
          firstColumnWidgets.add(_buildCategoryWidget(model.categoryList[i]));
          firstColumnWidgets
              .add(Padding(padding: EdgeInsets.only(top: padding)));
          firstColumnControlCount += model.categoryList[i].controlList!.length;
        } else {
          secondColumnWidgets.add(_buildCategoryWidget(model.categoryList[i]));
          secondColumnWidgets
              .add(Padding(padding: EdgeInsets.only(top: padding)));
        }
        organizedCardWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: sidePadding)),
            Column(children: firstColumnWidgets),
            Padding(padding: EdgeInsets.only(left: padding)),
            Column(children: secondColumnWidgets),
            Padding(
              padding: EdgeInsets.only(left: sidePadding),
            )
          ],
        );
      }
    } else {
      _cardWidth = deviceWidth * 0.9;
      padding = deviceWidth * 0.035;
      sidePadding = (deviceWidth * 0.1) / 2;
      final List<Widget> verticalOrderedWidgets = <Widget>[];
      for (int i = 0; i < model.categoryList.length; i++) {
        verticalOrderedWidgets.add(_buildCategoryWidget(model.categoryList[i]));
        verticalOrderedWidgets
            .add(Padding(padding: EdgeInsets.only(top: padding)));
      }
      organizedCardWidget = Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: sidePadding)),
          Column(children: verticalOrderedWidgets),
          Padding(
            padding: EdgeInsets.only(left: sidePadding),
          )
        ],
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: deviceWidth > 1060 ? 15 : 10),
        child: organizedCardWidget,
      ),
    );
  }

  /// Get the rounded corner layout for given category.
  Widget _buildCategoryWidget(WidgetCategory category) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: model.homeCardColor,
        border: Border.all(
          color: model.themeData.useMaterial3
              ? model.themeData.colorScheme.outlineVariant
              : const Color.fromRGBO(0, 0, 0, 0.12),
          width: 1.1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      width: _cardWidth,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 2),
            child: Text(
              category.categoryName!.toUpperCase(),
              style: TextStyle(
                color: model.primaryColor,
                fontSize: 16,
                fontFamily: 'Roboto-Bold',
              ),
            ),
          ),
          Divider(
            color: model.themeData.useMaterial3
                ? model.themeData.colorScheme.outlineVariant
                : (model.themeData.colorScheme.brightness == Brightness.dark
                    ? const Color.fromRGBO(61, 61, 61, 1)
                    : const Color.fromRGBO(238, 238, 238, 1)),
            thickness: 1,
          ),
          Column(children: _buildControlListView(category))
        ],
      ),
    );
  }

  /// Get the list view of the controls in the specified category.
  List<Widget> _buildControlListView(WidgetCategory category) {
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < category.controlList!.length; i++) {
      final Control control = category.controlList![i] as Control;
      final String? status = control.status;

      items.add(
        Container(
          color: model.homeCardColor,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              hoverColor: model.hoverColor,
              highlightColor: model.splashColor,
              splashColor: model.splashColor,
              onTap: () {
                !model.isWebFullView
                    ? onTapControlInMobile(context, model, category, i)
                    : onTapControlInWeb(context, model, category, i);
                model.searchResults.clear();
              },
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                    12, 2, 0, category.controlList!.length > 3 ? 6 : 0),
                leading: Image.asset(control.image!, fit: BoxFit.cover),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          control.title!,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          textScaler: TextScaler.noScaling,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.1,
                            color: model.textColor,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
                        if (!model.isWebFullView && Platform.isIOS)
                          Container()
                        else
                          (control.isBeta ?? false)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: model.isWeb &&
                                            model.isMobileResolution
                                        ? const EdgeInsets.fromLTRB(
                                            3, 1.5, 3, 5.5)
                                        : const EdgeInsets.fromLTRB(3, 3, 3, 2),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(245, 188, 14, 1)),
                                    child: const Text(
                                      'BETA',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.12,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                      ],
                    ),
                    if (status != null)
                      Container(
                        decoration: BoxDecoration(
                          color: status.toLowerCase() == 'new'
                              ? const Color.fromRGBO(55, 153, 30, 1)
                              : status.toLowerCase() == 'updated'
                                  ? const Color.fromRGBO(246, 117, 0, 1)
                                  : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        padding: model.isWeb && model.isMobileResolution
                            ? const EdgeInsets.fromLTRB(6, 1.5, 4, 5.5)
                            : const EdgeInsets.fromLTRB(6, 2.7, 4, 2.7),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontFamily: 'Roboto-Medium',
                            color: Colors.white,
                            fontSize: 10.5,
                          ),
                        ),
                      )
                    else
                      Container()
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 7.0, 12.0, 0.0),
                  child: Text(
                    control.description!,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Color.fromRGBO(128, 128, 128, 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }
}
