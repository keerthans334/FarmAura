import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:farmaura/l10n/app_localizations.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class LanguageChangeModal extends StatefulWidget {
  const LanguageChangeModal({super.key, required this.appState});
  final AppState appState;

  @override
  State<LanguageChangeModal> createState() => _LanguageChangeModalState();
}

class _LanguageChangeModalState extends State<LanguageChangeModal> {
  late String selected;

  final languages = const [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': 'IN'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'Hindi', 'flag': 'IN'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'Bangla', 'flag': 'IN'},
    {'code': 'nag', 'name': 'Nagpuri', 'nativeName': 'Nagpuri', 'flag': 'IN'},
    {'code': 'kur', 'name': 'Kurmali', 'nativeName': 'Kurmali', 'flag': 'IN'},
    {'code': 'sat', 'name': 'Santhali', 'nativeName': 'Santhali', 'flag': 'IN'},
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.appState.userLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.55;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.changeLanguage, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(AppLocalizations.of(context)!.selectLanguage, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(LucideIcons.x, color: Colors.white),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final active = selected == lang['name'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => setState(() => selected = lang['name']!),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: active ? AppColors.background : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 2),
                          boxShadow: [
                            if (active)
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lang['name']!, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                                Text(lang['nativeName']!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                              ],
                            ),
                            const Spacer(),
                            if (active)
                              const Icon(LucideIcons.check, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(color: AppColors.border, width: 2),
                      ),
                      child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.muted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.appState.setLanguage(selected);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(AppLocalizations.of(context)!.apply),
                    ),
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
