import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../constants.dart';
import '../custom_widgets/chip_and_drop_down_button.dart';
import '../custom_widgets/text_field.dart';
// import '../data_processing/budget_handler.dart'
//     if (dart.library.html) '../data_processing/budget_web_handler.dart';
import '../enum.dart';
import '../helper/budgets_center_dialog.dart';
import '../helper/common_helper.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/currency_and_data_format/date_format.dart';
import '../helper/dashboard.dart';
import '../helper/responsive_layout.dart';
import '../models/budget.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../notifiers/budget_notifier.dart';
import '../notifiers/import_notifier.dart';
import '../notifiers/mobile_app_bar.dart';
import '../notifiers/text_field_valid_notifier.dart';
import '../notifiers/theme_notifier.dart';
import '../notifiers/view_notifier.dart';
import 'base_home.dart';

enum _BudgetMenuOption {
  add,
  // view,
  edit,
  delete,
}

class BudgetLayout extends StatefulWidget {
  const BudgetLayout({required this.user, super.key});

  final UserDetails user;

  @override
  State<BudgetLayout> createState() => _BudgetLayoutState();
}

class _BudgetLayoutState extends State<BudgetLayout> {
  late List<String> _tabs;
  late String _selectedTab;
  List<Color>? _cardAvatarColors;

  Widget _buildHeader(ViewNotifier notifier) {
    return isMobile(context)
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _buildSegmentedButtons(notifier),
          )
        : Row(children: [_buildSegmentedButtons(notifier)]);
  }

  Widget _buildSegmentedButtons(ViewNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 14),
      child: SegmentedFilterButtons(
        options: _tabs,
        onSelectionChanged: (Set<String> selectedSegment) {
          _selectedTab = selectedSegment.first;
          notifier.notifyBudgetVisibilityChange(
            isCompleted: _selectedTab == _tabs[1],
          );
        },
        selectedSegment: _selectedTab,
      ),
    );
  }

  Widget _buildWrapLayout(BuildContext context, BoxConstraints constraints) {
    final Size availableSize = constraints.biggest;
    double cardWidthFactor;
    double gapBetweenCards = 0.0;
    const double spacing = 16;

    switch (deviceType(availableSize)) {
      case DeviceType.desktop:
        cardWidthFactor = 1 / 3;
        gapBetweenCards = spacing * 3;
      case DeviceType.mobile:
        cardWidthFactor = 1;
      case DeviceType.tablet:
        cardWidthFactor = 0.5;
        gapBetweenCards = spacing * 2;
    }

    return Consumer2<BudgetNotifier, MobileAppBarUpdate>(
      builder:
          (
            BuildContext context,
            BudgetNotifier budgetNotifier,
            MobileAppBarUpdate mobileNotifier,
            Widget? child,
          ) {
            final List<Budget> visibleBudgets = _visibleBudgets(budgetNotifier);
            final double availableWidthForChild =
                availableSize.width - gapBetweenCards;

            // Check if no budgets are available
            if (visibleBudgets.isEmpty) {
              return buildNoRecordsFound(context);
            }
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: List.generate(visibleBudgets.length, (
                            int index,
                          ) {
                            final List<Color> goalColors =
                                _cardAvatarColors ??
                                doughnutPalette(Theme.of(context));
                            final Budget budget = visibleBudgets[index];
                            return SizedBox(
                              width: availableWidthForChild * cardWidthFactor,
                              child: _BudgetCard(
                                notifier: budgetNotifier,
                                mobileNotifier: mobileNotifier,
                                index: index,
                                user: widget.user,
                                budget: budget,
                                color: goalColors[index % 10],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    if (isMobile(context))
                      verticalSpacer16
                    else
                      verticalSpacer24,
                  ],
                ),
              ),
            );
          },
    );
  }

  List<Budget> _visibleBudgets(BudgetNotifier budgetNotifier) {
    final bool isCompleted = _selectedTab == _tabs[1];
    budgetNotifier.budgets = budgetNotifier.isFirstTime
        ? widget.user.transactionalData.data.budgets
        : budgetNotifier.budgets;
    final List<Budget> visibleBudgets = <Budget>[];
    if (isCompleted) {
      for (final Budget budget in budgetNotifier.budgets) {
        if (budget.expense >= budget.target) {
          budget.isCompleted = true;
          visibleBudgets.add(budget);
        }
      }
    } else {
      for (final Budget budget in budgetNotifier.budgets) {
        if (budget.expense < budget.target) {
          visibleBudgets.add(budget);
        }
      }
    }
    budgetNotifier.visibleBudgets = visibleBudgets;
    return visibleBudgets;
  }

  @override
  void initState() {
    _tabs = <String>['Active', 'Completed'];
    _selectedTab = _tabs[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cardAvatarColors ??= randomColors(context);
    return Consumer<ViewNotifier>(
      builder: (BuildContext context, ViewNotifier notifier, Widget? child) {
        return Padding(
          padding: isMobile(context)
              ? const EdgeInsets.only(left: 8, right: 8, top: 16)
              : const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            children: <Widget>[
              _buildHeader(notifier),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return _buildWrapLayout(context, constraints);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabs.clear();
    _cardAvatarColors?.clear();
    super.dispose();
  }
}

class _BudgetCard extends StatefulWidget {
  const _BudgetCard({
    required this.notifier,
    required this.mobileNotifier,
    required this.index,
    required this.user,
    required this.budget,
    required this.color,
  });

  final Budget budget;
  final BudgetNotifier notifier;
  final MobileAppBarUpdate mobileNotifier;
  final Color color;
  final UserDetails user;
  final int index;

  @override
  State<_BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<_BudgetCard> {
  late TextTheme _textTheme;
  late ColorScheme _colorScheme;
  late TextStyle _titleMediumStyle;
  late TextStyle _bodyMediumStyle;
  late ImportNotifier _importNotifier;

  Widget _buildHeading() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: widget.budget.name.isNotEmpty
          ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                widget.user.userProfile.getIconForCategory(
                  widget.budget.category.toLowerCase(),
                ),
                color: widget.color,
              ),
            )
          : null,
      title: Text(
        widget.budget.name,
        style: _titleMediumStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          widget.budget.notes ?? '',
          style: _bodyMediumStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: _BudgetMenu(
        user: widget.user,
        budget: widget.budget,
        notifier: widget.notifier,
        mobileNotifier: widget.mobileNotifier,
        index: widget.index,
        importNotifier: _importNotifier,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: _colorScheme.outlineVariant);
  }

  Widget _buildRemainingAmount() {
    final String remaining = toCurrency(
      widget.budget.target - widget.budget.expense,
      widget.user.userProfile,
    );
    final String target = toCurrency(
      widget.budget.target,
      widget.user.userProfile,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                remaining,
                style: _textTheme.titleLarge?.copyWith(
                  color: _colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              formatDate(widget.budget.createdDate, user: widget.user),
              style: _titleMediumStyle,
              textAlign: TextAlign.end,
            ),
          ],
        ),
        verticalSpacer4,
        Row(
          children: <Widget>[
            Expanded(
              child: Text('Remaining from $target', style: _bodyMediumStyle),
            ),
            Text(
              'Created on',
              style: _bodyMediumStyle,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpentAmount() {
    final double percent = (widget.budget.expense / widget.budget.target) * 100;
    final String percentValue = NumberFormat('#.##').format(percent);

    final String spent = toCurrency(
      widget.budget.expense,
      widget.user.userProfile,
    );
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Amount spent', style: _bodyMediumStyle),
            Text('Utilization', style: _bodyMediumStyle),
          ],
        ),
        verticalSpacer4,
        Row(
          children: <Widget>[
            Expanded(child: Text(spent, style: _titleMediumStyle)),
            Text('$percentValue%', style: _titleMediumStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildProgress() {
    final double percent = (widget.budget.expense / widget.budget.target) * 100;
    return SfLinearGauge(
      showTicks: false,
      showLabels: false,
      barPointers: <LinearBarPointer>[
        LinearBarPointer(
          value: percent,
          thickness: 12.0,
          color: widget.color,
          edgeStyle: LinearEdgeStyle.bothCurve,
          animationDuration: 0,
        ),
      ],
      axisTrackStyle: const LinearAxisTrackStyle(
        thickness: 12.0,
        edgeStyle: LinearEdgeStyle.bothCurve,
        color: Color(0xFFD9D9D9),
      ),
    );
  }

  // Widget _buildViewDetails() {
  //   return TextButton(
  //     onPressed: () {
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => BudgetDetailsPage(
  //       //       budget: widget.budget,
  //       //       userDetails: widget.userDetails,
  //       //     ),
  //       //   ),
  //       // );
  //     },
  //     style: TextButton.styleFrom(
  //       minimumSize: const Size(double.infinity, 44),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(22),
  //         side: BorderSide(color: _colorScheme.primary),
  //       ),
  //     ),
  //     child: Text(
  //       'View details',
  //       style: _textTheme.labelLarge?.copyWith(color: _colorScheme.primary),
  //     ),
  //   );
  // }

  @override
  void initState() {
    _importNotifier = Provider.of<ImportNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _importNotifier = Provider.of<ImportNotifier>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _textTheme = themeData.textTheme;
    _colorScheme = themeData.colorScheme;

    _titleMediumStyle = themeData.textTheme.titleMedium!.copyWith(
      color: _colorScheme.onSurface,
    );
    _bodyMediumStyle = themeData.textTheme.bodyMedium!.copyWith(
      color: _colorScheme.onSurfaceVariant,
    );

    return ExpenseCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeading(),
          _buildDivider(),
          verticalSpacer12,
          _buildRemainingAmount(),
          verticalSpacer16,
          _buildSpentAmount(),
          verticalSpacer8,
          _buildProgress(),
          verticalSpacer8,
          // verticalSpacer32,
          // _buildViewDetails(),
        ],
      ),
    );
  }
}

class _BudgetMenu extends StatefulWidget {
  const _BudgetMenu({
    required this.budget,
    required this.notifier,
    required this.mobileNotifier,
    required this.user,
    required this.index,
    required this.importNotifier,
  });

  final Budget budget;
  final BudgetNotifier notifier;
  final MobileAppBarUpdate mobileNotifier;
  final UserDetails user;
  final int index;
  final ImportNotifier importNotifier;

  @override
  State<_BudgetMenu> createState() => _BudgetMenuState();
}

class _BudgetMenuState extends State<_BudgetMenu> {
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  List<PopupMenuEntry<_BudgetMenuOption>> get _buildMenuItems {
    return <PopupMenuEntry<_BudgetMenuOption>>[
      if (!widget.budget.isCompleted)
        PopupMenuItem<_BudgetMenuOption>(
          value: _BudgetMenuOption.add,
          child: _buildMenuItem(Icons.add, 'Add Expense'),
        ),
      PopupMenuItem<_BudgetMenuOption>(
        value: _BudgetMenuOption.edit,
        child: _buildMenuItem(Icons.edit_outlined, 'Edit'),
      ),
      PopupMenuItem<_BudgetMenuOption>(
        value: _BudgetMenuOption.delete,
        child: _buildMenuItem(Icons.delete_outlined, 'Delete'),
      ),
    ];
  }

  Widget _buildMenuItem(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Icon(icon, color: _colorScheme.onSurfaceVariant),
          horizontalSpacer8,
          Text(
            value,
            style: _textTheme.bodyLarge?.copyWith(
              color: _colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuButtonSelected(_BudgetMenuOption value) {
    if (isMobile(context)) {
      if (value == _BudgetMenuOption.delete) {
        showMobileDeleteConfirmation(
          context,
          'Delete Budget',
          'Are you sure you want to delete this budget item?',
          () {
            widget.notifier.deleteBudget(widget.budget);
            // updateBudgets(
            //   widget.user,
            //   widget.budget,
            //   UserInteractions.delete,
            //   index: widget.notifier.currentIndex,
            // );
            Navigator.of(context).pop();
          },
        );
      } else {
        widget.mobileNotifier.currentMobileDialog = MobileDialogs.budgets;
        showDialog<Widget>(
          context: context,
          builder: (BuildContext context) {
            switch (value) {
              case _BudgetMenuOption.add:
                return Consumer<TextButtonValidNotifier>(
                  builder:
                      (
                        BuildContext context,
                        TextButtonValidNotifier value,
                        Widget? child,
                      ) {
                        return MobileCenterDialog(
                          userInteraction: UserInteractions.add,
                          budgetNotifier: widget.notifier,
                          validateNotifier: value,
                          currentMobileDialog:
                              widget.mobileNotifier.currentMobileDialog,
                          title: 'Add Expense',
                          buttonText: 'Add',
                          index: widget.index,
                          isAddExpense: true,
                          userDetails: widget.user,
                          onCancelPressed: () {
                            widget.mobileNotifier.openDialog(
                              isDialogOpen: false,
                            );
                            value.isTextButtonValid(false);
                            Navigator.pop(context);
                          },
                          onPressed: () {
                            widget.notifier.addExpense(
                              widget.budget,
                              parseCurrency(
                                widget.notifier.budgetTextFieldDetails!.amount
                                    .toString(),
                                widget.user.userProfile,
                              ),
                            );
                            // final int index = widget.notifier.currentIndex;
                            // final Budget budget =
                            //     widget.notifier.budgets[index];
                            // updateBudgetExpense(budget, index);
                            value.isTextButtonValid(false);
                            widget.mobileNotifier.openDialog(
                              isDialogOpen: false,
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                );
              case _BudgetMenuOption.edit:
                return Consumer<TextButtonValidNotifier>(
                  builder:
                      (
                        BuildContext context,
                        TextButtonValidNotifier value,
                        Widget? child,
                      ) {
                        return MobileCenterDialog(
                          userInteraction: UserInteractions.edit,
                          budgetNotifier: widget.notifier,
                          validateNotifier: value,
                          currentMobileDialog:
                              widget.mobileNotifier.currentMobileDialog,
                          title: 'Edit Budget',
                          buttonText: 'Save',
                          index: widget.index,
                          userDetails: widget.user,
                          onCancelPressed: () {
                            widget.mobileNotifier.openDialog(
                              isDialogOpen: false,
                            );
                            value.isTextButtonValid(false);
                            Navigator.pop(context);
                          },
                          onPressed: () {
                            final BudgetTextFieldDetails details =
                                widget.notifier.budgetTextFieldDetails!;
                            final Budget budget = Budget(
                              name: details.name,
                              target: details.amount,
                              notes: details.remarks,
                              expense: 0,
                              createdDate: details.date,
                              category: details.category,
                            );
                            final Budget currentBudget =
                                widget.notifier.visibleBudgets[widget.index];
                            budget.expense = currentBudget.expense;
                            widget.notifier.editBudget(
                              currentBudget,
                              budget,
                              widget.index,
                            );
                            // updateBudgets(
                            //   widget.user,
                            //   budget,
                            //   UserInteractions.edit,
                            //   index: widget.notifier.currentIndex,
                            // );
                            widget.mobileNotifier.openDialog(
                              isDialogOpen: false,
                            );
                            value.isTextButtonValid(false);
                            Navigator.pop(context);
                          },
                        );
                      },
                );
              case _BudgetMenuOption.delete:
                return _DeleteBudget(
                  budget: widget.budget,
                  user: widget.user,
                  notifier: widget.notifier,
                );
            }
          },
        );
      }
    } else {
      showDialog<StatefulBuilder>(
        context: context,
        builder: (BuildContext context) {
          switch (value) {
            case _BudgetMenuOption.add:
              return Consumer<TextButtonValidNotifier>(
                builder:
                    (
                      BuildContext context,
                      TextButtonValidNotifier value,
                      Widget? child,
                    ) {
                      return _AddOrEditExpense(
                        budget: widget.budget,
                        notifier: widget.notifier,
                        validNotifier: value,
                        user: widget.user,
                        isEdit: false,
                      );
                    },
              );
            // case _BudgetMenuOption.view:
            // break;
            case _BudgetMenuOption.edit:
              return Consumer<TextButtonValidNotifier>(
                builder:
                    (
                      BuildContext context,
                      TextButtonValidNotifier value,
                      Widget? child,
                    ) {
                      return BudgetsCenterDialog(
                        notifier: widget.notifier,
                        validNotifier: value,
                        userInteraction: UserInteractions.edit,
                        userDetails: widget.user,
                        selectedIndex: widget.index,
                      );
                    },
              );
            case _BudgetMenuOption.delete:
              return _DeleteBudget(
                budget: widget.budget,
                user: widget.user,
                notifier: widget.notifier,
              );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _colorScheme = themeData.colorScheme;
    _textTheme = themeData.textTheme;

    return Theme(
      data: ThemeData(hoverColor: _colorScheme.primaryContainer),
      child: PopupMenuButton<_BudgetMenuOption>(
        position: PopupMenuPosition.under,
        iconSize: 18,
        tooltip: '',
        color: _colorScheme.surfaceContainerLow,
        icon: Icon(Icons.more_vert, color: _colorScheme.onSurfaceVariant),
        padding: EdgeInsets.zero,
        onSelected: _handleMenuButtonSelected,
        itemBuilder: (BuildContext context) {
          return _buildMenuItems;
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _AddOrEditExpense extends StatefulWidget {
  const _AddOrEditExpense({
    required this.budget,
    required this.user,
    required this.notifier,
    required this.validNotifier,
    required this.isEdit,
  });

  final Budget budget;
  final UserDetails user;
  final bool isEdit;
  final BudgetNotifier notifier;
  final TextButtonValidNotifier validNotifier;

  @override
  State<_AddOrEditExpense> createState() => _AddOrEditExpenseState();
}

class _AddOrEditExpenseState extends State<_AddOrEditExpense> {
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  final TextEditingController _amountController = TextEditingController();

  Widget _buildDesktopContent(BuildContext context, StateSetter setState) {
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          spacing: 16,
          children: <Widget>[
            Expanded(child: _buildCategory(setState)),
            Expanded(child: _buildAmount()),
          ],
        ),
        Row(
          spacing: 16,
          children: <Widget>[Expanded(child: _buildDate(context, setState))],
        ),
        _buildRemarks(),
      ],
    );
  }

  Widget _buildMobileContent(BuildContext context, StateSetter setState) {
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildCategory(setState),
        _buildAmount(),
        _buildDate(context, setState),
        _buildRemarks(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Add Expense',
          style: _textTheme.headlineSmall?.copyWith(
            color: _colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: _colorScheme.onSurfaceVariant,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCategory(StateSetter setState) {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.budget.name;
    return CustomTextField(
      controller: controller,
      focusNode: FocusNode(),
      hintText: 'Title',
      readOnly: true,
      canRequestFocus: false,
    );
  }

  Widget _buildAmount() {
    return CustomTextField(
      controller: _amountController,
      hintText: 'Add Amount',
      focusNode: FocusNode(),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
      ],
      onChanged: (String value) {
        final bool valid = _validateForm();
        widget.validNotifier.isTextButtonValid(valid);
      },
    );
  }

  Widget _buildDate(BuildContext context, StateSetter setState) {
    final TextEditingController controller = TextEditingController();
    controller.text = formatDate(widget.budget.createdDate);
    return CustomTextField(
      controller: controller,
      focusNode: FocusNode(),
      hintText: 'Date',
      readOnly: true,
      canRequestFocus: false,
    );
  }

  Widget _buildRemarks() {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.budget.notes ?? '';
    return CustomTextField(
      controller: controller,
      focusNode: FocusNode(),
      hintText: 'Remarks',
      maxLines: 4,
      readOnly: true,
      canRequestFocus: false,
    );
  }

  bool _validateForm() {
    return _amountController.text.isNotEmpty;
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () {
          widget.validNotifier.isTextButtonValid(false);
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          widget.notifier.addExpense(
            widget.budget,
            parseCurrency(_amountController.text, widget.user.userProfile),
          );
          // final int index = widget.notifier.currentIndex;
          // final Budget budget = widget.notifier.budgets[index];
          widget.validNotifier.isTextButtonValid(false);
          // updateBudgetExpense(budget, index);
          Navigator.pop(context);
        },
        child: Text(
          'Add',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: !widget.validNotifier.isValid
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _colorScheme = themeData.colorScheme;
    _textTheme = themeData.textTheme;

    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = deviceType(size) == DeviceType.desktop;

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurStyle: BlurStyle.outer,
                color: Color(0xff00004D),
                offset: Offset(0, 2),
                blurRadius: 3.0,
              ),
              BoxShadow(
                blurStyle: BlurStyle.outer,
                color: Color(0xff000026),
                offset: Offset(0, 6),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: AlertDialog(
            scrollable: true,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            surfaceTintColor: themeData.colorScheme.primary,
            backgroundColor: themeData.colorScheme.surface,
            titlePadding: const EdgeInsets.all(24),
            contentPadding: const EdgeInsetsDirectional.only(
              start: 24,
              top: 16,
              end: 24,
              bottom: 24,
            ),
            actionsPadding: const EdgeInsets.all(24),
            title: _buildHeader(context),
            content: SizedBox(
              width: 400,
              child: isDesktop
                  ? _buildDesktopContent(context, setState)
                  : _buildMobileContent(context, setState),
            ),
            actions: _buildActionButtons(context),
          ),
        );
      },
    );
  }
}

class _DeleteBudget extends StatefulWidget {
  const _DeleteBudget({
    required this.budget,
    required this.user,
    required this.notifier,
  });

  final Budget budget;
  final UserDetails user;
  final BudgetNotifier notifier;

  @override
  State<_DeleteBudget> createState() => _DeleteBudgetState();
}

class _DeleteBudgetState extends State<_DeleteBudget> {
  late TextTheme _textTheme;
  late ColorScheme _colorScheme;

  List<Widget> _buildActionButtons(BuildContext context) {
    final ButtonStyle actionButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    );
    final TextStyle? actionButtonTextStyle = _textTheme.labelLarge?.copyWith(
      color: _colorScheme.primary,
    );
    return <Widget>[
      TextButton(
        style: actionButtonStyle,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel', style: actionButtonTextStyle),
      ),
      TextButton(
        style: actionButtonStyle,
        onPressed: () {
          widget.notifier.deleteBudget(widget.budget);
          // updateBudgets(
          //   widget.user,
          //   widget.budget,
          //   UserInteractions.delete,
          //   index: widget.notifier.currentIndex,
          // );
          Navigator.of(context).pop();
        },
        child: Text(
          'Delete',
          style: _textTheme.labelLarge?.copyWith(color: _colorScheme.error),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _colorScheme = themeData.colorScheme;
    _textTheme = themeData.textTheme;
    return AlertDialog(
      titlePadding: const EdgeInsets.all(24),
      contentPadding: const EdgeInsetsDirectional.only(
        start: 24,
        top: 16,
        end: 24,
        bottom: 16,
      ),
      actionsPadding: const EdgeInsets.all(24),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete Budget',
            style: _textTheme.headlineSmall?.copyWith(
              color: _colorScheme.onSurface,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: IconButton(
              icon: const Icon(
                IconData(0xe721, fontFamily: fontIconFamily),
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to delete this budget?',
        style: _textTheme.bodyLarge?.copyWith(color: _colorScheme.onSurface),
      ),
      actions: _buildActionButtons(context),
    );
  }
}

class BudgetDataSource extends DataGridSource {
  BudgetDataSource(
    this.context, {
    required this.budgets,
    required this.transactions,
    required this.user,
  }) {
    _paginatedBudgets = budgets
        .getRange(0, budgets.length)
        .toList(growable: false);
    _buildPaginatedDataGridRows();
  }

  final BuildContext context;
  final UserDetails user;
  final List<Transaction> transactions;

  List<Budget> budgets = <Budget>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<Budget> _paginatedBudgets = <Budget>[];

  @override
  List<DataGridRow> get rows => dataGridRows;

  void _buildPaginatedDataGridRows() {
    final List<String> columnNames = buildBudgetColumnNames(context);
    dataGridRows = List<DataGridRow>.generate(_paginatedBudgets.length, (
      int index,
    ) {
      final Budget paginatedBudget = _paginatedBudgets[index];
      final double currentBudgetAmount = _transactionAmount(
        transactions,
        paginatedBudget,
      );

      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<String>(
            columnName: columnNames[0],
            value: paginatedBudget.name,
          ),
          DataGridCell<num>(
            columnName: columnNames[1],
            value: paginatedBudget.target,
          ),
          DataGridCell<num>(
            columnName: columnNames[2],
            value: currentBudgetAmount,
          ),
          DataGridCell<String>(
            columnName: columnNames[3],
            value: paginatedBudget.notes,
          ),
        ],
      );
    });
  }

  double _transactionAmount(List<Transaction> transactions, Budget budget) {
    double currentBudgetAmount = 0;
    for (final Transaction transaction in transactions) {
      if (transaction.category.contains(budget.name) &&
          transaction.subCategory.contains(budget.notes ?? '')) {
        currentBudgetAmount += transaction.amount;
      }
    }
    return currentBudgetAmount;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final List<DataGridCell<dynamic>> cellCollections = row.getCells();
    final ThemeData theme = Theme.of(context);
    return DataGridRowAdapter(
      cells: List.generate(cellCollections.length, (int index) {
        if (index == 0) {
          return Container(
            padding: const EdgeInsets.only(left: 30.0),
            alignment: Alignment.centerLeft,
            child: Text(
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface,
              ),
              row.getCells()[index].value.toString(),
            ),
          );
        }
        if (index == 1) {
          return Container(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface,
              ),
              toCurrency(row.getCells()[index].value, user.userProfile),
            ),
          );
        }
        if (index == 2) {
          final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(
            context,
            listen: false,
          );
          final double decimalValue = 2000 / cellCollections[1].value;
          return SizedBox(
            height: 12.0,
            child: _buildLinearGauge(
              decimalValue * 100,
              _buildBudgetColor(decimalValue * 100),
              themeNotifier,
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
            row.getCells()[index].value.toString(),
          ),
        );
      }),
    );
  }

  Widget _buildLinearGauge(
    double percent,
    Color financialColor,
    ThemeNotifier themeNotifier,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SfLinearGauge(
        showLabels: false,
        showTicks: false,
        barPointers: <LinearBarPointer>[
          LinearBarPointer(
            value: percent,
            color: financialColor,
            edgeStyle: LinearEdgeStyle.bothCurve,
            animationDuration: 0,
          ),
        ],
        axisTrackStyle: LinearAxisTrackStyle(
          edgeStyle: LinearEdgeStyle.bothCurve,
          color: themeNotifier.isDarkTheme
              ? linearGaugeDarkThemeTrackColor
              : linearGaugeLightThemeTrackColor,
        ),
      ),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < budgets.length) {
      if (endIndex > budgets.length) {
        endIndex = budgets.length;
      }
      _paginatedBudgets = budgets.getRange(startIndex, endIndex).toList();
    } else {
      _paginatedBudgets = <Budget>[];
    }
    _buildPaginatedDataGridRows();
    notifyListeners();
    return true;
  }

  Color _buildBudgetColor(double percent) {
    if (percent <= 50) {
      return progressGreenColor;
    } else if (percent >= 51 && percent <= 85) {
      return progressOrangeColor;
    } else {
      return progressRedColor;
    }
  }
}
