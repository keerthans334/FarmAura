import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceAssistantService {
  static final VoiceAssistantService _instance = VoiceAssistantService._internal();
  factory VoiceAssistantService() => _instance;
  VoiceAssistantService._internal();

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  DateTime? _lastCallTime;
  static const Duration _debounceTime = Duration(seconds: 1);
  
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

  Future<void> speak(String text, String languageCode) async {
    if (_azureKey.isEmpty) return;

    final voiceName = _ttsVoices[languageCode] ?? 'en-IN-NeerjaNeural';
    final url = Uri.parse('https://$_azureRegion.tts.speech.microsoft.com/cognitiveservices/v1');

    final ssml = '''
<speak version='1.0' xml:lang='$languageCode'>
    <voice xml:lang='$languageCode' xml:gender='Female' name='$voiceName'>
        $text
    </voice>
</speak>
''';

    try {
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
        // Play audio directly from bytes
        await _player.play(BytesSource(bytes));
      } else {
        print('TTS Error: ${response.body}');
      }
    } catch (e) {
      print('TTS Exception: $e');
    }
  }
  
  Future<void> stopSpeaking() async {
    await _player.stop();
  }
}
