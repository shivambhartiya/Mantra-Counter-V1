// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_1/src/app/app.dart';
import 'package:flutter_application_1/src/feature/mantra/bloc/mantra_cubit.dart';
import 'package:flutter_application_1/src/feature/mantra/data/mantra_repository.dart';
import 'package:flutter_application_1/src/feature/mantra/services/speech_service.dart';

class _FakeRepo implements MantraRepository {
  int _count = 0;
  String _word = 'om';
  @override
  Future<int> getCount() async => _count;
  @override
  Future<String> getTargetWord() async => _word;
  @override
  Future<void> setCount(int value) async => _count = value;
  @override
  Future<void> setTargetWord(String word) async => _word = word;
}

class _FakeSpeech extends SpeechService {
  _FakeSpeech();
}

void main() {
  testWidgets('MantraPage renders and increments', (tester) async {
    final repo = _FakeRepo();
    final speech = _FakeSpeech();
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => MantraCubit(repository: repo, speech: speech)..load(),
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('counterText')), findsOneWidget);
    expect(find.text('0'), findsWidgets);

    await tester.tap(find.byKey(const Key('incrementButton')));
    await tester.pump();
    expect(find.text('1'), findsWidgets);
  });
}
