import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lear_assignment/core/models/word.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataService {
  final _supabaseClient = Supabase.instance.client;
  final logger = Logger('DataService');

  // Get words stream with real-time updates
  Stream<List<Map<String, dynamic>>> getWords() {
    logger.info('Getting words stream');
    return _supabaseClient.from('words').stream(
        primaryKey: ['id']).map((rows) => rows.map((row) => row).toList());
  }

  // Create a new word
  Future<List<Map<String, dynamic>>> createWord(Word word) async {
    logger.info('Creating word: ${word.word}');
    final wordJson = word.toJson();

    wordJson.remove('id');
    wordJson.remove('created_at');

    final response =
        await _supabaseClient.from('words').insert(wordJson).select();
    logger.info('Word created successfully: ${response.toString()}');
    return response;
  }

  // Delete a word
  Future<void> deleteWord(int wordId) async {
    logger.info('Deleting word: $wordId');
    await _supabaseClient.from('words').delete().eq('id', wordId);
    logger.info('Word deleted successfully');
  }
}

final dataServiceProvider = Provider<DataService>((ref) => DataService());
