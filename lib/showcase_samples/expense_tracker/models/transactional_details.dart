import 'budget.dart';
// import 'category.dart';
import 'goal.dart';
import 'saving.dart';
import 'transaction.dart';

class TransactionalDetails {
  TransactionalDetails({
    required this.transactions,
    required this.budgets,
    required this.goals,
    required this.savings,
    // required this.categories,
  });

  factory TransactionalDetails.fromJson(
    TransactionalDetails transactionalDetails,
  ) {
    return TransactionalDetails(
      transactions: transactionalDetails.transactions,
      budgets: transactionalDetails.budgets,
      goals: transactionalDetails.goals,
      savings: transactionalDetails.savings,
      // categories: transactionalDetails.categories,
    );
  }

  List<Transaction> transactions;
  List<Budget> budgets;
  List<Goal> goals;
  List<Saving> savings;
  // List<Category> categories;
}
