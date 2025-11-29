import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalMemoryService {
  static const String _key = 'ivr_memory';
  static const int _maxTurns = 20;
  static const Duration _expiry = Duration(minutes: 20);

  Future<void> saveTurn(String query, String response, String language) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> memory = await getMemory();

    final newTurn = {
      'timestamp': DateTime.now().toIso8601String(),
      'user_query': query,
      'assistant_response': response,
      'language': language,
    };

    memory.add(newTurn);

    // Keep only last 20 turns
    if (memory.length > _maxTurns) {
      memory.removeRange(0, memory.length - _maxTurns);
    }

    await prefs.setString(_key, jsonEncode(memory));
  }

  Future<List<Map<String, dynamic>>> getMemory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final List<Map<String, dynamic>> memory = List<Map<String, dynamic>>.from(decoded);

      if (memory.isEmpty) return [];

      // Check expiry of the last message
      final lastTurn = memory.last;
      final lastTimestamp = DateTime.parse(lastTurn['timestamp']);
      
      if (DateTime.now().difference(lastTimestamp) > _expiry) {
        await clearMemory();
        return [];
      }

      return memory;
    } catch (e) {
      print('Error decoding memory: $e');
      await clearMemory();
      return [];
    }
  }

  Future<void> clearMemory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
