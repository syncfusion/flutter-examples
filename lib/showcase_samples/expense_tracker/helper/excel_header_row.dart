import 'package:excel/excel.dart';

import '../models/budget.dart';
// import '../models/category.dart';
import '../models/goal.dart';
import '../models/saving.dart';
import '../models/transaction.dart';
import '../models/user_profile.dart';
import 'currency_and_data_format/currency_format.dart';
import 'currency_and_data_format/date_format.dart';

Profile userProfileDetails(List<Data?> userDetails) {
  return Profile(
    userId: userDetails[0]!.value.toString(),
    firstName: userDetails[1]!.value.toString(),
    lastName: userDetails[2]!.value.toString(),
    gender: userDetails[3]!.value.toString(),
    dateOfBirth: DateTime.tryParse(userDetails[4]!.value.toString()),
    currency: userDetails[5]!.value.toString(),
    dateFormat: userDetails[6]!.value.toString(),
    isDrawerExpanded: userDetails[7]!.value.toString() == 'TRUE',
  );
}

Transaction readTransactionDetails(
  List<Data?> transaction,
  Profile userProfile,
) {
  return Transaction(
    transactionDate: parseDateString(transaction[1]!.value.toString()),
    category: transaction[2]!.value.toString(),
    subCategory: transaction[3]!.value.toString(),
    type: transaction[4]!.value.toString(),
    amount: parseCurrency(transaction[5]!.value.toString(), userProfile),
    remark: transaction[6]!.value.toString(),
  );
}

Saving readSavingDetails(List<Data?> saving, Profile userProfile) {
  return Saving(
    name: saving[2]!.value.toString(),
    savingDate: parseDateString(saving[1]!.value.toString()),
    savedAmount: parseCurrency(saving[4]!.value.toString(), userProfile),
    type: saving[3]!.value.toString(),
    remark: saving[5]!.value.toString(),
  );
}

Goal readGoalDetails(List<Data?> goal, Profile userProfile) {
  return Goal(
    name: goal[2]!.value.toString(),
    targetDate: parseDateString(goal[4]!.value.toString()),
    targetAmount: parseCurrency(goal[5]!.value.toString(), userProfile),
    notes: goal[7]!.value.toString(),
    priority: goal[3]!.value.toString(),
    savedAmount: parseCurrency(goal[6]!.value.toString(), userProfile),
  );
}

Budget readBudgetDetails(List<Data?> budget, Profile userProfile) {
  return Budget(
    name: (budget[2]?.value ?? '').toString(),
    target: parseCurrency((budget[3]?.value ?? '').toString(), userProfile),
    expense: parseCurrency((budget[4]?.value ?? '').toString(), userProfile),
    createdDate: DateTime.now(),
    notes: (budget[5]?.value ?? '').toString(),
  );
}

Sheet getSheet(Excel excel, String sheetName) {
  return excel[sheetName];
}

bool hasNull(List<Data?> data) {
  for (int i = 0; i < data.length; i++) {
    if (data[i]?.value == null) {
      return true;
    }
  }
  return false;
}

List<TextCellValue> userDetailsHeaderCellValue() {
  return <TextCellValue>[
    TextCellValue('User ID'),
    TextCellValue('First Name'),
    TextCellValue('Last Name'),
    TextCellValue('Gender'),
    TextCellValue('Date Of Birth'),
    TextCellValue('Currency'),
    TextCellValue('Date Format'),
    TextCellValue('IsExpanded'),
  ];
}

List<TextCellValue> transactionsHeaderCellValue() {
  return <TextCellValue>[
    TextCellValue('Transaction ID'),
    TextCellValue('Date'),
    TextCellValue('Category'),
    TextCellValue('Subcategory'),
    TextCellValue('Type'),
    TextCellValue('Amount'),
    TextCellValue('Remark'),
  ];
}

List<TextCellValue> transactionsCellValue(
  Transaction transaction,
  Profile userProfile,
) {
  return <TextCellValue>[
    TextCellValue('ID'),
    TextCellValue(formatDate(transaction.transactionDate)),
    TextCellValue(transaction.category),
    TextCellValue(transaction.subCategory),
    TextCellValue(transaction.type),
    TextCellValue(toCurrency(transaction.amount, userProfile)),
    TextCellValue(transaction.remark),
  ];
}

List<TextCellValue> savingsHeaderCellValue() {
  return <TextCellValue>[
    TextCellValue('Saving ID'),
    TextCellValue('Date'),
    TextCellValue('Saving Name'),
    TextCellValue('Type'),
    TextCellValue('Amount'),
    TextCellValue('Remarks'),
  ];
}

List<TextCellValue> savingsCellValue(Saving saving, Profile userProfile) {
  return <TextCellValue>[
    TextCellValue('Saving ID'),
    TextCellValue(formatDate(saving.savingDate)),
    TextCellValue(saving.name),
    TextCellValue(saving.type),
    TextCellValue(toCurrency(saving.savedAmount, userProfile)),
    TextCellValue(saving.remark),
  ];
}

List<TextCellValue> goalsHeaderCellValue() {
  return <TextCellValue>[
    TextCellValue('Goal ID'),
    TextCellValue('Date'),
    TextCellValue('Gaol Name'),
    TextCellValue('Type'),
    TextCellValue('Target Date'),
    TextCellValue('Target Amount'),
    TextCellValue('Saved Amount'),
    TextCellValue('Notes'),
  ];
}

List<TextCellValue> goalsCellValue(Goal goal, Profile userProfile) {
  return <TextCellValue>[
    TextCellValue('Goal ID'),
    TextCellValue(formatDate(goal.addedDateTime ?? DateTime.now())),
    TextCellValue(goal.name),
    TextCellValue(goal.priority.toString()),
    TextCellValue(formatDate(goal.targetDate)),
    TextCellValue(goal.targetAmount.toString()),
    TextCellValue(goal.savedAmount.toString()),
    TextCellValue(goal.notes.toString()),
  ];
}

List<TextCellValue> budgetsHeaderCellValue() {
  return <TextCellValue>[
    TextCellValue('Budget ID'),
    TextCellValue('Date'),
    TextCellValue('Budget Name'),
    TextCellValue('Target Amount'),
    TextCellValue('Current Amount'),
    TextCellValue('Notes'),
  ];
}

List<TextCellValue> budgetsCellValue(Budget budget, Profile userProfile) {
  return <TextCellValue>[
    TextCellValue('Budget ID'),
    TextCellValue(formatDate(budget.createdDate)),
    TextCellValue(budget.name),
    TextCellValue(toCurrency(budget.target, userProfile)),
    TextCellValue(toCurrency(budget.expense, userProfile)),
    TextCellValue(budget.notes ?? ''),
  ];
}
