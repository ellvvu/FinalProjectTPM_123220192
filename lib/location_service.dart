import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocationService {
  static bool _timeZonesInitialized = false;

  static Future<void> initTimeZones() async {
    try {
      if (!_timeZonesInitialized) {
        tz_data.initializeTimeZones();
        _timeZonesInitialized = true;
      }
      
      final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
      final location = tz.getLocation(timeZoneName);
      tz.setLocalLocation(location);
    } catch (e) {
      print('Error initializing timezones: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  static Future<String> getNearestCity() async {
    try {
      final position = await getCurrentPosition();
      // Implement your reverse geocoding logic here
      return 'Lat: ${position.latitude}, Lon: ${position.longitude}';
    } catch (e) {
      return 'Location unavailable';
    }
  }

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }
}