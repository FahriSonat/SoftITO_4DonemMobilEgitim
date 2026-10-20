import 'package:intl/intl.dart';

class AppDateUtils {
  /// Clock reference with explicit timezone (TRT, UTC+3)
  static DateTime now() {
    return DateTime.now().toUtc().add(const Duration(hours: 3));
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('d MMM').format(date);
  }
}
