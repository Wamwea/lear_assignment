import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lear_assignment/core/models/word.dart';
import 'package:lear_assignment/core/services/data_service.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class WordsState {
  final List<Word> words;
  final bool isLoading;
  final String? error;

  const WordsState({
    required this.words,
    this.isLoading = true,
    this.error,
  });

  WordsState copyWith({
    List<Word>? words,
    bool? isLoading,
    String? error,
  }) {
    return WordsState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final dataProvider = StateNotifierProvider<DataNotifier, WordsState>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return DataNotifier(dataService);
});

class DataNotifier extends StateNotifier<WordsState> {
  final DataService _dataService;
  final logger = Logger('DataNotifier');

  final _wordsSubject = BehaviorSubject<List<Word>>.seeded([]);

  DataNotifier(this._dataService) : super(const WordsState(words: [])) {
    _init();
  }

  void _init() {
    logger.info('Initializing DataNotifier');

    // Subscribe to the words stream
    _dataService.getWords().listen(
      (rawData) {
        logger.info('Received ${rawData.length} words from stream');
        final words = rawData.map((row) => Word.fromJson(row)).toList();
        _wordsSubject.add(words);
        state = state.copyWith(
          isLoading: false,
          error: null,
          words: _wordsSubject.value,
        );
      },
      onError: (error) {
        logger.severe('Error in words stream: $error');
        state = state.copyWith(
          isLoading: false,
          error: error.toString(),
        );
      },
    );
  }

  Future<void> createWord(Word word) async {
    try {
      logger.info('Creating new word: ${word.word}');
      state = state.copyWith(isLoading: true, error: null);
      await _dataService.createWord(word);
      logger.info('Word created successfully');
      _wordsSubject.add([...state.words, word]);
      state = state.copyWith(
        isLoading: false,
        error: null,
        words: _wordsSubject.value,
      );
    } catch (e) {
      logger.severe('Error creating word: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteWord(int wordId) async {
    try {
      logger.info('Deleting word: $wordId');
      state = state.copyWith(isLoading: true, error: null);
      await _dataService.deleteWord(wordId);
      logger.info('Word deleted successfully');
    } catch (e) {
      logger.severe('Error deleting word: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}
