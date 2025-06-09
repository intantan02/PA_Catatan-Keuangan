<<<<<<< HEAD
// core/utils/date_helper.dart

=======
>>>>>>> 0c7b4a4 ( perbaikan file)
import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy HH:mm').format(date);
  }

  static DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }
<<<<<<< HEAD
=======

  static DateTime parseDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }
>>>>>>> 0c7b4a4 ( perbaikan file)
}
