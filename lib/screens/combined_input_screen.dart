import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';
import 'recommendation_results_screen.dart';
import '../utils/location_helper.dart';

import 'package:farmaura/l10n/app_localizations.dart';

class CombinedInputScreen extends StatefulWidget {
  const CombinedInputScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<CombinedInputScreen> createState() => _CombinedInputScreenState();
}

class _CombinedInputScreenState extends State<CombinedInputScreen> {
  String soilInputMode = 'auto';
  String landSize = '';
  String irrigation = '';
  String soilType = '';
  String texture = '';
  double ph = 7;
  String lastCrop = '';
  String frequentCrop = '';

  final landSizes = const ['< 1 Acre', '1-2 Acres', '2-5 Acres', '5-10 Acres', '> 10 Acres', 'Other (Manual)'];
  final irrigationTypes = const ['Rainfed', 'Canal', 'Borewell', 'Drip', 'Other (Manual)'];
  final soilTypes = const ['Sandy', 'Loamy', 'Clay', 'Red', 'Black', 'Other (Manual)'];
  final soilTextures = const ['Fine', 'Medium', 'Coarse', 'Other (Manual)'];
  final crops = const ['Wheat', 'Rice', 'Cotton', 'Sugarcane', 'Soybean', 'Maize', 'Tomato', 'Potato', 'Other (Manual)'];
  final fertilizersList = const ['Urea', 'DAP', 'NPK', 'Organic Manure', 'None', 'Other (Manual)'];
  final units = const ['kg', 'g', 'L', 'mL', 'Bags', 'Other (Manual)'];
  final frequencies = const ['Weekly', 'Monthly', 'Per Stage', 'Other (Specify)'];

  Map<String, String> customInputs = {
    'landSize': '',
    'irrigation': '',
    'soilType': '',
    'texture': '',
    'lastCrop': '',
    'previousCrop': '',
  };

  List<FertilizerEntry> fertilizers = [FertilizerEntry(id: '1')];

  bool get isValid {
    final effectiveLandSize = landSize == 'Other (Manual)' ? customInputs['landSize']! : landSize;
    final effectiveIrrigation = irrigation == 'Other (Manual)' ? customInputs['irrigation']! : irrigation;
    final effectiveLastCrop = lastCrop == 'Other (Manual)' ? customInputs['lastCrop']! : lastCrop;
    final effectivePreviousCrop = frequentCrop == 'Other (Manual)' ? customInputs['previousCrop']! : frequentCrop;

    final requiredFields = [effectiveLandSize, effectiveIrrigation, effectiveLastCrop, effectivePreviousCrop];

    if (soilInputMode == 'manual') {
      final effectiveSoilType = soilType == 'Other (Manual)' ? customInputs['soilType']! : soilType;
      final effectiveTexture = texture == 'Other (Manual)' ? customInputs['texture']! : texture;
      requiredFields.addAll([effectiveSoilType, effectiveTexture]);
    }

    return requiredFields.every((e) => e.isNotEmpty);
  }

  String _getLocalizedValue(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    switch (value) {
      case '< 1 Acre': return loc.lessThanOneAcre;
      case '1-2 Acres': return loc.oneToTwoAcres;
      case '2-5 Acres': return loc.twoToFiveAcres;
      case '5-10 Acres': return loc.fiveToTenAcres;
      case '> 10 Acres': return loc.moreThanTenAcres;
      case 'Rainfed': return loc.rainfed;
      case 'Canal': return loc.canal;
      case 'Borewell': return loc.borewell;
      case 'Drip': return loc.drip;
      case 'Sandy': return loc.sandy;
      case 'Loamy': return loc.loamy;
      case 'Clay': return loc.clay;
      case 'Red': return loc.red;
      case 'Black': return loc.black;
      case 'Fine': return loc.fine;
      case 'Medium': return loc.medium;
      case 'Coarse': return loc.coarse;
      case 'Organic Manure': return loc.organicManure;
      case 'None': return loc.none;
      case 'Bags': return loc.bags;
      case 'Weekly': return loc.weekly;
      case 'Monthly': return loc.monthly;
      case 'Per Stage': return loc.perStage;
      case 'Other (Manual)': return loc.otherManual;
      case 'Other (Specify)': return loc.otherSpecify;
      case 'Wheat': return loc.wheat;
      case 'Rice': return loc.rice;
      case 'Cotton': return loc.cotton;
      case 'Sugarcane': return loc.sugarcane;
      case 'Soybean': return loc.soybean;
      case 'Maize': return loc.maize;
      case 'Tomato': return loc.tomato;
      case 'Potato': return loc.potato;
      case 'Urea': return loc.urea;
      case 'DAP': return loc.dap;
      case 'NPK': return loc.npk191919;
      default: return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: const AppFooter(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: AppLocalizations.of(context)!.cropInput, showBack: true, showProfile: false, appState: widget.appState),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(AppLocalizations.of(context)!.cropAdvisoryForm, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(AppLocalizations.of(context)!.fillDetails, style: const TextStyle(color: AppColors.muted)),
                        const SizedBox(height: 12),
                        _sectionCard(
                          title: AppLocalizations.of(context)!.sectionFarmDetails,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.of(context)!.landSize, style: const TextStyle(color: AppColors.muted)),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: landSizes
                                    .map((size) => ChoiceChip(
                                          label: Text(_getLocalizedValue(context, size)),
                                          selected: landSize == size,
                                          onSelected: (_) => setState(() => landSize = size),
                                          selectedColor: AppColors.primary,
                                          labelStyle: TextStyle(color: landSize == size ? Colors.white : AppColors.primaryDark),
                                        ))
                                    .toList(),
                              ),
                              if (landSize == 'Other (Manual)')
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: TextField(
                                    decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterLandSize),
                                    onChanged: (v) => setState(() => customInputs['landSize'] = v),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(AppLocalizations.of(context)!.irrigationType, style: const TextStyle(color: AppColors.muted)),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: irrigationTypes
                                    .map((type) => ChoiceChip(
                                          label: Text(_getLocalizedValue(context, type)),
                                          selected: irrigation == type,
                                          onSelected: (_) => setState(() => irrigation = type),
                                          selectedColor: AppColors.primary,
                                          labelStyle: TextStyle(color: irrigation == type ? Colors.white : AppColors.primaryDark),
                                        ))
                                    .toList(),
                              ),
                              if (irrigation == 'Other (Manual)')
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: TextField(
                                    decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterIrrigationType),
                                    onChanged: (v) => setState(() => customInputs['irrigation'] = v),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _sectionCard(
                          title: AppLocalizations.of(context)!.sectionSoilInfo,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppLocalizations.of(context)!.chooseInputMethod, style: const TextStyle(color: AppColors.primaryDark, fontSize: 13)),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _modeButton('auto', AppLocalizations.of(context)!.autoDetect, LucideIcons.navigation),
                                        const SizedBox(width: 8),
                                        _modeButton('manual', AppLocalizations.of(context)!.manual, LucideIcons.edit),
                                        const SizedBox(width: 8),
                                        _modeButton('shc', AppLocalizations.of(context)!.shc, LucideIcons.upload),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (soilInputMode == 'auto')
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.shade200)),
                                  child: Text('Location: ${widget.appState.location['district']}, ${widget.appState.location['state']}',
                                      style: const TextStyle(color: AppColors.primaryDark)),
                                ),
                              if (soilInputMode == 'manual') ...[
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.soilType),
                                  initialValue: soilType.isEmpty ? null : soilType,
                                  items: soilTypes.map((t) => DropdownMenuItem(value: t, child: Text(_getLocalizedValue(context, t)))).toList(),
                                  onChanged: (v) => setState(() => soilType = v ?? ''),
                                ),
                                if (soilType == 'Other (Manual)')
                                  TextField(
                                    decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterSoilType),
                                    onChanged: (v) => setState(() => customInputs['soilType'] = v),
                                  ),
                                const SizedBox(height: 12),
                                Text(AppLocalizations.of(context)!.soilTexture, style: const TextStyle(color: AppColors.muted)),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: soilTextures
                                      .map((t) => ChoiceChip(
                                            label: Text(_getLocalizedValue(context, t)),
                                            selected: texture == t,
                                            onSelected: (_) => setState(() => texture = t),
                                            selectedColor: AppColors.primary,
                                            labelStyle: TextStyle(color: texture == t ? Colors.white : AppColors.primaryDark),
                                          ))
                                      .toList(),
                                ),
                                if (texture == 'Other (Manual)')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextField(
                                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterSoilTexture),
                                      onChanged: (v) => setState(() => customInputs['texture'] = v),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Text('pH Level: ${ph.toStringAsFixed(1)}', style: const TextStyle(color: AppColors.muted)),
                                Slider(
                                  value: ph,
                                  min: 4,
                                  max: 10,
                                  divisions: 60,
                                  activeColor: AppColors.primary,
                                  onChanged: (v) => setState(() => ph = v),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!.acidic, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                    Text(AppLocalizations.of(context)!.neutral, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                    Text(AppLocalizations.of(context)!.alkaline, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: const [
                                    Expanded(child: _MiniInput(label: 'Nitrogen (N)', hint: '0-100')),
                                    SizedBox(width: 8),
                                    Expanded(child: _MiniInput(label: 'Phosphorus (P)', hint: '0-100')),
                                    SizedBox(width: 8),
                                    Expanded(child: _MiniInput(label: 'Potassium (K)', hint: '0-100')),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _MiniInput(label: AppLocalizations.of(context)!.soilMoisture, hint: AppLocalizations.of(context)!.enterMoisture),
                              ],
                              if (soilInputMode == 'shc')
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.primary, width: 2),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(color: AppColors.accent, width: 3),
                                        ),
                                        child: Column(
                                          children: [
                                            const Text('SHC', style: TextStyle(fontSize: 24, color: Colors.white)),
                                            const SizedBox(height: 6),
                                            Text(AppLocalizations.of(context)!.uploadShc, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 2),
                                            Text(AppLocalizations.of(context)!.recommendedForAccuracy, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _MiniInput(label: AppLocalizations.of(context)!.shcNumber, hint: AppLocalizations.of(context)!.enterShcNumberInput),
                                      const SizedBox(height: 8),
                                      _MiniInput(label: AppLocalizations.of(context)!.testDate, hint: 'YYYY-MM-DD'),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _sectionCard(
                          title: AppLocalizations.of(context)!.sectionCropRotation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastCropGrown),
                                initialValue: lastCrop.isEmpty ? null : lastCrop,
                                items: crops.map((c) => DropdownMenuItem(value: c, child: Text(_getLocalizedValue(context, c)))).toList(),
                                onChanged: (v) => setState(() => lastCrop = v ?? ''),
                              ),
                              if (lastCrop == 'Other (Manual)')
                                TextField(
                                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterLastCrop),
                                  onChanged: (v) => setState(() => customInputs['lastCrop'] = v),
                                ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.frequentCrop),
                                initialValue: frequentCrop.isEmpty ? null : frequentCrop,
                                items: crops.map((c) => DropdownMenuItem(value: c, child: Text(_getLocalizedValue(context, c)))).toList(),
                                onChanged: (v) => setState(() => frequentCrop = v ?? ''),
                              ),
                              if (frequentCrop == 'Other (Manual)')
                                TextField(
                                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterFrequentCrop),
                                  onChanged: (v) => setState(() => customInputs['previousCrop'] = v),
                                ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context)!.fertilizerDetails, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(height: 8),
                              ...fertilizers.map((fert) => _fertilizerCard(fert)),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => setState(() => fertilizers.add(FertilizerEntry(id: (fertilizers.length + 1).toString()))),
                                icon: const Icon(LucideIcons.plus),
                                label: Text(AppLocalizations.of(context)!.addFertilizer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isValid
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => RecommendationResultsScreen(appState: widget.appState)),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            child: Text(AppLocalizations.of(context)!.getRecommendation),
                          ),
                        ),
                        if (!isValid)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(AppLocalizations.of(context)!.fillAllFields, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const FloatingIVR(),
          ],
        ),
      ),
    );
  }

  Widget _modeButton(String mode, String label, IconData icon) {
    final active = soilInputMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() => soilInputMode = mode);
          if (mode == 'auto') {
            try {
              await widget.appState.updateLocationFromService();
              if (mounted) setState(() {}); // Refresh to show new location
            } catch (e) {
              if (mounted) {
                if (e.toString().contains('Location services are disabled')) {
                  LocationHelper.showLocationServiceDialog(context, () {
                    // Retry logic
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: active ? Colors.white : AppColors.primaryDark),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: active ? Colors.white : AppColors.primaryDark, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _fertilizerCard(FertilizerEntry fert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${AppLocalizations.of(context)!.fertilizerDetails} ${fert.id}', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              if (fertilizers.length > 1)
                IconButton(
                  onPressed: () => setState(() => fertilizers.removeWhere((f) => f.id == fert.id)),
                  icon: const Icon(LucideIcons.x, color: Colors.red),
                ),
            ],
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.selectFertilizer),
            isExpanded: true,
            initialValue: fert.fertilizer.isEmpty ? null : fert.fertilizer,
            items: fertilizersList.map((f) => DropdownMenuItem(value: f, child: Text(_getLocalizedValue(context, f)))).toList(),
            onChanged: (v) => setState(() {
              fert.fertilizer = v ?? '';
              fert.isOther = v == 'Other (Manual)';
            }),
          ),
          if (fert.isOther)
            TextField(
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterFertilizerName),
              onChanged: (v) => setState(() => fert.customFertilizer = v),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.quantity),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => setState(() => fert.quantity = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.unit),
                  isExpanded: true,
                  initialValue: fert.unit.isEmpty ? null : fert.unit,
                  items: units.map((u) => DropdownMenuItem(value: u, child: Text(_getLocalizedValue(context, u)))).toList(),
                  onChanged: (v) => setState(() {
                    fert.unit = v ?? '';
                    fert.isOtherUnit = v == 'Other (Manual)';
                  }),
                ),
              ),
            ],
          ),
          if (fert.isOtherUnit)
            TextField(
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterCustomUnit),
              onChanged: (v) => setState(() => fert.customUnit = v),
            ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.frequency),
            isExpanded: true,
            initialValue: fert.frequency.isEmpty ? null : fert.frequency,
            items: frequencies.map((f) => DropdownMenuItem(value: f, child: Text(_getLocalizedValue(context, f)))).toList(),
            onChanged: (v) => setState(() {
              fert.frequency = v ?? '';
              fert.isOtherFrequency = v == 'Other (Specify)';
            }),
          ),
          if (fert.isOtherFrequency)
            TextField(
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.specifyFrequency),
              onChanged: (v) => setState(() => fert.customFrequency = v),
            ),
        ],
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  const _MiniInput({required this.label, required this.hint});
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}

class FertilizerEntry {
  FertilizerEntry({required this.id});
  final String id;
  String fertilizer = '';
  String customFertilizer = '';
  String quantity = '';
  String unit = '';
  String customUnit = '';
  String frequency = '';
  String customFrequency = '';
  bool isOther = false;
  bool isOtherUnit = false;
  bool isOtherFrequency = false;
}
