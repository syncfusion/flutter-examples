class Budget {
  Budget({
    required this.name,
    required this.target,
    required this.createdDate,
    required this.expense,
    this.notes,
  });

  String name;
  String? notes;
  double target;
  double expense;
  DateTime createdDate;

  @override
  String toString() {
    return 'Budget: $name, Amount: $target, Date: $createdDate';
  }
}
