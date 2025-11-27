import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;

class LocationHelper {
  static Future<void> showLocationServiceDialog(BuildContext context, VoidCallback onRetry) async {
    final location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        onRetry();
      }
    } else {
      onRetry();
    }
  }
}
