class Budget {
  Budget({
    required this.name,
    required this.target,
    required this.createdDate,
    required this.expense,
    required this.category,
    this.isCompleted = false,
    this.notes,
  });

  String name;
  String? notes;
  double target;
  double expense;
  bool isCompleted;
  DateTime createdDate;
  String category;

  @override
  String toString() {
    return 'Budget: $name, Amount: $target, Date: $createdDate, Category: $category';
  }
}
