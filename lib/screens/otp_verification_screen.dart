import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.appState, this.phoneNumber, this.isNewUser = false});
  final AppState appState;
  final String? phoneNumber;
  final bool isNewUser;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String otp = '';
  int timer = 30;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    for (var t = 30; t >= 0; t--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        timer = t;
        canResend = t == 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = otp.length == 6;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.arrowLeft, color: AppColors.primaryDark, size: 18),
                label: const Text('Back', style: TextStyle(color: AppColors.primaryDark)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    const Text('Enter 6-digit OTP', style: TextStyle(color: AppColors.primaryDark, fontSize: 16)),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, letterSpacing: 4),
                      decoration: const InputDecoration(counterText: '', hintText: '000000'),
                      onChanged: (value) => setState(() => otp = value.replaceAll(RegExp(r'[^0-9]'), '')),
                    ),
                    const SizedBox(height: 12),
                    timer > 0
                        ? Text('Resend OTP in ${timer}s', style: const TextStyle(color: AppColors.muted))
                        : TextButton(
                            onPressed: canResend
                                ? () {
                                    setState(() {
                                      timer = 30;
                                      canResend = false;
                                    });
                                    _startTimer();
                                  }
                                : null,
                            child: const Text('Resend OTP', style: TextStyle(color: AppColors.primary)),
                          ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canProceed
                            ? () {
                                if (widget.isNewUser) {
                                  context.go('/profile-setup');
                                } else {
                                  context.go('/dashboard');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: const Text('Verify & Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
