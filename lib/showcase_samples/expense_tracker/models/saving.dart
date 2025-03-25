import 'package:intl/intl.dart';

import '../helper/currency_and_data_format/date_format.dart';

class Saving {
  Saving({
    required this.name,
    required this.savedAmount,
    required this.type,
    required this.savingDate,
    this.remark = '',
    this.isCompleted = false,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    DateTime savingDate;

    try {
      savingDate = DateTime.parse(json['savingDate']);
    } catch (_) {
      savingDate = DateFormat(currentDateFormat).parse(json['savingDate']);
    }
    return Saving(
      name: json['name'] ?? '',
      savedAmount: (json['savedAmount'] ?? 0.0).toDouble(),
      type: json['type'],
      remark: json['remark'],
      savingDate: savingDate,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'savedAmount': savedAmount,
      'type': type,
      'remark': remark,
      'savingDate': savingDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  String name;
  double savedAmount;
  String type;
  String remark;
  DateTime savingDate;
  bool isCompleted;

  @override
  String toString() {
    return 'Savings: $name, Added DateTime: $savingDate, Saved Amount: $savedAmount, Type: $type, remark: $remark';
  }
}
