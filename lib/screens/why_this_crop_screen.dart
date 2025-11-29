import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';
import 'package:farmaura/l10n/app_localizations.dart';
import '../services/crop_recommendation_service.dart';
import '../services/voice_assistant_service.dart';
import '../utils/narration_templates.dart';

class WhyThisCropScreen extends StatelessWidget {
  const WhyThisCropScreen({
    super.key, 
    required this.appState,
    required this.cropData,
    required this.contextData,
  });

  final AppState appState;
  final Map<String, dynamic> cropData;
  final Map<String, dynamic> contextData;

  Future<void> _saveRecommendation(BuildContext context) async {
    final service = CropRecommendationService();
    final phoneNumber = appState.userData['phone'] ?? 'Unknown';
    
    final payload = {
      'phone_number': phoneNumber,
      'recommendations': [cropData], 
      'location': appState.location,
      'farmer_context': contextData,
    };

    final success = await service.saveRecommendation(payload);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Plan saved successfully!' : 'Failed to save plan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropName = cropData['crop']?.toString() ?? 'Unknown';
    final suitability = ((cropData['suitability_score'] ?? 0.0) * 100).toStringAsFixed(0);
    final agronomic = cropData['agronomic_params'] ?? {};
    final ph = agronomic['ph']?.toStringAsFixed(1) ?? '?';
    final n = agronomic['nitrogen_kg_ha']?.toStringAsFixed(0) ?? '?';
    final p = agronomic['phosphorus_kg_ha']?.toStringAsFixed(0) ?? '?';
    final k = agronomic['potassium_kg_ha']?.toStringAsFixed(0) ?? '?';
    final temp = agronomic['temperature_c']?.toStringAsFixed(1) ?? '?';
    final rain = agronomic['rainfall_mm']?.toStringAsFixed(0) ?? '?';
    final profit = cropData['expected_profit_inr']?.toStringAsFixed(0) ?? '?';
    final market = cropData['mandi_suggestion'] ?? 'Local Market';
    final prevCrop = contextData['frequentCrop'] ?? 'Previous Crop';
    final fertilizerNote = cropData['fertilizer_note'] ?? 'Follow standard fertilizer application.';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  title: AppLocalizations.of(context)!.whyCropTitle(cropName),
                  showBack: true,
                  showProfile: false,
                  appState: appState,
                  onBack: () => Navigator.of(context).pop(),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.volume2, color: AppColors.primaryDark),
                    onPressed: () {
                      final text = NarrationTemplates.getWhyThisCropSummary(
                          cropName, 
                          suitability, 
                          ph, 
                          temp, 
                          rain, 
                          market
                      );
                      VoiceAssistantService().speak(text, appState.userLanguage);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.whyCropSubtitle(cropName.toLowerCase()),
                          style: const TextStyle(color: AppColors.muted, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        // Hero Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: const Color(0xFF43A047).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
                          ),
                          child: Column(
                            children: [
                              Text('$suitability%', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                              Text(AppLocalizations.of(context)!.suitabilityScore, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(AppLocalizations.of(context)!.highlyRecommended, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context)!.keyFactors, style: const TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 16),
                        _FactorCard(
                          title: AppLocalizations.of(context)!.excellentSoilMatch,
                          description: 'Soil pH $ph is suitable. Nutrient requirements: N ($n kg/ha), P ($p kg/ha), K ($k kg/ha).',
                          icon: LucideIcons.sprout,
                          color: Colors.green,
                        ),
                        _FactorCard(
                          title: AppLocalizations.of(context)!.weatherSuitability,
                          description: 'Optimal temperature ($temp°C) and rainfall ($rain mm) for this season.',
                          icon: Icons.wb_sunny_outlined,
                          color: Colors.orange,
                        ),
                        _FactorCard(
                          title: AppLocalizations.of(context)!.rotationBenefit,
                          description: 'Good rotation option after $prevCrop to maintain soil health.',
                          icon: Icons.sync,
                          color: Colors.blue,
                        ),
                        _FactorCard(
                          title: AppLocalizations.of(context)!.marketAdvantage,
                          description: '$market. Expected profit: ₹$profit/ha.',
                          icon: Icons.attach_money,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context)!.growthTimeline, style: const TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            children: [
                              _TimelineItem(title: AppLocalizations.of(context)!.sowing, time: 'Week 1-2', icon: LucideIcons.sprout, isFirst: true),
                              _TimelineItem(title: AppLocalizations.of(context)!.germination, time: 'Week 2-3', icon: LucideIcons.leaf),
                              _TimelineItem(title: AppLocalizations.of(context)!.vegetative, time: 'Week 4-12', icon: LucideIcons.wheat),
                              _TimelineItem(title: AppLocalizations.of(context)!.flowering, time: 'Week 13-18', icon: LucideIcons.flower),
                              _TimelineItem(title: AppLocalizations.of(context)!.bollFormation, time: 'Week 19-24', icon: LucideIcons.bean),
                              _TimelineItem(title: AppLocalizations.of(context)!.harvest, time: 'Week 25-28', icon: LucideIcons.scissors, isLast: true),
                            ],
                          ),
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
                              const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppLocalizations.of(context)!.fertilizerSuggestion, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(
                                      fertilizerNote,
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
                                child: Text(AppLocalizations.of(context)!.backToResults, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _saveRecommendation(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                child: Text(AppLocalizations.of(context)!.savePlan, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
          ],
        ),
      ),
    );
  }
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({required this.title, required this.description, required this.icon, required this.color});
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
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.title, required this.time, required this.icon, this.isFirst = false, this.isLast = false});
  final String title;
  final String time;
  final IconData icon;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst) Expanded(child: Container(width: 2, color: AppColors.primary.withOpacity(0.2))),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: AppColors.primary.withOpacity(0.2))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
