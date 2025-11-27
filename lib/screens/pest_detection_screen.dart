import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class PestDetectionScreen extends StatelessWidget {
  const PestDetectionScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(appState: appState),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () => context.go('/dashboard'),
                          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                          label: const Text('Back', style: TextStyle(color: AppColors.primary)),
                        ),
                        const SizedBox(height: 4),
                        Text('Pest Detection', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 6),
                        const Text('Upload or capture plant image for AI analysis', style: TextStyle(color: AppColors.muted)),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.orange.shade200)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.info_outline, color: AppColors.primaryDark),
                              SizedBox(width: 8),
                              Expanded(child: Text('Upload 4-5 images from different angles for accurate detection.')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Center(
                            child: _AddImagesCard(appState: appState),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
            const FloatingIVR(),
          ],
        ),
      ),
    );
  }
}

class _AddImagesCard extends StatelessWidget {
  const _AddImagesCard({required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      child: Container(
        constraints: BoxConstraints(minHeight: size.height * 0.35),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, size: 48, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 12),
            const Text('Add Images', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.go('/camera'),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.go('/upload-image'),
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Image'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: const BorderSide(color: AppColors.primary, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
