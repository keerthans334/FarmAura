import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';
import 'why_this_crop_screen.dart';
import '../services/crop_recommendation_service.dart';
import '../services/voice_assistant_service.dart';
import '../utils/narration_templates.dart';

import 'package:farmaura/l10n/app_localizations.dart';

class RecommendationResultsScreen extends StatefulWidget {
  const RecommendationResultsScreen({
    super.key,
    required this.appState,
    required this.recommendations,
    this.contextData = const {},
  });

  final AppState appState;
  final List<dynamic> recommendations;
  final Map<String, dynamic> contextData;

  @override
  State<RecommendationResultsScreen> createState() => _RecommendationResultsScreenState();
}

class _RecommendationResultsScreenState extends State<RecommendationResultsScreen> {
  final Map<String, Future<String>> _explanationFutures = {};

  @override
  void initState() {
    super.initState();
    _preloadExplanations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final text = widget.recommendations.isNotEmpty
           ? widget.recommendations.take(3).map((r) => "For ${r['crop']}: ${r['fertilizer_note']}").join("\n\n")
           : null;
       widget.appState.updateContextText(text);
    });
  }

  void _preloadExplanations() {
    for (var rec in widget.recommendations) {
      final cropName = rec['crop'];
      _explanationFutures[cropName] = CropRecommendationService().getExplanation(
        cropName: cropName,
        state: widget.contextData['state'] ?? '',
        district: widget.contextData['district'] ?? '',
        frequentCrop: widget.contextData['frequentCrop'] ?? '',
        landSize: (widget.contextData['landSize'] ?? 1.0).toDouble(),
      );
    }
  }

  @override
  void dispose() {
    widget.appState.updateContextText(null);
    super.dispose();
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
                  title: AppLocalizations.of(context)!.recommendedCrops,
                  showBack: true,
                  showProfile: false,
                  appState: widget.appState,
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.basedOnFarmConditions,
                          style: const TextStyle(color: AppColors.muted, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        if (widget.recommendations.isEmpty)
                          const Center(child: Text('No recommendations found.'))
                        else
                          ...widget.recommendations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final rec = entry.value;
                            return _RecommendationCard(
                              rec: rec,
                              rank: index + 1,
                              appState: widget.appState,
                              explanationFuture: _explanationFutures[rec['crop']]!,
                              contextData: widget.contextData,
                            );
                          }),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.tryDifferentInputs,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.rec,
    required this.rank,
    required this.appState,
    required this.explanationFuture,
    required this.contextData,
  });

  final Map<String, dynamic> rec;
  final int rank;
  final AppState appState;
  final Future<String> explanationFuture;
  final Map<String, dynamic> contextData;

  @override
  Widget build(BuildContext context) {
    final cropName = rec['crop'] ?? 'Unknown Crop';
    final suitability = (rec['suitability_score'] * 100).toStringAsFixed(0);
    final profit = '₹${rec['expected_profit_inr']?.toStringAsFixed(0) ?? '0'}';
    final yieldVal = '${rec['expected_yield_q_per_ha']?.toStringAsFixed(1) ?? '0'} q/ha';
    
    // Determine color based on rank
    Color color;
    if (rank == 1) color = const Color(0xFF2E7D32); // Dark Green
    else if (rank == 2) color = const Color(0xFFE65100); // Orange
    else color = const Color(0xFF1565C0); // Blue

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(LucideIcons.sprout, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cropName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$rank Match',
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              StreamBuilder<String?>(
                stream: VoiceAssistantService().playingIdStream,
                builder: (context, snapshot) {
                  final myId = 'rec_card_$rank';
                  final isPlaying = snapshot.data == myId;
                  return IconButton(
                    icon: Icon(
                      isPlaying ? LucideIcons.volumeX : LucideIcons.volume2,
                      color: isPlaying ? Colors.red : AppColors.primary,
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        VoiceAssistantService().stopSpeaking();
                      } else {
                        final text = NarrationTemplates.getCropSummary(
                          cropName,
                          suitability,
                          rec['expected_profit_inr']?.toStringAsFixed(0) ?? '0',
                          yieldVal
                        );
                        VoiceAssistantService().speak(text, appState.userLanguage, id: myId);
                      }
                    },
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.suitabilityScore, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              Text('$suitability%', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (rec['suitability_score'] ?? 0.0).toDouble(),
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: AppLocalizations.of(context)!.expectedProfit,
                  value: profit,
                  subLabel: 'per hectare',
                  icon: Icons.attach_money,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: AppLocalizations.of(context)!.yieldEstimate,
                  value: yieldVal,
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.science, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.fertilizerSuggestion,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  rec['fertilizer_note'] ?? 'Follow standard fertilizer application.',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WhyThisCropScreen(
                          appState: appState,
                          cropData: rec,
                          contextData: contextData,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.whyThisCrop,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                     showDialog(
                       context: context,
                       builder: (ctx) => _ExplanationDialog(
                         cropName: rec['crop'],
                         explanationFuture: explanationFuture,
                         appState: appState,
                       ),
                     );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.viewDetails,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, this.subLabel, required this.icon});
  final String label;
  final String value;
  final String? subLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 14)),
          if (subLabel != null)
            Text(subLabel!, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _ExplanationDialog extends StatelessWidget {
  const _ExplanationDialog({
    required this.cropName,
    required this.explanationFuture,
    required this.appState,
  });

  final String cropName;
  final Future<String> explanationFuture;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: explanationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            title: Text(cropName),
            content: const SizedBox(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Generating AI explanation...", style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
            ],
          );
        }
        
        if (snapshot.hasError) {
           return AlertDialog(
            title: Text(cropName),
            content: Text('Error: ${snapshot.error}'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
            ],
          );
        }

        final text = snapshot.data ?? 'No explanation available.';
        
        return AlertDialog(
          title: Text(cropName),
          content: SingleChildScrollView(child: Text(text)),
          actions: [
            StreamBuilder<String?>(
              stream: VoiceAssistantService().playingIdStream,
              builder: (context, snapshot) {
                final myId = 'explanation_$cropName';
                final isPlaying = snapshot.data == myId;
                return IconButton(
                  icon: Icon(
                    isPlaying ? LucideIcons.volumeX : LucideIcons.volume2,
                    color: isPlaying ? Colors.red : AppColors.primary,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      VoiceAssistantService().stopSpeaking();
                    } else {
                      VoiceAssistantService().speak(text, appState.userLanguage, id: myId);
                    }
                  },
                );
              },
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ],
        );
      },
    );
  }
}
