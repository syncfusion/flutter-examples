import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../stock_analysis/notifier/stock_chart_notifier.dart';
import '../../stock_analysis/notifier/theme_notifier.dart';
import 'budget_notifier.dart';
import 'drawer_notifier.dart';
import 'goal_notifier.dart';
import 'import_notifier.dart';
import 'mobile_app_bar.dart';
import 'restart_notifier.dart';
import 'savings_notifier.dart';
import 'setup_notifier.dart';
import 'text_field_valid_notifier.dart';
import 'theme_notifier.dart';
import 'transaction_notifier.dart';
import 'view_notifier.dart';
import 'welcome_screen_notifier.dart';

List<SingleChildWidget> buildProviders([BuildContext? context]) {
  return <SingleChildWidget>[
    ChangeNotifierProvider(create: (BuildContext context) => ThemeNotifier()),
    ChangeNotifierProvider(
      create: (BuildContext context) => TransactionNotifier(),
    ),
    ChangeNotifierProvider(create: (BuildContext context) => SavingsNotifier()),
    ChangeNotifierProvider(create: (BuildContext context) => BudgetNotifier()),
    ChangeNotifierProvider(create: (BuildContext context) => SetupNotifier()),
    ChangeNotifierProvider(create: (BuildContext context) => ViewNotifier()),
    ChangeNotifierProvider(
      create: (BuildContext context) => WelcomeScreenNotifier(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => TextButtonValidNotifier(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => VerifyUserNotifier(),
    ),
    ChangeNotifierProvider(create: (BuildContext context) => ImportNotifier()),
    ChangeNotifierProvider(
      create: (BuildContext context) => SavingsSelectedCountNotifier(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => TransactionSelectedCountNotifier(),
    ),
    ChangeNotifierProvider(create: (BuildContext context) => BudgetNotifier()),
    ChangeNotifierProvider(create: (BuildContext context) => GoalNotifier()),
    ChangeNotifierProvider(create: (BuildContext context) => DrawerNotifier()),
    ChangeNotifierProvider(
      create: (BuildContext context) => MobileAppBarUpdate(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => RestartAppNotifier(),
    ),
    ChangeNotifierProvider<StockThemeNotifier>(
      create: (BuildContext context) => StockThemeNotifier(),
    ),
    ChangeNotifierProvider<StockChartProvider>(
      create: (BuildContext context) => StockChartProvider(),
    ),
  ];
}
