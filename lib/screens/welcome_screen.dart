import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showAllLanguages = false;
  late String selectedLanguage;

  final languages = const [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'Hindi'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'Bengali'},
    {'code': 'nag', 'name': 'Nagpuri', 'native': 'Nagpuri'},
    {'code': 'kur', 'name': 'Kurmali', 'native': 'Kurmali'},
    {'code': 'sat', 'name': 'Santhali', 'native': 'Santhali'},
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.appState.userLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: viewPadding.bottom + 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [BoxShadow(color: AppColors.primaryDark.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 12))],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(LucideIcons.sprout, color: Colors.white, size: 56),
                              ),
                              Positioned(
                                right: -10,
                                top: -10,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('FarmAura', style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 6),
                          const Text('Government of Jharkhand', style: TextStyle(color: AppColors.muted)),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.appState.setLanguage(selectedLanguage);
                                context.go('/login', extra: {'isNewUser': true});
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                backgroundColor: null,
                                foregroundColor: Colors.white,
                                elevation: 10,
                              ).copyWith(
                                backgroundColor: WidgetStateProperty.all(AppColors.primary),
                              ),
                              child: const Text('Get Started'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => context.go('/login'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                side: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              child: const Text('Login', style: TextStyle(color: AppColors.primaryDark)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Already have an account? Login to continue',
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () => setState(() => showAllLanguages = !showAllLanguages),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border, width: 2),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6))],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(LucideIcons.globe, color: AppColors.primary),
                                      const SizedBox(width: 10),
                                      Text(selectedLanguage, style: const TextStyle(color: AppColors.primaryDark)),
                                    ],
                                  ),
                                  Icon(showAllLanguages ? LucideIcons.chevronUp : LucideIcons.chevronDown, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                          if (showAllLanguages)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.primary, width: 2),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 8))],
                              ),
                              child: Column(
                                children: languages
                                    .map(
                                      (lang) => ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(lang['native']!, style: TextStyle(color: lang['name'] == selectedLanguage ? AppColors.primaryDark : AppColors.muted)),
                                        trailing: lang['name'] == selectedLanguage ? const Icon(LucideIcons.check, color: AppColors.primary) : null,
                                        onTap: () {
                                          setState(() => selectedLanguage = lang['name']!);
                                          widget.appState.setLanguage(lang['name']!);
                                          setState(() => showAllLanguages = false);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
