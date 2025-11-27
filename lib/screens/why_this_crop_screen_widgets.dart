import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.content});
  final String title;
  final String content;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPositive ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: isPositive ? Colors.green.shade800 : Colors.red.shade800, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}

class _ProfitRow extends StatelessWidget {
  const _ProfitRow({required this.label, required this.value});
  final String label;
  final String value;
  final bool isBold;
  final bool isGreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted)),
        Text(value, style: TextStyle(color: isGreen ? Colors.green : AppColors.primaryDark, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, fontSize: isBold ? 16 : 14)),
      ],
    );
  }
}
