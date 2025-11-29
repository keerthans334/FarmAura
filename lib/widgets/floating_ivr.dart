import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/voice_assistant_service.dart';
import '../services/local_memory_service.dart';
import '../services/crop_recommendation_service.dart';
import '../models/app_state.dart';
import '../models/weather.dart';
import 'package:farmaura/l10n/app_localizations.dart';

class FloatingIVR extends StatefulWidget {
  const FloatingIVR({super.key, this.contextText, this.currentRoute});

  final String? contextText;
  final String? currentRoute;

  @override
  State<FloatingIVR> createState() => FloatingIVRState();
}

class FloatingIVRState extends State<FloatingIVR> {
  bool isOpen = false;
  bool isListening = false;
  bool isProcessing = false;
  bool isSpeaking = false;
  bool isTyping = false;
  final TextEditingController _textController = TextEditingController();
  final List<_Msg> messages = [];
  final VoiceAssistantService _service = VoiceAssistantService();
  final LocalMemoryService _memoryService = LocalMemoryService();
  final CropRecommendationService _cropService = CropRecommendationService();

  @override
  void initState() {
    super.initState();
    _loadMemory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.addListener(_onAppStateChanged);
    });
  }

  void _onAppStateChanged() {
    if (!mounted) return;
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.isIVROpen != isOpen) {
      setState(() {
        isOpen = appState.isIVROpen;
        if (isOpen) {
           isTyping = appState.isIVRTextMode;
           if (!isTyping) _greet();
        } else {
           _service.stopSpeaking();
        }
      });
    }
  }

  Future<void> _loadMemory() async {
    final history = await _memoryService.getMemory();
    if (history.isNotEmpty) {
      setState(() {
        messages.clear();
        for (final turn in history) {
          messages.add(_Msg(turn['user_query'], true));
          messages.add(_Msg(turn['assistant_response'], false));
        }
      });
    }
  }

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    
    _textController.clear();
    messages.add(_Msg(text, true));
    
    final appState = Provider.of<AppState>(context, listen: false);
    final langCode = _getLangCode(appState.userLanguage);
    
    setState(() {
      isTyping = false;
      isProcessing = true;
    });
    
    _processQuery(text, langCode);
  }

  @override
  void dispose() {
    _service.stopSpeaking();
    super.dispose();
  }

  void openAndListen({bool textMode = false}) {
    setState(() {
      isOpen = true;
      isTyping = textMode;
    });
    if (!textMode) {
      _greet();
    }
  }

  Future<void> _greet() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final name = appState.userData['name'] ?? 'Farmer';
    
    // Simple greeting logic (can be enhanced with TTS later if needed)
    // For now, we just show it in the UI
    if (messages.isEmpty) {
      final greeting = 'Hello $name, how can I help you today?';
      messages.add(_Msg(greeting, false));
    }
  }

  Future<void> _startListening() async {
    if (isListening || isProcessing) return;
    
    try {
      await _service.startListening();
      setState(() => isListening = true);
    } catch (e) {
      _showError('Microphone permission denied');
    }
  }

  Future<void> _stopListening() async {
    if (!isListening) return;

    setState(() {
      isListening = false;
      isProcessing = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final langCode = _getLangCode(appState.userLanguage);

      final text = await _service.stopListeningAndTranscribe(langCode);
      
      if (text != null && text.isNotEmpty) {
        messages.add(_Msg(text, true));
        await _processQuery(text, langCode);
      } else {
        setState(() => isProcessing = false);
        _showError("I couldn't understand. Please try again.");
      }
    } catch (e) {
      setState(() => isProcessing = false);
      _showError('Error processing speech: $e');
    }
  }

  Future<void> _processQuery(String query, String langCode) async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Fetch latest crop recommendation
      final latestReco = await _cropService.getLatestRecommendation(appState.userData['phone'] ?? '');
      
      // Get memory
      final memory = await _memoryService.getMemory();

      final contextData = {
        'screen': widget.currentRoute ?? 'home',
        'profile': appState.userData,
        'location': appState.location,
        'weather': appState.weather?.toJson() ?? {},
        'latest_crop_reco': latestReco ?? {},
        'memory': memory,
        'data': {
          if (widget.contextText != null) 'context_text': widget.contextText,
          if (appState.currentContextText != null) 'current_context': appState.currentContextText,
        },
      };

      final result = await _service.processQuery(query, contextData, langCode);
      
      final response = result['response'] as String;
      messages.add(_Msg(response, false));
      
      // Save turn
      await _memoryService.saveTurn(query, response, langCode);
      
      setState(() {
        isProcessing = false;
        isSpeaking = true;
      });

      await _service.speak(response, langCode);
      
      if (mounted) {
        setState(() => isSpeaking = false);
      }
      
    } catch (e) {
      setState(() => isProcessing = false);
      _showError('Failed to get response: $e');
    }
  }

  String _getLangCode(String userLang) {
    switch (userLang.toLowerCase()) {
      case 'hindi': return 'hi';
      case 'kannada': return 'kn';
      default: return 'en';
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final excludedRoutes = ['/', '/login', '/otp', '/profile-setup', '/farm-setup'];
    if (excludedRoutes.contains(widget.currentRoute)) return const SizedBox.shrink();

    if (!isOpen) {
      return Positioned(
        bottom: 100,
        right: 16,
        child: FloatingActionButton(
          onPressed: () => Provider.of<AppState>(context, listen: false).openIVR(),
          backgroundColor: AppColors.primary,
          elevation: 10,
          child: const Icon(LucideIcons.sparkles, color: Colors.white),
        ),
      );
    }

    return Positioned(
      bottom: 96,
      right: 16,
      child: _buildWindow(context),
    );
  }

  Widget _buildWindow(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            // Header
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
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white, size: 18),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false).closeIVR();
                    },
                  ),
                ],
              ),
            ),
            
            // Chat Area
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final m = messages[index];
                  return Align(
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
                  );
                },
              ),
            ),

            // Status Indicator
            if (isProcessing)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 8),
                    Text('Processing...', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),

            // Controls
            // Controls
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.8))),
              ),
              child: isTyping
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Type your query...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: AppColors.background,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: (_) => _sendText(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(LucideIcons.send, color: AppColors.primary),
                          onPressed: _sendText,
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.mic, color: AppColors.muted),
                          onPressed: () => setState(() => isTyping = false),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        GestureDetector(
                          onLongPress: _startListening,
                          onLongPressUp: _stopListening,
                          onTap: () {
                            if (isListening) {
                              _stopListening();
                            } else {
                              _startListening();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isListening ? Colors.red : AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (isListening)
                                  BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)
                              ]
                            ),
                            child: Icon(isListening ? LucideIcons.micOff : LucideIcons.mic, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isTyping = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isListening ? 'Listening...' : (isSpeaking ? 'Speaking...' : 'Tap mic to speak'),
                                    style: TextStyle(color: isListening ? Colors.red : AppColors.muted),
                                  ),
                                  const Icon(LucideIcons.keyboard, size: 18, color: AppColors.muted),
                                ],
                              ),
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
}

class _Msg {
  _Msg(this.text, this.isUser);
  final String text;
  final bool isUser;
}


