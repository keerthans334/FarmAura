// FarmAura Auto Detect Integration Example
// ==========================================
// This file shows how to integrate the Auto Detect API into your Flutter app.
// Copy the relevant parts into your existing Flutter codebase.

import 'dart:convert';
import 'package:http/http.dart' as http;

// ============================================================================
// 1. API Service Class
// ============================================================================

class CropRecommendationService {
  // TODO: Update this with your actual server URL
  // For local testing: 'http://localhost:5000'
  // For production: 'https://your-server.com'
  static const String baseUrl = 'http://YOUR_SERVER_IP:5000';
  
  /// Health check to verify server is running
  Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'healthy' && 
               data['model_loaded'] == true && 
               data['data_loaded'] == true;
      }
      return false;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }
  
  /// Auto Detect crop recommendation
  Future<AutoDetectResponse> autoDetectCrop({
    required String state,
    required String district,
    required String frequentGrownCrop,
    required double landSize,
    String irrigationType = 'rainfed',
    String? season,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auto-detect-crop'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state': state,
          'district': district,
          'frequent_grown_crop': frequentGrownCrop,
          'land_size': landSize,
          'irrigation_type': irrigationType,
          if (season != null) 'season': season,
        }),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AutoDetectResponse.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Unknown error');
      }
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }
}

// ============================================================================
// 2. Data Models
// ============================================================================

class AutoDetectResponse {
  final String status;
  final DateTime timestamp;
  final Location location;
  final FarmerContext farmerContext;
  final Map<String, dynamic> modelInputUsed;
  final List<CropRecommendation> recommendations;
  
  AutoDetectResponse({
    required this.status,
    required this.timestamp,
    required this.location,
    required this.farmerContext,
    required this.modelInputUsed,
    required this.recommendations,
  });
  
  factory AutoDetectResponse.fromJson(Map<String, dynamic> json) {
    return AutoDetectResponse(
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      location: Location.fromJson(json['location']),
      farmerContext: FarmerContext.fromJson(json['farmer_context']),
      modelInputUsed: json['model_input_used'],
      recommendations: (json['recommendations'] as List)
          .map((r) => CropRecommendation.fromJson(r))
          .toList(),
    );
  }
}

class Location {
  final String state;
  final String district;
  final String? season;
  
  Location({
    required this.state,
    required this.district,
    this.season,
  });
  
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      state: json['state'],
      district: json['district'],
      season: json['season'],
    );
  }
}

class FarmerContext {
  final String frequentGrownCrop;
  final double landSize;
  final String irrigationType;
  
  FarmerContext({
    required this.frequentGrownCrop,
    required this.landSize,
    required this.irrigationType,
  });
  
  factory FarmerContext.fromJson(Map<String, dynamic> json) {
    return FarmerContext(
      frequentGrownCrop: json['frequent_grown_crop'],
      landSize: json['land_size'].toDouble(),
      irrigationType: json['irrigation_type'],
    );
  }
}

class CropRecommendation {
  final String crop;
  final double modelConfidence;
  final double suitabilityScore;
  final String suitabilityFlag;
  final double expectedYieldQPerHa;
  final double expectedProfitInr;
  final double riskIndex;
  final String mandiSuggestion;
  final String fertilizerRecommendation;
  final String fertilizerNote;
  final String technicalReason;
  final String farmerFriendlyExplanation;
  final AgronomicParams agronomicParams;
  
  CropRecommendation({
    required this.crop,
    required this.modelConfidence,
    required this.suitabilityScore,
    required this.suitabilityFlag,
    required this.expectedYieldQPerHa,
    required this.expectedProfitInr,
    required this.riskIndex,
    required this.mandiSuggestion,
    required this.fertilizerRecommendation,
    required this.fertilizerNote,
    required this.technicalReason,
    required this.farmerFriendlyExplanation,
    required this.agronomicParams,
  });
  
  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      crop: json['crop'],
      modelConfidence: json['model_confidence'].toDouble(),
      suitabilityScore: json['suitability_score'].toDouble(),
      suitabilityFlag: json['suitability_flag'],
      expectedYieldQPerHa: json['expected_yield_q_per_ha'].toDouble(),
      expectedProfitInr: json['expected_profit_inr'].toDouble(),
      riskIndex: json['risk_index'].toDouble(),
      mandiSuggestion: json['mandi_suggestion'],
      fertilizerRecommendation: json['fertilizer_recommendation'],
      fertilizerNote: json['fertilizer_note'],
      technicalReason: json['technical_reason'],
      farmerFriendlyExplanation: json['farmer_friendly_explanation'],
      agronomicParams: AgronomicParams.fromJson(json['agronomic_params']),
    );
  }
  
  // Helper methods
  String get suitabilityColor {
    switch (suitabilityFlag.toUpperCase()) {
      case 'HIGH':
        return '#4CAF50'; // Green
      case 'MEDIUM':
        return '#FF9800'; // Orange
      case 'LOW':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }
  
  String get riskLevel {
    if (riskIndex < 0.3) return 'Low Risk';
    if (riskIndex < 0.6) return 'Medium Risk';
    return 'High Risk';
  }
}

class AgronomicParams {
  final double temperatureC;
  final double humidityPct;
  final double rainfallMm;
  final double ph;
  final double nitrogenKgHa;
  final double phosphorusKgHa;
  final double potassiumKgHa;
  
  AgronomicParams({
    required this.temperatureC,
    required this.humidityPct,
    required this.rainfallMm,
    required this.ph,
    required this.nitrogenKgHa,
    required this.phosphorusKgHa,
    required this.potassiumKgHa,
  });
  
  factory AgronomicParams.fromJson(Map<String, dynamic> json) {
    return AgronomicParams(
      temperatureC: json['temperature_c']?.toDouble() ?? 0.0,
      humidityPct: json['humidity_pct']?.toDouble() ?? 0.0,
      rainfallMm: json['rainfall_mm']?.toDouble() ?? 0.0,
      ph: json['ph']?.toDouble() ?? 0.0,
      nitrogenKgHa: json['nitrogen_kg_ha']?.toDouble() ?? 0.0,
      phosphorusKgHa: json['phosphorus_kg_ha']?.toDouble() ?? 0.0,
      potassiumKgHa: json['potassium_kg_ha']?.toDouble() ?? 0.0,
    );
  }
}

// ============================================================================
// 3. Example Usage in a Widget
// ============================================================================

/*
import 'package:flutter/material.dart';

class AutoDetectButton extends StatefulWidget {
  final String state;
  final String district;
  final String frequentCrop;
  final double landSize;
  
  const AutoDetectButton({
    Key? key,
    required this.state,
    required this.district,
    required this.frequentCrop,
    required this.landSize,
  }) : super(key: key);
  
  @override
  State<AutoDetectButton> createState() => _AutoDetectButtonState();
}

class _AutoDetectButtonState extends State<AutoDetectButton> {
  final _service = CropRecommendationService();
  bool _isLoading = false;
  
  Future<void> _onAutoDetect() async {
    setState(() => _isLoading = true);
    
    try {
      // Call the API
      final response = await _service.autoDetectCrop(
        state: widget.state,
        district: widget.district,
        frequentGrownCrop: widget.frequentCrop,
        landSize: widget.landSize,
      );
      
      // Navigate to results screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationsScreen(data: response),
          ),
        );
      }
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _onAutoDetect,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: Colors.green,
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Auto Detect',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}

// ============================================================================
// 4. Example Recommendations Screen
// ============================================================================

class RecommendationsScreen extends StatelessWidget {
  final AutoDetectResponse data;
  
  const RecommendationsScreen({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendations'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Location info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.location.district}, ${data.location.state}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Land Size: ${data.farmerContext.landSize} hectares'),
                  Text('Frequent Crop: ${data.farmerContext.frequentGrownCrop}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Recommendations
          const Text(
            'Top 3 Recommendations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 8),
          
          ...data.recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final rec = entry.value;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Crop name and rank
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text('${index + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            rec.crop.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _parseColor(rec.suitabilityColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            rec.suitabilityFlag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 24),
                    
                    // Key metrics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric(
                          'Yield',
                          '${rec.expectedYieldQPerHa.toStringAsFixed(1)} q/ha',
                          Icons.agriculture,
                        ),
                        _buildMetric(
                          'Profit',
                          '₹${_formatNumber(rec.expectedProfitInr)}',
                          Icons.currency_rupee,
                        ),
                        _buildMetric(
                          'Risk',
                          rec.riskLevel,
                          Icons.warning_amber,
                        ),
                      ],
                    ),
                    
                    const Divider(height: 24),
                    
                    // Explanation
                    const Text(
                      'Why this crop?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rec.farmerFriendlyExplanation,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Fertilizer recommendation
                    if (rec.fertilizerRecommendation.isNotEmpty) ...[
                      const Text(
                        'Fertilizer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(rec.fertilizerRecommendation),
                      if (rec.fertilizerNote.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          rec.fertilizerNote,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                    
                    const SizedBox(height: 16),
                    
                    // View details button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Show detailed view
                        _showDetailedView(context, rec);
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
  }
  
  String _formatNumber(double number) {
    if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }
  
  void _showDetailedView(BuildContext context, CropRecommendation rec) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                '${rec.crop.toUpperCase()} - Detailed Parameters',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 24),
              
              _buildParamRow('Temperature', '${rec.agronomicParams.temperatureC.toStringAsFixed(1)}°C'),
              _buildParamRow('Humidity', '${rec.agronomicParams.humidityPct.toStringAsFixed(1)}%'),
              _buildParamRow('Rainfall', '${rec.agronomicParams.rainfallMm.toStringAsFixed(1)} mm'),
              _buildParamRow('Soil pH', rec.agronomicParams.ph.toStringAsFixed(2)),
              
              const Divider(height: 24),
              const Text(
                'Nutrient Requirements',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              _buildParamRow('Nitrogen (N)', '${rec.agronomicParams.nitrogenKgHa.toStringAsFixed(0)} kg/ha'),
              _buildParamRow('Phosphorus (P)', '${rec.agronomicParams.phosphorusKgHa.toStringAsFixed(0)} kg/ha'),
              _buildParamRow('Potassium (K)', '${rec.agronomicParams.potassiumKgHa.toStringAsFixed(0)} kg/ha'),
              
              const Divider(height: 24),
              const Text(
                'Market Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              _buildParamRow('Nearest Mandi', rec.mandiSuggestion),
              _buildParamRow('Model Confidence', '${(rec.modelConfidence * 100).toStringAsFixed(1)}%'),
              
              const SizedBox(height: 16),
              
              const Text(
                'Technical Reason',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                rec.technicalReason,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildParamRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
*/
