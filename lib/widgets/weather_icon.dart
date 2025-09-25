import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final String iconCode;
  final double size;
  final Color color;

  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    this.size = 50,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Map OpenWeatherMap icon codes to Material Icons or custom icons
    IconData iconData = _getIconData(iconCode);
    
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }

  IconData _getIconData(String iconCode) {
    // Map OpenWeatherMap icon codes to Flutter Material Icons
    switch (iconCode) {
      // Clear sky
      case '01d': // clear sky day
      case '01n': // clear sky night
        return Icons.wb_sunny;
      
      // Few clouds
      case '02d': // few clouds day
      case '02n': // few clouds night
        return Icons.wb_cloudy;
      
      // Scattered clouds
      case '03d': // scattered clouds day
      case '03n': // scattered clouds night
        return Icons.cloud;
      
      // Broken clouds
      case '04d': // broken clouds day
      case '04n': // broken clouds night
        return Icons.cloud_queue;
      
      // Shower rain
      case '09d': // shower rain day
      case '09n': // shower rain night
        return Icons.grain;
      
      // Rain
      case '10d': // rain day
      case '10n': // rain night
        return Icons.beach_access;
      
      // Thunderstorm
      case '11d': // thunderstorm day
      case '11n': // thunderstorm night
        return Icons.flash_on;
      
      // Snow
      case '13d': // snow day
      case '13n': // snow night
        return Icons.ac_unit;
      
      // Mist
      case '50d': // mist day
      case '50n': // mist night
        return Icons.blur_on;
      
      // Default
      default:
        return Icons.wb_sunny;
    }
  }
}
