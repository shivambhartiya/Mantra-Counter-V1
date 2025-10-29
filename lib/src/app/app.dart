import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/feature/mantra/view/mantra_page.dart';
import 'package:flutter_application_1/src/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.deepMidnightBlue,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Krishna Japa Counter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.krishnaTheme,
      home: const MantraPage(),
    );
  }
}
