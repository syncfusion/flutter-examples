import 'package:flutter/material.dart';

import '../../../models/goal.dart';
import '../../../models/user.dart';
import 'common_list.dart';

class ActiveGoals extends StatelessWidget {
  const ActiveGoals({
    required this.userDetails,
    required this.goals,
    this.cardAvatarColors,
    super.key,
  });

  final List<Goal> goals;
  final List<Color>? cardAvatarColors;
  final UserDetails userDetails;

  @override
  Widget build(BuildContext context) {
    return CommonList(
      headerText: goals.isNotEmpty ? goals[0].name : '',
      subHeaderText: goals.isNotEmpty ? goals[0].notes ?? '' : '',
      userDetails: userDetails,
      isActiveGoals: true,
      collections: goals,
    );
  }
}
