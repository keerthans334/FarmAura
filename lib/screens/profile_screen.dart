import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/floating_ivr.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final user = appState.userData;
    final farm = appState.farmDetails;
    final stats = appState.profileStats;
    final location = appState.location;
    final cropsList = (farm['mainCrops'] as List?)?.whereType<String>().toList() ?? const [];
    final crops = cropsList.isNotEmpty ? cropsList.join(', ') : 'Maize, Wheat';
    final locationParts = <String>[
      if ((user['village'] as String?)?.isNotEmpty == true) user['village'] as String,
      if ((user['district'] as String?)?.isNotEmpty == true)
        user['district'] as String
      else if ((location['district'] as String?)?.isNotEmpty == true)
        location['district'] as String,
      if ((user['state'] as String?)?.isNotEmpty == true)
        user['state'] as String
      else if ((location['state'] as String?)?.isNotEmpty == true)
        location['state'] as String,
    ];
    final locationLine = locationParts.join(', ');

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  title: 'My Profile',
                  showBack: true,
                  showProfile: false,
                  appState: appState,
                  onBack: () => context.go('/dashboard'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileCard(context, user, locationLine, stats),
                        const SizedBox(height: 18),
                        _sectionTitle('My Farm Summary'),
                        const SizedBox(height: 10),
                        _farmSummaryGrid(farm, crops),
                        const SizedBox(height: 18),
                        _sectionTitle('Crop History'),
                        const SizedBox(height: 10),
                        _cropHistory(appState.cropHistory),
                        const SizedBox(height: 18),
                        _sectionTitle('Saved Recommendations'),
                        const SizedBox(height: 10),
                        _savedRecommendations(context, appState.savedRecommendations),
                        const SizedBox(height: 18),
                        _sectionTitle('Actions'),
                        const SizedBox(height: 8),
                        _actionsList(context),
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

  Widget _profileCard(BuildContext context, Map<String, dynamic> user, String locationLine, Map<String, num> stats) {
    final rating = stats['rating'];
    final ratingText = rating is num ? (rating % 1 == 0 ? rating.toStringAsFixed(0) : rating.toStringAsFixed(1)) : '0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
                child: const Icon(Icons.person, color: Colors.white, size: 38),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (user['name'] as String?)?.isNotEmpty == true ? user['name'] as String : 'Farmer',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      (user['occupation'] as String?)?.isNotEmpty == true ? user['occupation'] as String : 'Farmer',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            locationLine.isNotEmpty ? locationLine : 'Jharkhand',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(LucideIcons.phone, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          user['phone']?.toString().isNotEmpty == true ? user['phone'] as String : '+91 00000 00000',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => context.go('/profile-edit'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.14), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(LucideIcons.edit3, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _statItem('Crops Grown', "${stats['cropsGrown'] ?? 0}"),
                _divider(),
                _statItem('Active Fields', "${stats['activeFields'] ?? 0}"),
                _divider(),
                _statItem('Rating', ratingText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 32,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withOpacity(0.3),
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(text, style: const TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700));
  }

  Widget _farmSummaryGrid(Map<String, dynamic> farm, String crops) {
    final summaryItems = [
      {'title': 'Land Size', 'value': (farm['landSize'] ?? '2-5 Acres').toString(), 'icon': LucideIcons.ruler},
      {'title': 'Irrigation', 'value': (farm['irrigation'] ?? 'Rainfed').toString(), 'icon': LucideIcons.droplets},
      {'title': 'Soil Type', 'value': (farm['soilType'] ?? 'Loamy').toString(), 'icon': LucideIcons.shovel},
      {'title': 'Main Crops', 'value': crops, 'icon': LucideIcons.wheat},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemCount: summaryItems.length,
      itemBuilder: (context, index) {
        final item = summaryItems[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'] as IconData, color: AppColors.primaryDark, size: 18),
              ),
              const SizedBox(height: 10),
              Text(item['title'] as String, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                item['value'] as String,
                style: const TextStyle(color: AppColors.primaryDark, fontSize: 15, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cropHistory(List<Map<String, dynamic>> history) {
    if (history.isEmpty) {
      return const Text('No crop history added yet', style: TextStyle(color: AppColors.muted));
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = history[index];
          return Container(
            width: 210,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(LucideIcons.leaf, color: AppColors.primaryDark, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['crop']?.toString() ?? '-', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                          Text(item['season']?.toString() ?? '', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Yield', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        Text("${item['yield'] ?? '-'} ${item['unit'] ?? ''}", style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Profit', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        Text(item['profit']?.toString() ?? '-', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _savedRecommendations(BuildContext context, List<Map<String, dynamic>> recommendations) {
    if (recommendations.isEmpty) {
      return const Text('No saved recommendations yet', style: TextStyle(color: AppColors.muted));
    }

    return Column(
      children: recommendations
          .map(
            (rec) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(LucideIcons.sprout, color: AppColors.primaryDark, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rec['crop']?.toString() ?? 'Crop', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                        Text(rec['date']?.toString() ?? '', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${rec['suitability'] ?? 0}%", style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Open details for ${rec['crop'] ?? 'crop'}")),
                        ),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _actionsList(BuildContext context) {
    return Column(
      children: [
        _actionTile(
          context,
          icon: LucideIcons.edit3,
          title: 'Edit Profile',
          onTap: () => context.go('/profile-edit'),
        ),
        _actionTile(
          context,
          icon: LucideIcons.wallet,
          title: 'Personal Finance',
          onTap: () => context.go('/finance'),
        ),
        _actionTile(
          context,
          icon: LucideIcons.wheat,
          title: 'Manage Farms',
          onTap: () => context.go('/farm-details'),
        ),
        _actionTile(
          context,
          icon: LucideIcons.settings,
          title: 'Settings',
          onTap: () => context.go('/settings'),
        ),
        _actionTile(
          context,
          icon: LucideIcons.logOut,
          title: 'Logout',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout clicked'))),
        ),
      ],
    );
  }

  Widget _actionTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryDark),
        title: Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
        onTap: onTap,
      ),
    );
  }
}
