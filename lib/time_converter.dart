import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class TimeConverter {
  static String convertToLocalTime(DateTime utcTime, BuildContext context) {
    try {
      final localTime = tz.TZDateTime.from(utcTime, tz.local);
      return TimeOfDay.fromDateTime(localTime).format(context);
    } catch (e) {
      return utcTime.toLocal().toString();
    }
  }

  static String getCurrentTimeForCity(String cityId) {
    try {
      final location = tz.getLocation(cityId);
      return tz.TZDateTime.now(location).toString();
    } catch (e) {
      return 'Time zone not available';
    }
  }

  static List<String> getPopularTimeZones() {
    return [
      'Europe/London',
      'America/New_York', 
      'Asia/Tokyo',
      'Australia/Sydney',
      'Europe/Paris',
      'UTC'  // Tambahkan UTC jika diperlukan
    ];
  }
}