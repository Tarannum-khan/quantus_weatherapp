# 🔑 API Key Setup Guide

## Quick Setup Instructions

### 1. Get Your Free API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Go to "API Keys" section
4. Copy your API key

### 2. Configure the App
1. Open `lib/config/api_config.dart`
2. Replace `YOUR_API_KEY` with your actual API key:

```dart
class ApiConfig {
  static const String apiKey = 'your_actual_api_key_here';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
}
```

### 3. Save and Run
1. Save the file
2. Run `flutter run` to test the app

## Important Notes
- **Free tier**: 1,000 API calls per day
- **Rate limit**: 60 calls per minute
- **No credit card required** for free tier

## Troubleshooting
- If you get "Invalid API key" error, double-check your key
- Make sure there are no extra spaces in the API key
- Wait a few minutes after creating your API key before using it

---
**That's it! Your weather app is ready to use! 🌤️**
