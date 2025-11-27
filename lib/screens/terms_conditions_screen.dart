import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          context.pop();
        } else {
          context.go('/settings');
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: 'Terms & Conditions',
                showBack: true,
                showProfile: false,
                appState: appState,
                onBack: () => Navigator.canPop(context) ? context.pop() : context.go('/settings'),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('FarmAura Platform', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text('Last Updated: November 22, 2024', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('1. Acceptance of Terms', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'By accessing and using FarmAura, you accept and agree to be bound by these terms and provisions of this agreement. This platform is provided by the Government of Jharkhand for agricultural assistance and guidance.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('2. Use of Service', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('FarmAura provides AI-powered agricultural recommendations and assistance. Users agree to:', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Provide accurate information for better recommendations.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Use the platform for agricultural purposes only.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Not misuse or attempt to manipulate the system.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('• Respect other users in community features.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('3. Data Collection & Privacy', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'We collect location, farm details, and usage data to provide personalized recommendations. Your data is protected under Government of India’s data protection regulations. For more details, please refer to our Privacy Policy.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('4. AI Recommendations Disclaimer', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'While our AI provides data-driven crop recommendations, farmers should also consult local agricultural experts and consider their own experience. The Government of Jharkhand is not liable for any losses incurred from following recommendations.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('5. User Responsibilities', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('Users are responsible for:', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Maintaining confidentiality of their account.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• All activities under their account.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Ensuring device security and internet connectivity.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('• Reporting any bugs or issues to support.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('6. Service Availability', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'We strive to keep FarmAura available 24/7, but we do not guarantee uninterrupted service. Maintenance, updates, or technical issues may cause temporary unavailability.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('7. Intellectual Property', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'All content, features, and functionality on FarmAura are owned by the Government of Jharkhand and are protected by copyright, trademark, and other intellectual property laws.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('8. Modifications to Terms', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'The Government of Jharkhand reserves the right to modify these terms at any time. Users will be notified of significant changes. Continued use of the platform constitutes acceptance of modified terms.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('9. Contact Information', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'For questions about these terms, please contact:\nDepartment of Agriculture, Government of Jharkhand\nEmail: support@farmaura.jharkhand.gov.in\nHelpline: 1800-XXX-XXXX',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'By using FarmAura, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
