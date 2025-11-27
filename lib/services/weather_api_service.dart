import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApiService {
  static const _host = 'api.weatherapi.com';
  static const _path = '/v1/forecast.json';
  static const _apiKey = 'demo'; // replace with a real key when available

  Future<Weather> fetchWeather(String query) async {
    final uri = Uri.https(_host, _path, {
      'key': _apiKey,
      'q': query,
      'days': '7',
      'aqi': 'no',
      'alerts': 'no',
    });

    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        return Weather.fromWeatherApi(data);
      }
    } catch (_) {
      // fall through to sample data
    }
    return Weather.sample();
  }
}
