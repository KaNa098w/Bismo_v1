import 'package:intl/intl.dart';

class CustomNumberFormat {
  static String format(num number) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(number).replaceAll(',', ' ');
  }
}
