class Weather {
  Weather({
    required this.currentTempC,
    required this.feelsLikeC,
    required this.condition,
    required this.humidity,
    required this.windKph,
    required this.visibilityKm,
    required this.pressureMb,
    required this.iconName,
    required this.dailyForecast,
  });

  final int currentTempC;
  final int feelsLikeC;
  final String condition;
  final int humidity;
  final int windKph;
  final int visibilityKm;
  final int pressureMb;
  final String iconName;
  final List<DailyForecast> dailyForecast;

  String get iconAsset => 'assets/images/weather/$iconName.svg';

  static Weather sample() {
    final today = DateTime.now();
    final samples = List.generate(7, (i) {
      final date = today.add(Duration(days: i));
      final names = ['Sunny', 'Partly cloudy', 'Cloudy', 'Light rain', 'Thunderstorm'];
      final cond = names[i % names.length];
      return DailyForecast(
        date: date,
        maxTempC: 32 - i,
        minTempC: 22 - i,
        rainChance: (i * 10) % 80,
        condition: cond,
        iconName: _iconNameForCondition(cond),
      );
    });
    return Weather(
      currentTempC: 32,
      feelsLikeC: 34,
      condition: 'Sunny & Clear',
      humidity: 65,
      windKph: 12,
      visibilityKm: 10,
      pressureMb: 1013,
      iconName: _iconNameForCondition('Sunny'),
      dailyForecast: samples,
    );
  }

  factory Weather.fromWeatherApi(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final forecastDays = (json['forecast']?['forecastday'] as List? ?? []).whereType<Map<String, dynamic>>().toList();
    final daily = forecastDays.map((fd) => DailyForecast.fromWeatherApiDay(fd)).toList();
    final conditionText = (current['condition']?['text'] as String?) ?? 'Clear';
    return Weather(
      currentTempC: (current['temp_c'] as num?)?.round() ?? 0,
      feelsLikeC: (current['feelslike_c'] as num?)?.round() ?? 0,
      condition: conditionText,
      humidity: (current['humidity'] as num?)?.round() ?? 0,
      windKph: (current['wind_kph'] as num?)?.round() ?? 0,
      visibilityKm: (current['vis_km'] as num?)?.round() ?? 0,
      pressureMb: (current['pressure_mb'] as num?)?.round() ?? 0,
      iconName: _iconNameForCondition(conditionText),
      dailyForecast: daily.isNotEmpty ? daily : Weather.sample().dailyForecast,
    );
  }

  static String _iconNameForCondition(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('thunder')) return 'storm';
    if (c.contains('rain') || c.contains('drizzle') || c.contains('shower')) return 'rain';
    if (c.contains('cloudy') || c.contains('overcast')) return 'cloudy';
    if (c.contains('partly') || c.contains('partly cloudy')) return 'partly_cloudy';
    if (c.contains('sun') || c.contains('clear')) return 'sunny';
    return 'sunny';
  }
}

class DailyForecast {
  DailyForecast({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.rainChance,
    required this.condition,
    required this.iconName,
  });

  final DateTime date;
  final int maxTempC;
  final int minTempC;
  final int rainChance;
  final String condition;
  final String iconName;

  String get iconAsset => 'assets/images/weather/$iconName.svg';

  factory DailyForecast.fromWeatherApiDay(Map<String, dynamic> json) {
    final dateStr = json['date'] as String? ?? '';
    final day = json['day'] as Map<String, dynamic>? ?? {};
    final cond = (day['condition']?['text'] as String?) ?? 'Sunny';
    return DailyForecast(
      date: DateTime.tryParse(dateStr) ?? DateTime.now(),
      maxTempC: (day['maxtemp_c'] as num?)?.round() ?? 0,
      minTempC: (day['mintemp_c'] as num?)?.round() ?? 0,
      rainChance: (day['daily_chance_of_rain'] as num?)?.round() ?? 0,
      condition: cond,
      iconName: Weather._iconNameForCondition(cond),
    );
  }
}
