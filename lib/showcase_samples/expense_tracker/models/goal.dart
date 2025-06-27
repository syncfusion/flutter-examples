class Goal {
  Goal({
    required this.name,
    required this.date,
    required this.amount,
    required this.category,
    this.priority,
    this.isCompleted = false,
    this.fund = 0.0,
    DateTime? lastUpdated,
    this.addedDateTime,
    this.notes,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  String name;
  String? priority;
  String? notes;
  DateTime date;
  double amount;
  bool isCompleted;
  double fund;
  DateTime lastUpdated;
  DateTime? addedDateTime;
  String category;
}
