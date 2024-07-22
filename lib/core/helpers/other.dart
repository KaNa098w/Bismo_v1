import 'package:intl/intl.dart';

String formatMinutes(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  String formattedTime =
      '${hours != 0 ? '${hours.toString().padLeft(2, '0')} ч.' : ''} ${remainingMinutes.toString().padLeft(2, '0')} мин.';
  return formattedTime;
}

int getYearFromDateString(String dateString) {
  if (dateString.isEmpty) return 0;
  final parts = dateString.split('-');
  final year = int.tryParse(parts[0]) ?? 0;
  return year;
}

String formatNumber(int number) {
  final reversedNumberString = number.toString().split('').reversed.join();
  final formattedString = reversedNumberString
      .replaceAllMapped(
        RegExp(r'.{1,3}'),
        (match) => '${match.group(0)} ',
      )
      .trim()
      .split('')
      .reversed
      .join();

  return formattedString;
}

String formatDouble(double number) {
  final reversedNumberString =
      number.toInt().toString().split('').reversed.join();
  final formattedString = reversedNumberString
      .replaceAllMapped(
        RegExp(r'.{1,3}'),
        (match) => '${match.group(0)} ',
      )
      .trim()
      .split('')
      .reversed
      .join();

  return formattedString;
}

String formatDate(String? dateString, String? lang) {
  if (dateString == null) return "";
  final date = DateFormat('yyyy-MM-dd').parse(dateString);
  final formattedDate = DateFormat('d MMMM yyyy', lang).format(date);
  return formattedDate;
}

String formatDateWithTime(String? dateString, String? lang) {
  if (dateString == null) return "";
  final date = DateFormat('dd.MM.yyyy HH:mm:ss').parse(dateString);
  final formattedDate = DateFormat('d MMMM yyyy HH:mm', lang).format(date);
  return formattedDate;
}

String formatDateTime(String? dateTimeString, String lang) {
  if (dateTimeString == null) return "";
  DateTime dateTime = DateTime.parse(dateTimeString);
  Duration duration = DateTime.now().difference(dateTime);

  List<String> yearsStrings = lang == 'kk'
      ? ['жыл', 'жыл', 'жыл']
      : lang == 'en'
          ? ['years', 'years', 'years']
          : ['год', 'года', 'лет'];
  List<String> monthsStrings = lang == 'kk'
      ? ['ай', 'ай', 'ай']
      : lang == 'en'
          ? ['month', 'months', 'months']
          : ['месяц', 'месяца', 'месяцев'];
  List<String> daysStrings = lang == 'kk'
      ? ['күн', 'күн', 'күн']
      : lang == 'en'
          ? ['day', 'days', 'days']
          : ['день', 'дня', 'дней'];
  List<String> hoursStrings = lang == 'kk'
      ? ['сағат', 'сағат', 'сағат']
      : lang == 'en'
          ? ['hour', 'hours', 'hours']
          : ['час', 'часа', 'часов'];
  List<String> minutesStrings = lang == 'kk'
      ? ['минут', 'минут', 'минут']
      : lang == 'en'
          ? ['minute', 'minutes', 'minutes']
          : ['минута', 'минуты', 'минут'];
  List<String> secondStrings = lang == 'kk'
      ? ['секунд', 'секунд', 'секунд']
      : lang == 'en'
          ? ['second', 'seconds', 'seconds']
          : ['секунда', 'секунды', 'секунд'];

  String agoString = lang == 'kk'
      ? 'бұрын'
      : lang == 'en'
          ? 'ago'
          : 'назад';

  if (duration.inDays > 365) {
    int years = duration.inDays ~/ 365;
    return '$years ${_pluralize(years, yearsStrings)} $agoString';
  } else if (duration.inDays >= 30) {
    int months = duration.inDays ~/ 30;
    return '$months ${_pluralize(months, monthsStrings)} $agoString';
  } else if (duration.inDays > 0) {
    return '${duration.inDays} ${_pluralize(duration.inDays, daysStrings)} $agoString';
  } else if (duration.inHours > 0) {
    return '${duration.inHours} ${_pluralize(duration.inHours, hoursStrings)} $agoString';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes} ${_pluralize(duration.inMinutes, minutesStrings)} $agoString';
  } else {
    return '${duration.inSeconds} ${_pluralize(duration.inSeconds, secondStrings)} $agoString';
  }
}

String _pluralize(int value, List<String> translations) {
  if (value % 10 == 1 && value % 100 != 11) {
    return translations[0];
  } else if (value % 10 >= 2 &&
      value % 10 <= 4 &&
      (value % 100 < 10 || value % 100 >= 20)) {
    return translations[1];
  } else {
    return translations[2];
  }
}

double calculateAverage(double num1, double num2, double num3) {
  int count = 0;
  double sum = 0;

  if (num1 != 0) {
    sum += num1;
    count++;
  }
  if (num2 != 0) {
    sum += num2;
    count++;
  }
  if (num3 != 0) {
    sum += num3;
    count++;
  }

  if (count == 0) {
    return 0;
  }

  return double.parse((sum / count).toStringAsFixed(2));
}

String addUserIdIfSubstringPresent(String originalString, String userId) {
  if (originalString.contains("userIdForRec=")) {
    int index = originalString.indexOf("userIdForRec=");

    String modifiedString = originalString.substring(0, index + 13) +
        userId +
        originalString.substring(index + 13);

    return modifiedString;
  } else {
    return originalString;
  }
}
