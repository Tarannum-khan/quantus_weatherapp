import 'weather.dart';
import 'forecast.dart';

class WeatherResponse {
  final Weather? currentWeather;
  final List<Forecast>? forecast;
  final String? error;

  WeatherResponse({
    this.currentWeather,
    this.forecast,
    this.error,
  });

  factory WeatherResponse.fromCurrentWeatherJson(Map<String, dynamic> json) {
    try {
      return WeatherResponse(
        currentWeather: Weather.fromJson(json),
        error: null,
      );
    } catch (e) {
      return WeatherResponse(
        error: 'Failed to parse current weather data: $e',
      );
    }
  }

  factory WeatherResponse.fromForecastJson(Map<String, dynamic> json) {
    try {
      List<Forecast> forecastList = [];
      if (json['list'] != null) {
        for (var item in json['list']) {
          forecastList.add(Forecast.fromJson(item));
        }
      }
      return WeatherResponse(
        forecast: forecastList,
        error: null,
      );
    } catch (e) {
      return WeatherResponse(
        error: 'Failed to parse forecast data: $e',
      );
    }
  }

  factory WeatherResponse.error(String errorMessage) {
    return WeatherResponse(
      error: errorMessage,
    );
  }

  bool get hasError => error != null;
  bool get hasCurrentWeather => currentWeather != null;
  bool get hasForecast => forecast != null && forecast!.isNotEmpty;
}


