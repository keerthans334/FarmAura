import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class CropRecommendationStartScreen extends StatelessWidget {
  const CropRecommendationStartScreen({super.key, required this.appState});
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: primaryGradient(),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: AppColors.primaryDark.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 10))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.auto_awesome, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text('AI-Powered', style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text('Crop Advisory', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              const Text('Get personalized crop recommendations based on your farm\'s unique conditions', style: TextStyle(color: Colors.white70)),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.go('/crop-input'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primary,
                                  ),
                                  child: const Text('Start Crop Advisory'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=600&h=300&fit=crop'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 10))],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _statCard(title: '98%', subtitle: 'Accuracy', icon: Icons.trending_up, color: AppColors.primary),
                            const SizedBox(width: 10),
                            _statCard(title: '50K+', subtitle: 'Farmers', icon: Icons.groups, color: AppColors.accent),
                            const SizedBox(width: 10),
                            _statCard(title: '30+', subtitle: 'Crops', icon: Icons.spa, color: AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('How It Works', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
                              SizedBox(height: 12),
                              _StepTile(number: '1', title: 'Enter Farm Details', subtitle: 'Provide information about your land size, irrigation, and location'),
                              _StepTile(number: '2', title: 'Share Soil Data', subtitle: 'Enter soil type, pH levels, and nutrient information'),
                              _StepTile(number: '3', title: 'Get AI Recommendations', subtitle: 'Receive top 3 crop suggestions with detailed yield and profit analysis'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Why Use Crop Advisory?', style: TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w700)),
                              SizedBox(height: 10),
                              _Bullet(text: 'Maximize your farm profits with data-driven decisions'),
                              _Bullet(text: 'Reduce crop failure risk with suitable crop selection'),
                              _Bullet(text: 'Get market-demand based crop suggestions'),
                              _Bullet(text: 'Access detailed growing guides for each crop'),
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
            const FloatingIVR(),
          ],
        ),
      ),
    );
  }

  Widget _statCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))]),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.title, required this.subtitle});
  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
              shape: BoxShape.circle,
            ),
            child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.primaryDark, fontSize: 13))),
        ],
      ),
    );
  }
}
