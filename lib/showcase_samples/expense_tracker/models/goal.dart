import 'package:intl/intl.dart';

import '../helper/currency_and_data_format/date_format.dart';

class Goal {
  Goal({
    required this.name,
    required this.targetDate,
    required this.targetAmount,
    this.priority,
    this.isCompleted = false,
    this.savedAmount = 0.0,
    DateTime? lastUpdated,
    this.addedDateTime,
    this.notes,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Goal.fromJson(Map<String, dynamic> json) {
    DateTime date;
    DateTime lastUpdated;
    DateTime addedDateTime;

    try {
      date = DateTime.parse(json['targetDate'] ?? '');
      lastUpdated = DateTime.parse(json['lastUpdated'] ?? '');
      addedDateTime = DateTime.parse(
        json['addedDateTime'] ?? DateTime.now().toString(),
      );
    } catch (_) {
      date = DateFormat(currentDateFormat).parse(json['targetDate'] ?? '');
      lastUpdated = DateFormat(
        currentDateFormat,
      ).parse(json['lastUpdated'] ?? '');
      addedDateTime = DateFormat(
        currentDateFormat,
      ).parse(json['addedDateTime'] ?? DateTime.now().toString());
    }
    return Goal(
      name: json['name'] ?? '',
      targetDate: date,
      targetAmount: json['targetAmount'],
      isCompleted: json['isCompleted'] ?? false,
      savedAmount: (json['savedAmount'] ?? 0.0).toDouble(),
      lastUpdated: lastUpdated,
      addedDateTime: addedDateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'targetDate': targetDate.toIso8601String(),
      'targetAmount': targetAmount,
      'isCompleted': isCompleted,
      'savedAmount': savedAmount,
      'lastUpdated': lastUpdated.toIso8601String(),
      'addedDateTime': addedDateTime?.toIso8601String(),
    };
  }

  String name;
  String? priority;
  String? notes;
  DateTime targetDate;
  double targetAmount;
  bool isCompleted;
  double savedAmount;
  DateTime lastUpdated;
  DateTime? addedDateTime;

  @override
  String toString() {
    return 'Goal: $name, Target Date: $targetDate, Target Amount: $targetAmount, isCompleted: $isCompleted, Saved Amount: $savedAmount, Last Update: $lastUpdated';
  }
}
