import 'package:flutter/material.dart';

import '../../helper/responsive_layout.dart';
import 'dashboard_layout.dart';

/// Arranges the layout of insight boxes based on their box type.
void layoutForInsight(
  RenderBox? renderBox,
  BuildContext buildContext,
  Size boxSize,
  InsightBoxType type,
) {
  if (renderBox != null && renderBox.parentData != null) {
    renderBox.layout(BoxConstraints.tight(boxSize), parentUsesSize: true);
    final DashboardWidgetParentData parentData =
        renderBox.parentData! as DashboardWidgetParentData;
    switch (type) {
      case InsightBoxType.currentBalance:
        parentData.offset = currentBalanceOffset(buildContext, boxSize);
        break;
      case InsightBoxType.income:
        parentData.offset = incomeOffset(buildContext, boxSize);
        break;
      case InsightBoxType.expense:
        parentData.offset = expenseOffset(buildContext, boxSize);
        break;
      case InsightBoxType.savings:
        parentData.offset = savingsOffset(buildContext, boxSize);
        break;
    }
  }
}

/// Calculates the offset for displaying the current balance insight box.
Offset currentBalanceOffset(BuildContext buildContext, Size boxSize) {
  return Offset.zero;
}

/// Calculates the offset for displaying the income insight box.
Offset incomeOffset(BuildContext buildContext, Size boxSize) {
  return Offset(boxSize.width, 0);
}

/// Determines the offset for displaying the expense insight box.
Offset expenseOffset(BuildContext buildContext, Size boxSize) {
  return isMobile(buildContext) || isTablet(buildContext)
      ? Offset(0, boxSize.height)
      : Offset(2 * boxSize.width, 0);
}

/// Determines the offset for displaying the savings insight box.
Offset savingsOffset(BuildContext buildContext, Size boxSize) {
  return isMobile(buildContext) || isTablet(buildContext)
      ? Offset(boxSize.width, boxSize.height)
      : Offset(3 * boxSize.width, 0);
}

/// Configures the layout for dashboard widgets based on widget type.
void layoutForDashboardWidget(
  RenderBox? renderBox,
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize,
  DashboardWidgetType type,
) {
  final bool isMobileOrTablet =
      isMobile(buildContext) || isTablet(buildContext);
  final Size dashboardBoxSize = dashboardWidgetBoxSize(
    buildContext,
    type,
    boxSize,
    isMobileOrTablet: isMobileOrTablet,
  );
  if (renderBox != null && renderBox.parentData != null) {
    renderBox.layout(
      BoxConstraints.tight(dashboardBoxSize),
      parentUsesSize: true,
    );
    final DashboardWidgetParentData parentData =
        renderBox.parentData! as DashboardWidgetParentData;
    switch (type) {
      case DashboardWidgetType.financialOverview:
        parentData.offset = financialOverviewOffset(
          buildContext,
          boxSize,
          insightBoxSize,
          isMobileOrTablet: isMobileOrTablet,
        );
      case DashboardWidgetType.recentTransaction:
        parentData.offset = recentTransactionsOffset(
          buildContext,
          boxSize,
          insightBoxSize,
          isMobileOrTablet: isMobileOrTablet,
        );
      case DashboardWidgetType.accountBalance:
        parentData.offset = accountBalanceOffset(
          buildContext,
          boxSize,
          insightBoxSize,
          isMobileOrTablet: isMobileOrTablet,
        );
      case DashboardWidgetType.activeGoals:
        parentData.offset = activeGoalsOffset(
          buildContext,
          boxSize,
          insightBoxSize,
          isMobileOrTablet: isMobileOrTablet,
        );
      case DashboardWidgetType.savingGrowth:
        parentData.offset = savingGrowthOffset(
          buildContext,
          boxSize,
          insightBoxSize,
          isMobileOrTablet: isMobileOrTablet,
        );
    }
  }
}

/// Calculates the box size for a specific dashboard widget type.
Size dashboardWidgetBoxSize(
  BuildContext buildContext,
  DashboardWidgetType type,
  Size boxSize, {
  required bool isMobileOrTablet,
}) {
  switch (type) {
    case DashboardWidgetType.financialOverview:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 0.65, boxSize.height);

    case DashboardWidgetType.accountBalance:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 1, boxSize.height);

    case DashboardWidgetType.recentTransaction:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 0.35, boxSize.height);

    case DashboardWidgetType.activeGoals:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 0.5, boxSize.height);

    case DashboardWidgetType.savingGrowth:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 0.5, boxSize.height);
  }
}

/// Calculates the offset for the financial overview widget.
Offset financialOverviewOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  // Calculates the card position based on the box size and insight box size.
  return isMobileOrTablet
      ? Offset(0, 2 * insightBoxSize.height)
      : Offset(0, insightBoxSize.height);
}

/// Calculates the offset for the recent transactions widget.
Offset recentTransactionsOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  // Calculates the card position based on the box size and insight box size.
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + boxSize.height)
      : Offset(boxSize.width * 0.65, insightBoxSize.height);
}

/// Calculates the offset for the account balance widget.
Offset accountBalanceOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  // Calculates the card position based on the box size and insight box size.
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + (2 * boxSize.height))
      : Offset(0, insightBoxSize.height + boxSize.height);
}

/// Calculates the offset for the active goals widget.
Offset activeGoalsOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  // Calculates the card position based on the box size and insight box size.
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + (3 * boxSize.height))
      : Offset(0, insightBoxSize.height + (2 * boxSize.height));
}

/// Calculates the offset for the saving growth widget.
Offset savingGrowthOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  // Calculates the card position based on the box size and insight box size.
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + (4 * boxSize.height))
      : Offset(
          boxSize.width * 0.5,
          insightBoxSize.height + (2 * boxSize.height),
        );
}
