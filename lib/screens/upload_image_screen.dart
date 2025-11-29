import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: 'Upload Image', showBack: true, showProfile: false, appState: appState),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))]),
                          child: Column(
                            children: [
                              Container(
                                height: 180,
                                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_outlined, size: 56, color: AppColors.primaryDark),
                              ),
                              const SizedBox(height: 12),
                              const Text('Tap below to select images from gallery', style: TextStyle(color: AppColors.muted)),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () => context.go('/pest-result'),
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Choose Images'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
          ],
        ),
      ),
    );
  }
}
