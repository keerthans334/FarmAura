import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/floating_ivr.dart';
import 'pest_result_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../services/disease_detection_service.dart';
import 'package:farmaura/l10n/app_localizations.dart';

class PestDetectionScreen extends StatefulWidget {
  const PestDetectionScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<PestDetectionScreen> createState() => _PestDetectionScreenState();
}

class _PestDetectionScreenState extends State<PestDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  final DiseaseDetectionService _service = DiseaseDetectionService();
  bool _isLoading = false;

  Future<void> _processImages(ImageSource source) async {
    try {
      final List<XFile> images;
      if (source == ImageSource.camera) {
        final image = await _picker.pickImage(source: source);
        images = image != null ? [image] : [];
      } else {
        images = await _picker.pickMultiImage();
      }

      if (images.isEmpty) return;

      setState(() => _isLoading = true);

      // 1. Scan Disease
      final scanResult = await _service.scanDisease(images);
      final resultData = scanResult['result'];
      final diseaseName = resultData['disease_name'];

      // 2. Diagnose (Get Recommendations)
      // Use context from AppState (location, etc.)
      final contextData = {
        'location': widget.appState.location,
        'weather': widget.appState.weather?.toJson(),
      };

      final diagnosisResult = await _service.diagnoseDisease(
        diseaseName,
        'Unknown Crop', // Could ask user or infer
        contextData,
      );

      if (!mounted) return;

      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PestResultScreen(
          appState: widget.appState,
          scanResult: resultData,
          diagnosis: diagnosisResult['diagnosis'],
          imagePath: images.first.path,
        ),
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Analyzing crop health...', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.canPop(context) ? context.pop() : context.go('/dashboard'),
                        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.primaryDark),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(AppLocalizations.of(context)!.back, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(LucideIcons.scanLine, size: 64, color: AppColors.primary),
                        ),
                        const SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.pestDetection, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.pestDetectionSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: AppColors.muted, height: 1.5),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.blue),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.pestDetectionInfo,
                                  style: TextStyle(color: Colors.blue.shade900, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        _actionButton(
                          icon: LucideIcons.camera,
                          label: AppLocalizations.of(context)!.openCamera,
                          color: AppColors.primary,
                          onTap: () => _processImages(ImageSource.camera),
                        ),
                        const SizedBox(height: 16),
                        _actionButton(
                          icon: LucideIcons.image,
                          label: AppLocalizations.of(context)!.uploadImage,
                          color: AppColors.accent,
                          isOutlined: true,
                          onTap: () => _processImages(ImageSource.gallery),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap, bool isOutlined = false}) {
    return Material(
      color: isOutlined ? Colors.transparent : color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: isOutlined
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color, width: 2),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isOutlined ? color : Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isOutlined ? color : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
