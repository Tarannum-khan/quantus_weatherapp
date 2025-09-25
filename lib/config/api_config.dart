class ApiConfig {
  // Replace this with your OpenWeatherMap API key
  // Get your free API key from: https://openweathermap.org/api
  static const String openWeatherMapApiKey = '403b91f6ffd27d80f8afea1938187f7c';
  
  // API Configuration
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String units = 'metric'; // metric for Celsius, imperial for Fahrenheit
  static const String language = 'en';
  
  // Rate limiting
  static const int maxRequestsPerDay = 1000; // Free tier limit
  static const Duration requestTimeout = Duration(seconds: 10);
  
  // Cache settings
  static const Duration cacheExpiration = Duration(minutes: 10);
  static const int maxCacheSize = 50; // Maximum number of cached weather entries
}
