import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final features = [
      _Feature(LucideIcons.sprout, 'AI-Powered Recommendations', 'Get personalized crop suggestions based on soil, weather, and market data'),
      _Feature(LucideIcons.target, 'Local Expertise', 'Recommendations tailored for Jharkhand and surrounding regions'),
      _Feature(LucideIcons.users, 'Community Support', 'Connect with fellow farmers and share knowledge'),
      _Feature(LucideIcons.award, 'Expert Guidance', 'Access to agricultural experts and resources'),
    ];

    final stats = [
      _Stat('50,000+', 'Active Farmers'),
      _Stat('24/7', 'AI Assistance'),
      _Stat('100+', 'Crop Varieties'),
      _Stat('95%', 'Satisfaction'),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: 'About Us', showBack: true, showProfile: false, appState: appState),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Icon(LucideIcons.sprout, color: Colors.white, size: 32),
                              ),
                              const Text('FarmAura', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              const Text('Empowering Farmers with AI', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(LucideIcons.heart, size: 16, color: Colors.redAccent),
                                  SizedBox(width: 6),
                                  Text('Government of Jharkhand Initiative', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _textCard(
                          icon: LucideIcons.lightbulb,
                          title: 'Our Mission',
                          text:
                              'FarmAura is an innovative initiative by the Government of Jharkhand aimed at revolutionizing agriculture through artificial intelligence. Our mission is to empower farmers with data-driven insights, personalized recommendations, and modern farming techniques to increase productivity and income.',
                        ),
                        const SizedBox(height: 12),
                        _textCard(
                          icon: LucideIcons.target,
                          title: 'Our Vision',
                          text:
                              'To create a digitally empowered agricultural ecosystem in Jharkhand where every farmer has access to cutting-edge technology, expert guidance, and market intelligence. We envision a future where farming is sustainable, profitable, and technologically advanced.',
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: stats.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4),
                          itemBuilder: (context, index) {
                            final stat = stats[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(stat.value, style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text(stat.label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('What We Offer', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16)),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                        Column(
                          children: features
                              .map(
                                (f) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: Icon(f.icon, color: AppColors.primary, size: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(f.title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 4),
                                            Text(f.desc, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('How FarmAura Works', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16)),
                              const SizedBox(height: 10),
                              _step('1', 'Input Your Farm Details', 'Share information about your land, location, and current conditions'),
                              _step('2', 'AI Analysis', 'Our AI analyzes soil, weather, and market data to find the best crops'),
                              _step('3', 'Get Personalized Recommendations', 'Receive crop suggestions with cultivation tips and profit estimates'),
                              _step('4', 'Track & Optimize', 'Monitor your crops and get ongoing support throughout the season'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)]),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: const [
                              Text('Government of Jharkhand', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16)),
                              SizedBox(height: 6),
                              Text(
                                'FarmAura is developed and maintained by the Department of Agriculture, Animal Husbandry & Cooperative, Government of Jharkhand as part of the state\'s Digital Agriculture initiative.',
                                style: TextStyle(color: AppColors.primaryDark, fontSize: 12, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Get in Touch', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16)),
                              SizedBox(height: 8),
                              _ContactRow(label: 'Email', value: 'support@farmaura.jharkhand.gov.in'),
                              _ContactRow(label: 'Helpline', value: '1800-XXX-XXXX (Toll-Free)'),
                              _ContactRow(label: 'Office', value: 'Department of Agriculture\nGovernment of Jharkhand, Ranchi'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text('Version 1.0.0 • Made with ?? for Jharkhand Farmers', style: TextStyle(color: AppColors.muted, fontSize: 12)),
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

  static Widget _textCard({required IconData icon, required String title, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.6)),
        ],
      ),
    );
  }

  static Widget _step(String number, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
              shape: BoxShape.circle,
            ),
            child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  _Feature(this.icon, this.title, this.desc);
  final IconData icon;
  final String title;
  final String desc;
}

class _Stat {
  _Stat(this.value, this.label);
  final String value;
  final String label;
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.primaryDark, fontSize: 12, height: 1.4))),
        ],
      ),
    );
  }
}

