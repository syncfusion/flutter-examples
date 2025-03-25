/// Custom business object class which contains properties to hold the detailed
/// information about the stock which will be rendered in datagrid.
class Stock {
  /// Creates the stock class with required details.
  Stock(this.name, this.qs1, this.qs2, this.qs3, this.qs4);

  /// Qs1 of the stock.
  final double qs1;

  /// Qs2 of the stock.
  final double qs2;

  /// Qs3 of the stock.
  final double qs3;

  /// Qs4 of the stock.
  final double qs4;

  /// Name of the stock.
  final String name;
}
