part of 'mantra_cubit.dart';

enum MantraStatus { initial, loading, ready, failure }

class MantraState extends Equatable {
  const MantraState({
    this.count = 0,
    this.listening = false,
    this.targetWord = 'hello',
    this.status = MantraStatus.initial,
    this.error,
  });

  final int count;
  final bool listening;
  final String targetWord;
  final MantraStatus status;
  final String? error;

  MantraState copyWith({
    int? count,
    bool? listening,
    String? targetWord,
    MantraStatus? status,
    String? error,
  }) {
    return MantraState(
      count: count ?? this.count,
      listening: listening ?? this.listening,
      targetWord: targetWord ?? this.targetWord,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [count, listening, targetWord, status, error];
}
