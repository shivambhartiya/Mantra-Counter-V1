import 'package:hive/hive.dart';
import 'package:flutter_application_1/src/feature/mantra/data/mantra_repository.dart';

class HiveMantraRepository implements MantraRepository {
  HiveMantraRepository(this._box);

  static const _countKey = 'count';
  static const _wordKey = 'targetWord';
  static const _wordsKey = 'targetWords';

  final Box _box;

  @override
  Future<int> getCount() async => (_box.get(_countKey, defaultValue: 0) as int);

  @override
  Future<void> setCount(int value) async => _box.put(_countKey, value);

  @override
  Future<String> getTargetWord() async =>
      (_box.get(_wordKey, defaultValue: 'hello') as String);

  @override
  Future<void> setTargetWord(String word) async => _box.put(_wordKey, word);

  @override
  Future<List<String>> getTargetMantras() async {
    // Prefer the new list if available
    final list = _box.get(_wordsKey);
    if (list is List) {
      return list.map((e) => e.toString()).toList();
    }
    // Fallback to single word for backward compatibility
    final single = await getTargetWord();
    return [single];
  }

  @override
  Future<void> setTargetMantras(List<String> mantras) async {
    final cleaned = mantras
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    await _box.put(_wordsKey, cleaned);
    // Also set the first as single word for backward compatibility
    if (cleaned.isNotEmpty) {
      await _box.put(_wordKey, cleaned.first);
    }
  }
}
