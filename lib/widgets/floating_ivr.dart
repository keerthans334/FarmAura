import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class FloatingIVR extends StatefulWidget {
  const FloatingIVR({super.key});

  @override
  State<FloatingIVR> createState() => _FloatingIVRState();
}

class _FloatingIVRState extends State<FloatingIVR> {
  bool isOpen = false;
  bool isListening = false;
  final List<_Msg> messages = [];
  String typing = '';

  void _startListening() async {
    if (isListening) return;
    setState(() => isListening = true);
    await Future.delayed(const Duration(seconds: 2));
    const userQuery = 'How do I control pests on my wheat crop?';
    messages.add(_Msg(userQuery, true));
    setState(() => isListening = false);

    const response = 'For wheat pest control, I recommend:\n\n1. Use neem-based organic pesticides\n2. Spray early morning or evening\n3. Monitor for aphids and termites\n4. Apply fungicides if rust appears\n5. Maintain proper field drainage\n\nWould you like specific product recommendations?';
    for (var i = 1; i <= response.length; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      setState(() => typing = response.substring(0, i));
    }
    messages.add(_Msg(response, false));
    setState(() => typing = '');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 96,
      right: 16,
      child: isOpen
          ? _buildWindow(context)
          : FloatingActionButton(
              onPressed: () => setState(() => isOpen = true),
              backgroundColor: AppColors.primary,
              elevation: 10,
              child: const Icon(LucideIcons.volume2, color: Colors.white),
            ),
    );
  }

  Widget _buildWindow(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        height: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(LucideIcons.volume2, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('AI Voice Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.maximize2, color: Colors.white, size: 18),
                        onPressed: () => Navigator.of(context).pushNamed('/ai-chat'),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, color: Colors.white, size: 18),
                        onPressed: () => setState(() => isOpen = false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (messages.isEmpty && typing.isEmpty)
                    Column(
                      children: const [
                        Icon(LucideIcons.mic, size: 48, color: AppColors.primary),
                        SizedBox(height: 6),
                        Text('Tap the microphone to speak', style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ...messages.map((m) => Align(
                        alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: m.isUser ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(m.text, style: const TextStyle(color: AppColors.primaryDark)),
                        ),
                      )),
                  if (typing.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(typing, style: const TextStyle(color: AppColors.primaryDark))),
                            Container(width: 6, height: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  if (isListening)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _bar(0),
                          _bar(120),
                          _bar(240),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.8))),
              ),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _startListening,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      backgroundColor: isListening ? Colors.orange : AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Icon(isListening ? LucideIcons.pause : LucideIcons.mic),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isListening ? 'Listening...' : 'Tap mic to speak',
                        style: const TextStyle(color: AppColors.muted),
                      ),
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

  Widget _bar(int delay) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 6,
      height: isListening ? 28 : 12,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _Msg {
  _Msg(this.text, this.isUser);
  final String text;
  final bool isUser;
}
