import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

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
                AppHeader(title: 'Crop Details', showBack: true, showProfile: false, appState: appState),
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
                                    children: const [
                                      Text('Cotton', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                      Text('Excellent soil match', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Suitability Score', style: TextStyle(color: Colors.white, fontSize: 14)),
                                  Text('95%', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
                            Expanded(child: _StatCard(label: 'Expected Profit', value: '₹85,000', subLabel: 'per acre', icon: Icons.attach_money)),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCard(label: 'Yield Estimate', value: '18-20 quintals/acre', icon: LucideIcons.trendingUp)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Growing Requirements
                        const Text('Growing Requirements', style: TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _RequirementItem(icon: LucideIcons.calendar, label: 'Growing Period', value: '150-180 days'),
                        _RequirementItem(icon: LucideIcons.droplets, label: 'Water Requirement', value: 'Medium (600-700mm)'),
                        _RequirementItem(icon: LucideIcons.sun, label: 'Temperature Range', value: '21-30°C'),
                        _RequirementItem(icon: LucideIcons.globe, label: 'Soil Type', value: 'Black cotton soil, Red soil'),
                        _RequirementItem(icon: LucideIcons.flaskConical, label: 'pH Range', value: '6.0-7.5 (Slightly acidic to neutral)'),
                        _RequirementItem(icon: LucideIcons.cloudRain, label: 'Rainfall', value: '600-1200mm annually'),

                        const SizedBox(height: 24),
                        // Growing Stages
                        const Text('Growing Stages', style: TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _StageItem(icon: LucideIcons.sprout, title: 'Sowing', days: '0-15 days', description: 'Seed treatment, Land preparation'),
                        _StageItem(icon: LucideIcons.leaf, title: 'Vegetative', days: '15-60 days', description: 'Irrigation, Weeding, First fertilizer dose'),
                        _StageItem(icon: LucideIcons.flower, title: 'Flowering', days: '60-90 days', description: 'Pest control, Second fertilizer dose'),
                        _StageItem(icon: LucideIcons.wheat, title: 'Boll Formation', days: '90-120 days', description: 'Regular monitoring, Adequate water supply'),
                        _StageItem(icon: LucideIcons.hand, title: 'Harvesting', days: '150-180 days', description: 'Hand picking when bolls open', isLast: true),

                        const SizedBox(height: 24),
                        // Fertilizer Plan
                        const Text('Stage-wise Fertilizer Plan', style: TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _PlanCard(title: 'Basal (At sowing)', day: 'Day 0', item: 'DAP', quantity: '50 kg/acre'),
                        _PlanCard(title: 'First dose', day: 'Day 30', item: 'Urea', quantity: '25 kg/acre'),
                        _PlanCard(title: 'Second dose', day: 'Day 60', item: 'NPK (19:19:19)', quantity: '30 kg/acre'),
                        _PlanCard(title: 'Third dose', day: 'Day 90', item: 'Potash', quantity: '20 kg/acre'),

                        const SizedBox(height: 24),
                        // Irrigation Schedule
                        const Text('Irrigation Schedule', style: TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _PlanCard(title: 'Sowing to germination', day: 'Days 0-10', item: 'Light irrigation', quantity: '20mm', isGreen: true),
                        _PlanCard(title: 'Vegetative growth', day: 'Days 15-60', item: 'Every 7-10 days', quantity: '40-50mm per irrigation', isGreen: true),
                        _PlanCard(title: 'Flowering', day: 'Days 60-90', item: 'Every 5-7 days', quantity: '50-60mm per irrigation', isGreen: true),
                        _PlanCard(title: 'Boll development', day: 'Days 90-150', item: 'Every 7-10 days', quantity: '40-50mm per irrigation', isGreen: true),

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
                              const Text('Market Information', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _MarketRow(label: 'Current Price:', value: '₹6,500/quintal'),
                              _MarketRow(label: 'Market Trend:', value: 'Stable'),
                              _MarketRow(label: 'Demand:', value: 'High'),
                              const SizedBox(height: 16),
                              const Text('Major Buyers:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              const Text('Textile mills, Export market', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                                child: const Text('Try Different Inputs', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
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
                                child: const Text('View Market Prices', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
            const FloatingIVR(),
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
