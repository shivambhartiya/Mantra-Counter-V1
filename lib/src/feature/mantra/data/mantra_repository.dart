abstract class MantraRepository {
  Future<int> getCount();
  Future<void> setCount(int value);
  Future<String> getTargetWord();
  Future<void> setTargetWord(String word);
}
