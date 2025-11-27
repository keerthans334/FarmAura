import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key, required this.appState});
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
                title: 'Privacy Policy',
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
                      child: Text('Your Data Protection', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text('Last Updated: November 22, 2024', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Our Commitment', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'The Government of Jharkhand is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the FarmAura platform.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Information We Collect', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Personal Information: Name, phone number, email (optional), village, district, and state.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Farm Information: Land size, irrigation methods, soil type, and crop history.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Location Data: GPS coordinates for weather and local recommendations.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Usage Data: App interactions, features used, and recommendation history.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('• Device Information: Device type, OS version, and app version.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('How We Use Your Information', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Provide personalized crop recommendations.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Show relevant weather and market information.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Improve AI model accuracy and recommendations.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Send important agricultural alerts and notifications.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Provide customer support and assistance.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('• Analyze usage patterns to improve the platform.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Data Protection & Security', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'We implement industry-standard security measures to protect your data. All data is encrypted during transmission and storage. Access to personal information is restricted to authorized personnel only. We comply with the Information Technology Act, 2000 and related data protection regulations.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Data Sharing & Disclosure', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('We do not sell your personal information. We may share data with:', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Government Departments: For agricultural planning and policy-making (anonymized data).', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Service Providers: Third-party services that help us operate the platform.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('• Legal Requirements: When required by law or to protect rights and safety.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Your Rights', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Access your personal information.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Correct inaccurate or incomplete data.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Request deletion of your account and data.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('• Opt-out of non-essential communications.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('• Download your data in a portable format.', style: TextStyle(color: AppColors.primaryDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Data Retention', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'We retain your personal information for as long as your account is active or as needed to provide services. If you request account deletion, we will delete or anonymize your data within 30 days, except where retention is required by law.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Children\'s Privacy', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'FarmAura is intended for users 18 years and older. We do not knowingly collect information from children under 18. If you believe we have collected such information, please contact us immediately.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Changes to This Policy', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'We may update this Privacy Policy periodically. We will notify you of significant changes through the app or via email. Your continued use after such modifications constitutes acceptance of the updated policy.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Contact Us', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'For privacy-related questions or to exercise your rights, please contact:\nDepartment of Agriculture, Government of Jharkhand\nEmail: privacy@farmaura.jharkhand.gov.in\nHelpline: 1800-XXX-XXXX',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Your trust is important to us. We are committed to protecting your personal information and using it responsibly to serve you better.',
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
