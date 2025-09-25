import '../models/weather.dart';
import '../models/forecast.dart';
import '../models/weather_response.dart';

class DemoWeatherService {
  // Demo weather data for testing without API key
  static WeatherResponse getDemoCurrentWeather() {
    final demoWeather = Weather(
      cityName: 'London',
      country: 'GB',
      temperature: 22.5,
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 3.2,
      description: 'partly cloudy',
      main: 'Clouds',
      icon: '02d',
      dateTime: DateTime.now(),
    );
    
    return WeatherResponse(
      currentWeather: demoWeather,
      error: null,
    );
  }

  static WeatherResponse getDemoForecast() {
    final demoForecasts = [
      Forecast(
        date: DateTime.now().add(const Duration(days: 1)),
        minTemp: 18.0,
        maxTemp: 25.0,
        description: 'sunny',
        main: 'Clear',
        icon: '01d',
        humidity: 60,
        windSpeed: 2.5,
      ),
      Forecast(
        date: DateTime.now().add(const Duration(days: 2)),
        minTemp: 16.0,
        maxTemp: 23.0,
        description: 'light rain',
        main: 'Rain',
        icon: '10d',
        humidity: 75,
        windSpeed: 4.1,
      ),
      Forecast(
        date: DateTime.now().add(const Duration(days: 3)),
        minTemp: 19.0,
        maxTemp: 26.0,
        description: 'partly cloudy',
        main: 'Clouds',
        icon: '02d',
        humidity: 55,
        windSpeed: 2.8,
      ),
      Forecast(
        date: DateTime.now().add(const Duration(days: 4)),
        minTemp: 17.0,
        maxTemp: 24.0,
        description: 'overcast',
        main: 'Clouds',
        icon: '04d',
        humidity: 70,
        windSpeed: 3.5,
      ),
      Forecast(
        date: DateTime.now().add(const Duration(days: 5)),
        minTemp: 20.0,
        maxTemp: 27.0,
        description: 'sunny',
        main: 'Clear',
        icon: '01d',
        humidity: 50,
        windSpeed: 2.0,
      ),
    ];
    
    return WeatherResponse(
      forecast: demoForecasts,
      error: null,
    );
  }

  static WeatherResponse getDemoError() {
    return WeatherResponse.error(
      'Demo Mode: Please configure your OpenWeatherMap API key to get real weather data.\n\n'
      '1. Get a free API key from https://openweathermap.org/api\n'
      '2. Replace YOUR_API_KEY_HERE in lib/config/api_config.dart\n'
      '3. Restart the app',
    );
  }
}


