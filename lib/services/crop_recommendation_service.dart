import 'dart:convert';
import 'package:http/http.dart' as http;

class CropRecommendationService {
  // Use 10.0.2.2 for Android Emulator to access host's localhost
  static const String baseUrl = 'http://10.0.2.2:5001/api'; 

  Future<Map<String, dynamic>> autoFillParameters({
    required String state,
    required String district,
    required String frequentCrop,
    required double landSize,
    required String irrigationType,
    String season = 'kharif',
  }) async {
    final url = Uri.parse('$baseUrl/auto-fill-parameters');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state': state,
          'district': district,
          'frequent_grown_crop': frequentCrop.toLowerCase(),
          'land_size': landSize,
          'irrigation_type': irrigationType.toLowerCase(),
          'season': season,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to auto-fill parameters: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Map<String, dynamic>> getRecommendation({
    required String state,
    required String district,
    required String frequentCrop,
    required double landSize,
    required String irrigationType,
    required Map<String, dynamic> parameters,
    String season = 'kharif',
  }) async {
    final url = Uri.parse('$baseUrl/get-recommendation');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state': state,
          'district': district,
          'frequent_grown_crop': frequentCrop.toLowerCase(),
          'land_size': landSize,
          'irrigation_type': irrigationType.toLowerCase(),
          'season': season,
          'parameters': parameters,
        }),
      ).timeout(const Duration(seconds: 90)); // Longer timeout for recommendation

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get recommendations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<String> getExplanation({
    required String cropName,
    required String state,
    required String district,
    required String frequentCrop,
    required double landSize,
  }) async {
    final url = Uri.parse('$baseUrl/get-explanation');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'crop_name': cropName,
          'state': state,
          'district': district,
          'frequent_grown_crop': frequentCrop,
          'land_size': landSize,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['explanation'] as String;
      } else {
        throw Exception('Failed to get explanation');
      }
    } catch (e) {
      return 'Could not generate explanation at this time.';
    }
  }


  Future<bool> saveRecommendation(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/recommendations/save');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error saving recommendation: $e');
      return false;
    }
  }
  Future<Map<String, dynamic>?> getLatestRecommendation(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/recommendations/$phoneNumber');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> history = data['history'] ?? [];
        if (history.isNotEmpty) {
          // Assuming history is sorted descending by date, or we take the first one
          // The backend db_service.get_recommendations usually returns list.
          // We'll assume the first one is the latest or check timestamps if available.
          // For now, returning the first item.
          return history.first as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching latest recommendation: $e');
      return null;
    }
  }
}
