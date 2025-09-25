class Forecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String main;
  final String icon;
  final int humidity;
  final double windSpeed;

  Forecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.main,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('minTemp')) {
      return Forecast(
        date: DateTime.fromMillisecondsSinceEpoch(json['date'] ?? 0),
        minTemp: (json['minTemp'] ?? 0.0).toDouble(),
        maxTemp: (json['maxTemp'] ?? 0.0).toDouble(),
        description: json['description'] ?? '',
        main: json['main'] ?? '',
        icon: json['icon'] ?? '',
        humidity: json['humidity'] ?? 0,
        windSpeed: (json['windSpeed'] ?? 0.0).toDouble(),
      );
    } else {
      return Forecast(
        date: DateTime.fromMillisecondsSinceEpoch(
          (json['dt'] ?? 0) * 1000,
        ),
        minTemp: (json['main']?['temp_min'] ?? json['main']?['temp'] ?? 0.0).toDouble(),
        maxTemp: (json['main']?['temp_max'] ?? json['main']?['temp'] ?? 0.0).toDouble(),
        description: json['weather']?[0]?['description'] ?? '',
        main: json['weather']?[0]?['main'] ?? '',
        icon: json['weather']?[0]?['icon'] ?? '',
        humidity: json['main']?['humidity'] ?? 0,
        windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'description': description,
      'main': main,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }

  Forecast copyWith({
    DateTime? date,
    double? minTemp,
    double? maxTemp,
    String? description,
    String? main,
    String? icon,
    int? humidity,
    double? windSpeed,
  }) {
    return Forecast(
      date: date ?? this.date,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      description: description ?? this.description,
      main: main ?? this.main,
      icon: icon ?? this.icon,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
    );
  }
}

