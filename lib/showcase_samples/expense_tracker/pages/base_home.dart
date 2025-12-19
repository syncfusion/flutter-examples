import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../meta_tag/meta_tag.dart';
import '../constants.dart';
// import '../data_processing/budget_handler.dart'
//     if (dart.library.html) '../data_processing/budget_web_handler.dart';
// import '../data_processing/goal_handler.dart'
//     if (dart.library.html) '../data_processing/goal_web_handler.dart';
// import '../data_processing/saving_handler.dart'
//     if (dart.library.html) '../data_processing/saving_web_handler.dart';
// import '../data_processing/transaction_handler.dart'
//     if (dart.library.html) '../data_processing/transaction_web_handler.dart';
import '../enum.dart';
import '../helper/budgets_center_dialog.dart';
import '../helper/goals_center_dialog.dart';
import '../helper/responsive_layout.dart';
import '../helper/savings_center_dialog.dart';
import '../helper/transaction_center_dialog.dart';
import '../models/budget.dart';
import '../models/goal.dart';
import '../models/saving.dart';
import '../models/transaction.dart';
import '../models/transactional_data.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import '../notifiers/budget_notifier.dart';
import '../notifiers/drawer_notifier.dart';
import '../notifiers/goal_notifier.dart';
import '../notifiers/import_notifier.dart';
import '../notifiers/mobile_app_bar.dart';
import '../notifiers/restart_notifier.dart';
import '../notifiers/savings_notifier.dart';
import '../notifiers/text_field_valid_notifier.dart';
import '../notifiers/transaction_notifier.dart';
import 'budgets.dart';
import 'dashboard.dart';
import 'goal.dart';
import 'savings.dart';
import 'settings/sections/appearance.dart';
import 'settings/sections/personalization.dart';
import 'settings/sections/profile.dart';
import 'settings/settings.dart';
import 'transaction.dart';

ValueNotifier<NavigationPagesSlot> pageNavigatorNotifier =
    ValueNotifier<NavigationPagesSlot>(NavigationPagesSlot.dashboard);
ValueNotifier<String> pageTitle = ValueNotifier('Dashboard');

class ExpenseAnalysis extends StatefulWidget {
  const ExpenseAnalysis({required this.currentUserDetails, super.key});

  final UserDetails currentUserDetails;

  @override
  State<ExpenseAnalysis> createState() => _ExpenseAnalysisState();
}

class _ExpenseAnalysisState extends State<ExpenseAnalysis> {
  final ValueNotifier<int> _mobileViewIndex = ValueNotifier<int>(0);
  final ValueNotifier<int> _desktopOrWebViewIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isAccountPageActive = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isGoalsPageActive = ValueNotifier<bool>(false);
  final ValueNotifier<String> _appBarTitle = ValueNotifier('My Dashboard');
  late ThemeData themeData;
  late ColorScheme colorScheme;
  late UserDetails currentUserDetails;
  late bool isGoalsPage;
  final GlobalKey<PopupMenuButtonState<String>> _popupMenuKey = GlobalKey();
  final GlobalKey<PopupMenuButtonState<String>> _profilePopupMenuKey =
      GlobalKey();
  final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

  void _onPageNavigatorChanged() {
    final String pageTitle = _buildPageTitle(
      context,
      pageNavigatorNotifier.value,
    );
    metaTagUpdate.update(pageTitle, 'Expense Tracker');
  }

  @override
  void initState() {
    currentUserDetails = widget.currentUserDetails;
    super.initState();

    // Updates meta tag details when navigating from the import page
    // to the dashboard page in Expense Tracker.
    metaTagUpdate.update(
      _buildPageTitle(context, pageNavigatorNotifier.value),
      'Expense Tracker',
    );

    pageNavigatorNotifier.addListener(_onPageNavigatorChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mobileViewIndex.dispose();
    _desktopOrWebViewIndex.dispose();
    _isAccountPageActive.dispose();
    _isGoalsPageActive.dispose();
    _appBarTitle.dispose();
    pageNavigatorNotifier.removeListener(_onPageNavigatorChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    colorScheme = themeData.colorScheme;
    isGoalsPage = _isGoalsPageActive.value;
    return _layoutBuilder(currentUserDetails);
  }

  Widget _layoutBuilder(UserDetails userDetails) {
    return Consumer<ImportNotifier>(
      builder: (BuildContext context, ImportNotifier value, Widget? child) {
        final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(true);

        return Consumer<RestartAppNotifier>(
          builder:
              (
                BuildContext context,
                RestartAppNotifier restartAppNotifier,
                Widget? child,
              ) {
                if (restartAppNotifier.isRestarted) {
                  pageNavigatorNotifier = ValueNotifier<NavigationPagesSlot>(
                    NavigationPagesSlot.dashboard,
                  );
                }

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool isSmallScreen = isMobile(context);
                    final ValueNotifier<int> currentIndexNotifier =
                        isSmallScreen
                        ? _mobileViewIndex
                        : _desktopOrWebViewIndex;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (!isSmallScreen)
                          NavigationRailAndDrawer(
                            userDetails: value.user ?? userDetails,
                            isExpanded: isExpanded,
                          ),
                        Expanded(
                          child: _buildMobileNavigation(
                            isSmallScreen,
                            context,
                            currentIndexNotifier,
                            value.user ?? userDetails,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
        );
      },
    );
  }

  Widget _buildMobileNavigation(
    bool isSmallScreen,
    BuildContext context,
    ValueNotifier<int> currentIndexNotifier,
    UserDetails userDetails,
  ) {
    final Profile userProfile = userDetails.userProfile;
    final String firstNameFirstLetter = userProfile.firstName.characters.first
        .toUpperCase();
    final String lastNameFirstLetter = userProfile.lastName.isNotEmpty
        ? userProfile.lastName.characters.first.toUpperCase()
        : '';

    final String firstName = capitalizeFirstLetter(userProfile.firstName);
    final String lastName = userProfile.lastName.isNotEmpty
        ? capitalizeFirstLetter(userProfile.lastName)
        : '';

    String? selectedPageTitle;

    return Consumer5<
      SavingsNotifier,
      BudgetNotifier,
      GoalNotifier,
      TransactionNotifier,
      MobileAppBarUpdate
    >(
      builder:
          (
            BuildContext context,
            SavingsNotifier savingsNotifier,
            BudgetNotifier budgetNotifier,
            GoalNotifier goalNotifier,
            TransactionNotifier transactionNotifier,
            MobileAppBarUpdate mobileAppBarUpdate,
            Widget? child,
          ) {
            return Scaffold(
              floatingActionButton: ValueListenableBuilder(
                valueListenable: pageNavigatorNotifier,
                builder: (BuildContext context, NavigationPagesSlot value, _) {
                  return isMobile(context) &&
                          !(pageNavigatorNotifier.value ==
                                  NavigationPagesSlot.appearance ||
                              pageNavigatorNotifier.value ==
                                  NavigationPagesSlot.personalization ||
                              pageNavigatorNotifier.value ==
                                  NavigationPagesSlot.profile ||
                              pageNavigatorNotifier.value ==
                                  NavigationPagesSlot.settings)
                      ? CustomFabMenu(
                          userDetails: userDetails,
                          notifier: mobileAppBarUpdate,
                          savingNotifier: savingsNotifier,
                          goalNotifier: goalNotifier,
                          transactionNotifier: transactionNotifier,
                          budgetNotifier: budgetNotifier,
                        )
                      : const SizedBox.shrink();
                },
              ),
              // Adjust FloatingActionButton position
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              backgroundColor: themeData.colorScheme.surfaceContainerLow,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: ValueListenableBuilder<NavigationPagesSlot>(
                  valueListenable: pageNavigatorNotifier,
                  builder:
                      (BuildContext context, NavigationPagesSlot value, _) {
                        final bool showBackButton =
                            value == NavigationPagesSlot.profile ||
                            value == NavigationPagesSlot.personalization ||
                            value == NavigationPagesSlot.appearance;
                        return AppBar(
                          leadingWidth: 0.0,
                          shadowColor: const Color(0xff000026),
                          surfaceTintColor: Colors.transparent,
                          titleSpacing: 0.0,
                          title: _buildDefaultAppBar(
                            context,
                            Theme.of(context),
                            budgetNotifier,
                            savingsNotifier,
                            goalNotifier,
                            transactionNotifier,
                            pageNavigatorNotifier,
                            showBackButton,
                            selectedPageTitle,
                            isSmallScreen,
                            userDetails,
                            firstNameFirstLetter,
                            lastNameFirstLetter,
                            firstName,
                            lastName,
                          ),
                          backgroundColor: themeData.colorScheme.surface,
                          elevation: 2.0,
                          automaticallyImplyLeading: false,
                        );
                      },
                ),
              ),
              body: ValueListenableBuilder<NavigationPagesSlot>(
                valueListenable: pageNavigatorNotifier,
                builder:
                    (
                      BuildContext context,
                      NavigationPagesSlot navigationPagesSlot,
                      Widget? child,
                    ) {
                      final TransactionalDetails details =
                          userDetails.transactionalData.data;
                      final UserDetails updatedUserDetails = UserDetails(
                        userProfile: userProfile,
                        transactionalData: TransactionalData(
                          data: TransactionalDetails(
                            transactions: transactionNotifier.isFirstTime
                                ? details.transactions
                                : transactionNotifier.transactions,
                            budgets: budgetNotifier.isFirstTime
                                ? details.budgets
                                : budgetNotifier.budgets,
                            goals: goalNotifier.isFirstTime
                                ? details.goals
                                : goalNotifier.goals,
                            savings: savingsNotifier.isFirstTime
                                ? details.savings
                                : savingsNotifier.savings,
                          ),
                        ),
                      );
                      selectedPageTitle = _buildPageTitle(
                        context,
                        navigationPagesSlot,
                      );
                      return _buildSelectedPage(
                        navigationPagesSlot,
                        updatedUserDetails,
                      );
                    },
              ),
              bottomNavigationBar: isMobile(context)
                  ? MobileBottomNavigationBar(userDetails: userDetails)
                  : null,
            );
          },
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }

    final List<String> words = text.split(' ');
    final List<String> capitalizedWords = words.map((String word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }

  Widget _buildDefaultAppBar(
    BuildContext context,
    ThemeData themeData,
    BudgetNotifier budgetNotifier,
    SavingsNotifier savingsNotifier,
    GoalNotifier goalNotifier,
    TransactionNotifier transactionNotifier,
    ValueNotifier<NavigationPagesSlot> pageNavigatorNotifier,
    bool showBackButton,
    String? selectedPageTitle,
    bool isSmallScreen,
    UserDetails userDetails,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
    String firstName,
    String lastName,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        boxShadow: [
          _getBoxShadow(3.0, const Color(0xff000026)),
          _getBoxShadow(2.0, const Color(0xff00004D), 0),
        ],
      ),
      padding: _getPadding(showBackButton),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (showBackButton) _buildBackButton(showBackButton)!,
              _buildTitle(selectedPageTitle),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!isMobile(context))
                _buildCreateButton(
                  context,
                  themeData,
                  transactionNotifier,
                  budgetNotifier,
                  savingsNotifier,
                  goalNotifier,
                  userDetails,
                ),
              horizontalSpacer16,
              _buildProfileMenu(
                context,
                themeData,
                firstNameFirstLetter,
                lastNameFirstLetter,
                firstName,
                lastName,
              ),
            ],
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding(bool showBackButton) {
    final bool isMobileDevice = isMobile(context);
    return EdgeInsets.only(
      left: isMobileDevice ? 16.0 : (showBackButton ? 10 : 24.0),
      right: isMobileDevice ? 16.0 : 24.0,
      top: 10.0,
      bottom: 10.0,
    );
  }

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

  Text _buildTitle(String? selectedPageTitle) {
    TextStyle textStyle = themeData.textTheme.titleMedium!.copyWith(
      color: themeData.colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    );

    if (!isMobile(context)) {
      textStyle = themeData.textTheme.titleLarge!.copyWith(
        color: themeData.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      );
    }

    return Text(selectedPageTitle ?? 'Dashboard', style: textStyle);
  }

  IconButton? _buildBackButton(bool showBackButton) {
    if (showBackButton) {
      return IconButton(
        hoverColor: Colors.transparent,
        icon: Icon(
          const IconData(0xe708, fontFamily: fontIconFamily),
          color: themeData.colorScheme.onSurfaceVariant,
          size: 24.0,
        ),
        onPressed: () {
          if (pageNavigatorNotifier.value == NavigationPagesSlot.dashboard) {
            Navigator.of(context, rootNavigator: true).pop();
          } else {
            pageNavigatorNotifier.value = NavigationPagesSlot.settings;
          }
        },
      );
    }
    return null;
  }

  Widget _buildCreateButton(
    BuildContext context,
    ThemeData themeData,
    TransactionNotifier transactionNotifier,
    BudgetNotifier budgetNotifier,
    SavingsNotifier savingsNotifier,
    GoalNotifier goalNotifier,
    UserDetails userDetails,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: !isMobile(context) ? 0 : 0),
      child: Theme(
        data: Theme.of(context).copyWith(
          hoverColor: themeData.colorScheme.primaryContainer,
          highlightColor: themeData.colorScheme.primaryContainer,
        ),
        child: PopupMenuButton<String>(
          key: _popupMenuKey,
          position: PopupMenuPosition.under,
          elevation: 2.0,
          offset: const Offset(0, 6),
          borderRadius: BorderRadius.circular(30.0),
          color: themeData.colorScheme.surfaceContainerLow,
          tooltip: '',
          useRootNavigator: true,
          itemBuilder: (BuildContext context) => _buildPopupMenuItems(
            context,
            transactionNotifier,
            budgetNotifier,
            savingsNotifier,
            goalNotifier,
            userDetails,
          ),
          child: ElevatedButton(
            onPressed: () {
              _popupMenuKey.currentState?.showButtonMenu();
            },
            style: ElevatedButton.styleFrom(
              elevation: 2.0,
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: (!kIsWeb || !isMobile(context)) ? 13.0 : 14.0,
                bottom: (!kIsWeb || !isMobile(context)) ? 15.0 : 14.0,
              ),
              overlayColor: themeData.colorScheme.primaryContainer,
              surfaceTintColor: themeData.colorScheme.primary,
              backgroundColor: themeData.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Create',
                  style: themeData.textTheme.labelLarge!.copyWith(
                    color: themeData.colorScheme.onPrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 18.0,
                    color: themeData.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(
    BuildContext context,
    TransactionNotifier transactionNotifier,
    BudgetNotifier budgetNotifier,
    SavingsNotifier savingsNotifier,
    GoalNotifier goalNotifier,
    UserDetails userDetails,
  ) {
    return <PopupMenuEntry<String>>[
      _buildPopupMenuItem(
        'Transaction',
        const IconData(0xe738, fontFamily: fontIconFamily),
        'Transaction',
        () => showDialog<Transaction>(
          context: context,
          builder: (BuildContext context) =>
              _transactionDialog(context, transactionNotifier, userDetails),
        ),
      ),
      _buildPopupMenuItem(
        'Budget',
        const IconData(0xe739, fontFamily: fontIconFamily),
        'Budget',
        () => showDialog<Budget>(
          context: context,
          builder: (BuildContext context) =>
              _budgetDialog(context, budgetNotifier, userDetails),
        ),
      ),
      _buildPopupMenuItem(
        'Savings',
        const IconData(0xe737, fontFamily: fontIconFamily),
        'Savings',
        () => showDialog<Saving>(
          context: context,
          builder: (BuildContext context) =>
              _savingsDialog(context, savingsNotifier, userDetails),
        ),
      ),
      _buildPopupMenuItem(
        'Goal',
        const IconData(0xe73a, fontFamily: fontIconFamily),
        'Goal',
        () => showDialog<Budget>(
          context: context,
          builder: (BuildContext context) =>
              _goalDialog(context, goalNotifier, userDetails),
        ),
      ),
    ];
  }

  PopupMenuEntry<String> _buildPopupMenuItem(
    String value,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    return PopupMenuItem<String>(
      value: value,
      onTap: onTap,
      child: Row(
        children: <Widget>[Icon(icon), const SizedBox(width: 8.0), Text(text)],
      ),
    );
  }

  Widget _transactionDialog(
    BuildContext context,
    TransactionNotifier transactionNotifier,
    UserDetails userDetails,
  ) {
    return Consumer<TextButtonValidNotifier>(
      builder:
          (BuildContext context, TextButtonValidNotifier value, Widget? child) {
            return ResponsiveTransactionCenterDialog(
              userInteraction: UserInteractions.add,
              userDetails: userDetails,
              categories: userDetails.userProfile.categoryStrings,
              subCategories: userDetails.userProfile.getSubcategoriesFor(''),
              notifier: transactionNotifier,
              validNotifier: value,
              selectedCountNotifier: context
                  .watch<TransactionSelectedCountNotifier>(),
            );
          },
    );
  }

  Widget _budgetDialog(
    BuildContext context,
    BudgetNotifier budgetNotifier,
    UserDetails userDetails,
  ) {
    return Consumer<TextButtonValidNotifier>(
      builder:
          (BuildContext context, TextButtonValidNotifier value, Widget? child) {
            return BudgetsCenterDialog(
              notifier: budgetNotifier,
              validNotifier: value,
              userInteraction: UserInteractions.add,
              userDetails: userDetails,
            );
          },
    );
  }

  Widget _savingsDialog(
    BuildContext context,
    SavingsNotifier savingsNotifier,
    UserDetails userDetails,
  ) {
    return Consumer<TextButtonValidNotifier>(
      builder:
          (BuildContext context, TextButtonValidNotifier value, Widget? child) {
            return SavingsCenterDialog(
              selectedCountNotifier: context
                  .watch<SavingsSelectedCountNotifier>(),
              validNotifier: value,
              notifier: savingsNotifier,
              userInteraction: UserInteractions.add,
              userDetails: userDetails,
            );
          },
    );
  }

  Widget _goalDialog(
    BuildContext context,
    GoalNotifier goalNotifier,
    UserDetails userDetails,
  ) {
    return Consumer<TextButtonValidNotifier>(
      builder:
          (BuildContext context, TextButtonValidNotifier value, Widget? child) {
            return GoalsCenterDialog(
              notifier: goalNotifier,
              validNotifier: value,
              userInteraction: UserInteractions.add,
              userDetails: userDetails,
            );
          },
    );
  }

  Widget _buildProfileMenu(
    BuildContext context,
    ThemeData themeData,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
    String firstName,
    String lastName,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
      child: PopupMenuButton<String>(
        key: _profilePopupMenuKey,
        constraints: const BoxConstraints(minWidth: 300),
        position: PopupMenuPosition.under,
        padding: const EdgeInsets.only(top: 20),
        offset: const Offset(0, 4),
        elevation: 8.0,
        shadowColor: Colors.black54,
        color: themeData.colorScheme.surfaceContainerLow,
        tooltip: '',
        useRootNavigator: true,
        itemBuilder: (BuildContext context) => _buildProfileMenuItems(
          context,
          themeData,
          firstNameFirstLetter,
          lastNameFirstLetter,
          firstName,
          lastName,
        ),
        child: Tooltip(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inverseSurface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          message: '$firstName $lastName',
          textAlign: TextAlign.center,
          textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: themeData.colorScheme.onInverseSurface,
          ),
          child: SizedBox.square(
            dimension: 36.0,
            child: InkWell(
              onTap: () {
                _profilePopupMenuKey.currentState?.showButtonMenu();
              },
              hoverColor: themeData.colorScheme.primaryContainer,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xff8AE2D2),
                child: Text(
                  '$firstNameFirstLetter$lastNameFirstLetter',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff00604E),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildProfileMenuItems(
    BuildContext context,
    ThemeData themeData,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
    String firstName,
    String lastName,
  ) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        enabled: false,
        value: 'profile',
        mouseCursor: SystemMouseCursors.basic,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xff8AE2D2),
                child: Text(
                  '$firstNameFirstLetter$lastNameFirstLetter',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff00604E),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$firstName $lastName',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeData.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      PopupMenuItem<String>(
        enabled: false,
        value: 'View Profile & Settings',
        mouseCursor: SystemMouseCursors.basic,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              pageNavigatorNotifier.value = NavigationPagesSlot.settings;
            },
            child: Text(
              'View Profile & Settings',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      const PopupMenuDivider(height: 0.5),
      PopupMenuItem<String>(
        value: 'sample_browser',
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop(context);
          // Sets default meta tag details when navigating back from the
          // Expense Tracker to the home page.
          metaTagUpdate.setDefault();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.arrow_back,
                size: 20,
                color: themeData.colorScheme.primary,
              ),
              Text(
                'Go to Sample Browser',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: themeData.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  String _buildPageTitle(
    BuildContext context,
    NavigationPagesSlot navigationPagesSlot,
  ) {
    switch (navigationPagesSlot) {
      case NavigationPagesSlot.dashboard:
        return 'Dashboard';
      case NavigationPagesSlot.transaction:
        return 'Transaction';
      case NavigationPagesSlot.budget:
        return 'Budgets';
      case NavigationPagesSlot.savings:
        return 'Savings';
      case NavigationPagesSlot.goal:
        return 'Goals';
      case NavigationPagesSlot.settings:
        return 'Settings';
      case NavigationPagesSlot.profile:
        return 'Profile';
      case NavigationPagesSlot.personalization:
        return 'Personalization';
      case NavigationPagesSlot.appearance:
        return 'Appearance';
    }
  }

  Widget _buildSelectedPage(
    NavigationPagesSlot navigationPagesSlot,
    UserDetails userDetails,
  ) {
    switch (navigationPagesSlot) {
      case NavigationPagesSlot.dashboard:
        return DashboardPage(userDetails);
      case NavigationPagesSlot.transaction:
        return TransactionPage(userDetails);
      case NavigationPagesSlot.budget:
        return BudgetLayout(user: userDetails);
      case NavigationPagesSlot.savings:
        return SavingsPageWidget(userDetails);
      case NavigationPagesSlot.goal:
        return GoalLayout(user: userDetails);
      case NavigationPagesSlot.settings:
        return SettingsPage(userDetails);
      case NavigationPagesSlot.profile:
        return ProfilePage(userDetails.userProfile);
      case NavigationPagesSlot.personalization:
        return PersonalizationPage(userDetails.userProfile);
      case NavigationPagesSlot.appearance:
        return AppearancePage(userDetails.userProfile);
    }
  }
}

enum NavigationPagesSlot {
  dashboard,
  transaction,
  budget,
  savings,
  goal,
  settings,
  profile,
  personalization,
  appearance,
}

class NavigationRailAndDrawer extends StatefulWidget {
  const NavigationRailAndDrawer({
    required this.userDetails,
    required this.isExpanded,
    super.key,
  });
  final UserDetails userDetails;
  final ValueNotifier<bool> isExpanded;

  @override
  State<NavigationRailAndDrawer> createState() =>
      _NavigationRailAndDrawerState();
}

class _NavigationRailAndDrawerState extends State<NavigationRailAndDrawer> {
  Widget _createDrawerItem({
    required IconData? icon,
    required String text,
    required GestureTapCallback? onTap,
    bool isSelected = false,
    bool enabled = true,
    required bool isExpanded,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: !enabled ? 0 : (isExpanded ? 12.0 : 8.0),
        right: isExpanded ? 12.0 : 8.0,
      ),
      child: Material(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: ListTile(
          minVerticalPadding: 0,
          enabled: enabled,
          dense: true,
          // horizontalTitleGap: 8.0,
          style: ListTileStyle.drawer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          minLeadingWidth: 0,
          focusColor: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.primary,
          hoverColor: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.4),
          splashColor: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.2),
          tileColor: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.primary,
          contentPadding: !isExpanded
              ? EdgeInsets.zero
              : EdgeInsets.only(left: 16.0, right: enabled ? 16.0 : 0),
          titleAlignment: ListTileTitleAlignment.center,
          title: _buildTitle(icon, text, isExpanded, enabled, isSelected),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget? _buildTitle(
    IconData? icon,
    String text,
    bool isExpanded,
    bool enabled,
    bool isSelected,
  ) {
    return isExpanded
        ? _buildExpandedTitle(icon, text, isExpanded, enabled, isSelected)
        : _buildDefaultTitle(icon, text, isExpanded, enabled, isSelected);
  }

  Widget _buildDefaultTitle(
    IconData? icon,
    String text,
    bool isExpanded,
    bool enabled,
    bool isSelected,
  ) {
    return enabled
        ? _buildTooltip(text, icon, isSelected)
        : _buildIconView(icon, isSelected, enabled, isExpanded);
  }

  Widget _buildTooltip(String text, IconData? icon, bool isSelected) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    return Tooltip(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      message: text,
      textAlign: TextAlign.center,
      textStyle: themeData.textTheme.labelLarge!.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      child: Icon(
        icon,
        size: 24.0,
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildIconView(
    IconData? icon,
    bool isSelected,
    bool enabled,
    bool isExpanded,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: !isTablet(context)
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 08.0),
            child: Icon(
              icon,
              size: 36.0,
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onPrimary,
            ),
          ),
        ),
        if (!enabled)
          if (!isTablet(context))
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: _buildExpandOrCollapseIcon(isExpanded),
            ),
      ],
    );
  }

  Widget _buildExpandedTitle(
    IconData? icon,
    String text,
    bool isExpanded,
    bool enabled,
    bool isSelected,
  ) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextTheme textTheme = themeData.textTheme;
    return Row(
      mainAxisAlignment: !isTablet(context)
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(bottom: enabled ? 0.0 : 8.0),
                  child: Icon(
                    icon,
                    size: enabled ? 24.0 : 36.0,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onPrimary,
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: enabled
                      ? textTheme.titleMedium!.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onPrimary,
                        )
                      : textTheme.titleLarge!.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                ),
              ),
            ],
          ),
        ),
        if (!enabled)
          if (!isTablet(context))
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: _buildExpandOrCollapseIcon(isExpanded),
            ),
      ],
    );
  }

  Widget _buildExpandOrCollapseIcon(bool isExpanded) {
    return SizedBox.square(
      dimension: 18.0,
      child: InkWell(
        onTap: () {
          Provider.of<DrawerNotifier>(
            context,
            listen: false,
          ).toggleDrawer(context, widget.userDetails.userProfile);
        },
        child: Icon(
          !isExpanded
              ? const IconData(0xe701, fontFamily: fontIconFamily)
              : const IconData(0xe700, fontFamily: fontIconFamily),
          size: 18.0,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> navigationPages = buildNavigationPages(context);
    final List<IconData> iconDataCollections = buildIconDataCollections(
      context,
    );

    return Material(
      elevation: 2.0,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: Consumer<DrawerNotifier>(
        builder:
            (
              BuildContext context,
              DrawerNotifier drawerNotifier,
              Widget? child,
            ) {
              late bool isDrawerExpanded;
              if (!isTablet(context)) {
                isDrawerExpanded =
                    widget.userDetails.userProfile.isDrawerExpanded;
              } else {
                isDrawerExpanded = false;
              }
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: isDrawerExpanded ? Curves.easeIn : Curves.easeOut,
                width: isDrawerExpanded ? 270.0 : 64.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0xff00004D),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Color(0xff000026),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: ValueListenableBuilder<NavigationPagesSlot>(
                  valueListenable: pageNavigatorNotifier,
                  builder:
                      (
                        BuildContext context,
                        NavigationPagesSlot currentPage,
                        Widget? child,
                      ) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              spacing: 12.0,
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                navigationPages.length - 1,
                                (int index) {
                                  NavigationPagesSlot pageSlot;
                                  switch (index) {
                                    case 0:
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _createDrawerItem(
                                            icon: iconDataCollections[index],
                                            text: navigationPages[index],
                                            onTap: null,
                                            enabled: false,
                                            isExpanded: isDrawerExpanded,
                                          ),
                                          Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                          ),
                                        ],
                                      );
                                    case 1:
                                      pageSlot = NavigationPagesSlot.dashboard;
                                      break;
                                    case 2:
                                      pageSlot =
                                          NavigationPagesSlot.transaction;
                                      break;
                                    case 3:
                                      pageSlot = NavigationPagesSlot.budget;
                                      break;
                                    case 4:
                                      pageSlot = NavigationPagesSlot.savings;
                                      break;
                                    case 5:
                                      pageSlot = NavigationPagesSlot.goal;
                                      break;
                                    default:
                                      pageSlot = NavigationPagesSlot.dashboard;
                                  }
                                  return _createDrawerItem(
                                    icon: iconDataCollections[index],
                                    text: navigationPages[index],
                                    onTap: () {
                                      pageNavigatorNotifier.value = pageSlot;
                                    },
                                    isSelected: currentPage == pageSlot,
                                    isExpanded: isDrawerExpanded,
                                  );
                                },
                              ),
                            ),
                            Column(
                              spacing: 12,
                              children: <Widget>[
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                                _createDrawerItem(
                                  icon: Icons.settings,
                                  text: 'Settings',
                                  onTap: () {
                                    pageNavigatorNotifier.value =
                                        NavigationPagesSlot.settings;
                                  },
                                  isSelected:
                                      currentPage ==
                                      NavigationPagesSlot.settings,
                                  isExpanded: isDrawerExpanded,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                ),
              );
            },
      ),
    );
  }
}

class MobileBottomNavigationBar extends StatefulWidget {
  const MobileBottomNavigationBar({required this.userDetails, super.key});
  final UserDetails userDetails;
  @override
  State<MobileBottomNavigationBar> createState() =>
      _MobileBottomNavigationBarState();
}

class _MobileBottomNavigationBarState extends State<MobileBottomNavigationBar> {
  late ColorScheme _colorScheme;

  Widget _createNavigationIcon({
    required IconData icon,
    required String text,
    required GestureTapCallback? onTap,
    bool isSelected = false,
  }) {
    return Center(
      child: SizedBox(
        width: 64, // Adjust based on design
        height: 32,
        child: Center(
          child: Material(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(24.0),
                right: Radius.circular(24.0),
              ),
              splashColor: Colors.transparent, // Remove unwanted splash effect
              hoverColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? _colorScheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(24.0),
                    right: Radius.circular(24.0),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 24.0,
                  color: isSelected
                      ? _colorScheme.onPrimaryContainer
                      : _colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> navigationPages = buildNavigationPages(context);
    final List<IconData> iconDataCollections = buildIconDataCollections(
      context,
    );
    _colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 2.0,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: Container(
        height: 64.0,
        decoration: BoxDecoration(
          color: _colorScheme.onPrimary,
          border: Border(top: BorderSide(color: _colorScheme.outlineVariant)),
        ),
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<NavigationPagesSlot>(
          valueListenable: pageNavigatorNotifier,
          builder:
              (
                BuildContext context,
                NavigationPagesSlot currentPage,
                Widget? child,
              ) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(navigationPages.length - 1, (
                    int index,
                  ) {
                    NavigationPagesSlot pageSlot;
                    switch (index) {
                      case 0:
                        pageSlot = NavigationPagesSlot.dashboard;
                        break;
                      case 1:
                        pageSlot = NavigationPagesSlot.transaction;
                        break;
                      case 2:
                        pageSlot = NavigationPagesSlot.budget;
                        break;
                      case 3:
                        pageSlot = NavigationPagesSlot.savings;
                        break;
                      case 4:
                        pageSlot = NavigationPagesSlot.goal;
                        break;
                      default:
                        pageSlot = NavigationPagesSlot.dashboard;
                    }
                    return _createNavigationIcon(
                      icon: iconDataCollections[index],
                      text: navigationPages[index],
                      onTap: () {
                        pageNavigatorNotifier.value = pageSlot;
                      },
                      isSelected: currentPage == pageSlot,
                    );
                  }),
                );
              },
        ),
      ),
    );
  }
}

class CustomFabMenu extends StatefulWidget {
  const CustomFabMenu({
    required this.userDetails,
    required this.notifier,
    required this.savingNotifier,
    required this.goalNotifier,
    required this.budgetNotifier,
    required this.transactionNotifier,
    super.key,
  });
  final UserDetails userDetails;
  final MobileAppBarUpdate notifier;
  final SavingsNotifier savingNotifier;
  final GoalNotifier goalNotifier;
  final TransactionNotifier transactionNotifier;
  final BudgetNotifier budgetNotifier;

  @override
  State<CustomFabMenu> createState() => _CustomFabMenuState();
}

class _CustomFabMenuState extends State<CustomFabMenu>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _removeOverlay(widget.notifier);
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
        _showOverlay(widget.notifier);
      } else {
        _animationController.reverse();
        _removeOverlay(widget.notifier);
      }
    });
  }

  void _showOverlay(MobileAppBarUpdate mobileNotifier) {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext buildContext) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              _buildFullScreenOverlay(),
              _buildFabMenu(context, mobileNotifier),
              _buildFloatingActionButton(context),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildFullScreenOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _toggleMenu,
        child: Container(color: const Color.fromRGBO(0, 0, 0, 0.8)),
      ),
    );
  }

  Widget _buildFabMenu(
    BuildContext context,
    MobileAppBarUpdate mobileNotifier,
  ) {
    return Positioned(
      bottom: 150,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          verticalSpacer16,
          _buildFabMenuItem(
            context,
            mobileNotifier,
            'Goal',
            MobileDialogs.goals,
            _goalAction,
          ),
          verticalSpacer16,
          _buildFabMenuItem(
            context,
            mobileNotifier,
            'Savings',
            MobileDialogs.savings,
            _savingsAction,
          ),
          verticalSpacer16,
          _buildFabMenuItem(
            context,
            mobileNotifier,
            'Budget',
            MobileDialogs.budgets,
            _budgetAction,
          ),
          verticalSpacer16,
          _buildFabMenuItem(
            context,
            mobileNotifier,
            'Transaction',
            MobileDialogs.transactions,
            _transactionAction,
          ),
        ],
      ),
    );
  }

  Widget _buildFabMenuItem(
    BuildContext context,
    MobileAppBarUpdate mobileNotifier,
    String label,
    MobileDialogs dialog,
    Function(BuildContext, MobileAppBarUpdate) action,
  ) {
    return _buildMenuItem(
      icon: _iconData(label),
      label: label,
      onTap: () {
        _toggleMenu();
        widget.notifier.openDialog(isDialogOpen: true);
        mobileNotifier.currentMobileDialog = dialog;
        action(context, mobileNotifier);
      },
    );
  }

  IconData _iconData(String label) {
    switch (label) {
      case 'Transaction':
        return const IconData(0xe738, fontFamily: fontIconFamily);
      case 'Goal':
        return const IconData(0xe73a, fontFamily: fontIconFamily);
      case 'Budget':
        return const IconData(0xe739, fontFamily: fontIconFamily);
      case 'Savings':
        return const IconData(0xe737, fontFamily: fontIconFamily);
      default:
        return const IconData(0xe752, fontFamily: fontIconFamily);
    }
  }

  void _goalAction(BuildContext context, MobileAppBarUpdate mobileNotifier) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Consumer<TextButtonValidNotifier>(
          builder: (ctx, value, child) => MobileCenterDialog(
            currentMobileDialog: mobileNotifier.currentMobileDialog,
            validateNotifier: value,
            userInteraction: UserInteractions.add,
            title: 'Create Goal',
            buttonText: 'Create',
            userDetails: widget.userDetails,
            onPressed: () {
              final goalDetails = widget.goalNotifier.goalTextFieldDetails;
              if (goalDetails != null) {
                _createGoal(goalDetails, mobileNotifier, value);
              }
            },
            onCancelPressed: () {
              widget.notifier.openDialog(isDialogOpen: false);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _savingsAction(BuildContext context, MobileAppBarUpdate mobileNotifier) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Consumer<TextButtonValidNotifier>(
          builder: (ctx, value, child) => MobileCenterDialog(
            currentMobileDialog: mobileNotifier.currentMobileDialog,
            validateNotifier: value,
            userInteraction: UserInteractions.add,
            title: 'Create Saving',
            buttonText: 'Create',
            userDetails: widget.userDetails,
            onPressed: () {
              final savingsDetails =
                  widget.savingNotifier.savingsTextFieldDetails;
              if (savingsDetails != null) {
                _createSaving(widget, savingsDetails, mobileNotifier, value);
              }
            },
            onCancelPressed: () {
              widget.notifier.openDialog(isDialogOpen: false);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _createSaving(
    widget,
    SavingsTextFieldDetails savingsDetails,
    MobileAppBarUpdate mobileNotifier,
    TextButtonValidNotifier value,
  ) {
    final saving = Saving(
      name: savingsDetails.name,
      savedAmount: savingsDetails.amount,
      type: savingsDetails.type,
      remark: savingsDetails.remarks,
      savingDate: savingsDetails.date,
    );
    final savings = widget.userDetails.transactionalData.data.savings;
    savings.add(saving);
    widget.savingNotifier.updateSavings(savings);
    // updateSavings(widget.userDetails, saving, UserInteractions.add, <int>[]);
    widget.notifier.openDialog(isDialogOpen: false);
    value.isTextButtonValid(false);
    Navigator.pop(context);
  }

  void _budgetAction(BuildContext context, MobileAppBarUpdate mobileNotifier) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Consumer<TextButtonValidNotifier>(
          builder: (ctx, value, child) => MobileCenterDialog(
            currentMobileDialog: mobileNotifier.currentMobileDialog,
            validateNotifier: value,
            userInteraction: UserInteractions.add,
            title: 'Create Budget',
            buttonText: 'Create',
            userDetails: widget.userDetails,
            onPressed: () {
              final BudgetTextFieldDetails? budgetDetails =
                  widget.budgetNotifier.budgetTextFieldDetails;
              if (budgetDetails != null) {
                _createBudget(budgetDetails, mobileNotifier, value);
              }
            },
            onCancelPressed: () {
              widget.notifier.openDialog(isDialogOpen: false);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _createBudget(
    BudgetTextFieldDetails budgetDetails,
    MobileAppBarUpdate mobileNotifier,
    TextButtonValidNotifier value,
  ) {
    final budget = Budget(
      name: budgetDetails.name,
      target: budgetDetails.amount,
      createdDate: budgetDetails.date,
      notes: budgetDetails.remarks,
      expense: 0,
      category: budgetDetails.category,
    );
    if (widget.budgetNotifier.isFirstTime) {
      widget.budgetNotifier.read(widget.userDetails);
    }
    widget.budgetNotifier.createBudget(budget);
    // updateBudgets(widget.userDetails, budget, UserInteractions.add);
    widget.notifier.openDialog(isDialogOpen: false);
    value.isTextButtonValid(false);
    Navigator.pop(context);
  }

  void _transactionAction(
    BuildContext context,
    MobileAppBarUpdate mobileNotifier,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Consumer<TextButtonValidNotifier>(
          builder: (ctx, value, child) => MobileCenterDialog(
            currentMobileDialog: mobileNotifier.currentMobileDialog,
            validateNotifier: value,
            userInteraction: UserInteractions.add,
            title: 'Create Transaction',
            buttonText: 'Create',
            userDetails: widget.userDetails,
            onPressed: () {
              final transactionDetails =
                  widget.transactionNotifier.transactionTextFieldDetails;
              if (transactionDetails != null) {
                _createTransaction(transactionDetails, mobileNotifier, value);
              }
            },
            onCancelPressed: () {
              widget.notifier.openDialog(isDialogOpen: false);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _createTransaction(
    TransactionTextFieldDetails transactionDetails,
    MobileAppBarUpdate mobileNotifier,
    TextButtonValidNotifier value,
  ) {
    final transaction = Transaction(
      type: transactionDetails.type,
      amount: transactionDetails.amount,
      category: transactionDetails.category,
      remark: transactionDetails.remarks,
      subCategory: transactionDetails.subCategory,
      transactionDate: transactionDetails.date,
    );
    final transactions = widget.userDetails.transactionalData.data.transactions;
    transactions.add(transaction);
    widget.transactionNotifier.updateTransactions(transactions);
    // updateTransactions(
    //   widget.userDetails,
    //   transaction,
    //   UserInteractions.add,
    //   <int>[],
    // );
    widget.notifier.openDialog(isDialogOpen: false);
    value.isTextButtonValid(false);
    Navigator.pop(context);
  }

  void _createGoal(
    GoalTextFieldDetails goalDetails,
    MobileAppBarUpdate mobileNotifier,
    TextButtonValidNotifier value,
  ) {
    final Goal goal = Goal(
      name: goalDetails.name,
      amount: goalDetails.amount,
      date: goalDetails.date,
      notes: goalDetails.remarks,
      priority: goalDetails.priority,
      category: goalDetails.category,
    );
    if (widget.goalNotifier.isFirstTime) {
      widget.goalNotifier.read(widget.userDetails);
    }
    widget.goalNotifier.createGoal(goal);
    // updateGoals(widget.userDetails, goal, UserInteractions.add);
    widget.notifier.openDialog(isDialogOpen: false);
    value.isTextButtonValid(false);
    Navigator.pop(context);
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        width: 48,
        height: 48,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleMenu,
            borderRadius: BorderRadius.circular(28),
            child: Icon(
              _isMenuOpen ? Icons.close : Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _removeOverlay(MobileAppBarUpdate mobileNotifier) {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 48,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleMenu,
          borderRadius: BorderRadius.circular(28),
          child: Icon(
            _isMenuOpen ? Icons.close : Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Row(
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileCenterDialog extends StatelessWidget {
  const MobileCenterDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.userDetails,
    required this.userInteraction,
    required this.validateNotifier,
    this.currentMobileDialog,
    this.budgetNotifier,
    this.goalNotifier,
    this.savingsNotifier,
    this.transactionNotifier,
    this.index = -1,
    this.onPressed,
    this.isAddExpense = false,
    this.onCancelPressed,
  });

  final String title;
  final String buttonText;
  final UserDetails userDetails;
  final UserInteractions userInteraction;
  final MobileDialogs? currentMobileDialog;
  final void Function()? onPressed;
  final void Function()? onCancelPressed;
  final int index;
  final BudgetNotifier? budgetNotifier;
  final GoalNotifier? goalNotifier;
  final SavingsNotifier? savingsNotifier;
  final TransactionNotifier? transactionNotifier;
  final TextButtonValidNotifier validateNotifier;
  final bool isAddExpense;

  Widget _currentMobileDialogContent(
    BuildContext context,
    UserDetails userDetails,
  ) {
    switch (currentMobileDialog) {
      case MobileDialogs.savings:
        return SavingsCenterDialog(
          selectedCountNotifier: context.watch<SavingsSelectedCountNotifier>(),
          validNotifier: validateNotifier,
          notifier: savingsNotifier ?? context.watch<SavingsNotifier>(),
          userInteraction: userInteraction,
          userDetails: userDetails,
          selectedIndex: index,
        );
      case MobileDialogs.budgets:
        return BudgetsCenterDialog(
          isMobile: true,
          validNotifier: validateNotifier,
          isAddExpense: isAddExpense,
          userInteraction: userInteraction,
          notifier: budgetNotifier ?? context.watch<BudgetNotifier>(),
          userDetails: userDetails,
          selectedIndex: index,
        );
      case MobileDialogs.goals:
        return GoalsCenterDialog(
          isMobile: true,
          validNotifier: validateNotifier,
          isAddExpense: isAddExpense,
          userInteraction: userInteraction,
          notifier: goalNotifier ?? context.watch<GoalNotifier>(),
          userDetails: userDetails,
          selectedIndex: index,
        );
      case MobileDialogs.transactions:
        return ResponsiveTransactionCenterDialog(
          userInteraction: userInteraction,
          userDetails: userDetails,
          validNotifier: validateNotifier,
          categories: const [],
          subCategories: const [],
          selectedIndex: index,
          selectedCountNotifier: context
              .watch<TransactionSelectedCountNotifier>(),
          notifier: transactionNotifier ?? context.watch<TransactionNotifier>(),
        );
      case null:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRespectiveTextButton(BuildContext context) {
    switch (currentMobileDialog) {
      case MobileDialogs.savings:
        return _buildTextButton(context, validateNotifier.isValid);

      case MobileDialogs.budgets:
        return _buildTextButton(context, validateNotifier.isValid);

      case MobileDialogs.transactions:
        return _buildTextButton(context, validateNotifier.isValid);

      case MobileDialogs.goals:
        return _buildTextButton(context, validateNotifier.isValid);

      case null:
        return const SizedBox.shrink();
    }
  }

  TextButton _buildTextButton(BuildContext context, bool isValid) {
    return TextButton(
      onPressed: isValid ? onPressed : null,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: isValid ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0.0,
        shadowColor: const Color(0xff000026),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0.0,
        title: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 3.0,
                spreadRadius: 1.0,
                color: Color(0xff000026),
              ),
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2.0,
                color: Color(0xff00004D),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              spacing: 8.0,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment.bottomCenter,
                      onPressed: onCancelPressed,
                      icon: Icon(
                        const IconData(0xe721, fontFamily: fontIconFamily),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 24.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: _buildRespectiveTextButton(context),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2.0,
        automaticallyImplyLeading: false,
      ),
      body: _currentMobileDialogContent(context, userDetails),
    );
  }
}
