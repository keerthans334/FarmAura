import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final navItems = [
      _NavItem(path: '/pest', label: 'Pest', icon: LucideIcons.bug),
      _NavItem(path: '/crop-rec', label: 'Crop', icon: LucideIcons.sprout),
      _NavItem(path: '/dashboard', label: 'Home', icon: LucideIcons.home),
      _NavItem(path: '/profile', label: 'Profile', icon: LucideIcons.user),
      _NavItem(path: '/videos', label: 'Videos', icon: LucideIcons.video),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -2))],
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isActive = location == item.path;
          return Expanded(
            child: InkWell(
              onTap: () => context.go(item.path),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, color: isActive ? AppColors.primary : AppColors.muted, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive ? AppColors.primary : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  _NavItem({required this.path, required this.label, required this.icon});
  final String path;
  final String label;
  final IconData icon;
}
