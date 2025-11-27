import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController villageController;

  final occupations = const ['Farmer', 'Tenant Farmer', 'FPO Member', 'Other'];
  final districts = const ['Ranchi', 'Dhanbad', 'Hazaribagh', 'Bokaro'];
  final states = const ['Jharkhand', 'Bihar', 'Odisha', 'West Bengal'];
  final landSizes = const ['<1 Acre', '1-2 Acres', '2-5 Acres', '5-10 Acres', '>10 Acres'];
  final irrigationMethods = const ['Rainfed', 'Borewell', 'Canal', 'Drip', 'Sprinkler'];

  String? occupation;
  String? district;
  String? state;
  String? landSize;
  String? irrigation;

  @override
  void initState() {
    super.initState();
    final user = widget.appState.userData;
    final farm = widget.appState.farmDetails;
    nameController = TextEditingController(text: user['name']?.toString() ?? '');
    phoneController = TextEditingController(text: user['phone']?.toString() ?? '');
    emailController = TextEditingController(text: user['email']?.toString() ?? '');
    villageController = TextEditingController(text: user['village']?.toString() ?? '');
    occupation = user['occupation']?.toString() ?? occupations.first;
    district = user['district']?.toString().isNotEmpty == true ? user['district']?.toString() : districts.first;
    state = user['state']?.toString().isNotEmpty == true ? user['state']?.toString() : states.first;
    landSize = farm['landSize']?.toString().isNotEmpty == true ? farm['landSize']?.toString() : landSizes[2];
    irrigation = farm['irrigation']?.toString().isNotEmpty == true ? farm['irrigation']?.toString() : irrigationMethods.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Edit Profile',
              showBack: true,
              showProfile: false,
              appState: widget.appState,
              onBack: () => context.go('/profile'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 42),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Change photo tapped'))),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.edit, color: AppColors.primaryDark, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle('Personal Information'),
                    const SizedBox(height: 10),
                    _textField('Full Name', nameController, textInputAction: TextInputAction.next),
                    const SizedBox(height: 12),
                    _textField('Phone Number', phoneController, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next),
                    const SizedBox(height: 12),
                    _textField('Email (Optional)', emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
                    const SizedBox(height: 12),
                    _dropdownField('Occupation', occupation, occupations, (val) => setState(() => occupation = val)),
                    const SizedBox(height: 18),
                    _sectionTitle('Location Information'),
                    const SizedBox(height: 10),
                    _textField('Village', villageController, textInputAction: TextInputAction.next),
                    const SizedBox(height: 12),
                    _dropdownField('District', district, districts, (val) => setState(() => district = val)),
                    const SizedBox(height: 12),
                    _dropdownField('State', state, states, (val) => setState(() => state = val)),
                    const SizedBox(height: 18),
                    _sectionTitle('Farm Information'),
                    const SizedBox(height: 10),
                    _dropdownField('Land Size', landSize, landSizes, (val) => setState(() => landSize = val)),
                    const SizedBox(height: 12),
                    _dropdownField('Irrigation Method', irrigation, irrigationMethods, (val) => setState(() => irrigation = val)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: const TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700));
  }

  Widget _textField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, TextInputAction textInputAction = TextInputAction.done}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _dropdownField(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: options.contains(value) ? value : options.first,
      items: options.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }

  void _save() {
    final updated = {
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'occupation': occupation,
      'village': villageController.text.trim(),
      'district': district,
      'state': state,
      'landSize': landSize,
      'irrigation': irrigation,
    };

    widget.appState.updateUserData(updated);
    widget.appState.updateFarmDetails({
      'landSize': landSize,
      'irrigation': irrigation,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
    context.go('/profile');
  }
}
