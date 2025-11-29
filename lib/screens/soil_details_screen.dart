import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

import 'package:farmaura/l10n/app_localizations.dart';
class SoilDetailsScreen extends StatelessWidget {
  const SoilDetailsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final npkData = [
      _Metric(AppLocalizations.of(context)!.nitrogen, 0.45, Colors.blue),
      _Metric(AppLocalizations.of(context)!.phosphorus, 0.38, Colors.purple),
      _Metric(AppLocalizations.of(context)!.potassium, 0.52, Colors.orange),
    ];

    final insights = [
      'Your soil is rich in organic matter', // TODO: Localize dynamic insights if possible or keep generic
      'Consider adding phosphorus fertilizer',
      'pH level is ideal for most crops',
      'Good water retention capacity',
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: AppLocalizations.of(context)!.soilDetails, showBack: true, showProfile: false, appState: appState, onBack: () => Navigator.canPop(context) ? context.pop() : context.go('/dashboard')),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF8D6E63), Color(0xFF6D4C41)]),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 10))],
                          ),
                          child: Column(
                            children: [
                              const Icon(LucideIcons.sprout, size: 48, color: Colors.white),
                              const SizedBox(height: 6),
                              Text(AppLocalizations.of(context)!.soilStatusGood, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                              Text(AppLocalizations.of(context)!.basedOnRegion(appState.location['district']), style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...npkData.map((m) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(m.label, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                                        child: Text('${(m.value * 100).round()}%', style: TextStyle(color: m.color)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      value: m.value,
                                      valueColor: AlwaysStoppedAnimation(m.color),
                                      backgroundColor: AppColors.background,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.soilProperties, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              _PropRow(label: AppLocalizations.of(context)!.soilType, value: 'Loamy'),
                              _PropRow(label: AppLocalizations.of(context)!.phLevel, value: '6.5 (Neutral)'),
                              _PropRow(label: AppLocalizations.of(context)!.moisture, value: '68%'),
                              _PropRow(label: AppLocalizations.of(context)!.organicMatter, value: '4.2%'),
                              _PropRow(label: AppLocalizations.of(context)!.ecSalinity, value: '0.8 dS/m'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.soilInsights, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 130,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Container(
                                    width: 240,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 2)),
                                    child: Text(insights[index], style: const TextStyle(color: AppColors.primaryDark)),
                                  ),
                                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                                  itemCount: insights.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(AppLocalizations.of(context)!.requestSoilTest),
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

class _Metric {
  _Metric(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}

class _PropRow extends StatelessWidget {
  const _PropRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          Text(value, style: const TextStyle(color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}
