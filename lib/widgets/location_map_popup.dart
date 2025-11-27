import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LocationMapPopup extends StatelessWidget {
  const LocationMapPopup({super.key, required this.location, required this.onClose});
  final Map<String, dynamic> location;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.map_outlined, size: 64, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 12),
          Text('${location['district']}, ${location['state']}', style: const TextStyle(color: AppColors.primaryDark)),
          const SizedBox(height: 6),
          const Text('Map preview placeholder', style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
      actions: [
        TextButton(onPressed: onClose, child: const Text('Close')),
      ],
    );
  }
}
