import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      {'q': 'How to request soil test?', 'a': 'Go to Soil Details and tap Request Soil Test.'},
      {'q': 'How to change language?', 'a': 'Open settings and choose Language.'},
      {'q': 'How to contact support?', 'a': 'Email support@farmaura.in or call 1800-000-000.'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: 'Help & Support', showBack: true, showProfile: false, appState: appState),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Frequently Asked Questions', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 10),
                  ...faqs.map((f) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f['q'] as String, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(f['a'] as String, style: const TextStyle(color: AppColors.muted)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                    child: const Text('Need more help? Email support@farmaura.in or call our helpline.', style: TextStyle(color: AppColors.primaryDark)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
