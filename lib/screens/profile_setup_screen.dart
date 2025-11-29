import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_ivr.dart';

import 'package:farmaura/l10n/app_localizations.dart';
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _villageCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String occupation = 'Farmer';

  final occupations = const [
    {'value': 'Farmer', 'asset': 'assets/icons/occupation/farmer.svg'},
    {'value': 'Agricultural Worker', 'asset': 'assets/icons/occupation/agricultural_worker.svg'},
    {'value': 'Landowner', 'asset': 'assets/icons/occupation/landowner.svg'},
    {'value': 'Tenant Farmer', 'asset': 'assets/icons/occupation/tenant_farmer.svg'},
    {'value': 'Other', 'asset': 'assets/icons/occupation/other.svg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.userCircle2, color: Colors.white, size: 46),
                  ),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.of(context)!.personalInformation, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context)!.helpUsKnowYou, style: const TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 12))],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildField(AppLocalizations.of(context)!.fullName, _nameCtrl),
                          _buildField(AppLocalizations.of(context)!.villageName, _villageCtrl),
                          _buildField(AppLocalizations.of(context)!.emailOptional, _emailCtrl, keyboard: TextInputType.emailAddress, validator: (_) => null),
                          const SizedBox(height: 4),
                          _occupationGrid(),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!(_formKey.currentState?.validate() ?? false)) return;
                                widget.appState.updateUserData({
                                  'name': _nameCtrl.text,
                                  'village': _villageCtrl.text,
                                  'email': _emailCtrl.text,
                                  'occupation': occupation,
                                });
                                context.go('/farm-setup');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(AppLocalizations.of(context)!.continueText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 32, height: 6, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12))),
                      const SizedBox(width: 6),
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(12))),
                      const SizedBox(width: 6),
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(12))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType keyboard = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.primaryDark, fontSize: 13)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            validator: validator ?? (v) => (v == null || v.isEmpty) ? AppLocalizations.of(context)!.required : null,
            decoration: const InputDecoration(hintText: ''),
          ),
        ],
      ),
    );
  }

  Widget _occupationGrid() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.occupation, style: const TextStyle(color: AppColors.primaryDark, fontSize: 13)),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 2;
              const spacing = 10.0;
              const padding = 12.0;
              const iconSize = 24.0;
              const labelStyle = TextStyle(fontSize: 14);
              final textScale = MediaQuery.textScaleFactorOf(context);
              final labelPainter = TextPainter(
                text: const TextSpan(text: 'Agricultural Worker', style: labelStyle),
                textDirection: TextDirection.ltr,
                maxLines: 1,
                textScaleFactor: textScale,
              )..layout();
              final labelHeight = labelPainter.size.height;
              final desiredHeight = padding * 2 + iconSize + 4 + labelHeight;
              final itemWidth = (constraints.maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
              final aspectRatio = itemWidth / desiredHeight;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: occupations.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) {
                  final occ = occupations[index];
                  final active = occupation == occ['value'];
                  return GestureDetector(
                    onTap: () => setState(() => occupation = occ['value'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        gradient: active ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]) : null,
                        color: active ? null : AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 2),
                        boxShadow: [
                          if (active)
                            BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: SvgPicture.asset(
                              occ['asset'] as String,
                              width: iconSize,
                              height: iconSize,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              occ['value'] as String,
                              style: TextStyle(color: active ? Colors.white : AppColors.primaryDark, fontSize: 14),
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
