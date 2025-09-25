import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'storage_service.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isCelsius = true;

  bool get isDarkMode => _isDarkMode;
  bool get isCelsius => _isCelsius;

  ThemeService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _isDarkMode = await StorageService.getIsDarkMode();
    _isCelsius = await StorageService.getIsCelsius();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.saveIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> toggleTemperatureUnit() async {
    _isCelsius = !_isCelsius;
    await StorageService.saveIsCelsius(_isCelsius);
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
    );
  }

  // Weather condition colors
  Color getWeatherConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return _isDarkMode ? Colors.yellow[300]! : Colors.orange[400]!;
      case 'sunny':
        return _isDarkMode ? Colors.yellow[300]! : Colors.orange[400]!;
      case 'clouds':
        return _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
      case 'rain':
        return _isDarkMode ? Colors.blue[300]! : Colors.blue[600]!;
      case 'drizzle':
        return _isDarkMode ? Colors.blue[300]! : Colors.blue[500]!;
      case 'thunderstorm':
        return _isDarkMode ? Colors.purple[300]! : Colors.purple[600]!;
      case 'snow':
        return _isDarkMode ? Colors.blue[100]! : Colors.blue[200]!;
      case 'mist':
        return _isDarkMode ? Colors.grey[300]! : Colors.grey[500]!;
      case 'fog':
        return _isDarkMode ? Colors.grey[300]! : Colors.grey[500]!;
      case 'haze':
        return _isDarkMode ? Colors.grey[300]! : Colors.grey[500]!;
      default:
        return _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    }
  }

  // Background gradient colors based on weather condition
  List<Color> getWeatherBackgroundGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return _isDarkMode
            ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
            : [const Color(0xFF87CEEB), const Color(0xFF98D8E8)];
      case 'clouds':
        return _isDarkMode
            ? [const Color(0xFF2c2c54), const Color(0xFF40407a)]
            : [const Color(0xFFB0C4DE), const Color(0xFFD3D3D3)];
      case 'rain':
      case 'drizzle':
        return _isDarkMode
            ? [const Color(0xFF1a1a2e), const Color(0xFF0f3460)]
            : [const Color(0xFF4682B4), const Color(0xFF87CEEB)];
      case 'thunderstorm':
        return _isDarkMode
            ? [const Color(0xFF0f0f23), const Color(0xFF1a1a2e)]
            : [const Color(0xFF9370DB), const Color(0xFFBA55D3)];
      case 'snow':
        return _isDarkMode
            ? [const Color(0xFF2c2c54), const Color(0xFF40407a)]
            : [const Color(0xFFF0F8FF), const Color(0xFFE6E6FA)];
      case 'mist':
      case 'fog':
      case 'haze':
        return _isDarkMode
            ? [const Color(0xFF2c2c54), const Color(0xFF40407a)]
            : [const Color(0xFFD3D3D3), const Color(0xFFF5F5F5)];
      default:
        return _isDarkMode
            ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
            : [const Color(0xFF87CEEB), const Color(0xFF98D8E8)];
    }
  }
}
