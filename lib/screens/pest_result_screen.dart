import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/floating_ivr.dart';
import 'package:farmaura/l10n/app_localizations.dart';
import '../services/voice_assistant_service.dart';
import '../services/disease_detection_service.dart';

import 'dart:io';

class PestResultScreen extends StatelessWidget {
  PestResultScreen({
    super.key,
    required this.appState,
    required this.scanResult,
    required this.diagnosis,
    required this.imagePath,
  });

  final AppState appState;
  final Map<String, dynamic> scanResult;
  final Map<String, dynamic> diagnosis;
  final String imagePath;
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  final DiseaseDetectionService _diseaseService = DiseaseDetectionService();

  Future<void> _speakReport(BuildContext context) async {
    final langCode = appState.userLanguage == 'Hindi' ? 'hi' : (appState.userLanguage == 'Kannada' ? 'kn' : 'en');
    
    final text = '''
    ${scanResult['disease_name']} Detected. Severity is ${scanResult['severity']}.
    
    Chemical Control: ${diagnosis['chemical_control'] ?? 'Not available'}.
    
    Biological Control: ${diagnosis['biological_control'] ?? 'Not available'}.
    
    Organic Alternative: ${diagnosis['organic_alternative'] ?? 'Not available'}.
    ''';
    
    await _voiceService.speak(text, langCode, id: 'pest_report');
  }

  Future<void> _saveReport(BuildContext context) async {
    final reportData = {
      'phone_number': appState.userData['phone'] ?? 'unknown',
      'disease_name': scanResult['disease_name'],
      'severity': scanResult['severity'],
      'confidence': scanResult['confidence'],
      'diagnosis': diagnosis,
      'image_path': imagePath, // Note: Local path, ideally should be uploaded URL
      'timestamp': DateTime.now().toIso8601String(),
    };

    final success = await _diseaseService.saveReport(reportData);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success 
            ? 'Report saved successfully' 
            : 'Failed to save report'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  title: AppLocalizations.of(context)!.pestDetection, 
                  showBack: true, 
                  showProfile: false, 
                  appState: appState, 
                  onBack: () => Navigator.of(context).pop(),
                  trailing: StreamBuilder<String?>(
                    stream: _voiceService.playingIdStream,
                    builder: (context, snapshot) {
                      final myId = 'pest_report';
                      final isPlaying = snapshot.data == myId;
                      return IconButton(
                        icon: Icon(
                          isPlaying ? LucideIcons.volumeX : LucideIcons.volume2,
                          color: isPlaying ? Colors.red : AppColors.primaryDark,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            _voiceService.stopSpeaking();
                          } else {
                            _speakReport(context);
                          }
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: FileImage(File(imagePath)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${scanResult['disease_name']} Detected',
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                                        ),
                                        Text(
                                          'Severity: ${scanResult['severity'].toString().toUpperCase()} (${(scanResult['confidence'] * 100).toStringAsFixed(0)}%)',
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.recommendedActions, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _ActionCard(
                          title: AppLocalizations.of(context)!.chemicalControl,
                          description: diagnosis['chemical_control'] ?? 'No chemical control advice available.',
                          icon: LucideIcons.flaskConical,
                          color: Colors.orange,
                        ),
                        _ActionCard(
                          title: AppLocalizations.of(context)!.biologicalControl,
                          description: diagnosis['biological_control'] ?? 'No biological control advice available.',
                          icon: LucideIcons.leaf,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC8E6C9)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline, color: Colors.green, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppLocalizations.of(context)!.organicAlternativeTitle, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(
                                      diagnosis['organic_alternative'] ?? 'No organic alternative available.',
                                      style: const TextStyle(color: AppColors.primaryDark, fontSize: 13, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(AppLocalizations.of(context)!.scanAgain, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _saveReport(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                child: Text(AppLocalizations.of(context)!.saveReport, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
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
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: AppColors.muted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
