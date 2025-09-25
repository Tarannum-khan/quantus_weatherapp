class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String main;
  final String icon;
  final DateTime dateTime;
  final double? latitude;
  final double? longitude;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.main,
    required this.icon,
    required this.dateTime,
    this.latitude,
    this.longitude,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('cityName')) {
      return Weather(
        cityName: json['cityName'] ?? '',
        country: json['country'] ?? '',
        temperature: (json['temperature'] ?? 0.0).toDouble(),
        feelsLike: (json['feelsLike'] ?? 0.0).toDouble(),
        humidity: json['humidity'] ?? 0,
        windSpeed: (json['windSpeed'] ?? 0.0).toDouble(),
        description: json['description'] ?? '',
        main: json['main'] ?? '',
        icon: json['icon'] ?? '',
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime'] ?? 0),
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
      );
    } else {
      return Weather(
        cityName: json['name'] ?? '',
        country: json['sys']?['country'] ?? '',
        temperature: (json['main']?['temp'] ?? 0.0).toDouble(),
        feelsLike: (json['main']?['feels_like'] ?? 0.0).toDouble(),
        humidity: json['main']?['humidity'] ?? 0,
        windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
        description: json['weather']?[0]?['description'] ?? '',
        main: json['weather']?[0]?['main'] ?? '',
        icon: json['weather']?[0]?['icon'] ?? '',
        dateTime: DateTime.fromMillisecondsSinceEpoch(
          (json['dt'] ?? 0) * 1000,
        ),
        latitude: json['coord']?['lat']?.toDouble(),
        longitude: json['coord']?['lon']?.toDouble(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'description': description,
      'main': main,
      'icon': icon,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Weather copyWith({
    String? cityName,
    String? country,
    double? temperature,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    String? description,
    String? main,
    String? icon,
    DateTime? dateTime,
  }) {
    return Weather(
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      description: description ?? this.description,
      main: main ?? this.main,
      icon: icon ?? this.icon,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

