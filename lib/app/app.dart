import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/home/presentation/home_screen.dart';
import 'localization.dart';
import 'theme/app_theme.dart';

class ProverbiosApp extends StatefulWidget {
  const ProverbiosApp({this.supabaseClient, super.key});

  final SupabaseClient? supabaseClient;

  @override
  State<ProverbiosApp> createState() => _ProverbiosAppState();
}

class _ProverbiosAppState extends State<ProverbiosApp> {
  AppLanguage _language = AppLanguage.es;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getString('app_language');
      if (!mounted || saved == null) return;
      setState(() {
        _language = saved == 'ptBr' ? AppLanguage.ptBr : AppLanguage.es;
      });
    } on Exception {
      // Keep the default language if preferences are unavailable.
    }
  }

  Future<void> _setLanguage(AppLanguage language) async {
    setState(() => _language = language);
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('app_language', language.name);
    } on Exception {
      // The language remains active for this session.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLocalizations(
      language: _language,
      onLanguageChanged: _setLanguage,
      child: MaterialApp(
        title: _language == AppLanguage.es
            ? '¿Qué perfil eres?'
            : 'Qual é o seu perfil?',
        locale: _language == AppLanguage.es
            ? const Locale('es', 'ES')
            : const Locale('pt', 'BR'),
        supportedLocales: const [Locale('es', 'ES'), Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: HomeScreen(supabaseClient: widget.supabaseClient),
      ),
    );
  }
}
