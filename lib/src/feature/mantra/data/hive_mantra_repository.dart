import 'package:hive/hive.dart';
import 'package:flutter_application_1/src/feature/mantra/data/mantra_repository.dart';

class HiveMantraRepository implements MantraRepository {
  HiveMantraRepository(this._box);

  static const _countKey = 'count';
  static const _wordKey = 'targetWord';

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
}
