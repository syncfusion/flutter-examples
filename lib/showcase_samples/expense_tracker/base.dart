import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_widgets/splash.dart';
import 'enum.dart';
import 'helper/common_helper.dart';
import 'helper/responsive_layout.dart';
import 'models/user.dart';
import 'models/user_profile.dart';
import 'notifiers/providers.dart';
import 'notifiers/restart_notifier.dart';
import 'notifiers/setup_notifier.dart';
import 'notifiers/theme_notifier.dart';
import 'notifiers/welcome_screen_notifier.dart';
import 'pages/base_home.dart';
import 'pages/welcome_screens/import_page.dart';
import 'pages/welcome_screens/setup_page.dart';

class ExpenseAnalysisApp extends StatelessWidget {
  const ExpenseAnalysisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(context),
      child: const MainApp(),
    );
  }
}

/// Main application scaffold.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final PageController _pageController;

  /// Builds the main home screen of the application.
  Widget _buildHomeScreen(BuildContext context) {
    return SplashScreen(
      nextScreen: Scaffold(
        body: Consumer<VerifyUserNotifier>(
          builder:
              (
                BuildContext context,
                VerifyUserNotifier homeScreenNotifier,
                Widget? child,
              ) {
                return FutureBuilder<FirstTimeUserDetails>(
                  future: homeScreenNotifier.isFirstTimeUser(),
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<FirstTimeUserDetails> snapshot,
                      ) {
                        return _buildConditionalPages(context, snapshot);
                      },
                );
              },
        ),
      ),
    );
  }

  /// Builds the conditional pages based on initial setup status.
  Widget _buildConditionalPages(
    BuildContext context,
    AsyncSnapshot<FirstTimeUserDetails> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasData && !snapshot.data!.isFirstTimeUser) {
      return ExpenseAnalysis(currentUserDetails: snapshot.data!.userDetails);
    } else {
      return SetupOrImportPage(
        userDetails: setDefaultUserDetails(
          Profile(firstName: '', lastName: '', userId: '', currency: 'Dollar'),
        ),
        pageController: _pageController,
      );
    }
  }

  /// Initializes user details and page controller.
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  /// Disposes page controller
  @override
  void dispose() {
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder:
          (BuildContext context, ThemeNotifier themeNotifier, Widget? child) {
            return Consumer<RestartAppNotifier>(
              builder:
                  (
                    BuildContext context,
                    RestartAppNotifier restartAppNotifier,
                    Widget? child,
                  ) {
                    if (restartAppNotifier.isRestarted) {
                      SharedPreferences.getInstance().then((preferences) {
                        preferences.remove('selected_theme');
                      });
                    }

                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      themeMode: themeNotifier.themeMode,
                      darkTheme: ThemeData(
                        useMaterial3: true,
                        colorSchemeSeed: const Color(0xff00639B),
                        brightness: Brightness.dark,
                      ),
                      initialRoute: '/expense-tracker',
                      routes: {
                        '/expense-tracker': (context) {
                          return _buildHomeScreen(context);
                        },
                      },
                      theme: ThemeData(
                        useMaterial3: true,
                        colorSchemeSeed: const Color(0xff00639B),
                        brightness: Brightness.light,
                      ),
                    );
                  },
            );
          },
    );
  }
}

/// Builds setup or import page depending on the current page state
class SetupOrImportPage extends StatelessWidget {
  const SetupOrImportPage({
    required this.userDetails,
    required this.pageController,
    super.key,
  });

  final UserDetails userDetails;
  final PageController pageController;

  /// Builds page view for setup and import pages.
  Widget _buildPageView(WelcomeScreenNotifier welcomeScreenNotifier) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: _buildPageViewChildren(),
    );
  }

  /// Builds the children for the page view.
  List<Widget> _buildPageViewChildren() {
    return <Widget>[
      SetupProfilePage(userDetails, pageController),
      ImportPage(userDetails, pageController),
    ];
  }

  /// Builds navigation indicators for the page view.
  Widget _buildNavigationIndicators(
    double screenWidth,
    BuildContext context,
    WelcomeScreenNotifier welcomeScreenNotifier,
  ) {
    // The count of the welcome screens i.e) setup and import pages.
    const int noOfWelcomeScreens = 2;
    return Positioned(
      right: isMobile(context) ? screenWidth / 1.15 : screenWidth / 2.15,
      bottom: 20.0,
      child: Row(
        spacing: 8.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(noOfWelcomeScreens, (
          int welcomeScreenIndex,
        ) {
          return _buildIndicator(
            isActiveScreen(welcomeScreenIndex, welcomeScreenNotifier),
            context,
          );
        }),
      ),
    );
  }

  /// Constructs a single navigation indicator.
  Widget _buildIndicator(bool isActive, BuildContext context) {
    return SizedBox.square(
      dimension: 10.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  /// Checks if the current screen is active.
  bool isActiveScreen(
    int welcomeScreenIndex,
    WelcomeScreenNotifier welcomeScreenNotifier,
  ) {
    return (welcomeScreenIndex == 0)
        ? (welcomeScreenNotifier.currentPage == WelcomeScreens.setupPage)
        : (welcomeScreenNotifier.currentPage == WelcomeScreens.importPage);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width / 2.0;

    return Consumer<WelcomeScreenNotifier>(
      builder:
          (
            BuildContext context,
            WelcomeScreenNotifier welcomeScreenNotifier,
            Widget? child,
          ) {
            return Stack(
              children: <Widget>[
                _buildPageView(welcomeScreenNotifier),
                _buildNavigationIndicators(
                  screenWidth,
                  context,
                  welcomeScreenNotifier,
                ),
              ],
            );
          },
    );
  }
}

class FirstTimeUserDetails {
  FirstTimeUserDetails(this.isFirstTimeUser, this.userDetails);

  final bool isFirstTimeUser;
  final UserDetails userDetails;
}
