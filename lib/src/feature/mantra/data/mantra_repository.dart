abstract class MantraRepository {
  Future<int> getCount();
  Future<void> setCount(int value);

  // Backward-compatible single target word APIs
  Future<String> getTargetWord();
  Future<void> setTargetWord(String word);

  // New multi-mantra APIs
  Future<List<String>> getTargetMantras();
  Future<void> setTargetMantras(List<String> mantras);
}
