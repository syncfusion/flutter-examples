import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../constants.dart';
import '../custom_widgets/chip_and_drop_down_button.dart';

import '../data_processing/goal_handler.dart';
import '../enum.dart';

import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/currency_and_data_format/date_format.dart';
import '../helper/dashboard.dart';
import '../helper/goals_center_dialog.dart';
import '../helper/responsive_layout.dart';

import '../models/goal.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../notifiers/import_notifier.dart';
import '../notifiers/theme_notifier.dart';
import '../notifiers/view_notifier.dart';

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

  Widget _buildHeader(ViewNotifier notifier) {
    return isMobile(context)
        ? SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _buildSegmentedButtons(notifier),
        )
        : Row(children: [_buildSegmentedButtons(notifier)]);
  }

  SegmentedFilterButtons _buildSegmentedButtons(ViewNotifier notifier) {
    return SegmentedFilterButtons(
      options: _tabs,
      onSelectionChanged: (Set<String> selectedSegment) {
        _selectedTab = selectedSegment.first;
        notifier.notifyActiveGoalsChange(isActive: _selectedTab == _tabs[1]);
      },
      selectedSegment: _selectedTab,
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
        gapBetweenCards = spacing * 2;
      case DeviceType.mobile:
        cardWidthFactor = 1;
      case DeviceType.tablet:
        cardWidthFactor = 0.5;
        gapBetweenCards = spacing;
    }

    final List<Goal> visibleGoals = _visibleGoals();
    final double availableWidthForChild = availableSize.width - gapBetweenCards;
    return SingleChildScrollView(
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(visibleGoals.length, (int index) {
          final Goal goal = visibleGoals[index];
          return SizedBox(
            width: availableWidthForChild * cardWidthFactor,
            child: _GoalCard(
              index: index,
              user: widget.user,
              goal: goal,
              color: doughnutPalette(Theme.of(context))[index % 10],
            ),
          );
        }),
      ),
    );
  }

  List<Goal> _visibleGoals() {
    final bool isCompleted = _selectedTab == _tabs[1];
    final List<Goal> goals = readGoals(context, widget.user);
    final List<Goal> visibleGoals = <Goal>[];
    if (isCompleted) {
      for (final Goal goal in goals) {
        if (goal.savedAmount >= goal.targetAmount) {
          visibleGoals.add(goal);
        }
      }
    } else {
      for (final Goal goal in goals) {
        if (goal.savedAmount < goal.targetAmount) {
          visibleGoals.add(goal);
        }
      }
    }

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
    return Consumer<ViewNotifier>(
      builder: (BuildContext context, ViewNotifier notifier, Widget? child) {
        return Padding(
          padding: EdgeInsets.all(isMobile(context) ? 16.0 : 24.0),
          child: Column(
            children: <Widget>[
              _buildHeader(notifier),
              verticalSpacer16,
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
    super.dispose();
  }
}

class _GoalCard extends StatefulWidget {
  const _GoalCard({
    required this.index,
    required this.user,
    required this.goal,
    required this.color,
  });

  final Goal goal;
  final Color color;
  final UserDetails user;
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
        child: Text(
          widget.goal.name[0].toUpperCase(),
          style: _textTheme.titleLarge?.copyWith(color: widget.color),
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
        child: Text(widget.goal.notes ?? '', style: _bodyMediumStyle),
      ),
      trailing: _GoalMenu(
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
      widget.goal.targetAmount - widget.goal.savedAmount,
      widget.user.userProfile,
    );
    final String target = toCurrency(
      widget.goal.targetAmount,
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
              formatDate(widget.goal.targetDate, user: widget.user),
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
    final double amountSpent =
        widget.goal.targetAmount - widget.goal.savedAmount;
    final double percent =
        (widget.goal.savedAmount / widget.goal.targetAmount) * 100;
    final String percentValue = NumberFormat('#.##').format(percent);

    final String spent = toCurrency(amountSpent, widget.user.userProfile);
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
    final double percent =
        (widget.goal.savedAmount / widget.goal.targetAmount) * 100;
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
    required this.user,
    required this.index,
    required this.importNotifier,
  });

  final Goal goal;
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
      PopupMenuItem<_GoalMenuOption>(
        value: _GoalMenuOption.add,
        child: _buildMenuItem(Icons.add, 'Add expense'),
      ),
      // PopupMenuItem<_GoalMenuOption>(
      //   value: _GoalMenuOption.view,
      //   child: _buildMenuItem(Icons.remove_red_eye_outlined, 'View expense'),
      // ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    showDialog<StatefulBuilder>(
      context: context,
      builder: (BuildContext context) {
        switch (value) {
          case _GoalMenuOption.add:
            return _AddOrEditExpense(
              goal: widget.goal,
              user: widget.user,
              isEdit: false,
            );
          // case _GoalMenuOption.view:
          // break;
          case _GoalMenuOption.edit:
            return GoalsCenterDialog(
              userInteraction: UserInteractions.edit,
              userDetails: widget.user,
            );
          case _GoalMenuOption.delete:
            return _DeleteGoal(goal: widget.goal, user: widget.user);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _colorScheme = themeData.colorScheme;
    _textTheme = themeData.textTheme;

    return PopupMenuButton<_GoalMenuOption>(
      position: PopupMenuPosition.under,
      iconSize: 18,
      color: _colorScheme.surfaceContainerLow,
      icon: const Icon(Icons.more_vert),
      padding: EdgeInsets.zero,
      onSelected: _handleMenuButtonSelected,
      itemBuilder: (BuildContext context) {
        return _buildMenuItems;
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _AddOrEditExpense extends StatefulWidget {
  const _AddOrEditExpense({
    required this.goal,
    required this.user,
    required this.isEdit,
  });

  final Goal goal;
  final UserDetails user;
  final bool isEdit;

  @override
  State<_AddOrEditExpense> createState() => _AddOrEditExpenseState();
}

class _AddOrEditExpenseState extends State<_AddOrEditExpense> {
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  String? _selectedCategory;
  String? _selectedSubcategory;
  // ignore: unused_field
  String? _addedAmount;
  // ignore: unused_field
  String? _remarks;

  Widget _buildDesktopContent(BuildContext context, StateSetter setState) {
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          spacing: 16,
          children: <Widget>[
            Expanded(child: _buildCategory(setState)),
            Expanded(child: _buildSubcategory(setState)),
          ],
        ),
        Row(
          spacing: 16,
          children: <Widget>[
            Expanded(child: _buildAmount()),
            Expanded(child: _buildDate(context, setState)),
          ],
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
        _buildSubcategory(setState),
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
    return SizedBox(
      width: 208.0,
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        // TODO(VijayakumarM): Load categories based on the selected Goal.
        items: const <DropdownMenuItem<String>>[],
        onChanged: (String? value) {
          setState(() => _selectedCategory = value);
        },
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategory(StateSetter setState) {
    return DropdownButtonFormField<String>(
      value: _selectedSubcategory,
      // TODO(VijayakumarM): Load subcategories based on the selected category.
      items: const <DropdownMenuItem<String>>[],
      onChanged: (String? value) {
        setState(() => _selectedSubcategory = value);
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Subcategory',
      ),
    );
  }

  Widget _buildAmount() {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Amount',
      ),
      keyboardType: TextInputType.number,
      onChanged: (String value) => _addedAmount = value,
    );
  }

  Widget _buildDate(BuildContext context, StateSetter setState) {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Date',
        suffixIcon: Icon(Icons.calendar_month_outlined),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {}
      },
    );
  }

  Widget _buildRemarks() {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Remarks',
      ),
      maxLines: 3,
      onChanged: (String value) => _remarks = value,
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          // TODO(VijayakumarM): Add the expense to the database.
        },
        child: const Text('Add'),
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
            content:
                isDesktop
                    ? _buildDesktopContent(context, setState)
                    : _buildMobileContent(context, setState),
            actions: _buildActionButtons(context),
          ),
        );
      },
    );
  }
}

class _DeleteGoal extends StatefulWidget {
  const _DeleteGoal({required this.goal, required this.user});

  final Goal goal;
  final UserDetails user;

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
          Navigator.of(context).pop();
          // TODO(VijayakumarM): Add delete logic.
        },
        child: Text('Delete', style: actionButtonTextStyle),
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
      title: Text(
        'Delete Goal',
        style: _textTheme.headlineSmall?.copyWith(
          color: _colorScheme.onSurface,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this Goal?',
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
            value: paginatedGoal.targetAmount,
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
          color:
              themeNotifier.isDarkTheme
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
