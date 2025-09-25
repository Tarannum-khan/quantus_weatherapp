import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import 'weather_service.dart';
import 'storage_service.dart';
import 'demo_weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _currentWeather;
  List<Forecast>? _forecast;
  String? _error;
  bool _isLoading = false;
  String _lastSearchedCity = '';

  Weather? get currentWeather => _currentWeather;
  List<Forecast>? get forecast => _forecast;
  String? get error => _error;
  bool get isLoading => _isLoading;
  String get lastSearchedCity => _lastSearchedCity;

  WeatherProvider() {
    _loadLastSearchedCity();
    _initializeWithCachedData();
  }

  Future<void> _loadLastSearchedCity() async {
    _lastSearchedCity = await StorageService.getLastSearchedCity() ?? '';
    notifyListeners();
  }

  Future<void> _initializeWithCachedData() async {
    try {
      await loadCachedWeather();
      
      final hasFreshWeather = await StorageService.isWeatherDataFresh();
      final hasFreshForecast = await StorageService.isForecastDataFresh();
      
      if (!hasFreshWeather || !hasFreshForecast) {
        await _refreshInBackground();
      }
    } catch (e) {
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      final lastLocation = await StorageService.getLastLocation();
      if (lastLocation != null) {
        await searchWeatherByLocation(
          lastLocation['latitude']!,
          lastLocation['longitude']!,
        );
      } else if (_lastSearchedCity.isNotEmpty) {
        await searchWeather(_lastSearchedCity);
      }
    } catch (e) {
    }
  }

  Future<void> searchWeather(String cityName) async {
    if (cityName.trim().isEmpty) return;

    _setLoading(true);
    _clearError();

    try {
      final weatherResponse = await WeatherService.getCurrentWeather(cityName);
      
      if (weatherResponse.hasError) {
        if (weatherResponse.error!.contains('API key not configured')) {
          _setError(weatherResponse.error!);
          _setLoading(false);
          return;
        }
        _setError(weatherResponse.error!);
        _setLoading(false);
        return;
      }

      if (weatherResponse.hasCurrentWeather) {
        _currentWeather = weatherResponse.currentWeather;
        await StorageService.saveLastSearchedCity(cityName);
        await StorageService.saveLastWeatherData(
          jsonEncode(_currentWeather!.toJson()),
        );
        
        if (_currentWeather!.latitude != null && _currentWeather!.longitude != null) {
          await StorageService.saveLastLocation(
            _currentWeather!.latitude!,
            _currentWeather!.longitude!,
          );
        }
        
        _lastSearchedCity = cityName;
      }

      final forecastResponse = await WeatherService.getForecast(cityName);
      
      if (forecastResponse.hasError) {
        if (weatherResponse.hasCurrentWeather) {
          _setError('Current weather loaded, but forecast unavailable');
        } else {
          _setError(forecastResponse.error!);
        }
      } else if (forecastResponse.hasForecast) {
        _forecast = forecastResponse.forecast;
        await StorageService.saveLastForecastData(
          jsonEncode(_forecast!.map((f) => f.toJson()).toList()),
        );
      }

    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
    }

    _setLoading(false);
  }

  Future<void> searchWeatherByLocation(double latitude, double longitude) async {
    _setLoading(true);
    _clearError();

    try {
      final weatherResponse = await WeatherService.getCurrentWeatherByLocation(
        latitude,
        longitude,
      );
      
      if (weatherResponse.hasError) {
        if (weatherResponse.error!.contains('API key not configured')) {
          _setError(weatherResponse.error!);
          _setLoading(false);
          return;
        }
        _setError(weatherResponse.error!);
        _setLoading(false);
        return;
      }

      if (weatherResponse.hasCurrentWeather) {
        _currentWeather = weatherResponse.currentWeather;
        await StorageService.saveLastSearchedCity(_currentWeather!.cityName);
        await StorageService.saveLastWeatherData(
          jsonEncode(_currentWeather!.toJson()),
        );
            await StorageService.saveLastLocation(latitude, longitude);
        
        _lastSearchedCity = _currentWeather!.cityName;
        notifyListeners();
      }

      final forecastResponse = await WeatherService.getForecastByLocation(
        latitude,
        longitude,
      );
      
      if (forecastResponse.hasError) {
        if (weatherResponse.hasCurrentWeather) {
        } else {
          _setError(forecastResponse.error!);
        }
      } else if (forecastResponse.hasForecast) {
        _forecast = forecastResponse.forecast;
        await StorageService.saveLastForecastData(
          jsonEncode(_forecast!.map((f) => f.toJson()).toList()),
        );
        notifyListeners();
      }

    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
    }

    _setLoading(false);
  }

  Future<void> smartSearchWeather(String cityName) async {
    if (cityName.trim().isEmpty) return;

    await loadCachedWeather();
    
    await searchWeather(cityName);
  }

  Future<void> smartSearchWeatherByLocation(double latitude, double longitude) async {
    await loadCachedWeather();
    
    await searchWeatherByLocation(latitude, longitude);
  }

  Future<void> refreshWeather() async {
    if (_lastSearchedCity.isNotEmpty) {
      await searchWeather(_lastSearchedCity);
    }
  }

  Future<void> loadCachedWeather() async {
    try {
      final weatherData = await StorageService.getLastWeatherData();
      final forecastData = await StorageService.getLastForecastData();
      final lastCity = await StorageService.getLastSearchedCity();

      if (weatherData != null && weatherData.isNotEmpty) {
        try {
          final weatherJson = jsonDecode(weatherData);
          _currentWeather = Weather.fromJson(weatherJson);
          
          if (_currentWeather != null && _currentWeather!.cityName.isNotEmpty) {
            _lastSearchedCity = _currentWeather!.cityName;
          } else if (lastCity != null && lastCity.isNotEmpty) {
            _lastSearchedCity = lastCity;
          } else {
            _currentWeather = null;
          }
        } catch (e) {
          _currentWeather = null;
          if (lastCity != null && lastCity.isNotEmpty) {
            _lastSearchedCity = lastCity;
          }
        }
      } else if (lastCity != null && lastCity.isNotEmpty) {
        _lastSearchedCity = lastCity;
      }

      if (forecastData != null && forecastData.isNotEmpty) {
        try {
          final forecastJson = jsonDecode(forecastData);
          _forecast = (forecastJson as List)
              .map((f) => Forecast.fromJson(f))
              .toList();
        } catch (e) {
          _forecast = null;
        }
      }

      notifyListeners();
    } catch (e) {
      _currentWeather = null;
      _forecast = null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearWeather() {
    _currentWeather = null;
    _forecast = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearAllWeatherData() async {
    clearWeather();
    await StorageService.clearWeatherData();
    _lastSearchedCity = '';
  }

  List<Forecast> get fiveDayForecast {
    if (_forecast == null || _forecast!.isEmpty) return [];

    List<Forecast> dailyForecasts = [];
    DateTime currentDate = DateTime.now();
    
    for (int i = 0; i < 5; i++) {
      DateTime targetDate = currentDate.add(Duration(days: i));
      
      Forecast? bestForecast;
      for (var forecast in _forecast!) {
        if (forecast.date.day == targetDate.day &&
            forecast.date.month == targetDate.month &&
            forecast.date.year == targetDate.year) {
          if (bestForecast == null ||
              (forecast.date.hour - 12).abs() < (bestForecast.date.hour - 12).abs()) {
            bestForecast = forecast;
          }
        }
      }
      
      if (bestForecast != null) {
        dailyForecasts.add(bestForecast);
      }
    }
    
    return dailyForecasts;
  }
}
