import '../enum.dart';

class StockData {
  StockData({
    required this.stock,
    required this.companyName,
    required this.officialName,
    required this.exchange,
    required this.logoSvgPath,
    required this.data,
    this.isFavorite = false,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      stock: stockFromString(json['Stock']),
      companyName: json['Company'],
      officialName: json['OfficialName'],
      exchange: json['Exchange'],
      logoSvgPath: json['LogoSvgPath'] ?? '',
      isFavorite: json['isFavorite'],
      data: (json['Data'] as List).map((e) => Data.fromJson(e)).toList(),
    );
  }

  static Stock stockFromString(String str) {
    return Stock.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => Stock.apple,
    );
  }

  final Stock stock;
  final String companyName;
  final String officialName;
  final String exchange;
  final String logoSvgPath;
  final List<Data> data;
  bool isFavorite;
}

class Data {
  Data({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.adjClose,
    required this.volume,
    required this.lastTradedPrice,
    required this.lastDayPrice,
    required this.currentPrice,
    required this.priceChange,
    required this.percentageChange,
    required this.priceEarningsRatio,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      date: json['Date'].toString(),
      open: json['Open'],
      high: json['High'],
      low: json['Low'],
      close: json['Close'],
      adjClose: json['Adj Close'],
      volume: json['Volume'],
      lastTradedPrice: json['LTP'],
      lastDayPrice: json['Last Day Price'],
      currentPrice: json['Current Price'],
      priceChange: json['Price Change'],
      percentageChange: json['Percentage Change'],
      priceEarningsRatio: json['P/E Ratio'],
    );
  }

  final String date;
  final num open;
  final num high;
  final num low;
  final num close;
  final num adjClose;
  final num volume;
  final num lastTradedPrice;
  final num lastDayPrice;
  final num currentPrice;
  final num priceChange;
  final num percentageChange;
  final num priceEarningsRatio;
}

class CustomDateRange {
  const CustomDateRange({this.start, this.end});

  final DateTime? start;
  final DateTime? end;
}

// class StockDetails {
//   StockDetails({
//     required this.stock,
//     required this.title,
//     required this.subTitle,
//     required this.value,
//     required this.percentageIncreased,
//     this.favorites = false,
//     this.logoPath = '',
//   });

//   Stock stock;
//   String title;
//   String subTitle;
//   double value;
//   double percentageIncreased;
//   bool favorites;
//   String logoPath;
// }
