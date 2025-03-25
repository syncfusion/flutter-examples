import 'package:intl/intl.dart';

import '../../models/user_profile.dart';

List<String> buildCurrencies() {
  return <String>[
    'Dollar', // US
    'Canadian Dollar', // Canada
    'Pound', // UK
    'Euro', // Germany
    'Yen', // Japan
    'Rupee', // India
    'Yuan', // China
  ];
}

// Map of country names to currency locales
final Map<String, String> languageCodes = <String, String>{
  'Dollar': 'en_US',
  'Canadian Dollar': 'en_CA',
  'Pound': 'en_GB',
  'Euro': 'de_DE',
  'Yen': 'ja_JP',
  'Rupee': 'en_IN',
  'Yuan': 'zh_CN',
};

String toCurrency(double value, Profile user) {
  final NumberFormat formatter = NumberFormat.simpleCurrency(
    locale: languageCodes[user.currency],
  );
  String formatted = formatter.format(value);
  // Remove only trailing zeros after the decimal point.
  formatted = formatted.replaceAll(RegExp(r'(?<=\.\d*?)0+$'), '');
  // Remove the decimal point if there are no digits after it.
  formatted = formatted.replaceAll(RegExp(r'\.$'), '');
  return formatted;
}

double parseCurrency(String formattedAmount, Profile userProfile) {
  final String selectedCurrency = userProfile.currency;
  final String currencyLocale = languageCodes[selectedCurrency] ?? '';

  // Create a NumberFormat instance for parsing
  final NumberFormat formatter = NumberFormat.simpleCurrency(
    locale: currencyLocale,
  );

  // Parse the string to a number
  return formatter.parse(formattedAmount).toDouble();
}

double formatPredefinedCurrency(int amountInRupees, Profile userProfile) {
  final String selectedCurrency = userProfile.currency;
  final Map<String, double> exchangeRates = <String, double>{
    'US': 0.012,
    'Canada': 0.015,
    'UK': 0.009,
    'Germany': 0.011,
    'Japan': 1.5,
    'India': 1.0,
    'China': 0.086,
  };
  final double exchangeRate = exchangeRates[selectedCurrency] ?? 1.0;
  final double convertedAmount = amountInRupees * exchangeRate;
  return convertedAmount;
}
