import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_response.dart';
import '../config/api_config.dart';

class WeatherService {
  static const String _baseUrl = ApiConfig.baseUrl;
  static const String _apiKey = ApiConfig.openWeatherMapApiKey;
  
  // Get current weather by city name
  static Future<WeatherResponse> getCurrentWeather(String cityName) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        return WeatherResponse.error('API key not configured. Please add your OpenWeatherMap API key in lib/config/api_config.dart');
      }
      
      final url = Uri.parse(
        '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric',
      );
      
      
      final response = await http.get(url);
      
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherResponse.fromCurrentWeatherJson(data);
      } else if (response.statusCode == 401) {
        return WeatherResponse.error('Invalid API key. Please check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        return WeatherResponse.error('City not found. Please check the spelling.');
      } else if (response.statusCode == 429) {
        return WeatherResponse.error('API rate limit exceeded. Please try again later.');
      } else {
        return WeatherResponse.error('Failed to fetch weather data (${response.statusCode}). Please try again.');
      }
    } catch (e) {
      return WeatherResponse.error('Network error: ${e.toString()}');
    }
  }

  // Get current weather by coordinates
  static Future<WeatherResponse> getCurrentWeatherByLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        return WeatherResponse.error('API key not configured. Please add your OpenWeatherMap API key in lib/config/api_config.dart');
      }
      
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
      );
      
      
      final response = await http.get(url);
      
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherResponse.fromCurrentWeatherJson(data);
      } else if (response.statusCode == 401) {
        return WeatherResponse.error('Invalid API key. Please check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        return WeatherResponse.error('Location not found. Please try again.');
      } else if (response.statusCode == 429) {
        return WeatherResponse.error('API rate limit exceeded. Please try again later.');
      } else {
        return WeatherResponse.error('Failed to fetch weather data (${response.statusCode}). Please try again.');
      }
    } catch (e) {
      return WeatherResponse.error('Network error: ${e.toString()}');
    }
  }

  // Get 5-day forecast by city name
  static Future<WeatherResponse> getForecast(String cityName) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        return WeatherResponse.error('API key not configured. Please add your OpenWeatherMap API key in lib/config/api_config.dart');
      }
      
      final url = Uri.parse(
        '$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=metric',
      );
      
      
      final response = await http.get(url);
      
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherResponse.fromForecastJson(data);
      } else if (response.statusCode == 401) {
        return WeatherResponse.error('Invalid API key. Please check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        return WeatherResponse.error('City not found. Please check the spelling.');
      } else if (response.statusCode == 429) {
        return WeatherResponse.error('API rate limit exceeded. Please try again later.');
      } else {
        return WeatherResponse.error('Failed to fetch forecast data (${response.statusCode}). Please try again.');
      }
    } catch (e) {
      return WeatherResponse.error('Network error: ${e.toString()}');
    }
  }

  // Get 5-day forecast by coordinates
  static Future<WeatherResponse> getForecastByLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        return WeatherResponse.error('API key not configured. Please add your OpenWeatherMap API key in lib/config/api_config.dart');
      }
      
      final url = Uri.parse(
        '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
      );
      
      
      final response = await http.get(url);
      
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherResponse.fromForecastJson(data);
      } else if (response.statusCode == 401) {
        return WeatherResponse.error('Invalid API key. Please check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        return WeatherResponse.error('Location not found. Please try again.');
      } else if (response.statusCode == 429) {
        return WeatherResponse.error('API rate limit exceeded. Please try again later.');
      } else {
        return WeatherResponse.error('Failed to fetch forecast data (${response.statusCode}). Please try again.');
      }
    } catch (e) {
      return WeatherResponse.error('Network error: ${e.toString()}');
    }
  }

  // Convert temperature based on unit
  static double convertTemperature(double temp, bool isCelsius) {
    if (isCelsius) {
      return temp;
    } else {
      return (temp * 9 / 5) + 32;
    }
  }

  // Get temperature unit symbol
  static String getTemperatureUnit(bool isCelsius) {
    return isCelsius ? '°C' : '°F';
  }

  // Get wind speed unit
  static String getWindSpeedUnit(bool isMetric) {
    return isMetric ? 'm/s' : 'mph';
  }
}
