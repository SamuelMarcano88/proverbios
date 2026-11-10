import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/home/presentation/home_screen.dart';
import 'theme/app_theme.dart';

class ProverbiosApp extends StatelessWidget {
  const ProverbiosApp({this.supabaseClient, super.key});

  final SupabaseClient? supabaseClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '¿Qué perfil eres?',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(supabaseClient: supabaseClient),
    );
  }
}
