import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/feature/mantra/data/mantra_repository.dart';
import 'package:flutter_application_1/src/feature/mantra/services/hybrid_speech_service.dart';

part 'mantra_state.dart';

class MantraCubit extends Cubit<MantraState> {
  MantraCubit({required MantraRepository repository, required HybridSpeechService speech})
      : _repository = repository,
        _speech = speech,
        super(const MantraState());

  final MantraRepository _repository;
  final HybridSpeechService _speech;
  String _lastRecognizedText = '';
  DateTime? _lastIncrementTime;

  Future<void> load() async {
    emit(state.copyWith(status: MantraStatus.loading));
    try {
      final count = await _repository.getCount();
      final word = await _repository.getTargetWord();
      emit(state.copyWith(
        count: count,
        targetWord: word,
        status: MantraStatus.ready,
      ));
    } catch (e) {
      emit(state.copyWith(status: MantraStatus.failure, error: e.toString()));
    }
  }

  Future<void> increment([int by = 1]) async {
    final next = state.count + by;
    emit(state.copyWith(count: next));
    await _repository.setCount(next);
  }

  Future<void> reset() async {
    emit(state.copyWith(count: 0));
    await _repository.setCount(0);
  }

  Future<void> setTargetWord(String word) async {
    emit(state.copyWith(targetWord: word));
    await _repository.setTargetWord(word);
  }

  Future<void> toggleListening() async {
    if (state.listening) {
      await _speech.stop();
      emit(state.copyWith(listening: false));
      _lastRecognizedText = '';
      _lastIncrementTime = null;
      return;
    }
    final ok = await _speech.initialize(onError: (error) {
      emit(state.copyWith(status: MantraStatus.failure, error: error));
    });
    if (!ok) return;

    emit(state.copyWith(listening: true));
    _lastRecognizedText = '';
    _lastIncrementTime = null;
    
    await _speech.start(
      onPartial: (text) {
        _processSpeechText(text);
      }, 
      onComplete: () {
        emit(state.copyWith(listening: false));
        _lastRecognizedText = '';
        _lastIncrementTime = null;
      },
      onError: (error) {
        emit(state.copyWith(status: MantraStatus.failure, error: error));
      }
    );
  }

  void _processSpeechText(String text) {
    final normalized = text.toLowerCase().trim();
    final trigger = state.targetWord.trim().toLowerCase();
    
    if (trigger.isEmpty || normalized.isEmpty) return;
    
    // Only process if this is new text (not a duplicate)
    if (normalized == _lastRecognizedText) return;
    
    // Check if the text contains the target word as a complete word
    final words = normalized.split(RegExp(r'\s+'));
    final hasTargetWord = words.any((word) => word == trigger);
    
    if (hasTargetWord) {
      // Debounce: only allow one increment per 500ms
      final now = DateTime.now();
      if (_lastIncrementTime == null || 
          now.difference(_lastIncrementTime!).inMilliseconds > 500) {
        _lastRecognizedText = normalized;
        _lastIncrementTime = now;
        increment(1);
      }
    }
  }
}
