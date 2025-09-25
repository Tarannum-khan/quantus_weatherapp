# 🌤️ Quintus Weather App

A beautiful, modern weather application built with Flutter that provides real-time weather information and 5-day forecasts with a stunning UI and comprehensive theme system.

## ✨ Features

### Core Functionality
- **Real-time Weather Data**: Current weather conditions with temperature, humidity, wind speed
- **5-Day Forecast**: Integrated forecast display with daily weather predictions
- **City Search**: Search for weather in any city worldwide
- **Pull-to-Refresh**: Refresh weather data with a simple pull gesture
- **Offline Support**: Cached weather data for offline viewing

### Advanced Features
- **Dark/Light Theme**: Beautiful theme system with persistent preferences
- **Temperature Units**: Toggle between Celsius and Fahrenheit
- **Weather Icons**: Dynamic weather icons based on conditions
- **Responsive Design**: Optimized for all screen sizes
- **Error Handling**: Comprehensive error states with retry functionality
- **Local Storage**: Persistent settings and last searched city

### UI/UX Highlights
- **Modern Design**: Clean, minimalist interface with transparent cards
- **Weather-based Backgrounds**: Dynamic gradient backgrounds based on weather conditions
- **Smooth Animations**: Elegant transitions and loading states
- **Consistent Theming**: All elements follow the selected theme
- **Intuitive Navigation**: Easy-to-use interface with clear visual hierarchy

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code
- OpenWeatherMap API Key (free)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd quintus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **API Key Setup**
   - Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Open `lib/config/api_config.dart`
   - Replace `YOUR_API_KEY` with your actual API key:
   ```dart
   class ApiConfig {
     static const String apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
     static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
   }
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Light Mode
- Clean, bright interface with weather-based gradients
- Transparent cards with subtle shadows
- Easy-to-read typography

### Dark Mode
- Elegant dark theme with consistent theming
- Reduced eye strain for night usage
- Beautiful contrast and readability

## 🏗️ Project Structure

```
lib/
├── config/
│   └── api_config.dart          # API configuration
├── models/
│   ├── weather.dart            # Weather data model
│   ├── forecast.dart           # Forecast data model
│   └── weather_response.dart   # API response model
├── screens/
│   ├── dashboard_screen.dart   # Main weather screen
│   ├── forecast_screen.dart    # Forecast display (integrated)
│   └── login_screen.dart       # Authentication screen
├── services/
│   ├── weather_service.dart    # Weather API service
│   ├── weather_provider.dart   # Weather state management
│   ├── theme_service.dart      # Theme management
│   └── storage_service.dart    # Local storage service
└── widgets/
    ├── weather_icon.dart       # Weather icon widget
    └── error_state.dart        # Error state widget
```

## 🔧 Configuration

### API Configuration
The app uses OpenWeatherMap API for weather data. Configure your API key in `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String apiKey = 'your_api_key_here';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
}
```

### Theme Configuration
The app includes a comprehensive theme system with:
- Light and dark modes
- Weather-based background gradients
- Consistent color schemes
- Persistent theme preferences

## 📦 Building for Production

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle (Recommended for Play Store)
```bash
flutter build appbundle --release
```

The built APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Provider**: State management
- **SharedPreferences**: Local storage
- **HTTP**: API communication
- **Google Fonts**: Typography
- **OpenWeatherMap API**: Weather data source

## 📋 Features Checklist

### ✅ Core Requirements
- [x] Search bar for city input
- [x] Current weather display (temperature, condition, location)
- [x] 5-day forecast display
- [x] Error/empty state handling
- [x] Loading indicators
- [x] Pull-to-refresh functionality
- [x] Local storage for last searched city

### ✅ Extra Features
- [x] Weather icons based on conditions
- [x] Temperature unit toggle (Celsius/Fahrenheit)
- [x] Dark mode toggle
- [x] Persistent theme preferences
- [x] Weather-based background gradients
- [x] Responsive design
- [x] Smooth animations
- [x] Comprehensive error handling

## 🐛 Troubleshooting

### Common Issues

1. **API Key Error**
   - Ensure your OpenWeatherMap API key is valid
   - Check that the API key is properly set in `api_config.dart`

2. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Ensure Flutter SDK is up to date

3. **Permission Issues**
   - For location services, ensure location permissions are granted
   - Check Android manifest for required permissions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for weather data API
- [Flutter](https://flutter.dev/) for the amazing framework
- [Google Fonts](https://fonts.google.com/) for beautiful typography

## 📞 Support

For support or questions, please open an issue in the repository or contact the development team.

---

**Built with ❤️ using Flutter**# quantus_weatherapp
