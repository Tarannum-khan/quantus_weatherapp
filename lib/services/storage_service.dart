import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _lastCityKey = 'last_searched_city';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _isCelsiusKey = 'is_celsius';
  static const String _lastWeatherDataKey = 'last_weather_data';
  static const String _lastForecastDataKey = 'last_forecast_data';
  static const String _lastWeatherTimestampKey = 'last_weather_timestamp';
  static const String _lastForecastTimestampKey = 'last_forecast_timestamp';
  static const String _lastLocationLatKey = 'last_location_lat';
  static const String _lastLocationLngKey = 'last_location_lng';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  // Get last searched city
  static Future<String?> getLastSearchedCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastCityKey);
    } catch (e) {
      return null;
    }
  }

  // Save last searched city
  static Future<bool> saveLastSearchedCity(String cityName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_lastCityKey, cityName);
    } catch (e) {
      return false;
    }
  }

  // Get dark mode preference
  static Future<bool> getIsDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isDarkModeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Save dark mode preference
  static Future<bool> saveIsDarkMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_isDarkModeKey, isDarkMode);
    } catch (e) {
      return false;
    }
  }

  // Get temperature unit preference
  static Future<bool> getIsCelsius() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isCelsiusKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  // Save temperature unit preference
  static Future<bool> saveIsCelsius(bool isCelsius) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_isCelsiusKey, isCelsius);
    } catch (e) {
      return false;
    }
  }

  // Save last weather data with timestamp
  static Future<bool> saveLastWeatherData(String weatherJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setString(_lastWeatherDataKey, weatherJson);
      await prefs.setInt(_lastWeatherTimestampKey, timestamp);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get last weather data
  static Future<String?> getLastWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastWeatherDataKey);
    } catch (e) {
      return null;
    }
  }

  // Save last forecast data with timestamp
  static Future<bool> saveLastForecastData(String forecastJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setString(_lastForecastDataKey, forecastJson);
      await prefs.setInt(_lastForecastTimestampKey, timestamp);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get last forecast data
  static Future<String?> getLastForecastData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastForecastDataKey);
    } catch (e) {
      return null;
    }
  }

  // Clear all stored data
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      return false;
    }
  }

  // Clear only weather data (keep preferences)
  static Future<bool> clearWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastWeatherDataKey);
      await prefs.remove(_lastForecastDataKey);
      await prefs.remove(_lastWeatherTimestampKey);
      await prefs.remove(_lastForecastTimestampKey);
      await prefs.remove(_lastLocationLatKey);
      await prefs.remove(_lastLocationLngKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if cached weather data is fresh (less than 10 minutes old)
  static Future<bool> isWeatherDataFresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastWeatherTimestampKey);
      if (timestamp == null) return false;
      
      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(lastUpdate);
      
      // Consider data fresh if it's less than 10 minutes old
      return difference.inMinutes < 10;
    } catch (e) {
      return false;
    }
  }

  // Check if cached forecast data is fresh (less than 30 minutes old)
  static Future<bool> isForecastDataFresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastForecastTimestampKey);
      if (timestamp == null) return false;
      
      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(lastUpdate);
      
      // Consider forecast data fresh if it's less than 30 minutes old
      return difference.inMinutes < 30;
    } catch (e) {
      return false;
    }
  }

  // Save last location coordinates
  static Future<bool> saveLastLocation(double latitude, double longitude) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_lastLocationLatKey, latitude);
      await prefs.setDouble(_lastLocationLngKey, longitude);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get last location coordinates
  static Future<Map<String, double>?> getLastLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble(_lastLocationLatKey);
      final lng = prefs.getDouble(_lastLocationLngKey);
      
      if (lat != null && lng != null) {
        return {'latitude': lat, 'longitude': lng};
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if we have cached data (either weather or forecast)
  static Future<bool> hasCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final weatherData = prefs.getString(_lastWeatherDataKey);
      final forecastData = prefs.getString(_lastForecastDataKey);
      return weatherData != null || forecastData != null;
    } catch (e) {
      return false;
    }
  }

  // Login state management
  static Future<bool> saveLoginState(String userEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, userEmail);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getLoggedInUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> clearLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userEmailKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Clear all data including login state (for complete logout)
  static Future<bool> clearAllUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

}


