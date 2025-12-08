import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceAssistantService {
  static final VoiceAssistantService _instance = VoiceAssistantService._internal();
  factory VoiceAssistantService() => _instance;
  final StreamController<String?> _playingIdController = StreamController<String?>.broadcast();
  Stream<String?> get playingIdStream => _playingIdController.stream;
  String? _currentPlayingId;

  VoiceAssistantService._internal() {
    _player.onPlayerComplete.listen((event) {
      _currentPlayingId = null;
      _playingIdController.add(null);
    });
  }

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  DateTime? _lastCallTime;
  static const Duration _debounceTime = Duration(seconds: 1);
  
  // Backend URL (Emulator)
  // Backend URL (Emulator)
  static const String _backendUrl = 'http://10.0.2.2:5001/api/voice-query';

  // Azure Config
  String get _azureKey => dotenv.env['AZURE_SPEECH_KEY'] ?? '';
  String get _azureRegion => dotenv.env['AZURE_SPEECH_REGION'] ?? 'eastus';

  // Language & Voice Mapping
  final Map<String, String> _sttLocales = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'kn': 'kn-IN',
  };

  final Map<String, String> _ttsVoices = {
    'en': 'en-IN-NeerjaNeural',
    'hi': 'hi-IN-SwaraNeural',
    'kn': 'kn-IN-GaganNeural',
  };

  Future<void> startListening() async {
    if (await _recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/voice_query.wav';
      
      // Start recording to file
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: path,
      );
    } else {
      throw Exception('Microphone permission denied');
    }
  }

  Future<String?> stopListeningAndTranscribe(String languageCode) async {
    final path = await _recorder.stop();
    if (path == null) return null;

    final file = File(path);
    if (!await file.exists()) return null;

    return await _transcribeAudio(file, languageCode);
  }

  Future<String> _transcribeAudio(File audioFile, String languageCode) async {
    if (_azureKey.isEmpty) {
      print('Error: Azure Speech Key is missing/empty.');
      throw Exception('Azure Speech Key not found');
    }
    
    // Debug: Check file
    final length = await audioFile.length();
    print('Audio file path: ${audioFile.path}, Size: $length bytes');
    
    if (length == 0) {
      print('Error: Audio file is empty.');
      return '';
    }

    final locale = _sttLocales[languageCode] ?? 'en-IN';
    final url = Uri.parse(
        'https://$_azureRegion.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=$locale');

    print('Sending STT request to: $url');

    final audioBytes = await audioFile.readAsBytes();

    try {
      final response = await http.post(
        url,
        headers: {
          'Ocp-Apim-Subscription-Key': _azureKey,
          'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
          'Accept': 'application/json',
        },
        body: audioBytes,
      );

      print('STT Response Status: ${response.statusCode}');
      print('STT Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['DisplayText'] ?? '';
      } else {
        print('STT Error: ${response.body}');
        return '';
      }
    } catch (e) {
      print('STT Exception: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> processQuery(String query, Map<String, dynamic> context, String languageCode) async {
    if (_lastCallTime != null && DateTime.now().difference(_lastCallTime!) < _debounceTime) {
      throw Exception('Please wait a moment.');
    }
    _lastCallTime = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'context': context,
          'language': languageCode,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Backend error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  String prepareTtsSpeech(String text, String languageCode) {
    // 1. Initial cleanup: Remove unwanted symbols but keep structure
    // Allow: Alphanumeric (En, Hi, Kn), spaces, basic punctuation, and specific units/symbols
    String processed = text.replaceAll(RegExp(r'[^a-zA-Z0-9\s.,!?:;()/%₹\-\u0900-\u097F\u0C80-\u0CFF]'), '');

    // 2. Unit & Symbol Conversions
    // N-P-K or NPK
    processed = processed.replaceAll(RegExp(r'\bN-?P-?K\b', caseSensitive: false), 'N P K nutrients');
    
    // Grams (e.g. 500g)
    processed = processed.replaceAllMapped(RegExp(r'(\d+)\s*g\b'), (match) => '${match.group(1)} grams');
    
    // Quintals per hectare
    processed = processed.replaceAllMapped(RegExp(r'(\d+)\s*q/ha'), (match) => '${match.group(1)} quintals per hectare');
    
    // Currency and Percentage based on language
    if (languageCode == 'hi') {
      processed = processed.replaceAll('₹', ' रूपये ');
      processed = processed.replaceAll('%', ' प्रतिशत ');
    } else if (languageCode == 'kn') {
      processed = processed.replaceAll('₹', ' ರೂಪಾಯಿ ');
      processed = processed.replaceAll('%', ' ಪ್ರತಿಶತ ');
    } else {
      processed = processed.replaceAll('₹', ' rupees ');
      processed = processed.replaceAll('%', ' percent ');
    }

    // 3. Add Natural Pauses (SSML)
    // Colon -> Pause
    processed = processed.replaceAll(':', '. <break time="300ms"/>');
    
    // Opening Bracket -> Pause
    processed = processed.replaceAll('(', '<break time="250ms"/> (');
    
    // Comma -> Short Pause
    processed = processed.replaceAll(',', ', <break time="150ms"/>');

    // Newlines (Headings/Sections) -> Long Pause
    processed = processed.replaceAll(RegExp(r'\n+'), ' <break time="500ms"/> ');

    // 4. Final Normalization
    // Normalize spaces (collapse multiple spaces into one)
    processed = processed.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return processed;
  }

  Future<void> speak(String text, String languageCode, {String? id}) async {
    if (_azureKey.isEmpty) {
      print('❌ Error: Azure Speech Key is missing in .env');
      return;
    }

    // If already playing this ID, stop it
    if (id != null && _currentPlayingId == id) {
      await stopSpeaking();
      return;
    }

    final cleanText = prepareTtsSpeech(text, languageCode);

    final voiceName = _ttsVoices[languageCode] ?? 'en-IN-NeerjaNeural';
    final url = Uri.parse('https://$_azureRegion.tts.speech.microsoft.com/cognitiveservices/v1');

    final ssml = '''
<speak version='1.0' xml:lang='$languageCode'>
    <voice xml:lang='$languageCode' xml:gender='Female' name='$voiceName'>
        $cleanText
    </voice>
</speak>
''';

    try {
      print('🔊 Sending TTS request for: "${cleanText.length > 20 ? cleanText.substring(0, 20) + '...' : cleanText}"');
      final response = await http.post(
        url,
        headers: {
          'Ocp-Apim-Subscription-Key': _azureKey,
          'Content-Type': 'application/ssml+xml',
          'X-Microsoft-OutputFormat': 'audio-16khz-128kbitrate-mono-mp3',
          'User-Agent': 'FarmAura',
        },
        body: ssml,
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        print('✅ TTS Audio received (${bytes.length} bytes). Playing...');
        
        // Update state before playing
        if (id != null) {
          _currentPlayingId = id;
          _playingIdController.add(id);
        }
        
        await _player.play(BytesSource(bytes));
      } else {
        print('❌ TTS Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ TTS Exception: $e');
    }
  }
  
  Future<void> stopSpeaking() async {
    await _player.stop();
    _currentPlayingId = null;
    _playingIdController.add(null);
  }
}
