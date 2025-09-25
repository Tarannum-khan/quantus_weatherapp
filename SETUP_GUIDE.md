# Weather App Setup Guide

## Quick Setup (5 minutes)

### Step 1: Get Free API Key
1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Click "Sign Up" to create a free account
3. Verify your email address
4. Go to "API Keys" section
5. Copy your API key (it looks like: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`)

### Step 2: Configure API Key
1. Open `lib/config/api_config.dart`
2. Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```dart
   static const String openWeatherMapApiKey = 'your_actual_api_key_here';
   ```

### Step 3: Run the App
```bash
flutter run
```

## Troubleshooting

### "API key not configured" Error
- Make sure you've replaced `YOUR_API_KEY_HERE` with your actual API key
- Check that there are no extra spaces or quotes around the key

### "Invalid API key" Error
- Verify your API key is correct
- Make sure your OpenWeatherMap account is activated
- Check if you've exceeded the free tier limit (1000 calls/day)

### "Network error" Error
- Check your internet connection
- Make sure you're not behind a corporate firewall
- Try again in a few minutes

### Location Permission Issues
- Make sure location permissions are granted
- Try searching for a city manually if location fails

## Features Available

✅ **Current Weather**: Real-time weather for any location
✅ **5-Day Forecast**: Detailed weather predictions
✅ **Location Services**: Automatic current location detection
✅ **Search**: Search for any city worldwide
✅ **Dark Mode**: Toggle between light and dark themes
✅ **Temperature Units**: Switch between Celsius and Fahrenheit
✅ **Offline Support**: Cached weather data
✅ **Beautiful UI**: Modern, responsive design

## API Limits (Free Tier)

- **1000 calls per day**
- **60 calls per minute**
- **Current weather data**
- **5-day forecast data**

## Need Help?

If you're still having issues:
1. Check the console output for detailed error messages
2. Make sure all dependencies are installed: `flutter pub get`
3. Try a clean build: `flutter clean && flutter pub get`
4. Verify your API key is working by testing it in a browser

## Demo Mode

The app will show helpful error messages when the API key is not configured, making it easy to test the UI and understand what needs to be set up.


