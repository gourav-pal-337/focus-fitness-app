import '../constants/app_constants.dart';

class CurrencyFormatter {
  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'INR': '₹',
    'GBP': '£',
    'EUR': '€',
    'AED': 'د.إ',
    'SAR': '﷼',
  };

  /// Returns the symbol for the given currency code.
  /// Defaults to GBP (£) if the code is null or not found.
  static String getSymbol([String? currencyCode]) {
    final code = currencyCode?.toUpperCase() ?? AppConstants.defaultCurrencyCode;
    return _currencySymbols[code] ?? _currencySymbols[AppConstants.defaultCurrencyCode] ?? '£';
  }

  /// Formats an amount with the appropriate currency symbol.
  /// Example: format(29.99, 'USD') -> "$29.99"
  static String format(num amount, [String? currencyCode]) {
    final symbol = getSymbol(currencyCode);
    
    // Format to 2 decimal places. 
    // toStringAsFixed(2) is used for currency representation.
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
