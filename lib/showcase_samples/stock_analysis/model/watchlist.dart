import '../enum.dart';

class Watchlist {
  Watchlist({required this.id, required this.name, List<Stock>? stocks})
    : stocks = stocks ?? [];

  final String id;
  String name;
  final List<Stock> stocks;

  void addStock(Stock stock) {
    if (!stocks.contains(stock)) {
      stocks.add(stock);
    }
  }

  void removeStock(Stock stock) {
    stocks.remove(stock);
  }

  bool containsStock(Stock stock) {
    return stocks.contains(stock);
  }
}
