/// Custom business object class which contains properties to hold the detailed
/// information about the real time stock which will be rendered in datagrid.
class Stock {
  /// Creates the real time class with required details.
  Stock(this.symbol, this.stock, this.open, this.previousClose, this.lastTrade);

  /// Symbol of the stock
  String symbol;

  ///Name of the stock
  double stock;

  /// Open rate of the stock
  double open;

  /// Previous close of the stock
  double previousClose;

  /// Last trade of the stock
  int lastTrade;
}
