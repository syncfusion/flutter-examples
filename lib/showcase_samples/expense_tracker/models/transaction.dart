import 'package:intl/intl.dart';

import '../helper/currency_and_data_format/date_format.dart';

class Transaction {
  Transaction({
    required this.category,
    required this.transactionDate,
    required this.subCategory,
    required this.type,
    required this.remark,
    required this.amount,
    this.addedDateTime,
    this.isSelected = false,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    DateTime transactionDate;
    DateTime addedDateTime;
    try {
      transactionDate = DateTime.parse(json['transactionDate']);
      addedDateTime = DateTime.parse(json['addedDateTime']);
    } catch (_) {
      transactionDate = DateFormat(
        currentDateFormat,
      ).parse(json['transactionDate']);
      addedDateTime = DateFormat(
        currentDateFormat,
      ).parse(json['addedDateTime']);
    }

    return Transaction(
      category: json['category'],
      transactionDate: transactionDate,
      subCategory: json['subCategory'],
      type: json['type'],
      remark: json['remark'],
      amount: json['amount'],
      isSelected: json['isSelected'] ?? false,
      addedDateTime: addedDateTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'transactionDate': transactionDate.toIso8601String(),
    'subCategory': subCategory,
    'type': type,
    'remark': remark,
    'amount': amount,
    'isSelected': isSelected,
    'addedDateTime': addedDateTime?.toIso8601String(),
  };

  String category;
  DateTime transactionDate;
  String subCategory;
  String type;
  String remark;
  double amount;
  bool isSelected;
  DateTime? addedDateTime;

  Transaction copyWith({
    String? type,
    String? category,
    String? subCategory,
    double? amount,
    String? remark,
    DateTime? transactionDate,
    bool? isSelected,
    DateTime? addedDateTime,
  }) {
    return Transaction(
      type: type ?? this.type,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      amount: amount ?? this.amount,
      remark: remark ?? this.remark,
      transactionDate: transactionDate ?? this.transactionDate,
      isSelected: isSelected ?? this.isSelected,
      addedDateTime: addedDateTime ?? this.addedDateTime,
    );
  }
}
