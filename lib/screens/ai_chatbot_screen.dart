import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class AiChatbotScreen extends StatefulWidget {
  const AiChatbotScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<AiChatbotScreen> createState() => _AiChatbotScreenState();
}

class _AiChatbotScreenState extends State<AiChatbotScreen> {
  late final stt.SpeechToText _speech;
  final TextEditingController _messageController = TextEditingController();
  bool _isListening = false;
  String _lastRecognizedText = '';

  final List<Map<String, String>> messages = const [
    {'type': 'assistant', 'text': 'Hello! I am your FarmAura assistant. How can I help you?'},
    {'type': 'user', 'text': 'How to improve soil moisture?'},
    {'type': 'assistant', 'text': 'Use mulching and schedule irrigation during evening to reduce evaporation.'},
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _startListening() async {
    final available = await _speech.initialize(
      onStatus: (_) {},
      onError: (_) {},
    );
    if (!available) return;
    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _lastRecognizedText = result.recognizedWords;
          _messageController.text = _lastRecognizedText;
          _messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: _messageController.text.length),
          );
        });
      },
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _speech.stop();
    _speech.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(title: 'AI Chat', showBack: true, showProfile: false, appState: widget.appState, onBack: _handleBack),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = msg['type'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(msg['text'] ?? '', style: const TextStyle(color: AppColors.primaryDark)),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask AI Assistant...',
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        gradient: primaryGradient(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
                        onPressed: _toggleListening,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        gradient: primaryGradient(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {},
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
