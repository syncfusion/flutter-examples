import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../helper/currency_and_data_format/currency_format.dart';
import '../../helper/dashboard.dart';
import '../../helper/responsive_layout.dart';
import '../../models/goal.dart';
import '../../models/saving.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';
import '../../notifiers/dashboard_notifier.dart';
import '../../pages/dashboard.dart';
import 'dashboard_sections/active_goals.dart';
import 'dashboard_sections/common_finance_widget.dart';
import 'dashboard_sections/financial_overview.dart';
import 'dashboard_sections/recent_transaction.dart';
import 'layout_helper.dart';

enum DashboardLayoutSlot { dashboardWidget }

enum InsightBoxType { currentBalance, income, expense, savings }

enum DashboardWidgetType {
  financialOverview,
  accountBalance,
  recentTransaction,
  activeGoals,
  savingGrowth,
}

enum DashboardWidgetsSlot {
  currentBalance,
  income,
  expense,
  savings,
  financialOverviewWidget,
  accountBalanceChart,
  recentTransactionWidget,
  activeGoals,
  savingGrowth,
}

class OverallDetails extends StatelessWidget {
  const OverallDetails({
    required this.insightTitle,
    required this.insightValue,
    required this.iconData,
    required this.backgroundColor,
    required this.iconColor,
    super.key,
    this.isLast = false,
    this.isIconNeeded = true,
  });

  final String insightTitle;
  final String insightValue;
  final bool isLast;
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final bool isIconNeeded;

  TextStyle getTextStyle(BuildContext context, String insightTitle) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    if (isMobile(context)) {
      return textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.0,
      );
    } else if (insightTitle == 'Total Savings' ||
        insightTitle == 'This Month Saving') {
      return textTheme.titleMedium!.copyWith(
        fontWeight: kIsWeb ? FontWeight.w500 : FontWeight.w400,
        color: color,
        letterSpacing: 0.5,
      );
    } else {
      return textTheme.bodyLarge!.copyWith(
        fontWeight: kIsWeb ? FontWeight.w500 : FontWeight.w400,
        color: color,
        letterSpacing: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpenseCard(
      edgeInsets: EdgeInsets.symmetric(
        horizontal: isMobile(context) ? 12.0 : 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: <Widget>[
          if (isIconNeeded)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile(context) ? 16.0 : 20.0,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: backgroundColor,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isMobile(context) ? 6.0 : 10.0,
                      right: isMobile(context) ? 6.0 : 10.0,
                      bottom: isMobile(context) ? 6.0 : 8.0,
                      top: isMobile(context) ? 6.0 : 8.0,
                    ),
                    child: Icon(
                      iconData,
                      size: isMobile(context) ? 16.0 : 32.0,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile(context) ? 12.0 : 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      insightTitle,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(context, insightTitle),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      insightValue,
                      overflow: TextOverflow.ellipsis,
                      style: isMobile(context)
                          ? Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            )
                          : Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardLayout
    extends
        SlottedMultiChildRenderObjectWidget<DashboardLayoutSlot, RenderObject> {
  const DashboardLayout({
    required this.buildContext,
    required this.userDetails,
    required this.cardAvatarColors,
    required this.incomeDetails,
    required this.expenseDetails,
    required this.transactions,
    required this.goals,
    required this.savings,
    required this.accountBalanceController,
    required this.filteredTimeFrame,
    required this.filteredSavingTimeFrame,
    required this.title,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.totalExpense,
    required this.totalIncome,
    required this.totalSavings,
    super.key,
  });

  final BuildContext buildContext;
  final UserDetails userDetails;
  final List<Color>? cardAvatarColors;
  final List<IncomeDetails> incomeDetails;
  final List<ExpenseDetails> expenseDetails;
  final TextEditingController accountBalanceController;
  final TimeFrameNotifier filteredTimeFrame;
  final TimeFrameNotifier filteredSavingTimeFrame;

  final String title;
  final Map<String, List<ExpenseDetails>>? expenseCategories;
  final Map<String, List<IncomeDetails>>? incomeCategories;
  final List<Transaction> transactions;
  final List<Goal> goals;
  final List<Saving> savings;
  final double totalIncome;
  final double totalExpense;
  final double totalSavings;

  @override
  Widget? childForSlot(DashboardLayoutSlot slot) {
    switch (slot) {
      case DashboardLayoutSlot.dashboardWidget:
        {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: isMobile(buildContext)
                      ? const EdgeInsets.all(10.0)
                      : const EdgeInsets.all(16.0),
                  child: DashboardWidget(
                    buildContext: buildContext,
                    userDetails: userDetails,
                    cardAvatarColors: cardAvatarColors,
                    incomeDetails: incomeDetails,
                    expenseDetails: expenseDetails,
                    transactions: transactions,
                    goals: goals,
                    savings: savings,
                    accountBalanceController: accountBalanceController,
                    filteredTimeFrame: filteredTimeFrame,
                    filteredSavingTimeFrame: filteredSavingTimeFrame,
                    title: title,
                    expenseCategories: expenseCategories,
                    incomeCategories: incomeCategories,
                    totalIncome: totalIncome,
                    totalSavings: totalSavings,
                    totalExpense: totalExpense,
                  ),
                ),
              ],
            ),
          );
        }
    }
  }

  @override
  Iterable<DashboardLayoutSlot> get slots => DashboardLayoutSlot.values;

  @override
  SlottedContainerRenderObjectMixin<DashboardLayoutSlot, RenderObject>
  createRenderObject(BuildContext context) {
    return RenderDashboardLayout(context);
  }

  @override
  RenderDashboardLayout updateRenderObject(
    BuildContext context,
    covariant SlottedContainerRenderObjectMixin<
      DashboardLayoutSlot,
      RenderObject
    >
    renderObject,
  ) {
    return RenderDashboardLayout(context);
  }
}

class DashboardParentData extends ContainerBoxParentData<RenderBox> {}

class RenderDashboardLayout extends RenderBox
    with SlottedContainerRenderObjectMixin<DashboardLayoutSlot, RenderBox> {
  RenderDashboardLayout(this.buildContext);

  final BuildContext buildContext;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! DashboardParentData) {
      child.parentData = DashboardParentData();
    }

    super.setupParentData(child);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;

    // Iterate over children and check hit testing in reverse paint order

    visitChildren((RenderObject child) {
      final RenderBox renderBoxChild = child as RenderBox;
      final DashboardParentData parentData =
          child.parentData! as DashboardParentData;
      // Transform the position into the child's coordinate system
      final Offset childPosition = position - parentData.offset;
      // Perform hit testing for this child
      if (renderBoxChild.hitTest(result, position: childPosition)) {
        isHit = true;
      }
    });

    return isHit;
  }

  @override
  void performLayout() {
    final Size availableSize = constraints.biggest;

    final RenderBox? dashboardWidgetRenderBox = childForSlot(
      DashboardLayoutSlot.dashboardWidget,
    );

    if (dashboardWidgetRenderBox != null &&
        dashboardWidgetRenderBox.parentData != null) {
      dashboardWidgetRenderBox.layout(
        BoxConstraints.tight(Size(availableSize.width, availableSize.height)),
        parentUsesSize: true,
      );

      final DashboardParentData dashboardWidgetParentData =
          dashboardWidgetRenderBox.parentData! as DashboardParentData;

      dashboardWidgetParentData.offset = Offset.zero;
    }

    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? dashboardWidgetRenderBox = childForSlot(
      DashboardLayoutSlot.dashboardWidget,
    );

    if (dashboardWidgetRenderBox != null &&
        dashboardWidgetRenderBox.parentData != null) {
      final DashboardParentData dashboardWidgetParentData =
          dashboardWidgetRenderBox.parentData! as DashboardParentData;

      context.paintChild(
        dashboardWidgetRenderBox,
        offset + dashboardWidgetParentData.offset,
      );
    }
  }
}

class DashboardWidget
    extends
        SlottedMultiChildRenderObjectWidget<
          DashboardWidgetsSlot,
          RenderObject
        > {
  const DashboardWidget({
    required this.buildContext,
    required this.userDetails,
    required this.cardAvatarColors,
    required this.incomeDetails,
    required this.expenseDetails,
    required this.transactions,
    required this.goals,
    required this.savings,
    required this.accountBalanceController,
    required this.filteredTimeFrame,
    required this.filteredSavingTimeFrame,
    required this.title,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSavings,
    super.key,
  });

  final BuildContext buildContext;
  final UserDetails userDetails;
  final List<Color>? cardAvatarColors;
  final List<IncomeDetails> incomeDetails;
  final List<ExpenseDetails> expenseDetails;
  final List<Transaction> transactions;
  final List<Goal> goals;
  final List<Saving> savings;
  final TextEditingController accountBalanceController;
  final TimeFrameNotifier filteredTimeFrame;
  final TimeFrameNotifier filteredSavingTimeFrame;

  final String title;
  final double totalExpense;
  final double totalIncome;
  final double totalSavings;
  final Map<String, List<ExpenseDetails>>? expenseCategories;
  final Map<String, List<IncomeDetails>>? incomeCategories;

  @override
  Widget? childForSlot(DashboardWidgetsSlot slot) {
    switch (slot) {
      case DashboardWidgetsSlot.currentBalance:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: OverallDetails(
            insightTitle: 'Balance',
            insightValue: toCurrency(
              totalIncome - totalExpense,
              userDetails.userProfile,
            ),
            iconData: const IconData(0xe734, fontFamily: fontIconFamily),
            backgroundColor: const Color.fromRGBO(146, 21, 243, 0.1),
            iconColor: const Color.fromRGBO(146, 21, 243, 1),
          ),
        );
      case DashboardWidgetsSlot.income:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: OverallDetails(
            insightTitle: 'Income',
            insightValue: toCurrency(totalIncome, userDetails.userProfile),
            isLast: isMobile(buildContext) || isTablet(buildContext),
            iconData: const IconData(0xe735, fontFamily: fontIconFamily),
            backgroundColor: const Color.fromRGBO(0, 225, 144, 0.1),
            iconColor: const Color.fromRGBO(0, 225, 144, 1),
          ),
        );
      case DashboardWidgetsSlot.expense:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: OverallDetails(
            insightTitle: 'Expense',
            insightValue: toCurrency(totalExpense, userDetails.userProfile),
            iconData: const IconData(0xe736, fontFamily: fontIconFamily),
            backgroundColor: const Color.fromRGBO(255, 78, 78, 0.1),
            iconColor: const Color.fromRGBO(255, 78, 78, 1),
          ),
        );
      case DashboardWidgetsSlot.savings:
        {
          return Padding(
            padding: isMobile(buildContext)
                ? mobileCardPadding
                : windowsCardPadding,
            child: OverallDetails(
              insightTitle: 'Savings',
              insightValue: toCurrency(totalSavings, userDetails.userProfile),
              isLast: true,
              iconData: const IconData(0xe737, fontFamily: fontIconFamily),
              backgroundColor: const Color.fromRGBO(17, 109, 249, 0.1),
              iconColor: const Color.fromRGBO(17, 109, 249, 1),
            ),
          );
        }
      case DashboardWidgetsSlot.financialOverviewWidget:
        return ChangeNotifierProvider(
          create: (BuildContext context) => DashboardNotifier(),
          child: Padding(
            padding: isMobile(buildContext)
                ? mobileCardPadding
                : windowsCardPadding,
            child: FinancialOverview(
              userDetails: userDetails,
              incomeDetails: incomeDetails,
              expenseDetails: expenseDetails,
              controller: accountBalanceController,
            ),
          ),
        );
      case DashboardWidgetsSlot.recentTransactionWidget:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: RecentTransactions(
            userDetails: userDetails,
            transactionsCollection: transactions,
            expenseDetailCollections: expenseDetails,
            cardAvatarColors: cardAvatarColors,
          ),
        );
      case DashboardWidgetsSlot.accountBalanceChart:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: CommonFinanceWidget(
            userDetails: userDetails,
            incomeDetails: incomeDetails,
            expenseDetails: expenseDetails,
            controller: accountBalanceController,
            timeFrameNotifier: filteredTimeFrame,
            accountBalance: totalIncome - totalExpense,
            title: 'Account Overview',
          ),
        );
      case DashboardWidgetsSlot.activeGoals:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: ActiveGoals(
            userDetails: userDetails,
            goals: goals,
            cardAvatarColors: cardAvatarColors,
          ),
        );
      case DashboardWidgetsSlot.savingGrowth:
        return Padding(
          padding: isMobile(buildContext)
              ? mobileCardPadding
              : windowsCardPadding,
          child: CommonFinanceWidget(
            userDetails: userDetails,
            controller: accountBalanceController,
            timeFrameNotifier: filteredSavingTimeFrame,
            savings: savings,
            title: 'Saving Growth',
            showViewMore: true,
          ),
        );
    }
  }

  @override
  Iterable<DashboardWidgetsSlot> get slots => DashboardWidgetsSlot.values;

  @override
  SlottedContainerRenderObjectMixin<DashboardWidgetsSlot, RenderObject>
  createRenderObject(BuildContext context) {
    return RenderDashboardWidgetsLayout(context);
  }

  @override
  RenderDashboardWidgetsLayout updateRenderObject(
    BuildContext context,
    covariant SlottedContainerRenderObjectMixin<
      DashboardWidgetsSlot,
      RenderObject
    >
    renderObject,
  ) {
    return RenderDashboardWidgetsLayout(context);
  }
}

class DashboardWidgetParentData extends ContainerBoxParentData<RenderBox> {}

class RenderDashboardWidgetsLayout extends RenderBox
    with SlottedContainerRenderObjectMixin<DashboardWidgetsSlot, RenderBox> {
  RenderDashboardWidgetsLayout(this.buildContext);
  final BuildContext buildContext;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! DashboardWidgetParentData) {
      child.parentData = DashboardWidgetParentData();
    }
    super.setupParentData(child);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;

    // Iterate over children and check hit testing in reverse paint order
    visitChildren((RenderObject child) {
      final RenderBox renderBoxChild = child as RenderBox;
      final DashboardWidgetParentData parentData =
          child.parentData! as DashboardWidgetParentData;

      // Transform the position into the child's coordinate system
      final Offset childPosition = position - parentData.offset;

      // Perform hit testing for this child
      if (renderBoxChild.hitTest(result, position: childPosition)) {
        isHit = true;
      }
    });

    return isHit;
  }

  @override
  void performLayout() {
    final Size availableSize = constraints.biggest;
    final double commonInsightTileMinimumHeight = isMobile(buildContext)
        ? 76.0
        : 108.0;
    const double commonInsightWidthFactor = 0.25;
    const double commonInsightMobileWidthFactor = 0.5;
    final bool isMobileOrTablet =
        isMobile(buildContext) || isTablet(buildContext);

    final Size insightBoxSize = Size(
      isMobileOrTablet
          ? (availableSize.width * commonInsightMobileWidthFactor)
          : (availableSize.width * commonInsightWidthFactor),
      commonInsightTileMinimumHeight,
    );

    final Size dashboardWidgetBoxSize = Size(
      availableSize.width,
      MediaQuery.of(buildContext).size.height -
          (insightBoxSize.height + 24.0 + AppBar().preferredSize.height),
    );

    final RenderBox? currentBalanceRenderBox = childForSlot(
      DashboardWidgetsSlot.currentBalance,
    );
    layoutForInsight(
      currentBalanceRenderBox,
      buildContext,
      insightBoxSize,
      InsightBoxType.currentBalance,
    );

    final RenderBox? incomeRenderBox = childForSlot(
      DashboardWidgetsSlot.income,
    );
    layoutForInsight(
      incomeRenderBox,
      buildContext,
      insightBoxSize,
      InsightBoxType.income,
    );

    final RenderBox? expenseRenderBox = childForSlot(
      DashboardWidgetsSlot.expense,
    );
    layoutForInsight(
      expenseRenderBox,
      buildContext,
      insightBoxSize,
      InsightBoxType.expense,
    );

    final RenderBox? savingsRenderBox = childForSlot(
      DashboardWidgetsSlot.savings,
    );
    layoutForInsight(
      savingsRenderBox,
      buildContext,
      insightBoxSize,
      InsightBoxType.savings,
    );

    final RenderBox? financialOverviewBox = childForSlot(
      DashboardWidgetsSlot.financialOverviewWidget,
    );
    layoutForDashboardWidget(
      financialOverviewBox,
      buildContext,
      dashboardWidgetBoxSize,
      insightBoxSize,
      DashboardWidgetType.financialOverview,
    );

    final RenderBox? recentTransactionsBox = childForSlot(
      DashboardWidgetsSlot.recentTransactionWidget,
    );
    layoutForDashboardWidget(
      recentTransactionsBox,
      buildContext,
      dashboardWidgetBoxSize,
      insightBoxSize,
      DashboardWidgetType.recentTransaction,
    );

    final RenderBox? accountBalanceBox = childForSlot(
      DashboardWidgetsSlot.accountBalanceChart,
    );
    layoutForDashboardWidget(
      accountBalanceBox,
      buildContext,
      dashboardWidgetBoxSize,
      insightBoxSize,
      DashboardWidgetType.accountBalance,
    );

    final RenderBox? activeGoalsBox = childForSlot(
      DashboardWidgetsSlot.activeGoals,
    );
    layoutForDashboardWidget(
      activeGoalsBox,
      buildContext,
      dashboardWidgetBoxSize,
      insightBoxSize,
      DashboardWidgetType.activeGoals,
    );

    final RenderBox? savingGrowthChartBox = childForSlot(
      DashboardWidgetsSlot.savingGrowth,
    );
    layoutForDashboardWidget(
      savingGrowthChartBox,
      buildContext,
      dashboardWidgetBoxSize,
      insightBoxSize,
      DashboardWidgetType.savingGrowth,
    );

    final double height = _desiredHeight(
      insightBoxSize.height,
      dashboardWidgetBoxSize.height,
      isMobileOrTablet,
    );

    size = Size(constraints.maxWidth, height);
  }

  double _desiredHeight(
    double insightBoxHeight,
    double dashboardWidgetBoxHeight,
    bool isMobileOrTablet,
  ) {
    return isMobileOrTablet
        ? (2 * insightBoxHeight) + (5 * dashboardWidgetBoxHeight)
        : insightBoxHeight + (3 * dashboardWidgetBoxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? currentBalanceRenderBox = childForSlot(
      DashboardWidgetsSlot.currentBalance,
    );
    if (currentBalanceRenderBox != null &&
        currentBalanceRenderBox.parentData != null) {
      final DashboardWidgetParentData currentBalanceParentData =
          currentBalanceRenderBox.parentData! as DashboardWidgetParentData;
      context.paintChild(
        currentBalanceRenderBox,
        offset + currentBalanceParentData.offset,
      );
    }

    final RenderBox? incomeRenderBox = childForSlot(
      DashboardWidgetsSlot.income,
    );
    if (incomeRenderBox != null && incomeRenderBox.parentData != null) {
      final DashboardWidgetParentData incomeParentData =
          incomeRenderBox.parentData! as DashboardWidgetParentData;
      context.paintChild(incomeRenderBox, offset + incomeParentData.offset);
    }

    final RenderBox? expenseRenderBox = childForSlot(
      DashboardWidgetsSlot.expense,
    );
    if (expenseRenderBox != null && expenseRenderBox.parentData != null) {
      final DashboardWidgetParentData expenseParentData =
          expenseRenderBox.parentData! as DashboardWidgetParentData;
      context.paintChild(expenseRenderBox, offset + expenseParentData.offset);
    }

    final RenderBox? savingsRenderBox = childForSlot(
      DashboardWidgetsSlot.savings,
    );
    if (savingsRenderBox != null && savingsRenderBox.parentData != null) {
      final DashboardWidgetParentData savingsParentData =
          savingsRenderBox.parentData! as DashboardWidgetParentData;
      context.paintChild(savingsRenderBox, offset + savingsParentData.offset);
    }

    final RenderBox? financialOverviewBox = childForSlot(
      DashboardWidgetsSlot.financialOverviewWidget,
    );
    if (financialOverviewBox != null &&
        financialOverviewBox.parentData != null) {
      final DashboardWidgetParentData financialViewChartParentData =
          financialOverviewBox.parentData! as DashboardWidgetParentData;
      context.paintChild(
        financialOverviewBox,
        offset + financialViewChartParentData.offset,
      );
    }

    final RenderBox? accountBalChartBox = childForSlot(
      DashboardWidgetsSlot.accountBalanceChart,
    );
    if (accountBalChartBox != null && accountBalChartBox.parentData != null) {
      final DashboardWidgetParentData accountBalChartParentData =
          accountBalChartBox.parentData! as DashboardWidgetParentData;
      context.paintChild(
        accountBalChartBox,
        offset + accountBalChartParentData.offset,
      );
    }

    final RenderBox? recentTransactionsBox = childForSlot(
      DashboardWidgetsSlot.recentTransactionWidget,
    );
    if (recentTransactionsBox != null &&
        recentTransactionsBox.parentData != null) {
      final DashboardWidgetParentData recentTransactionsParentData =
          recentTransactionsBox.parentData! as DashboardWidgetParentData;
      context.paintChild(
        recentTransactionsBox,
        offset + recentTransactionsParentData.offset,
      );
    }

    final RenderBox? activeGoalsBox = childForSlot(
      DashboardWidgetsSlot.activeGoals,
    );
    if (activeGoalsBox != null && activeGoalsBox.parentData != null) {
      final DashboardWidgetParentData activeGoalsParentData =
          activeGoalsBox.parentData! as DashboardWidgetParentData;
      context.paintChild(activeGoalsBox, offset + activeGoalsParentData.offset);
    }

    final RenderBox? savingGrowthBox = childForSlot(
      DashboardWidgetsSlot.savingGrowth,
    );
    if (savingGrowthBox != null && savingGrowthBox.parentData != null) {
      final DashboardWidgetParentData savingGrowthParentData =
          savingGrowthBox.parentData! as DashboardWidgetParentData;
      context.paintChild(
        savingGrowthBox,
        offset + savingGrowthParentData.offset,
      );
    }
  }
}
