import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class FloatingAI extends StatelessWidget {
  const FloatingAI({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 96,
      right: 16,
      child: FloatingActionButton(
        onPressed: () => context.go('/ai-chat'),
        backgroundColor: AppColors.primary,
        elevation: 8,
        child: const Icon(LucideIcons.bot, color: Colors.white),
      ),
    );
  }
}
