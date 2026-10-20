import 'package:intl/intl.dart';

class AppNumberUtils {
  static final _numberFormat = NumberFormat('#,##0', 'tr_TR');
  static final _decimalFormat = NumberFormat('#,##0.0', 'tr_TR');

  static String formatInteger(int value) {
    return _numberFormat.format(value);
  }

  static String formatDouble(double value) {
    return _decimalFormat.format(value);
  }

  static String formatPercent(double ratio) {
    return '%${(ratio * 100).toStringAsFixed(1)}';
  }

  static String formatUnits(int count) {
    return '$count Ünite';
  }
}
