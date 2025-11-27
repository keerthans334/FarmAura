import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key, required this.languages, required this.onSelected, this.selected});
  final List<String> languages;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: languages
          .map(
            (lang) => ListTile(
              title: Text(lang, style: const TextStyle(color: AppColors.primaryDark)),
              trailing: selected == lang ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () => onSelected(lang),
            ),
          )
          .toList(),
    );
  }
}
