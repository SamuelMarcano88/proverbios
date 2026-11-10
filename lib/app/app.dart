import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import 'theme/app_theme.dart';

class ProverbiosApp extends StatelessWidget {
  const ProverbiosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '¿Qué perfil eres?',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
