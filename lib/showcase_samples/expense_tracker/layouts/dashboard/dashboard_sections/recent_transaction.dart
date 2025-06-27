import 'package:flutter/material.dart';

import '../../../models/transaction.dart';
import '../../../models/user.dart';
import '../../../pages/dashboard.dart';
import 'common_list.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    required this.expenseDetailCollections,
    required this.transactionsCollection,
    required this.userDetails,
    this.cardAvatarColors,
    super.key,
  });

  final List<Color>? cardAvatarColors;
  final List<ExpenseDetails> expenseDetailCollections;
  final List<Transaction> transactionsCollection;
  final UserDetails userDetails;

  @override
  Widget build(BuildContext context) {
    return CommonList(
      headerText: transactionsCollection.isNotEmpty
          ? transactionsCollection[0].category
          : '',
      subHeaderText: transactionsCollection.isNotEmpty
          ? transactionsCollection[0].subCategory
          : '',
      userDetails: userDetails,
      isActiveGoals: false,
      collections: transactionsCollection,
    );
  }
}
