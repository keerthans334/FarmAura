import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'api.open-meteo.com';
  static const _currentWeatherPath = '/v1/forecast';

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final uri = Uri.https(_baseUrl, _currentWeatherPath, {
        'latitude': '$lat',
        'longitude': '$lon',
        'current': 'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,pressure_msl',
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
        'timezone': 'auto',
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return _mapOpenMeteoToWeather(data);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather: $e');
      rethrow;
    }
  }

  Weather _mapOpenMeteoToWeather(Map<String, dynamic> data) {
    final current = data['current'] as Map<String, dynamic>;
    final daily = data['daily'] as Map<String, dynamic>;
    
    final weatherCode = current['weather_code'] as int;
    final condition = _getConditionFromWmoCode(weatherCode);

    // Map daily forecast
    final List<DailyForecast> dailyForecasts = [];
    final dates = daily['time'] as List;
    final maxTemps = daily['temperature_2m_max'] as List;
    final minTemps = daily['temperature_2m_min'] as List;
    final codes = daily['weather_code'] as List;
    final rainChances = daily['precipitation_probability_max'] as List;

    for (var i = 0; i < dates.length && i < 7; i++) {
      final code = codes[i] as int;
      final cond = _getConditionFromWmoCode(code);
      dailyForecasts.add(DailyForecast(
        date: DateTime.parse(dates[i]),
        maxTempC: (maxTemps[i] as num).round(),
        minTempC: (minTemps[i] as num).round(),
        rainChance: (rainChances[i] as num).round(),
        condition: cond,
        iconName: Weather.getIconNameForCondition(cond), // Helper we'll add to Weather model or use existing logic
      ));
    }

    return Weather(
      currentTempC: (current['temperature_2m'] as num).round(),
      feelsLikeC: (current['temperature_2m'] as num).round(), // OpenMeteo basic doesn't have feels_like in free tier easily, using temp
      condition: condition,
      humidity: (current['relative_humidity_2m'] as num).round(),
      windKph: (current['wind_speed_10m'] as num).round(),
      visibilityKm: 10, // Default as not always available
      pressureMb: (current['pressure_msl'] as num).round(),
      iconName: Weather.getIconNameForCondition(condition),
      dailyForecast: dailyForecasts,
    );
  }

  String _getConditionFromWmoCode(int code) {
    switch (code) {
      case 0: return 'Sunny';
      case 1: return 'Mainly Clear';
      case 2: return 'Partly Cloudy';
      case 3: return 'Cloudy';
      case 45: case 48: return 'Fog';
      case 51: case 53: case 55: return 'Drizzle';
      case 61: case 63: case 65: return 'Rain';
      case 71: case 73: case 75: return 'Snow';
      case 77: return 'Snow Grains';
      case 80: case 81: case 82: return 'Rain Showers';
      case 85: case 86: return 'Snow Showers';
      case 95: return 'Thunderstorm';
      case 96: case 99: return 'Thunderstorm with Hail';
      default: return 'Unknown';
    }
  }

  Future<Weather> getWeatherByCity(String city) async {
    // OpenMeteo requires coordinates. For city, we'd need geocoding first.
    // Since the app uses coordinates primarily, we can skip this or throw.
    throw UnimplementedError('City search not supported with OpenMeteo directly');
  }
}
