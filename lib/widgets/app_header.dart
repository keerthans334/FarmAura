import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'side_menu.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.showProfile = true,
    this.showMenu = true,
    this.onBack,
    this.onMenuTap,
    required this.appState,
  });

  final String? title;
  final bool showBack;
  final bool showProfile;
  final bool showMenu;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;
  final AppState appState;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool _menuOpen = false;

  void _openMenu() async {
    setState(() => _menuOpen = true);
    await showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, _, __) {
        return SideMenu(
          appState: widget.appState,
          onClose: () => Navigator.of(context).maybePop(),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final offset = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
    );
    setState(() => _menuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.showBack)
                InkWell(
                  onTap: () => widget.onBack != null ? widget.onBack!() : context.pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(LucideIcons.arrowLeft, color: AppColors.primaryDark, size: 20),
                  ),
                )
              else if (widget.showProfile)
                GestureDetector(
                  onTap: widget.onMenuTap ?? () => context.go('/profile'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'FA',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              if (widget.title != null) ...[
                const SizedBox(width: 12),
                Text(widget.title!, style: Theme.of(context).textTheme.titleMedium),
              ],
            ],
          ),
          if (widget.showMenu)
            InkWell(
              onTap: _menuOpen ? null : _openMenu,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(LucideIcons.moreVertical, color: AppColors.primaryDark, size: 20),
              ),
            )
          else
            const SizedBox(width: 36, height: 36),
        ],
      ),
    );
  }
}
