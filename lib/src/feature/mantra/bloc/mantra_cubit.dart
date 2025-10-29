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
  int _lastMatchOccurrences = 0;

  Future<void> load() async {
    emit(state.copyWith(status: MantraStatus.loading));
    try {
      final count = await _repository.getCount();
      final mantras = await _repository.getTargetMantras();
      emit(state.copyWith(
        count: count,
        targetMantras: mantras,
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
    // Keep compatibility: replace the list with a single item
    final list = [word];
    emit(state.copyWith(targetMantras: list));
    await _repository.setTargetMantras(list);
  }

  Future<void> setTargetMantras(List<String> mantras) async {
    final cleaned = mantras
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    emit(state.copyWith(targetMantras: cleaned));
    await _repository.setTargetMantras(cleaned);
  }

  Future<void> toggleListening() async {
    if (state.listening) {
      await _speech.stop();
      emit(state.copyWith(listening: false));
      _lastRecognizedText = '';
      _lastIncrementTime = null;
      _lastMatchOccurrences = 0;
      return;
    }
    final ok = await _speech.initialize(onError: (error) {
      emit(state.copyWith(status: MantraStatus.failure, error: error));
    });
    if (!ok) return;

    emit(state.copyWith(listening: true));
    _lastRecognizedText = '';
    _lastIncrementTime = null;
    _lastMatchOccurrences = 0;
    
    await _speech.start(
      onPartial: (text) {
        _processSpeechText(text);
      }, 
      onComplete: () {
        emit(state.copyWith(listening: false));
        _lastRecognizedText = '';
        _lastIncrementTime = null;
        _lastMatchOccurrences = 0;
      },
      onError: (error) {
        emit(state.copyWith(status: MantraStatus.failure, error: error));
      }
    );
  }

  void _processSpeechText(String text) {
    final normalized = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final triggers = state.targetMantras.map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();
    if (triggers.isEmpty || normalized.isEmpty) return;
    // Build regex patterns with word boundaries and transliteration variants
    final List<RegExp> patterns = _buildPatternsForTriggers(triggers);

    // Count total occurrences across all patterns in the current partial
    int totalMatches = 0;
    for (final p in patterns) {
      totalMatches += p.allMatches(normalized).length;
    }

    // If occurrences increased compared to previous partial, increment by the delta
    if (totalMatches > _lastMatchOccurrences) {
      final delta = totalMatches - _lastMatchOccurrences;
      _lastIncrementTime = DateTime.now();
      increment(delta);
    }

    _lastMatchOccurrences = totalMatches;
    _lastRecognizedText = normalized;
  }

  List<RegExp> _buildPatternsForTriggers(List<String> triggers) {
    final List<RegExp> patterns = <RegExp>[];
    for (final t in triggers) {
      final trimmed = t.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.contains(' ')) {
        final words = trimmed.split(' ');
        final regexWords = <String>[];
        for (final w in words) {
          regexWords.add(_wordPattern(w));
        }
        final phrase = regexWords.join('\\s+');
        patterns.add(RegExp('\\b' + phrase + '\\b'));
      } else {
        patterns.add(RegExp('\\b' + _wordPattern(trimmed) + '\\b'));
      }
    }
    return patterns;
  }

  String _wordPattern(String word) {
    final w = word.toLowerCase();
    // Om variants
    if (w == 'om' || w == 'aum' || w == 'ohm' || w == 'um') {
      return '(?:om|aum|ohm|um)';
    }
    // Namah/Namaha
    if (w == 'namah' || w == 'namaha') {
      return 'namaha?';
    }
    // Shivay/Shivaya
    if (w == 'shivay' || w == 'shivaya') {
      return 'shivaya?';
    }
    // Hare variants
    if (w == 'hare' || w == 'hari' || w == 'haray') {
      return '(?:hare|hari|haray)';
    }
    // Krishna transliterations
    if (w == 'krishna' || w == 'krsna' || w == 'krushna' || w == 'krsna' || w == 'kṛṣṇa') {
      return '(?:krishna|krsna|krushna|k[rṛ]s?[nṇ]a)';
    }
    // Ram/Rama transliterations
    if (w == 'ram' || w == 'rama' || w == 'raam') {
      return '(?:ram|rama|raam|r[aā]ma?)';
    }
    return RegExp.escape(w);
  }
}
