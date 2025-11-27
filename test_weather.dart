import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  const apiKey = '8a6b3f9e2d1c4e5a8b7c9d0e1f2a3b4c';
  const lat = 23.3441;
  const lon = 85.3096;
  final uri = Uri.https('api.weatherapi.com', '/v1/forecast.json', {
    'key': apiKey,
    'q': '$lat,$lon',
    'days': '1',
    'aqi': 'no',
    'alerts': 'no',
  });

  print('Fetching: $uri');
  try {
    final resp = await http.get(uri);
    print('Status: ${resp.statusCode}');
    print('Body: ${resp.body}');
  } catch (e) {
    print('Error: $e');
  }
}
