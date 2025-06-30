import 'package:flutter/material.dart';

import 'helper/responsive_layout.dart';

const String defaultDateFormat = 'M/d/yyyy';
const String defaultTimeFormat = 'hh:mm a';
const int rowsPerPage = 5;
const double preferredAppBarHeight = 68;

const String userIdPrefix = 'EAUser#0';
const String fontIconFamily = 'Expense Tracker Icons';

const String googleUrlLink = 'https://www.google.com/';
const String facebookUrlLink = 'https://www.facebook.com/';
const String twitterUrlLink =
    'https://x.com/i/flow/login?input_flow_data=%7B%22requested_variant%22%3A%22eyJteCI6IjIifQ%3D%3D%22%7D';

const Widget verticalSpacer4 = SizedBox(height: 4.0);
const Widget verticalSpacer8 = SizedBox(height: 8.0);
const Widget verticalSpacer10 = SizedBox(height: 10.0);
const Widget verticalSpacer12 = SizedBox(height: 12.0);
const Widget verticalSpacer16 = SizedBox(height: 16.0);
const Widget verticalSpacer20 = SizedBox(height: 20.0);
const Widget verticalSpacer22 = SizedBox(height: 22.0);
const Widget verticalSpacer24 = SizedBox(height: 24.0);
const Widget verticalSpacer32 = SizedBox(height: 32.0);
const Widget verticalSpacer30 = SizedBox(height: 30.0);
const Widget verticalSpacer40 = SizedBox(height: 40.0);
const Widget verticalSpacer44 = SizedBox(height: 44.0);
const Widget verticalSpacer54 = SizedBox(height: 54.0);
const Widget verticalSpacer56 = SizedBox(height: 56.0);

const Widget horizontalSpacer8 = SizedBox(width: 8.0);
const Widget horizontalSpacer6 = SizedBox(width: 6.0);
const Widget horizontalSpacer10 = SizedBox(width: 10.0);
const Widget horizontalSpacer12 = SizedBox(width: 12.0);
const Widget horizontalSpacer14 = SizedBox(width: 14.0);
const Widget horizontalSpacer16 = SizedBox(width: 16.0);
const Widget horizontalSpacer20 = SizedBox(width: 20.0);

const EdgeInsets windowsCardPadding = EdgeInsets.all(8.0);
const EdgeInsets mobileCardPadding = EdgeInsets.all(6.0);

const Color linearGaugeLightThemeTrackColor = Color.fromARGB(
  255,
  218,
  218,
  218,
);
const Color linearGaugeDarkThemeTrackColor = Color.fromARGB(255, 217, 217, 217);
const Color progressRedColor = Color.fromRGBO(229, 57, 53, 1);
const Color progressOrangeColor = Color.fromRGBO(251, 140, 0, 1);
const Color progressGreenColor = Color.fromRGBO(67, 160, 71, 1);

List<String> buildBudgetColumnNames(BuildContext context) {
  return <String>['Name', 'Target Amount', 'Progress', 'Notes'];
}

List<Color> doughnutPalette(ThemeData themeData) {
  if (themeData.colorScheme.brightness == Brightness.light) {
    return const <Color>[
      Color.fromRGBO(6, 174, 224, 1),
      Color.fromRGBO(32, 81, 7, 1),
      Color.fromRGBO(99, 85, 199, 1),
      Color.fromRGBO(49, 90, 116, 1),
      Color.fromRGBO(255, 180, 0, 1),
      Color.fromRGBO(150, 60, 112, 1),
      Color.fromRGBO(33, 150, 245, 1),
      Color.fromRGBO(71, 59, 137, 1),
      Color.fromRGBO(219, 255, 216, 1),
      Color.fromRGBO(236, 92, 123, 1),
      Color.fromRGBO(236, 131, 23, 1),
    ];
  } else {
    return const <Color>[
      Color.fromRGBO(255, 245, 0, 1),
      Color.fromRGBO(59, 163, 26, 1),
      Color.fromRGBO(218, 150, 70, 1),
      Color.fromRGBO(201, 88, 142, 1),
      Color.fromRGBO(77, 170, 255, 1),
      Color.fromRGBO(255, 157, 69, 1),
      Color.fromRGBO(178, 243, 46, 1),
      Color.fromRGBO(185, 60, 228, 1),
      Color.fromRGBO(219, 255, 216, 1),
      Color.fromRGBO(207, 142, 14, 1),
    ];
  }
}

List<String> dateDuration = [
  'All',
  'Today',
  'Yesterday',
  'This Week',
  'This Month',
  'This Year',
];

const List<String> chartTimeFrames = [
  'This Month',
  'This Year',
  'Last Year',
  'Last 6 Month',
];

const IconData expenseTrackerIcon = IconData(
  0xe752,
  fontFamily: fontIconFamily,
);
IconData dashboardIcon = const IconData(0xe716, fontFamily: fontIconFamily);
IconData transactionIcon = const IconData(0xe738, fontFamily: fontIconFamily);
IconData budgetIcon = const IconData(0xe739, fontFamily: fontIconFamily);
IconData savingIcon = const IconData(0xe737, fontFamily: fontIconFamily);
IconData goalIcon = const IconData(0xe73a, fontFamily: fontIconFamily);
IconData settingIcon = const IconData(0xe717, fontFamily: fontIconFamily);

List<IconData> buildIconDataCollections(BuildContext context) {
  return <IconData>[
    if (!isMobile(context)) expenseTrackerIcon,
    dashboardIcon,
    transactionIcon,
    budgetIcon,
    savingIcon,
    goalIcon,
    settingIcon,
  ];
}

List<String> buildTransactionColumnNames(BuildContext context) {
  return <String>['Date', 'Name', 'Type', 'Amount', 'Remarks'];
}

List<String> buildNavigationPages(BuildContext context) {
  return <String>[
    if (!isMobile(context)) 'Expense Tracker',
    'Dashboard',
    'Transaction',
    'Budgets',
    'Savings',
    'Goals',
    'Settings',
  ];
}

List<String> buildGoalsColumnNames(BuildContext context) {
  return <String>['Name', 'Target Amount', 'Progress', 'Notes'];
}

List<String> buildSavingsColumnNames(BuildContext context) {
  return <String>[
    'Date',
    'Name',
    'Type',
    'Amount',
    // localizations.progress,
    'Notes',
  ];
}

List<String> buildBudgetSegmentedButtonNames() {
  return ['Active Budget', 'Completed Budget'];
}

const String screenCoverAssetPath = 'assets/screen_cover.png';
