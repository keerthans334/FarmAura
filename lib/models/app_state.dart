import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String userLanguage = 'English';
  Map<String, dynamic> userData = {
    'name': 'Farmer',
    'village': 'Hazaribagh',
    'district': 'Ranchi',
    'state': 'Jharkhand',
    'phone': '+91 98765 43210',
    'email': 'farmer@example.com',
    'landSize': '2-5 Acres',
    'irrigation': 'Borewell',
    'occupation': 'Farmer',
  };

  Map<String, dynamic> farmDetails = {
    'landSize': '2-5 Acres',
    'irrigation': 'Borewell',
    'soilType': 'Loamy',
    'mainCrops': ['Wheat', 'Mustard'],
    'pastCrops': ['Paddy', 'Maize'],
  };

  Map<String, num> profileStats = {
    'cropsGrown': 4,
    'activeFields': 3,
    'rating': 4.8,
  };

  List<Map<String, dynamic>> cropHistory = [
    {'crop': 'Cotton', 'season': 'Kharif 2023', 'yield': '18', 'unit': 'q/acre', 'profit': '₹45,000'},
    {'crop': 'Wheat', 'season': 'Rabi 2024', 'yield': '22', 'unit': 'q/acre', 'profit': '₹38,500'},
    {'crop': 'Maize', 'season': 'Zaid 2024', 'yield': '15', 'unit': 'q/acre', 'profit': '₹22,000'},
  ];

  List<Map<String, dynamic>> savedRecommendations = [
    {'crop': 'Wheat', 'date': '12 Oct 2024', 'suitability': 92},
    {'crop': 'Paddy', 'date': '28 Sep 2024', 'suitability': 88},
    {'crop': 'Mustard', 'date': '10 Aug 2024', 'suitability': 84},
  ];

  Map<String, dynamic> location = {
    'district': 'Ranchi',
    'state': 'Jharkhand',
    'detected': false,
  };

  List<String> capturedImages = [];

  void setLanguage(String language) {
    userLanguage = language;
    notifyListeners();
  }

  void updateUserData(Map<String, dynamic> data) {
    userData = {...userData, ...data};
    final farmKeys = ['landSize', 'irrigation', 'soilType', 'mainCrops', 'pastCrops'];
    final farmUpdates = <String, dynamic>{};
    for (final key in farmKeys) {
      if (data.containsKey(key)) {
        farmUpdates[key] = data[key];
      }
    }
    if (farmUpdates.isNotEmpty) {
      farmDetails = {...farmDetails, ...farmUpdates};
    }
    notifyListeners();
  }

  void updateFarmDetails(Map<String, dynamic> data) {
    farmDetails = {...farmDetails, ...data};
    notifyListeners();
  }

  void updateCropHistory(List<Map<String, dynamic>> history) {
    cropHistory = history;
    notifyListeners();
  }

  void updateSavedRecommendations(List<Map<String, dynamic>> recommendations) {
    savedRecommendations = recommendations;
    notifyListeners();
  }

  void updateProfileStats(Map<String, num> stats) {
    profileStats = {...profileStats, ...stats};
    notifyListeners();
  }

  void updateLocation(Map<String, dynamic> data) {
    location = {...location, ...data};
    notifyListeners();
  }

  void setImages(List<String> images) {
    capturedImages = List<String>.from(images);
    notifyListeners();
  }
}
