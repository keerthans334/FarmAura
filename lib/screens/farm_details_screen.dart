import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class FarmDetailsScreen extends StatefulWidget {
  const FarmDetailsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  final landSizes = const [
    {'value': '<1 Acre', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '1-2 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '2-5 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '5-10 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': '>10 Acres', 'icon': 'assets/icons/occupation/farmer.svg'},
    {'value': 'Custom', 'icon': null},
  ];

  final irrigationTypes = const [
    {'type': 'Borewell', 'icon': 'assets/icons/irrigation/borewell.svg', 'desc': 'Groundwater source'},
    {'type': 'Canal', 'icon': 'assets/icons/irrigation/canal.svg', 'desc': 'Canal based'},
    {'type': 'Rainfed', 'icon': 'assets/icons/irrigation/rainfed.svg', 'desc': 'Dependent on rain'},
    {'type': 'Drip', 'icon': 'assets/icons/irrigation/drip.svg', 'desc': 'Water saving'},
    {'type': 'Sprinkler', 'icon': 'assets/icons/irrigation/drip.svg', 'desc': 'Uniform coverage'},
  ];

  late TextEditingController soilController;
  late TextEditingController cropsController;

  String? selectedLandSize;
  String? selectedIrrigation;
  String customLandSize = '';
  bool detected = false;

  @override
  void initState() {
    super.initState();
    final farm = widget.appState.farmDetails;
    soilController = TextEditingController(text: farm['soilType']?.toString() ?? '');
    final mainCrops = (farm['mainCrops'] as List?)?.whereType<String>().toList() ?? const [];
    cropsController = TextEditingController(text: mainCrops.join(', '));
    selectedLandSize = farm['landSize']?.toString().isNotEmpty == true ? farm['landSize']?.toString() : landSizes[2]['value'] as String;
    selectedIrrigation = farm['irrigation']?.toString().isNotEmpty == true ? farm['irrigation']?.toString() : irrigationTypes.first['type'] as String;
    detected = widget.appState.location['detected'] == true;
  }

  @override
  void dispose() {
    soilController.dispose();
    cropsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showCustom = selectedLandSize == 'Custom';
    final canSave = (showCustom ? customLandSize.isNotEmpty : selectedLandSize != null) && selectedIrrigation != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Farm Details',
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
                    const SizedBox(height: 6),
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
                            child: const Icon(LucideIcons.sprout, color: Colors.white, size: 42),
                          ),
                          const SizedBox(height: 10),
                          Text('Farm Details', style: Theme.of(context).textTheme.headlineSmall),
                          const Text('Tell us about your farmland', style: TextStyle(color: AppColors.muted)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/location/location_pin.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
                              const SizedBox(width: 8),
                              const Text('Location', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => detected = true);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GPS detection simulated')));
                                widget.appState.updateLocation({'detected': true});
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text('Auto-Detect via GPS', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          if (detected) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.primary, width: 1.4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.check, color: AppColors.primaryDark, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${widget.appState.location['district']}, ${widget.appState.location['state']}",
                                      style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600),
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
                          const Text('Land Size', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: landSizes.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.95,
                            ),
                            itemBuilder: (context, index) {
                              final size = landSizes[index];
                              final active = selectedLandSize == size['value'];
                              return GestureDetector(
                                onTap: () => setState(() => selectedLandSize = size['value'] as String),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: active ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]) : null,
                                    color: active ? null : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 2),
                                    boxShadow: [if (active) BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 8))],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (size['icon'] != null)
                                        SvgPicture.asset(
                                          size['icon'] as String,
                                          width: 22,
                                          height: 22,
                                          colorFilter: active ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                                        )
                                      else
                                        Icon(LucideIcons.pencil, size: 22, color: active ? Colors.white : AppColors.primaryDark),
                                      const SizedBox(height: 6),
                                      Text(
                                        size['value'] as String,
                                        style: TextStyle(color: active ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (showCustom) ...[
                            const SizedBox(height: 12),
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
                          const Text('Irrigation Type', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: irrigationTypes.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                            itemBuilder: (context, index) {
                              final item = irrigationTypes[index];
                              final active = selectedIrrigation == item['type'];
                              return GestureDetector(
                                onTap: () => setState(() => selectedIrrigation = item['type'] as String),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: active ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]) : null,
                                    color: active ? null : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 2),
                                    boxShadow: [if (active) BoxShadow(color: AppColors.primary.withOpacity(0.18), blurRadius: 12, offset: const Offset(0, 8))],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(item['icon'] as String, width: 26, height: 26, colorFilter: active ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null),
                                      const SizedBox(height: 10),
                                      Text(
                                        item['type'] as String,
                                        style: TextStyle(color: active ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['desc'] as String,
                                        style: TextStyle(color: active ? Colors.white70 : AppColors.muted, fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
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
                          const Text('Additional Info', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          TextField(
                            controller: soilController,
                            decoration: const InputDecoration(labelText: 'Soil Type'),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: cropsController,
                            decoration: const InputDecoration(labelText: 'Main Crops (comma separated)'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canSave ? _save : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }

  void _save() {
    final landValue = selectedLandSize == 'Custom' && customLandSize.isNotEmpty ? customLandSize : selectedLandSize;
    final cropsList = cropsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    widget.appState.updateFarmDetails({
      'landSize': landValue,
      'irrigation': selectedIrrigation,
      'soilType': soilController.text.trim(),
      'mainCrops': cropsList,
    });

    widget.appState.updateUserData({
      'landSize': landValue,
      'irrigation': selectedIrrigation,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Farm details updated')));
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go('/profile');
    }
  }
}
