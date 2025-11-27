import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/language_change_modal.dart';
import 'package:farmaura/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final location = widget.appState.location;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: AppLocalizations.of(context)!.settings,
              showBack: true,
              showProfile: false,
              appState: widget.appState,
              onBack: () => Navigator.canPop(context) ? context.pop() : context.go('/profile'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topCard(context),
                    const SizedBox(height: 16),
                    _sectionTitle(AppLocalizations.of(context)!.preferences),
                    const SizedBox(height: 8),
                    _toggleTile(
                      icon: LucideIcons.bell,
                      title: AppLocalizations.of(context)!.notifications,
                      subtitle: notificationsEnabled ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled,
                      value: notificationsEnabled,
                      onChanged: (val) => setState(() => notificationsEnabled = val),
                    ),
                    _navTile(
                      icon: LucideIcons.languages,
                      title: AppLocalizations.of(context)!.language,
                      subtitle: widget.appState.userLanguage,
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => LanguageChangeModal(appState: widget.appState),
                      ),
                    ),
                    _navTile(
                      icon: LucideIcons.mapPin,
                      title: AppLocalizations.of(context)!.location,
                      subtitle: "${location['district']}, ${location['state']}",
                      onTap: () {},
                    ),
                    const SizedBox(height: 14),
                    _sectionTitle(AppLocalizations.of(context)!.privacySecurity),
                    const SizedBox(height: 8),
                    _navTile(
                      icon: LucideIcons.shield,
                      title: AppLocalizations.of(context)!.privacyPolicy,
                      subtitle: AppLocalizations.of(context)!.privacyPolicySubtitle,
                      onTap: () => context.go('/privacy-policy'),
                    ),
                    _navTile(
                      icon: LucideIcons.fileText,
                      title: AppLocalizations.of(context)!.termsOfService,
                      subtitle: AppLocalizations.of(context)!.termsOfServiceSubtitle,
                      onTap: () => context.go('/terms-conditions'),
                    ),
                    const SizedBox(height: 14),
                    _sectionTitle(AppLocalizations.of(context)!.support),
                    const SizedBox(height: 8),
                    _navTile(
                      icon: LucideIcons.lifeBuoy,
                      title: AppLocalizations.of(context)!.helpSupport,
                      subtitle: AppLocalizations.of(context)!.helpSupportSubtitle,
                      onTap: () => context.go('/help-support'),
                    ),
                    _navTile(
                      icon: LucideIcons.info,
                      title: AppLocalizations.of(context)!.about,
                      subtitle: AppLocalizations.of(context)!.aboutSubtitle,
                      onTap: () => context.go('/about-us'),
                    ),
                    const SizedBox(height: 16),
                    _govCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 14, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
            child: const Icon(LucideIcons.settings, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.settings, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Manage your preferences', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: const TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700));
  }

  Widget _toggleTile({required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryDark),
        title: Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.muted)),
        trailing: Switch(value: value, onChanged: onChanged),
        onTap: () => onChanged(!value),
      ),
    );
  }

  Widget _navTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryDark),
        title: Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.muted)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
        onTap: onTap,
      ),
    );
  }

  Widget _govCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 8))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.badgeCheck, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.govJharkhand, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)!.govSubtitle, style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 6),
                Text('${AppLocalizations.of(context)!.version} 1.0.0', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
