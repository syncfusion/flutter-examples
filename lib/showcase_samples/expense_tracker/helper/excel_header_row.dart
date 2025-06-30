// TODO(Praveen): Replace this excel code with csv or xml format code.

// import 'package:excel/excel.dart';

// import '../models/budget.dart';
// import '../models/goal.dart';
// import '../models/saving.dart';
// import '../models/transaction.dart';
// import '../models/user_profile.dart';
// import 'currency_and_data_format/currency_format.dart';
// import 'currency_and_data_format/date_format.dart';

// Profile userProfileDetails(List<Data?> userDetails) {
//   return Profile(
//     userId: '${userDetails[0]!.value}',
//     firstName: '${userDetails[1]!.value}',
//     lastName: '${userDetails[2]!.value}',
//     gender: '${userDetails[3]!.value}',
//     dateOfBirth: DateTime.tryParse('${userDetails[4]!.value}'),
//     currency: '${userDetails[5]!.value}',
//     dateFormat: '${userDetails[6]!.value}',
//     isDrawerExpanded: '${userDetails[7]!.value}' == 'TRUE',
//   );
// }

// Transaction readTransactionDetails(
//   List<Data?> transaction,
//   Profile userProfile,
// ) {
//   return Transaction(
//     transactionDate: parseDateString('${transaction[1]?.value}'),
//     category: '${transaction[2]?.value}',
//     subCategory: '${transaction[3]?.value}',
//     type: '${transaction[4]?.value}',
//     amount: parseCurrency('${transaction[5]?.value}', userProfile),
//     remark: '${transaction[6]?.value}',
//   );
// }

// Saving readSavingDetails(List<Data?> saving, Profile userProfile) {
//   return Saving(
//     name: '${saving[2]?.value}',
//     savingDate: parseDateString('${saving[1]?.value}'),
//     savedAmount: parseCurrency('${saving[4]?.value}', userProfile),
//     type: '${saving[3]?.value}',
//     remark: '${saving[5]?.value}',
//   );
// }

// Goal readGoalDetails(List<Data?> goal, Profile userProfile) {
//   return Goal(
//     name: '${goal[2]?.value}',
//     date: parseDateString('${goal[5]?.value}'),
//     amount: parseCurrency('${goal[6]?.value}', userProfile),
//     notes: '${goal[8]?.value}',
//     priority: '${goal[4]?.value}',
//     fund: parseCurrency('${goal[7]?.value}', userProfile),
//     category: '${goal[3]?.value}',
//   );
// }

// Budget readBudgetDetails(List<Data?> budget, Profile userProfile) {
//   return Budget(
//     name: '${budget[2]?.value}',
//     target: parseCurrency('${budget[4]?.value}', userProfile),
//     expense: parseCurrency('${budget[5]?.value}', userProfile),
//     createdDate: DateTime.now(),
//     notes: '${budget[6]?.value}',
//     category: '${budget[3]?.value}',
//   );
// }

// Sheet excelSheet(Excel excel, String sheetName) {
//   return excel[sheetName];
// }

// bool hasNull(List<Data?> data) {
//   for (int i = 0; i < data.length; i++) {
//     if (data[i]?.value == null) {
//       return true;
//     }
//   }
//   return false;
// }

// List<TextCellValue> userDetailsHeaderCellValue() {
//   return <TextCellValue>[
//     TextCellValue('User ID'),
//     TextCellValue('First Name'),
//     TextCellValue('Last Name'),
//     TextCellValue('Gender'),
//     TextCellValue('Date Of Birth'),
//     TextCellValue('Currency'),
//     TextCellValue('Date Format'),
//     TextCellValue('IsExpanded'),
//   ];
// }

// List<TextCellValue> transactionsHeaderCellValue() {
//   return <TextCellValue>[
//     TextCellValue('Transaction ID'),
//     TextCellValue('Date'),
//     TextCellValue('Category'),
//     TextCellValue('Subcategory'),
//     TextCellValue('Type'),
//     TextCellValue('Amount'),
//     TextCellValue('Remark'),
//   ];
// }

// List<TextCellValue> transactionsCellValue(
//   Transaction transaction,
//   Profile userProfile,
// ) {
//   return <TextCellValue>[
//     TextCellValue('ID'),
//     TextCellValue(formatDate(transaction.transactionDate)),
//     TextCellValue(transaction.category),
//     TextCellValue(transaction.subCategory),
//     TextCellValue(transaction.type),
//     TextCellValue(toCurrency(transaction.amount, userProfile)),
//     TextCellValue(transaction.remark),
//   ];
// }

// List<TextCellValue> savingsHeaderCellValue() {
//   return <TextCellValue>[
//     TextCellValue('Saving ID'),
//     TextCellValue('Date'),
//     TextCellValue('Saving Name'),
//     TextCellValue('Type'),
//     TextCellValue('Amount'),
//     TextCellValue('Remarks'),
//   ];
// }

// List<TextCellValue> savingsCellValue(Saving saving, Profile userProfile) {
//   return <TextCellValue>[
//     TextCellValue('Saving ID'),
//     TextCellValue(formatDate(saving.savingDate)),
//     TextCellValue(saving.name),
//     TextCellValue(saving.type),
//     TextCellValue(toCurrency(saving.savedAmount, userProfile)),
//     TextCellValue(saving.remark),
//   ];
// }

// List<TextCellValue> goalsHeaderCellValue() {
//   return <TextCellValue>[
//     TextCellValue('Goal ID'),
//     TextCellValue('Date'),
//     TextCellValue('Gaol Name'),
//     TextCellValue('Category'),
//     TextCellValue('Type'),
//     TextCellValue('Target Date'),
//     TextCellValue('Target Amount'),
//     TextCellValue('Saved Amount'),
//     TextCellValue('Notes'),
//   ];
// }

// List<TextCellValue> goalsCellValue(Goal goal, Profile userProfile) {
//   return <TextCellValue>[
//     TextCellValue('Goal ID'),
//     TextCellValue(formatDate(goal.addedDateTime ?? DateTime.now())),
//     TextCellValue(goal.name),
//     TextCellValue(goal.category),
//     TextCellValue(goal.priority ?? 'Low'),
//     TextCellValue(formatDate(goal.date)),
//     TextCellValue(toCurrency(goal.amount, userProfile)),
//     TextCellValue(toCurrency(goal.fund, userProfile)),
//     TextCellValue(goal.notes ?? ''),
//   ];
// }

// List<TextCellValue> budgetsHeaderCellValue() {
//   return <TextCellValue>[
//     TextCellValue('Budget ID'),
//     TextCellValue('Date'),
//     TextCellValue('Budget Name'),
//     TextCellValue('Category'),
//     TextCellValue('Target Amount'),
//     TextCellValue('Current Amount'),
//     TextCellValue('Notes'),
//   ];
// }

// List<TextCellValue> budgetsCellValue(Budget budget, Profile userProfile) {
//   return <TextCellValue>[
//     TextCellValue('Budget ID'),
//     TextCellValue(formatDate(budget.createdDate)),
//     TextCellValue(budget.name),
//     TextCellValue(budget.category),
//     TextCellValue(toCurrency(budget.target, userProfile)),
//     TextCellValue(toCurrency(budget.expense, userProfile)),
//     TextCellValue(budget.notes ?? ''),
//   ];
// }
