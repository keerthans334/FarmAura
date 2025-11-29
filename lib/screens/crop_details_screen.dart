import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

import 'package:farmaura/l10n/app_localizations.dart';
class CropDetailsScreen extends StatelessWidget {
  const CropDetailsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: AppLocalizations.of(context)!.cropDetails, showBack: true, showProfile: false, appState: appState),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(LucideIcons.sprout, color: Colors.white, size: 32),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppLocalizations.of(context)!.cotton, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                        Text(AppLocalizations.of(context)!.excellentSoilMatch, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!.suitabilityScore, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                    const Text('95%', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 0.95,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    color: Colors.white,
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Stats Row
                          Row(
                            children: [
                              Expanded(child: _StatCard(label: AppLocalizations.of(context)!.expectedProfit, value: '₹85,000', subLabel: AppLocalizations.of(context)!.perAcre, icon: Icons.attach_money)),
                              const SizedBox(width: 16),
                              Expanded(child: _StatCard(label: AppLocalizations.of(context)!.yieldEstimate, value: '18-20 quintals/acre', icon: LucideIcons.trendingUp)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Growing Requirements
                          Text(AppLocalizations.of(context)!.growingRequirements, style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _RequirementItem(icon: LucideIcons.calendar, label: AppLocalizations.of(context)!.growingPeriod, value: AppLocalizations.of(context)!.growingPeriodValue),
                          _RequirementItem(icon: LucideIcons.droplets, label: AppLocalizations.of(context)!.waterRequirement, value: AppLocalizations.of(context)!.waterRequirementValue),
                          _RequirementItem(icon: LucideIcons.sun, label: AppLocalizations.of(context)!.temperatureRange, value: AppLocalizations.of(context)!.temperatureRangeValue),
                          _RequirementItem(icon: LucideIcons.globe, label: AppLocalizations.of(context)!.soilType, value: AppLocalizations.of(context)!.blackCottonSoilRedSoil),
                          _RequirementItem(icon: LucideIcons.flaskConical, label: AppLocalizations.of(context)!.phRange, value: AppLocalizations.of(context)!.phRangeValue),
                          _RequirementItem(icon: LucideIcons.cloudRain, label: AppLocalizations.of(context)!.rainfall, value: AppLocalizations.of(context)!.rainfallValue),

                          const SizedBox(height: 24),
                          // Growing Stages
                          Text(AppLocalizations.of(context)!.growingStages, style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _StageItem(icon: LucideIcons.sprout, title: AppLocalizations.of(context)!.sowing, days: '0-15 days', description: AppLocalizations.of(context)!.sowingDesc),
                          _StageItem(icon: LucideIcons.leaf, title: AppLocalizations.of(context)!.vegetative, days: '15-60 days', description: AppLocalizations.of(context)!.vegetativeDesc),
                          _StageItem(icon: LucideIcons.flower, title: AppLocalizations.of(context)!.flowering, days: '60-90 days', description: AppLocalizations.of(context)!.floweringDesc),
                          _StageItem(icon: LucideIcons.wheat, title: AppLocalizations.of(context)!.bollFormation, days: '90-120 days', description: AppLocalizations.of(context)!.bollFormationDesc),
                          _StageItem(icon: LucideIcons.hand, title: AppLocalizations.of(context)!.harvesting, days: '150-180 days', description: AppLocalizations.of(context)!.harvestingDesc, isLast: true),

                          const SizedBox(height: 24),
                          // Fertilizer Plan
                          Text(AppLocalizations.of(context)!.fertilizerPlan, style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _PlanCard(title: AppLocalizations.of(context)!.basal, day: 'Day 0', item: AppLocalizations.of(context)!.dap, quantity: '50 kg/acre'),
                          _PlanCard(title: AppLocalizations.of(context)!.firstDose, day: 'Day 30', item: AppLocalizations.of(context)!.urea, quantity: '25 kg/acre'),
                          _PlanCard(title: AppLocalizations.of(context)!.secondDose, day: 'Day 60', item: AppLocalizations.of(context)!.npk191919, quantity: '30 kg/acre'),
                          _PlanCard(title: AppLocalizations.of(context)!.thirdDose, day: 'Day 90', item: AppLocalizations.of(context)!.potash, quantity: '20 kg/acre'),

                          const SizedBox(height: 24),
                          // Irrigation Schedule
                          Text(AppLocalizations.of(context)!.irrigationSchedule, style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _PlanCard(title: AppLocalizations.of(context)!.sowingToGermination, day: 'Days 0-10', item: AppLocalizations.of(context)!.lightIrrigation, quantity: '20mm', isGreen: true),
                          _PlanCard(title: AppLocalizations.of(context)!.vegetativeGrowth, day: 'Days 15-60', item: AppLocalizations.of(context)!.every7to10Days, quantity: '40-50mm per irrigation', isGreen: true),
                          _PlanCard(title: AppLocalizations.of(context)!.flowering, day: 'Days 60-90', item: AppLocalizations.of(context)!.every5to7Days, quantity: '50-60mm per irrigation', isGreen: true),
                          _PlanCard(title: AppLocalizations.of(context)!.bollDevelopment, day: 'Days 90-150', item: AppLocalizations.of(context)!.every7to10Days, quantity: '40-50mm per irrigation', isGreen: true),

                          const SizedBox(height: 24),
                          // Market Information
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.marketInformation, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                _MarketRow(label: AppLocalizations.of(context)!.currentPrice, value: '₹6,500/quintal'),
                                _MarketRow(label: AppLocalizations.of(context)!.marketTrend, value: AppLocalizations.of(context)!.stable),
                                _MarketRow(label: AppLocalizations.of(context)!.demand, value: AppLocalizations.of(context)!.high),
                                const SizedBox(height: 16),
                                Text(AppLocalizations.of(context)!.majorBuyers, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(AppLocalizations.of(context)!.textileMillsExportMarket, style: const TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),
                        // Footer Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.pop(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(AppLocalizations.of(context)!.tryDifferentInputs, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.push('/market-prices'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                child: Text(AppLocalizations.of(context)!.viewMarketPrices, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.subLabel, required this.icon});
  final String label;
  final String value;
  final String? subLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.muted),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          if (subLabel != null)
            Text(subLabel!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageItem extends StatelessWidget {
  const _StageItem({required this.icon, required this.title, required this.days, required this.description, this.isLast = false});
  final IconData icon;
  final String title;
  final String days;
  final String description;
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
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(days, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.day, required this.item, required this.quantity, this.isGreen = false});
  final String title;
  final String day;
  final String item;
  final String quantity;
  final bool isGreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGreen ? const Color(0xFFE8F5E9) : const Color(0xFFFAFAF5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 14)),
              Text(day, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              Text(quantity, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w500, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarketRow extends StatelessWidget {
  const _MarketRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
