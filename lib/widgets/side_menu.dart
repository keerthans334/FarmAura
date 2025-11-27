import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'language_change_modal.dart';
import 'package:farmaura/l10n/app_localizations.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key, required this.appState, required this.onClose});

  final AppState appState;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final panelWidth = width < 360 ? width * 0.85 : width - 48;

    final items = [
      _MenuItem(icon: LucideIcons.home, label: AppLocalizations.of(context)!.home, path: '/dashboard'),
      _MenuItem(icon: LucideIcons.user, label: AppLocalizations.of(context)!.profile, path: '/profile'),
      _MenuItem(icon: LucideIcons.dollarSign, label: AppLocalizations.of(context)!.personalFinance, path: '/finance'),
      _MenuItem(icon: LucideIcons.settings, label: AppLocalizations.of(context)!.settings, path: '/settings'),
      _MenuItem(icon: LucideIcons.upload, label: AppLocalizations.of(context)!.soilHealthCardUpload, path: '/soil'),
      _MenuItem(icon: LucideIcons.gift, label: AppLocalizations.of(context)!.governmentSchemes, path: '/community'),
      _MenuItem(icon: LucideIcons.helpCircle, label: AppLocalizations.of(context)!.helpSupport, path: '/help'),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: panelWidth,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(-4, 0))],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 36, 16, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white24,
                            child: Text('FA', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(height: 10),
                          Text(AppLocalizations.of(context)!.appTitle, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                          Text(AppLocalizations.of(context)!.govJharkhand, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: onClose,
                          icon: const Icon(LucideIcons.x, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      ...items.map((item) => _menuTile(context, item)),
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        leading: const Icon(LucideIcons.languages, color: AppColors.primaryDark, size: 20),
                        title: Text(AppLocalizations.of(context)!.language, style: const TextStyle(color: AppColors.primaryDark)),
                        trailing: Text(appState.userLanguage, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        onTap: () async {
                          await showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => LanguageChangeModal(appState: appState),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.6))),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    tileColor: Colors.red.shade50,
                    leading: const Icon(LucideIcons.logOut, color: Colors.red, size: 20),
                    title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
                    onTap: () {
                      context.go('/');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuTile(BuildContext context, _MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: AppColors.background,
        leading: Icon(item.icon, color: AppColors.primaryDark, size: 20),
        title: Text(item.label, style: const TextStyle(color: AppColors.primaryDark)),
        onTap: () => context.go(item.path),
      ),
    );
  }
}

class _MenuItem {
  _MenuItem({required this.icon, required this.label, required this.path});
  final IconData icon;
  final String label;
  final String path;
}
