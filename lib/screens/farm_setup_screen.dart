import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_ivr.dart';
import '../utils/location_helper.dart';

class FarmSetupScreen extends StatefulWidget {
  const FarmSetupScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends State<FarmSetupScreen> {
  final landSizes = const [
    {'value': '< 1 Acre', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '1-2 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '2-5 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '5-10 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '> 10 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': 'Custom', 'icon': null},
  ];

  final irrigationTypes = const [
    {'type': 'Rainfed', 'icon': 'assets/icons/irrigation/rainfed.svg', 'desc': 'Rain dependent', 'color': [Color(0xFF42A5F5), Color(0xFF1E88E5)]},
    {'type': 'Canal', 'icon': 'assets/icons/irrigation/canal.svg', 'desc': 'Canal irrigation', 'color': [Color(0xFF26C6DA), Color(0xFF00ACC1)]},
    {'type': 'Borewell', 'icon': 'assets/icons/irrigation/borewell.svg', 'desc': 'Borewell water', 'color': [Color(0xFFFFD54F), Color(0xFFFFB300)]},
    {'type': 'Drip', 'icon': 'assets/icons/irrigation/drip.svg', 'desc': 'Drip irrigation', 'color': [Color(0xFF26A69A), Color(0xFF00897B)]},
  ];

  final pastCropOptions = const [
    'Rice',
    'Wheat',
    'Maize',
    'Mustard',
    'Cotton',
    'Soybean',
    'Pulses',
    'Vegetables',
  ];

  String? landSize;
  String? irrigation;
  String customLandSize = '';
  bool detected = false;
  bool _isLocating = false;
  final List<String> selectedPastCrops = [];
  final TextEditingController customCropController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final farm = widget.appState.farmDetails;
    final storedLand = farm['landSize'];
    final storedIrrigation = farm['irrigation'];
    landSize = storedLand is String && storedLand.isNotEmpty ? storedLand : null;
    irrigation = storedIrrigation is String && storedIrrigation.isNotEmpty ? storedIrrigation : null;
    final past = farm['pastCrops'];
    if (past is List) {
      selectedPastCrops.addAll(past.whereType<String>());
    }
  }

  @override
  void dispose() {
    customCropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showCustom = landSize == 'Custom';
    final canSubmit = (showCustom ? customLandSize.isNotEmpty : landSize != null) && irrigation != null;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.sprout, color: Colors.white, size: 44),
                        ),
                        const SizedBox(height: 12),
                        Text('Farm Details', style: Theme.of(context).textTheme.headlineSmall),
                        const Text('Tell us about your farmland', style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/location/location_pin.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
                            const SizedBox(width: 6),
                            const Text('Location', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _isLocating ? null : () async {
                            setState(() => _isLocating = true);
                            try {
                              await widget.appState.updateLocationFromService();
                              if (mounted) {
                                setState(() {
                                  _isLocating = false;
                                  detected = true;
                                });
                              }
                            } catch (e) {
                              if (mounted) {
                                setState(() => _isLocating = false);
                                if (e.toString().contains('Location services are disabled')) {
                                  LocationHelper.showLocationServiceDialog(context, () {
                                    // Retry logic handled by user tapping button again or we can auto-trigger
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                }
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFF9800)]),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isLocating)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                else
                                  SvgPicture.asset('assets/icons/location/gps_arrow.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                const SizedBox(width: 8),
                                Text(_isLocating ? 'Detecting...' : 'Auto-Detect via GPS', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        if (detected) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)]),
                              border: Border.all(color: AppColors.primary, width: 2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.check, color: AppColors.primaryDark, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${widget.appState.location['district'] ?? 'Ranchi'}, ${widget.appState.location['state'] ?? 'Jharkhand'}',
                                          style: const TextStyle(color: AppColors.primaryDark, fontSize: 14, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 2),
                                      const Text('Location detected successfully', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Land Size', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const spacing = 12.0;
                            const padding = 16.0;
                            const iconSize = 22.0;
                            const gap = 4.0;
                            const labelStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
                            const aspectRatio = 0.95; // lower ratio = taller card to remove overflow

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: landSizes.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                                childAspectRatio: aspectRatio,
                              ),
                              itemBuilder: (context, index) {
                                final size = landSizes[index];
                                final active = landSize == size['value'] || (size['value'] == 'Custom' && landSize == 'Custom');
                                return GestureDetector(
                                  onTap: () => setState(() => landSize = size['value'] as String),
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (size['icon'] != null)
                                          SvgPicture.asset(
                                            size['icon'] as String,
                                            width: iconSize,
                                            height: iconSize,
                                            colorFilter: active ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                                          )
                                        else
                                          Icon(LucideIcons.pencil, size: iconSize, color: active ? Colors.white : AppColors.primaryDark),
                                        const SizedBox(height: gap),
                                        Text(
                                          size['value'] as String,
                                          style: labelStyle.copyWith(color: active ? Colors.white : AppColors.primaryDark),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        if (showCustom) ...[
                          const SizedBox(height: 10),
                          TextField(
                            decoration: const InputDecoration(hintText: 'Enter land size (e.g., 3.5 Acres)'),
                            onChanged: (v) => setState(() => customLandSize = v),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Irrigation Type', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const spacing = 16.0;
                            const padding = 20.0;
                            const iconSize = 30.0;
                            const aspectRatio = 0.85; // taller cards to eliminate overflow

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: irrigationTypes.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                childAspectRatio: aspectRatio,
                              ),
                              itemBuilder: (context, index) {
                                final item = irrigationTypes[index];
                                final active = irrigation == item['type'];
                                final colors = (item['color'] as List<Color>);
                                return GestureDetector(
                                  onTap: () => setState(() => irrigation = item['type'] as String),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.all(padding),
                                    decoration: BoxDecoration(
                                      gradient: active ? LinearGradient(colors: colors) : null,
                                      color: active ? null : AppColors.background,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 2),
                                      boxShadow: [
                                        if (active)
                                          BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 8)),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              item['icon'] as String,
                                              width: iconSize,
                                              height: iconSize,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item['type'] as String,
                                              style: TextStyle(color: active ? Colors.white : AppColors.primaryDark, fontSize: 14, fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['desc'] as String,
                                              style: TextStyle(color: active ? Colors.white70 : AppColors.muted, fontSize: 12),
                                              maxLines: 2,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        if (active)
                                          const Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Icon(LucideIcons.check, color: Colors.white, size: 18),
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
                  ),
                  const SizedBox(height: 12),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Past crop grown', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: pastCropOptions.map((crop) {
                            final isSelected = selectedPastCrops.contains(crop);
                            return ChoiceChip(
                              label: Text(crop),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.primaryDark),
                              backgroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border, width: 1.5),
                              ),
                              onSelected: (_) => _toggleCrop(crop),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: customCropController,
                                decoration: const InputDecoration(hintText: 'Add custom crop'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _addCustomCrop,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canSubmit
                          ? () {
                            widget.appState.updateUserData({
                              'landSize': showCustom ? customLandSize : landSize,
                              'irrigation': irrigation,
                              'pastCrops': selectedPastCrops,
                            });
                            widget.appState.updateFarmDetails({
                              'landSize': showCustom ? customLandSize : landSize,
                              'irrigation': irrigation,
                              'pastCrops': selectedPastCrops,
                            });
                            context.go('/dashboard');
                          }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(12))),
                      const SizedBox(width: 6),
                      Container(width: 32, height: 6, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12))),
                      const SizedBox(width: 6),
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(12))),
                    ],
                  ),
                ],
              ),
            ),
            const FloatingIVR(),
          ],
        ),
      ),
    );
  }

  void _toggleCrop(String crop) {
    setState(() {
      if (selectedPastCrops.contains(crop)) {
        selectedPastCrops.remove(crop);
      } else {
        selectedPastCrops.add(crop);
      }
    });
  }

  void _addCustomCrop() {
    final value = customCropController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      if (!selectedPastCrops.contains(value)) {
        selectedPastCrops.add(value);
      }
      customCropController.clear();
    });
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }
}
