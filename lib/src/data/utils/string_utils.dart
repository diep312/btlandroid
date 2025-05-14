import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class StringUtils {
  static String getPublishDateShort(DateTime date) {
    final DateTime currentTime = DateTime.now();
    final difference = currentTime.difference(date);
    initializeDateFormatting('tr_TR');
    if (difference.inDays > 365) {
      return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    } else if (difference.inDays > 8) {
      return DateFormat('d MMMM', 'tr_TR').format(date);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return "1d";
    } else if (difference.inDays >= 2) {
      return "${difference.inDays}d";
    } else if (difference.inDays >= 1) {
      return "1d";
    } else if (difference.inHours >= 2) {
      return "${difference.inHours}h";
    } else if (difference.inHours >= 1) {
      return "1h";
    } else if (difference.inMinutes >= 2) {
      return "${difference.inMinutes}m";
    } else if (difference.inMinutes >= 1) {
      return "1m";
    } else if (difference.inSeconds >= 3) {
      return "${difference.inSeconds}s";
    } else {
      return "1s";
    }
  }

  static String getPublishDateLong(DateTime date) {
    final DateTime currentTime = DateTime.now();
    final difference = currentTime.difference(date);
    initializeDateFormatting('tr_TR');
    if (difference.inDays > 365) {
      return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    } else if (difference.inDays > 8) {
      return DateFormat('d MMMM', 'tr_TR').format(date);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return "1 Week Before";
    } else if (difference.inDays >= 2) {
      return "${difference.inDays} ngày trước";
    } else if (difference.inDays >= 1) {
      return "1 Day Before";
    } else if (difference.inHours >= 2) {
      return "${difference.inHours} giờ trước";
    } else if (difference.inHours >= 1) {
      return "1 Hour Before";
    } else if (difference.inMinutes >= 2) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inMinutes >= 1) {
      return "1 Minute Before";
    } else if (difference.inSeconds >= 3) {
      return "${difference.inSeconds} giây trước";
    } else {
      return "Gần đây";
    }
  }

  static String getDateInDayMonthYearFormat(DateTime date, String divider) {
    initializeDateFormatting('tr_TR');
    return DateFormat('dd${divider}MM${divider}yyyy', 'tr_TR').format(date);
  }

  static String getDateInMinSecFormat(DateTime date) {
    String hour = date.hour.toString().length != 1
        ? date.hour.toString()
        : '0' + date.hour.toString();
    String minute = date.minute.toString().length != 1
        ? date.minute.toString()
        : '0' + date.minute.toString();

    return '$hour:$minute';
  }

  static String getCountdownTime(int countdown) {
    int minutes = countdown ~/ 60;
    int seconds = countdown - (minutes * 60);

    return seconds < 10 ? '0$minutes:0$seconds' : '0$minutes:$seconds';
  }
}
