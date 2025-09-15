import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/src/feature/mantra/bloc/mantra_cubit.dart';
import 'package:flutter_application_1/src/feature/mantra/data/mantra_repository.dart';
import 'package:flutter_application_1/src/feature/mantra/services/speech_service.dart';

class _MemRepo implements MantraRepository {
  int _count = 0;
  String _word = 'hello';
  @override
  Future<int> getCount() async => _count;
  @override
  Future<String> getTargetWord() async => _word;
  @override
  Future<void> setCount(int value) async => _count = value;
  @override
  Future<void> setTargetWord(String word) async => _word = word;
}

class _NoopSpeech extends SpeechService {}

void main() {
  group('MantraCubit', () {
    late _MemRepo repo;
    late _NoopSpeech speech;
    setUp(() {
      repo = _MemRepo();
      speech = _NoopSpeech();
    });

    test('initial state', () {
      final cubit = MantraCubit(repository: repo, speech: speech);
      expect(cubit.state.count, 0);
  expect(cubit.state.targetWord, 'hello');
      expect(cubit.state.status, MantraStatus.initial);
    });

    blocTest<MantraCubit, MantraState>(
      'loads from repository',
      build: () => MantraCubit(repository: repo, speech: speech),
      act: (cubit) => cubit.load(),
      expect: () => [
        const MantraState(status: MantraStatus.loading),
        const MantraState(status: MantraStatus.ready),
      ],
      verify: (cubit) {
        expect(cubit.state.count, 0);
  expect(cubit.state.targetWord, 'hello');
      },
    );

    blocTest<MantraCubit, MantraState>(
      'increment and reset',
      build: () => MantraCubit(repository: repo, speech: speech),
      act: (cubit) async {
        await cubit.increment();
        await cubit.reset();
      },
      expect: () => [
        const MantraState(count: 1),
        const MantraState(count: 0),
      ],
    );

    blocTest<MantraCubit, MantraState>(
      'set target word',
      build: () => MantraCubit(repository: repo, speech: speech),
      act: (cubit) async => cubit.setTargetWord('hello'),
      expect: () => [
        const MantraState(targetWord: 'hello'),
      ],
    );
  });
}
