import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/weather_provider.dart';
import '../services/theme_service.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../widgets/weather_icon.dart';
import '../widgets/error_state.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  bool _isLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    
    _animationController.forward();
    _initializeWeatherData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeWeatherData() async {
    final lastLocation = await StorageService.getLastLocation();
    
    if (lastLocation != null) {
    } else {
      await _getCurrentLocationWeather();
    }
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        // Use smart search: show cached data immediately, then refresh
        // This is automatic current location, not user-initiated
        await context.read<WeatherProvider>().smartSearchWeatherByLocation(
          location['latitude']!,
          location['longitude']!,
        );
      } else {
        // Fallback to a default city
        await context.read<WeatherProvider>().smartSearchWeather('London');
      }
    } catch (e) {
      // Fallback to a default city
      await context.read<WeatherProvider>().smartSearchWeather('London');
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  void _searchWeather() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Use smart search: show cached data immediately, then refresh
      context.read<WeatherProvider>().smartSearchWeather(query);
      _searchController.clear();
    }
  }

  void _toggleDarkMode() {
    context.read<ThemeService>().toggleDarkMode();
  }

  void _toggleTemperatureUnit() {
    context.read<ThemeService>().toggleTemperatureUnit();
  }

  void _logout() async {
    await context.read<WeatherProvider>().clearAllWeatherData();
    
    await StorageService.clearLoginState();
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<WeatherProvider, ThemeService>(
        builder: (context, weatherProvider, themeService, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: weatherProvider.currentWeather != null
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: themeService.getWeatherBackgroundGradient(
                        weatherProvider.currentWeather!.main,
                      ),
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                    ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildAppBar(themeService),
                      Expanded(
                        child: Consumer<ThemeService>(
                          builder: (context, themeService, child) {
                            return RefreshIndicator(
                              onRefresh: weatherProvider.refreshWeather,
                              color: themeService.isDarkMode ? Colors.white : Colors.black87,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    _buildSearchBar(themeService),
                                    const SizedBox(height: 24),
                                    if (weatherProvider.forecast != null && weatherProvider.forecast!.isNotEmpty)
                                      _buildForecastSection(weatherProvider, themeService),
                                    const SizedBox(height: 16),
                                    if (_isLocationLoading)
                                      _buildLoadingState()
                                    else if (weatherProvider.isLoading)
                                      _buildLoadingState()
                                    else if (weatherProvider.error != null)
                                      _buildErrorState(weatherProvider)
                                    else if (weatherProvider.currentWeather == null)
                                      _buildEmptyState()
                                    else
                                      _buildWeatherContent(weatherProvider, themeService),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good ${_getGreeting()}',
                        style: GoogleFonts.poppins(
                          color: themeService.isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Weather Dashboard',
                        style: GoogleFonts.poppins(
                          color: themeService.isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _toggleTemperatureUnit,
                      icon: Icon(
                        themeService.isCelsius ? Icons.thermostat : Icons.thermostat_outlined,
                        color: themeService.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      tooltip: 'Toggle Temperature Unit',
                    ),
                    IconButton(
                      onPressed: _toggleDarkMode,
                      icon: Icon(
                        themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: themeService.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      tooltip: 'Toggle Dark Mode',
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: Icon(
                        Icons.logout,
                        color: themeService.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildSearchBar(ThemeService themeService) {
    final isDark = themeService.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'Search city...',
              hintStyle: GoogleFonts.poppins(
                color: isDark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black87,
                size: 22,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: Icon(
                  Icons.clear,
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black87,
                  size: 20,
                ),
              )
                  : null,
              border: InputBorder.none,
            ),
            onChanged: (value) => setState(() {}),
            onSubmitted: (_) => _searchWeather(),
          ),
        ),
      ),
    );
  }


  Widget _buildLoadingState() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final isDark = themeService.isDarkMode;
        return Container(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: isDark ? Colors.white : Colors.black87,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading weather data...',
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white.withOpacity(0.8) : Colors.black87.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(WeatherProvider weatherProvider) {
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<ThemeService>(
              builder: (context, themeService, child) {
                final isDark = themeService.isDarkMode;
                return Icon(
                  Icons.error_outline,
                  size: 80,
                  color: isDark ? Colors.white.withOpacity(0.8) : Colors.black87.withOpacity(0.8),
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<ThemeService>(
              builder: (context, themeService, child) {
                final isDark = themeService.isDarkMode;
                return Text(
                  'Oops!',
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Consumer<ThemeService>(
              builder: (context, themeService, child) {
                final isDark = themeService.isDarkMode;
                return Text(
                  weatherProvider.error!,
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white.withOpacity(0.8) : Colors.black87.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<ThemeService>(
              builder: (context, themeService, child) {
                final isDark = themeService.isDarkMode;
                return ElevatedButton.icon(
                  onPressed: () => weatherProvider.refreshWeather(),
                  icon: Icon(
                    Icons.refresh,
                    color: isDark ? Colors.black87 : Colors.white,
                  ),
                  label: Text(
                    'Try Again',
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black87,
                    foregroundColor: isDark ? Colors.black87 : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 80,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Search for a city to get weather information',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherProvider weatherProvider, ThemeService themeService) {
    final weather = weatherProvider.currentWeather!;
    final temperature = WeatherService.convertTemperature(
      weather.temperature,
      themeService.isCelsius,
    );
    final unit = WeatherService.getTemperatureUnit(themeService.isCelsius);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Current Weather Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: themeService.isDarkMode 
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeService.isDarkMode 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${weather.cityName}, ${weather.country}',
                  style: GoogleFonts.poppins(
                    color: themeService.isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  weather.description.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: themeService.isDarkMode 
                        ? Colors.white.withOpacity(0.9)
                        : Colors.black.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 30),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherIconWidget(
                      iconCode: weather.icon,
                      size: 80,
                      color: themeService.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        '${temperature.toStringAsFixed(0)}$unit',
                        style: GoogleFonts.poppins(
                          color: themeService.isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Feels like ${WeatherService.convertTemperature(weather.feelsLike, themeService.isCelsius).toStringAsFixed(0)}$unit',
                  style: GoogleFonts.poppins(
                    color: themeService.isDarkMode 
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                  themeService: themeService,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDetailCard(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  themeService: themeService,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required ThemeService themeService,
  }) {
    final isDark = themeService.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isDark ? Colors.white : Colors.black87,
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: isDark 
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection(WeatherProvider weatherProvider, ThemeService themeService) {
    final forecasts = weatherProvider.fiveDayForecast;
    
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 20),
      child: SizedBox(
        height: 75,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: forecasts.length,
          itemBuilder: (context, index) {
            final forecast = forecasts[index];
            return _buildForecastCard(forecast, themeService);
          },
        ),
      ),
    );
  }

  Widget _buildForecastCard(forecast, ThemeService themeService) {
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
    final isDark = themeService.isDarkMode;
    
    return Container(
      width: 65,
      height: 75,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayName,
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          WeatherIconWidget(
            iconCode: forecast.icon,
            size: 20,
            color: isDark ? Colors.white : Colors.black87,
          ),
          
          Text(
            '${maxTemp.toStringAsFixed(0)}$unit',
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }
}
