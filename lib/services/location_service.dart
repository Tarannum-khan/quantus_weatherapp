import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<bool> _checkLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    }
    
    return false;
  }

  static Future<bool> _isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      // Check if location service is enabled
      final serviceEnabled = await _isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check location permission
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permissions are denied');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getCityNameFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return placemark.locality ?? placemark.administrativeArea;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, double>?> getCurrentLocation() async {
    try {
      final position = await getCurrentPosition();
      if (position != null) {
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getCurrentCityName() async {
    try {
      final position = await getCurrentPosition();
      if (position != null) {
        return await getCityNameFromPosition(position);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}


