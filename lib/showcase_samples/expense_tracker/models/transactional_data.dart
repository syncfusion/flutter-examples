import 'transactional_details.dart';

class TransactionalData {
  TransactionalData({required this.data});

  factory TransactionalData.fromExcel(
    List<TransactionalDetails> transactionalDetails,
  ) {
    return TransactionalData(
      data: List<TransactionalDetails>.generate(
        transactionalDetails.length,
        (int index) => TransactionalDetails.fromJson(
          TransactionalDetails(
            transactions: transactionalDetails[index].transactions,
            budgets: transactionalDetails[index].budgets,
            goals: transactionalDetails[index].goals,
            savings: transactionalDetails[index].savings,
            // categories: transactionalDetails[index].categories,
          ),
        ),
      ),
    );
  }

  final List<TransactionalDetails> data;
}
