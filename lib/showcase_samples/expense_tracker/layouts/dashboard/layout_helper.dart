import 'package:flutter/material.dart';

import '../../helper/responsive_layout.dart';
import 'dashboard_layout.dart';

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

Offset currentBalanceOffset(BuildContext buildContext, Size boxSize) {
  return Offset.zero;
}

Offset incomeOffset(BuildContext buildContext, Size boxSize) {
  return Offset(boxSize.width, 0);
}

Offset expenseOffset(BuildContext buildContext, Size boxSize) {
  return isMobile(buildContext) || isTablet(buildContext)
      ? Offset(0, boxSize.height)
      : Offset(2 * boxSize.width, 0);
}

Offset savingsOffset(BuildContext buildContext, Size boxSize) {
  return isMobile(buildContext) || isTablet(buildContext)
      ? Offset(boxSize.width, boxSize.height)
      : Offset(3 * boxSize.width, 0);
}

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
      // TODO(Hari): Need to implement goals page later.
      // case DashboardWidgetType.activeGoals:
      //   parentData.offset = activeGoalsOffset(
      //     buildContext,
      //     boxSize,
      //     insightBoxSize,
      //     isMobileOrTablet: isMobileOrTablet,
      //   );
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
          : Size(boxSize.width * 0.5, boxSize.height);

    case DashboardWidgetType.recentTransaction:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 0.35, boxSize.height);

    // case DashboardWidgetType.activeGoals:
    //   return isMobileOrTablet
    //       ? boxSize
    //       : Size(boxSize.width * 0.5, boxSize.height);

    case DashboardWidgetType.savingGrowth:
      return isMobileOrTablet
          ? boxSize
          : Size(boxSize.width * 0.5, boxSize.height);
  }
}

Offset financialOverviewOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  return isMobileOrTablet
      ? Offset(0, 2 * insightBoxSize.height)
      : Offset(0, insightBoxSize.height);
}

Offset recentTransactionsOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + boxSize.height)
      : Offset(boxSize.width * 0.65, insightBoxSize.height);
}

Offset accountBalanceOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + (2 * boxSize.height))
      : Offset(0, insightBoxSize.height + boxSize.height);
}

// Offset activeGoalsOffset(
//   BuildContext buildContext,
//   Size boxSize,
//   Size insightBoxSize, {
//   required bool isMobileOrTablet,
// }) {
//   return isMobileOrTablet
//       ? Offset(0, (2 * insightBoxSize.height) + (3 * boxSize.height))
//       : Offset(0, insightBoxSize.height + (2 * boxSize.height));
// }

Offset savingGrowthOffset(
  BuildContext buildContext,
  Size boxSize,
  Size insightBoxSize, {
  required bool isMobileOrTablet,
}) {
  return isMobileOrTablet
      ? Offset(0, (2 * insightBoxSize.height) + (3 * boxSize.height))
      : Offset(boxSize.width * 0.5, insightBoxSize.height + boxSize.height);
}
