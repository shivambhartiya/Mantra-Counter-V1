import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'src/app/app.dart';
import 'src/feature/mantra/bloc/mantra_cubit.dart';
import 'src/feature/mantra/data/hive_mantra_repository.dart';
import 'src/feature/mantra/data/mantra_repository.dart';
import 'src/feature/mantra/services/hybrid_speech_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('mantra');
  final MantraRepository repo = HiveMantraRepository(box);
  final speech = HybridSpeechService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MantraCubit(repository: repo, speech: speech)..load(),
        ),
      ],
      child: const App(),
    ),
  );
}
