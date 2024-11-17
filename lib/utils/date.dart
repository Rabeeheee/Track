import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return "No date selected";

    return DateFormat('MM/dd/yyyy').format(date);
  }
}
