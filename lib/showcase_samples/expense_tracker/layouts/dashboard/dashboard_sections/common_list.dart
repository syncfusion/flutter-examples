import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../stock_analysis/helper/helper.dart';
import '../../../constants.dart';
import '../../../helper/common_helper.dart';
import '../../../helper/currency_and_data_format/currency_format.dart';
import '../../../helper/dashboard.dart';
import '../../../helper/responsive_layout.dart';
import '../../../helper/view_more.dart';
import '../../../models/goal.dart';
import '../../../models/transaction.dart';
import '../../../models/user.dart';
import '../../../models/user_profile.dart';
import '../../../pages/base_home.dart';

class CommonList extends StatelessWidget {
  const CommonList({
    required this.headerText,
    required this.subHeaderText,
    required this.userDetails,
    required this.isActiveGoals,
    required this.collections,
    this.cardAvatarColors,
    super.key,
  });

  final List<Color>? cardAvatarColors;
  final String headerText;
  final String subHeaderText;
  final UserDetails userDetails;
  final bool isActiveGoals;
  final List<dynamic> collections;

  Widget _buildListViews(
    BuildContext context, {
    required int index,
    required String type,
    dynamic dataModel,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      spacing: 8.0,
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: <Widget>[
              if (collections.isNotEmpty)
                _buildCircleAvatar(
                  context,
                  index,
                  isActiveGoals
                      ? (dataModel as Goal).category
                      : (dataModel as Transaction).category,
                  textTheme,
                  colorScheme,
                ),
              if (collections.isNotEmpty)
                Flexible(
                  child: _buildHeaderAndSubHeader(
                    context,
                    isActiveGoals
                        ? (dataModel as Goal).name.capitalizeFirst()
                        : (dataModel as Transaction).category.capitalizeFirst(),
                    textTheme,
                    colorScheme,
                    isActiveGoals
                        ? (dataModel as Goal).notes?.capitalizeFirst() ?? ''
                        : (dataModel as Transaction).subCategory
                              .capitalizeFirst(),
                  ),
                ),
            ],
          ),
        ),
        _buildDateAndAmountValue(
          context,
          index,
          dataModel,
          textTheme,
          type,
          colorScheme,
        ),
      ],
    );
  }

  Column _buildDateAndAmountValue(
    BuildContext context,
    int index,
    dynamic dataModel,
    TextTheme textTheme,
    String type,
    ColorScheme colorScheme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (collections.isNotEmpty)
          _buildCurrencyValue(
            context,
            isActiveGoals
                ? (dataModel as Goal).fund
                : (dataModel as Transaction).amount,
            textTheme,
            colorScheme,
            type,
          ),
        _buildRightSubText(dataModel, index, textTheme, colorScheme),
      ],
    );
  }

  Text _buildRightSubText(
    dynamic dataModel,
    int index,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Text(
      isActiveGoals
          ? 'Out of ${toCurrency((dataModel as Goal).amount, userDetails.userProfile)}'
          : _buildDateString(
              (dataModel as Transaction).transactionDate,
              DateFormat(userDetails.userProfile.dateFormat),
            ),
      textAlign: TextAlign.right,
      style: textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  String _buildDateString(DateTime date, DateFormat dateFormat) {
    final int daysDifference = date.difference(DateTime.now()).inDays;
    if (daysDifference > 1 || daysDifference < -1) {
      return dateFormat.format(date);
    } else {
      return daysDifference == 1
          ? 'Tomorrow'
          : daysDifference == 0
          ? 'Today'
          : 'Yesterday';
    }
  }

  Text _buildCurrencyValue(
    BuildContext context,
    double amount,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String type,
  ) {
    return Text(
      (isActiveGoals
              ? ''
              : type == 'Income'
              ? '+'
              : '-') +
          toCurrency(amount, userDetails.userProfile),
      textAlign: TextAlign.right,
      style: textTheme.bodyLarge!.copyWith(
        fontFamily: 'Roboto',
        color: isActiveGoals
            ? colorScheme.onSurface
            : type == 'Income'
            ? doughnutPalette(Theme.of(context))[1]
            : const Color.fromRGBO(179, 38, 30, 1),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildHeaderAndSubHeader(
    BuildContext context,
    String category,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String subCategory,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: _buildHeaderText(context, category, textTheme, colorScheme),
        ),
        Flexible(
          child: _buildSubHeaderText(subCategory, textTheme, colorScheme),
        ),
      ],
    );
  }

  Text _buildSubHeaderText(
    String subCategory,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Text(
      subCategory,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Text _buildHeaderText(
    BuildContext context,
    String category,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Text(
      category,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyLarge!.copyWith(
        fontWeight: isMobile(context) ? FontWeight.w400 : FontWeight.w500,
        color: colorScheme.onSurface,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCircleAvatar(
    BuildContext context,
    int index,
    String category,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final Color color =
        (cardAvatarColors ?? doughnutPalette(Theme.of(context)))[index % 10];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: isActiveGoals
          ? SizedBox(
              width: 36.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: _buildIcon(category, color),
                ),
              ),
            )
          : CircleAvatar(
              radius: 16,
              backgroundColor: color.withAlpha(25),
              child: _buildIcon(category, color),
            ),
    );
  }

  Icon _buildIcon(String category, Color color) {
    final Profile profile = userDetails.userProfile;
    return Icon(
      isActiveGoals
          ? profile.getIconForGoalCategory(category.toLowerCase())
          : profile.getIconForCategory(category.toLowerCase()),
      color: color,
    );
  }

  Widget _buildViews(
    List<dynamic> collections,
    int visibleTileCount,
    BuildContext context,
  ) {
    if (isActiveGoals) {
      final List<Goal> goals = <Goal>[];
      for (final Goal goal in collections) {
        if (goal.fund < goal.amount) {
          goals.add(goal);
        }
      }
      collections.clear();
      collections.addAll(goals);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(
        collections.length > visibleTileCount
            ? visibleTileCount
            : collections.length,
        (int index) {
          late Transaction transaction;
          late Goal goal;
          if (collections.isNotEmpty) {
            if (isActiveGoals) {
              goal =
                  collections[collections.length > visibleTileCount
                      ? ((collections.length - visibleTileCount) + index)
                      : index];
            } else {
              transaction =
                  collections[collections.length > visibleTileCount
                      ? ((collections.length - visibleTileCount) + index)
                      : index];
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (isActiveGoals) ...[
                Flexible(
                  child: _buildListViews(
                    context,
                    index: index,
                    type: '',
                    dataModel: goal,
                  ),
                ),
              ] else ...[
                Flexible(
                  child: _buildListViews(
                    context,
                    index: index,
                    type: transaction.type,
                    dataModel: transaction,
                  ),
                ),
              ],
              if (isActiveGoals && collections.isNotEmpty) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: SfLinearGauge(
                        showLabels: false,
                        showTicks: false,
                        barPointers: <LinearBarPointer>[
                          LinearBarPointer(
                            thickness: 12,
                            value: (goal.fund / goal.amount) * 100,
                            color:
                                (cardAvatarColors ??
                                doughnutPalette(Theme.of(context)))[index % 10],
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            animationDuration: 0,
                          ),
                        ],
                        markerPointers: [
                          LinearWidgetPointer(
                            value: ((goal.fund / goal.amount) * 100) - 3.5,
                            animationDuration: 0,
                            child: Text(
                              '${((goal.fund / goal.amount) * 100).floor()}%',
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(
                                    fontSize: 10,
                                    // height: 10,
                                    letterSpacing: 0.15,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ],
                        axisTrackStyle: const LinearAxisTrackStyle(
                          thickness: 12,
                          edgeStyle: LinearEdgeStyle.bothCurve,
                          color: linearGaugeLightThemeTrackColor,
                        ),
                      ),
                    ),
                    _buildDivider(context),
                  ],
                ),
              ],
              if (!isActiveGoals) _buildDivider(context),
            ],
          );
        },
      ),
    );
  }

  Padding _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(
        color: Theme.of(context).colorScheme.outlineVariant,
        thickness: 1.0,
        height: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpenseCard(
      edgeInsets: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double headerHeight = measureText(
            headerText,
            Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ).height;

          final double subTitleHeight = measureText(
            subHeaderText,
            Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ).height;

          const double bothSideDividerPadding = 16.0 + 16.0;
          const double dividerHeight = 1.0;
          const double linearGaugeHeight = 12.0;
          const double topGaugePadding = 18.0;
          final double listTileHeight =
              headerHeight +
              subTitleHeight +
              (isActiveGoals ? topGaugePadding : 0) +
              (isActiveGoals ? linearGaugeHeight : 0) +
              bothSideDividerPadding +
              dividerHeight;
          const double paddingTop = 24.0;
          const double paddingBottom = 12.0;
          const double recentTransaction = 24;
          final double startGap = isActiveGoals ? 26.0 : 32.0;

          // Calculating available space for list tiles
          final double availableHeight =
              constraints.maxHeight -
              (startGap + paddingTop + paddingBottom + recentTransaction);
          // Calculate number of tiles that can be displayed based on available height
          final int visibleTileCount = availableHeight ~/ listTileHeight;
          return Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24,
              bottom: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Row(
                    spacing: 8.0,
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: buildHeaderText(
                          context,
                          isActiveGoals
                              ? 'Active Goals'
                              : 'Recent Transactions',
                        ),
                      ),
                      buildViewMoreButton(context, () {
                        if (isActiveGoals) {
                          pageNavigatorNotifier.value =
                              NavigationPagesSlot.goal;
                        } else {
                          pageNavigatorNotifier.value =
                              NavigationPagesSlot.transaction;
                        }
                      }),
                    ],
                  ),
                ),
                if (collections.isNotEmpty)
                  _buildViews(collections, visibleTileCount, context)
                else ...<Widget>[
                  verticalSpacer16,
                  Center(child: buildNoRecordsFound(context)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
