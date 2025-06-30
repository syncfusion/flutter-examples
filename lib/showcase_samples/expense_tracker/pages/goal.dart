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
import '../data_processing/goal_handler.dart'
    if (dart.library.html) '../data_processing/goal_web_handler.dart';
import '../enum.dart';

import '../helper/common_helper.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/currency_and_data_format/date_format.dart';
import '../helper/dashboard.dart';
import '../helper/goals_center_dialog.dart';
import '../helper/responsive_layout.dart';

import '../helper/type_color.dart';
import '../layouts/dashboard/dashboard_layout.dart';
import '../models/goal.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../notifiers/goal_notifier.dart';
import '../notifiers/import_notifier.dart';
import '../notifiers/mobile_app_bar.dart';
import '../notifiers/text_field_valid_notifier.dart';
import '../notifiers/theme_notifier.dart';
import '../notifiers/view_notifier.dart';
import 'base_home.dart';

enum _GoalMenuOption {
  add,
  // view,
  edit,
  delete,
}

class GoalLayout extends StatefulWidget {
  const GoalLayout({required this.user, super.key});

  final UserDetails user;

  @override
  State<GoalLayout> createState() => _GoalLayoutState();
}

class _GoalLayoutState extends State<GoalLayout> {
  late List<String> _tabs;
  late String _selectedTab;
  List<Color>? _cardAvatarColors;

  Widget _buildInsightCards(BuildContext context, Size availableSize) {
    final List<Goal> goals = readGoals(widget.user);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 96,
        child: Row(
          children: [
            Expanded(
              child: OverallDetails(
                insightTitle: 'This Month Contribution',
                insightValue: _monthlyContributionAmount(goals),
                iconData: Icons.savings_outlined,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.primary,
                isIconNeeded: false,
              ),
            ),
            horizontalSpacer16,
            Expanded(
              child: OverallDetails(
                insightTitle: 'No Active Goals',
                insightValue: _activeGoalsCount(goals),
                iconData: Icons.savings_outlined,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.primary,
                isIconNeeded: false,
              ),
            ),
            horizontalSpacer16,
            Expanded(
              child: OverallDetails(
                insightTitle: 'No of Completed Goals',
                insightValue: _completedGoalsCount(goals),
                iconData: Icons.savings_outlined,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.primary,
                isIconNeeded: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthlyContributionAmount(List<Goal> goals) {
    final DateTime currentDate = DateTime.now();
    final double totalSaved = goals.fold<double>(0, (double sum, Goal goal) {
      final double thisMonthSavedAmount =
          goal.lastUpdated.month == currentDate.month ? goal.fund : 0;
      return sum + thisMonthSavedAmount;
    });
    return toCurrency(totalSaved, widget.user.userProfile);
  }

  String _activeGoalsCount(List<Goal> goals) {
    final int activeGoalsCount = goals
        .where((goal) => goal.fund < goal.amount)
        .length;
    return '$activeGoalsCount';
  }

  String _completedGoalsCount(List<Goal> goals) {
    final int completedGoalsCount = goals
        .where((goal) => goal.fund >= goal.amount)
        .length;
    return '$completedGoalsCount';
  }

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
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 14),
      child: SegmentedFilterButtons(
        options: _tabs,
        onSelectionChanged: (Set<String> selectedSegment) =>
            _handleSelectionChange(selectedSegment, notifier),
        selectedSegment: _selectedTab,
      ),
    );
  }

  void _handleSelectionChange(
    Set<String> selectedSegment,
    ViewNotifier notifier,
  ) {
    _selectedTab = selectedSegment.first;
    notifier.notifyActiveGoalsChange(isActive: _selectedTab == _tabs[1]);
  }

  Widget _buildWrapLayout(BuildContext context, BoxConstraints constraints) {
    final Size availableSize = constraints.biggest;
    final double cardWidthFactor = _calculateCardWidthFactor(availableSize);
    final double gapBetweenCards = _calculateGapBetweenCards(availableSize);

    return Consumer2<GoalNotifier, MobileAppBarUpdate>(
      builder:
          (
            BuildContext context,
            GoalNotifier goalNotifier,
            MobileAppBarUpdate mobileNotifier,
            Widget? child,
          ) {
            return _buildGoalsLayout(
              context,
              goalNotifier,
              mobileNotifier,
              availableSize,
              cardWidthFactor,
              gapBetweenCards,
            );
          },
    );
  }

  double _calculateCardWidthFactor(Size availableSize) {
    switch (deviceType(availableSize)) {
      case DeviceType.desktop:
        return 1 / 3;
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 0.5;
    }
  }

  double _calculateGapBetweenCards(Size availableSize) {
    const double spacing = 16;
    switch (deviceType(availableSize)) {
      case DeviceType.desktop:
        return spacing * 3;
      case DeviceType.mobile:
        return 0.0;
      case DeviceType.tablet:
        return spacing * 2;
    }
  }

  Widget _buildGoalsLayout(
    BuildContext context,
    GoalNotifier goalNotifier,
    MobileAppBarUpdate mobileNotifier,
    Size availableSize,
    double cardWidthFactor,
    double gapBetweenCards,
  ) {
    final List<Goal> visibleGoals = _visibleGoals(goalNotifier);
    final double availableWidthForChild = availableSize.width - gapBetweenCards;

    if (visibleGoals.isEmpty) {
      return buildNoRecordsFound(context);
    }
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
        child: Column(
          children: [
            _buildGoalsWrap(
              context,
              goalNotifier,
              mobileNotifier,
              visibleGoals,
              availableWidthForChild,
              cardWidthFactor,
            ),
            if (isMobile(context)) verticalSpacer16 else verticalSpacer24,
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsWrap(
    BuildContext context,
    GoalNotifier goalNotifier,
    MobileAppBarUpdate mobileNotifier,
    List<Goal> visibleGoals,
    double availableWidthForChild,
    double cardWidthFactor,
  ) {
    const double spacing = 16;
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(visibleGoals.length, (int index) {
          final List<Color> goalColors =
              _cardAvatarColors ?? doughnutPalette(Theme.of(context));
          final Goal goal = visibleGoals[index];
          return SizedBox(
            width: availableWidthForChild * cardWidthFactor,
            child: _GoalCard(
              notifier: goalNotifier,
              mobileNotifier: mobileNotifier,
              index: index,
              user: widget.user,
              goal: goal,
              color: goalColors[index % 10],
            ),
          );
        }),
      ),
    );
  }

  List<Goal> _visibleGoals(GoalNotifier goalNotifier) {
    final bool isCompleted = _selectedTab == _tabs[1];
    goalNotifier.goals = goalNotifier.isFirstTime
        ? widget.user.transactionalData.data.goals
        : goalNotifier.goals;
    final List<Goal> visibleGoals = <Goal>[];
    if (isCompleted) {
      for (final Goal goal in goalNotifier.goals) {
        if (goal.fund >= goal.amount) {
          goal.isCompleted = true;
          visibleGoals.add(goal);
        }
      }
    } else {
      for (final Goal goal in goalNotifier.goals) {
        if (goal.fund < goal.amount) {
          visibleGoals.add(goal);
        }
      }
    }
    goalNotifier.visibleGoals = visibleGoals;
    return visibleGoals;
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
    final Size availableSize = MediaQuery.of(context).size;
    return Consumer<ViewNotifier>(
      builder: (BuildContext context, ViewNotifier notifier, Widget? child) {
        return Padding(
          padding: isMobile(context)
              ? const EdgeInsets.only(left: 8, right: 8, top: 16)
              : const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            children: <Widget>[
              if (!isMobile(context))
                _buildInsightCards(context, availableSize),
              verticalSpacer24,
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

class _GoalCard extends StatefulWidget {
  const _GoalCard({
    required this.index,
    required this.user,
    required this.notifier,
    required this.mobileNotifier,
    required this.goal,
    required this.color,
  });

  final Goal goal;
  final Color color;
  final UserDetails user;
  final GoalNotifier notifier;
  final MobileAppBarUpdate mobileNotifier;
  final int index;

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard> {
  late TextTheme _textTheme;
  late ColorScheme _colorScheme;
  late TextStyle _titleMediumStyle;
  late TextStyle _bodyMediumStyle;
  late ImportNotifier _importNotifier;

  Widget _buildHeading() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: widget.color.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.user.userProfile.getIconForGoalCategory(
            widget.goal.category.toLowerCase(),
          ),
          color: widget.color,
        ),
      ),
      title: Text(
        widget.goal.name,
        style: _titleMediumStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          widget.goal.notes ?? '',
          style: _bodyMediumStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: _GoalMenu(
        notifier: widget.notifier,
        mobileNotifier: widget.mobileNotifier,
        user: widget.user,
        goal: widget.goal,
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
      widget.goal.fund,
      widget.user.userProfile,
    );
    final String target = toCurrency(
      widget.goal.amount,
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
            TypeColor(type: widget.goal.priority ?? 'Low'),
          ],
        ),
        verticalSpacer4,
        Row(
          children: <Widget>[
            Expanded(child: Text('Out of $target', style: _bodyMediumStyle)),
            Text('Priority', style: _bodyMediumStyle, textAlign: TextAlign.end),
          ],
        ),
      ],
    );
  }

  Widget _buildSpentAmount() {
    final double percent = (widget.goal.fund / widget.goal.amount) * 100;
    final String percentValue = NumberFormat('#.##').format(percent);

    final String date = formatDate(widget.goal.date, user: widget.user);
    final String remainingDays =
        widget.goal.date.difference(DateTime.now()).inDays.toString() +
        ' days left';
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Deadline', style: _bodyMediumStyle),
            Text(remainingDays, style: _bodyMediumStyle),
          ],
        ),
        verticalSpacer4,
        Row(
          children: <Widget>[
            Expanded(child: Text(date, style: _titleMediumStyle)),
            Text('$percentValue%', style: _titleMediumStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildProgress() {
    final double percent = (widget.goal.fund / widget.goal.amount) * 100;
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

class _GoalMenu extends StatefulWidget {
  const _GoalMenu({
    required this.goal,
    required this.notifier,
    required this.mobileNotifier,
    required this.user,
    required this.index,
    required this.importNotifier,
  });

  final Goal goal;
  final GoalNotifier notifier;
  final MobileAppBarUpdate mobileNotifier;
  final UserDetails user;
  final int index;
  final ImportNotifier importNotifier;

  @override
  State<_GoalMenu> createState() => _GoalMenuState();
}

class _GoalMenuState extends State<_GoalMenu> {
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  List<PopupMenuEntry<_GoalMenuOption>> get _buildMenuItems {
    return <PopupMenuEntry<_GoalMenuOption>>[
      if (!widget.goal.isCompleted)
        PopupMenuItem<_GoalMenuOption>(
          value: _GoalMenuOption.add,
          child: _buildMenuItem(Icons.add, 'Add Fund'),
        ),
      PopupMenuItem<_GoalMenuOption>(
        value: _GoalMenuOption.edit,
        child: _buildMenuItem(Icons.edit_outlined, 'Edit'),
      ),
      PopupMenuItem<_GoalMenuOption>(
        value: _GoalMenuOption.delete,
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

  void _handleMenuButtonSelected(_GoalMenuOption value) {
    if (isMobile(context)) {
      _handleMobileMenuSelection(value);
    } else {
      _showDesktopDialog(value);
    }
  }

  void _handleMobileMenuSelection(_GoalMenuOption value) {
    switch (value) {
      case _GoalMenuOption.delete:
        _showDeleteConfirmation();
        break;
      case _GoalMenuOption.add:
      case _GoalMenuOption.edit:
        _showMobileDialog(value);
        break;
    }
  }

  void _showMobileDialog(_GoalMenuOption value) {
    widget.mobileNotifier.currentMobileDialog = MobileDialogs.goals;
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return _buildMobileDialog(value);
      },
    );
  }

  void _showDesktopDialog(_GoalMenuOption value) {
    showDialog<StatefulBuilder>(
      context: context,
      builder: (BuildContext context) {
        return _buildDesktopDialog(value);
      },
    );
  }

  void _showDeleteConfirmation() {
    showMobileDeleteConfirmation(
      context,
      'Delete Goal',
      'Are you sure you want to delete this goal item?',
      () {
        widget.notifier.deleteGoal(widget.goal);
        // updateGoals(
        //   widget.user,
        //   widget.goal,
        //   UserInteractions.delete,
        //   index: widget.notifier.currentIndex,
        // );
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildMobileDialog(_GoalMenuOption value) {
    switch (value) {
      case _GoalMenuOption.add:
        return _createMobileDialog(
          UserInteractions.add,
          'Add Fund',
          'Add',
          true,
        );
      case _GoalMenuOption.edit:
        return _createMobileDialog(
          UserInteractions.edit,
          'Edit Goal',
          'Save',
          false,
        );
      case _GoalMenuOption.delete:
        return _DeleteGoal(
          goal: widget.goal,
          user: widget.user,
          notifier: widget.notifier,
        );
    }
  }

  Widget _buildDesktopDialog(_GoalMenuOption value) {
    switch (value) {
      case _GoalMenuOption.add:
        return _createDesktopDialog(false);
      case _GoalMenuOption.edit:
        return _createDesktopDialog(true);
      case _GoalMenuOption.delete:
        return _DeleteGoal(
          goal: widget.goal,
          user: widget.user,
          notifier: widget.notifier,
        );
    }
  }

  Widget _createMobileDialog(
    UserInteractions interaction,
    String title,
    String buttonText,
    bool isAddExpense,
  ) {
    return Consumer<TextButtonValidNotifier>(
      builder:
          (BuildContext context, TextButtonValidNotifier value, Widget? child) {
            return MobileCenterDialog(
              userInteraction: interaction,
              goalNotifier: widget.notifier,
              validateNotifier: value,
              currentMobileDialog: widget.mobileNotifier.currentMobileDialog,
              title: title,
              buttonText: buttonText,
              index: widget.index,
              isAddExpense: isAddExpense,
              userDetails: widget.user,
              onCancelPressed: () => _handleCancel(value),
              onPressed: () => _handleOnPressed(interaction, value),
            );
          },
    );
  }

  void _handleCancel(TextButtonValidNotifier value) {
    widget.mobileNotifier.openDialog(isDialogOpen: false);
    value.isTextButtonValid(false);
    Navigator.pop(context);
  }

  void _handleOnPressed(
    UserInteractions interaction,
    TextButtonValidNotifier value,
  ) {
    if (interaction == UserInteractions.add) {
      _addFund();
    } else {
      _editGoal();
    }

    _updateGoalState(interaction);
    value.isTextButtonValid(false);
    widget.mobileNotifier.openDialog(isDialogOpen: false);
    Navigator.pop(context);
  }

  void _addFund() {
    widget.notifier.addFund(
      widget.goal,
      parseCurrency(
        widget.notifier.goalTextFieldDetails!.amount.toString(),
        widget.user.userProfile,
      ),
    );
  }

  void _editGoal() {
    final GoalTextFieldDetails details = widget.notifier.goalTextFieldDetails!;
    final Goal goal = Goal(
      name: details.name,
      amount: details.amount,
      notes: details.remarks,
      date: details.date,
      priority: details.priority,
      category: details.category,
    );
    final Goal currentGoal = widget.notifier.visibleGoals[widget.index];
    goal.fund = currentGoal.fund;
    widget.notifier.editGoal(currentGoal, goal, widget.index);
  }

  void _updateGoalState(UserInteractions interaction) {
    // final int index = widget.notifier.currentIndex;
    // final Goal goal = widget.notifier.goals[index];
    if (interaction == UserInteractions.add) {
      // updateGoalFund(goal, index);
    } else if (interaction == UserInteractions.edit) {
      // updateGoals(widget.user, goal, UserInteractions.edit, index: index);
    }
  }

  Widget _createDesktopDialog(bool isEdit) {
    return Consumer<TextButtonValidNotifier>(
      builder:
          (BuildContext context, TextButtonValidNotifier value, Widget? child) {
            if (isEdit) {
              return GoalsCenterDialog(
                notifier: widget.notifier,
                validNotifier: value,
                userInteraction: UserInteractions.edit,
                userDetails: widget.user,
                selectedIndex: widget.index,
              );
            } else {
              return _AddOrEditFund(
                goal: widget.goal,
                notifier: widget.notifier,
                validNotifier: value,
                user: widget.user,
                isEdit: false,
              );
            }
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _colorScheme = themeData.colorScheme;
    _textTheme = themeData.textTheme;

    return Theme(
      data: ThemeData(hoverColor: _colorScheme.primaryContainer),
      child: PopupMenuButton<_GoalMenuOption>(
        position: PopupMenuPosition.under,
        iconSize: 18,
        tooltip: '',
        color: _colorScheme.surfaceContainerLow,
        icon: Icon(Icons.more_vert, color: _colorScheme.onSurfaceVariant),
        padding: EdgeInsets.zero,
        onSelected: _handleMenuButtonSelected,
        itemBuilder: (BuildContext context) => _buildMenuItems,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _AddOrEditFund extends StatefulWidget {
  const _AddOrEditFund({
    required this.goal,
    required this.user,
    required this.notifier,
    required this.validNotifier,
    required this.isEdit,
  });

  final Goal goal;
  final UserDetails user;
  final bool isEdit;
  final GoalNotifier notifier;
  final TextButtonValidNotifier validNotifier;

  @override
  State<_AddOrEditFund> createState() => _AddOrEditFundState();
}

class _AddOrEditFundState extends State<_AddOrEditFund> {
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  final TextEditingController _amountController = TextEditingController();

  Widget _buildDesktopContent() {
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          spacing: 16,
          children: <Widget>[
            Expanded(child: _buildCategory()),
            Expanded(child: _buildAmount()),
          ],
        ),
        Row(spacing: 16, children: <Widget>[Expanded(child: _buildDate())]),
        _buildRemarks(),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildCategory(),
        _buildAmount(),
        _buildDate(),
        _buildRemarks(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Add Fund',
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

  Widget _buildCategory() {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.goal.name;
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

  Widget _buildDate() {
    final TextEditingController controller = TextEditingController();
    controller.text = formatDate(widget.goal.date);
    return CustomTextField(
      controller: controller,
      focusNode: FocusNode(),
      hintText: 'Deadline',
      readOnly: true,
      canRequestFocus: false,
    );
  }

  Widget _buildRemarks() {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.goal.notes ?? '';
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

  Widget _buildContent(bool isDesktop, BuildContext context) {
    return SizedBox(
      width: 400,
      child: isDesktop ? _buildDesktopContent() : _buildMobileContent(),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return <Widget>[_buildCancelButton(context), _buildAddButton(context)];
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => _handleCancel(context),
      child: const Text('Cancel'),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return TextButton(
      onPressed: () => _handleAdd(context),
      child: Text(
        'Add',
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: !widget.validNotifier.isValid
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    widget.validNotifier.isTextButtonValid(false);
    Navigator.pop(context);
  }

  void _handleAdd(BuildContext context) {
    widget.notifier.addFund(
      widget.goal,
      parseCurrency(_amountController.text, widget.user.userProfile),
    );
    // final int index = widget.notifier.currentIndex;
    // final Goal goal = widget.notifier.goals[index];
    widget.validNotifier.isTextButtonValid(false);
    // updateGoalFund(goal, index);
    Navigator.pop(context);
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
            content: _buildContent(isDesktop, context),
            actions: _buildActionButtons(context),
          ),
        );
      },
    );
  }
}

class _DeleteGoal extends StatefulWidget {
  const _DeleteGoal({
    required this.goal,
    required this.user,
    required this.notifier,
  });

  final Goal goal;
  final UserDetails user;
  final GoalNotifier notifier;

  @override
  State<_DeleteGoal> createState() => _DeleteGoalState();
}

class _DeleteGoalState extends State<_DeleteGoal> {
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
          widget.notifier.deleteGoal(widget.goal);
          // updateGoals(
          //   widget.user,
          //   widget.goal,
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
            'Delete Goal',
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
        'Are you sure you want to delete this goal?',
        style: _textTheme.bodyLarge?.copyWith(color: _colorScheme.onSurface),
      ),
      actions: _buildActionButtons(context),
    );
  }
}

class GoalDataSource extends DataGridSource {
  GoalDataSource(
    this.context, {
    required this.goals,
    required this.transactions,
    required this.user,
  }) {
    _paginatedGoals = goals.getRange(0, goals.length).toList(growable: false);
    _buildPaginatedDataGridRows();
  }

  final BuildContext context;
  final UserDetails user;
  final List<Transaction> transactions;

  List<Goal> goals = <Goal>[];
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<Goal> _paginatedGoals = <Goal>[];

  @override
  List<DataGridRow> get rows => dataGridRows;

  void _buildPaginatedDataGridRows() {
    final List<String> columnNames = buildGoalsColumnNames(context);
    dataGridRows = List<DataGridRow>.generate(_paginatedGoals.length, (
      int index,
    ) {
      final Goal paginatedGoal = _paginatedGoals[index];
      final double currentGoalAmount = _transactionAmount(
        transactions,
        paginatedGoal,
      );

      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<String>(
            columnName: columnNames[0],
            value: paginatedGoal.name,
          ),
          DataGridCell<num>(
            columnName: columnNames[1],
            value: paginatedGoal.amount,
          ),
          DataGridCell<num>(
            columnName: columnNames[2],
            value: currentGoalAmount,
          ),
          DataGridCell<String>(
            columnName: columnNames[3],
            value: paginatedGoal.notes,
          ),
        ],
      );
    });
  }

  double _transactionAmount(List<Transaction> transactions, Goal goal) {
    double currentGoalAmount = 0;
    for (final Transaction transaction in transactions) {
      if (transaction.category.contains(goal.name) &&
          transaction.subCategory.contains(goal.notes ?? '')) {
        currentGoalAmount += transaction.amount;
      }
    }
    return currentGoalAmount;
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
              _buildGoalColor(decimalValue * 100),
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
    if (startIndex < goals.length) {
      if (endIndex > goals.length) {
        endIndex = goals.length;
      }
      _paginatedGoals = goals.getRange(startIndex, endIndex).toList();
    } else {
      _paginatedGoals = <Goal>[];
    }
    _buildPaginatedDataGridRows();
    notifyListeners();
    return true;
  }

  Color _buildGoalColor(double percent) {
    if (percent <= 50) {
      return progressGreenColor;
    } else if (percent >= 51 && percent <= 85) {
      return progressOrangeColor;
    } else {
      return progressRedColor;
    }
  }
}
