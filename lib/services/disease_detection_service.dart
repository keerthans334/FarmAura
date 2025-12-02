import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'crop_recommendation_service.dart'; // For baseUrl

class DiseaseDetectionService {
  final String baseUrl = CropRecommendationService.baseUrl;

  Future<Map<String, dynamic>> scanDisease(List<XFile> images) async {
    final uri = Uri.parse('$baseUrl/disease/scan');
    final request = http.MultipartRequest('POST', uri);

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('images', image.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to scan disease: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error scanning disease: $e');
    }
  }

  Future<Map<String, dynamic>> diagnoseDisease(
      String diseaseName, String cropName, Map<String, dynamic> context) async {
    final uri = Uri.parse('$baseUrl/disease/diagnose');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'disease_name': diseaseName,
          'crop_name': cropName,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to diagnose disease: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error diagnosing disease: $e');
    }
  }
  Future<bool> saveReport(Map<String, dynamic> reportData) async {
    final uri = Uri.parse('$baseUrl/disease/report/save');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reportData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to save report: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saving report: $e');
      return false;
    }
  }
}
