import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/weather_provider.dart';
import '../services/theme_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_icon.dart';
import '../widgets/error_state.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
        actions: [
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return IconButton(
                onPressed: () => themeService.toggleTemperatureUnit(),
                icon: Icon(
                  themeService.isCelsius ? Icons.thermostat : Icons.thermostat_outlined,
                ),
                tooltip: 'Toggle Temperature Unit',
              );
            },
          ),
        ],
      ),
      body: Consumer2<WeatherProvider, ThemeService>(
        builder: (context, weatherProvider, themeService, child) {
          return RefreshIndicator(
            onRefresh: weatherProvider.refreshWeather,
            child: weatherProvider.isLoading
                ? const LoadingState(message: 'Loading forecast...')
                : weatherProvider.error != null
                    ? ErrorState(
                        message: weatherProvider.error!,
                        onRetry: () => weatherProvider.refreshWeather(),
                      )
                    : weatherProvider.forecast == null || weatherProvider.forecast!.isEmpty
                        ? const EmptyState(
                            message: 'No forecast data available',
                            subtitle: 'Try searching for a city first',
                          )
                        : _buildForecastList(weatherProvider, themeService),
          );
        },
      ),
    );
  }

  Widget _buildForecastList(WeatherProvider weatherProvider, ThemeService themeService) {
    final forecasts = weatherProvider.fiveDayForecast;
    
    if (forecasts.isEmpty) {
      return const EmptyState(
        message: 'No forecast data available',
        subtitle: 'Try refreshing or searching for a different city',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: forecasts.length,
      itemBuilder: (context, index) {
        final forecast = forecasts[index];
        return _buildForecastCard(forecast, themeService, context);
      },
    );
  }

  Widget _buildForecastCard(forecast, ThemeService themeService, BuildContext context) {
    final minTemp = WeatherService.convertTemperature(
      forecast.minTemp,
      themeService.isCelsius,
    );
    final maxTemp = WeatherService.convertTemperature(
      forecast.maxTemp,
      themeService.isCelsius,
    );
    final unit = WeatherService.getTemperatureUnit(themeService.isCelsius);
    
    final dayName = _getDayName(forecast.date);
    final condition = forecast.main.toLowerCase();
    final isDark = themeService.isDarkMode;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeService.getWeatherBackgroundGradient(condition),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Day and date
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${forecast.date.day}/${forecast.date.month}',
                    style: GoogleFonts.poppins(
                      color: isDark 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Weather icon
            Expanded(
              flex: 1,
              child: WeatherIconWidget(
                iconCode: forecast.icon,
                size: 48,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            
            // Temperature range
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${maxTemp.toStringAsFixed(0)}$unit',
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${minTemp.toStringAsFixed(0)}$unit',
                    style: GoogleFonts.poppins(
                      color: isDark 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            // Weather description
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    forecast.description.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: isDark 
                          ? Colors.white.withOpacity(0.9)
                          : Colors.black.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 14,
                        color: isDark 
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withOpacity(0.7),
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${forecast.humidity}%',
                          style: GoogleFonts.poppins(
                            color: isDark 
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black.withOpacity(0.7),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.air,
                        size: 14,
                        color: isDark 
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withOpacity(0.7),
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${forecast.windSpeed.toStringAsFixed(1)} m/s',
                          style: GoogleFonts.poppins(
                            color: isDark 
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black.withOpacity(0.7),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate = DateTime(date.year, date.month, date.day);
    
    if (forecastDate == today) {
      return 'Today';
    } else if (forecastDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    }
  }
}
