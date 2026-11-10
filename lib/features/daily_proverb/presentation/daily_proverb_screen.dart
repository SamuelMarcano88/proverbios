import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme/app_theme.dart';
import '../../progress/data/progress_repository.dart';
import '../../shared/presentation/auth_screen.dart';
import '../domain/daily_proverbs.dart';

class DailyProverbScreen extends StatefulWidget {
  const DailyProverbScreen({this.supabaseClient, super.key});

  final SupabaseClient? supabaseClient;

  @override
  State<DailyProverbScreen> createState() => _DailyProverbScreenState();
}

class _DailyProverbScreenState extends State<DailyProverbScreen> {
  late final DailyProverb _proverb = proverbForDate(DateTime.now());
  bool _isSaved = false;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.supabaseClient?.auth.currentUser != null) {
      _loadSaved();
    }
  }

  Future<void> _loadSaved() async {
    final client = widget.supabaseClient;
    if (client == null || client.auth.currentUser == null) return;

    try {
      final saved = await ProgressRepository(client).isProverbSaved(_proverb);
      if (mounted) setState(() => _isSaved = saved);
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on PostgrestException catch (error) {
      if (mounted) {
        setState(
          () => _error = 'No se pudo cargar el favorito: ${error.message}',
        );
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo cargar el favorito: $error');
      }
    }
  }

  Future<void> _toggleSaved() async {
    final client = widget.supabaseClient;
    if (client == null) {
      setState(() {
        _error =
            'Para guardar favoritos, configura Supabase en las variables '
            'de entorno de Netlify.';
      });
      return;
    }
    if (client.auth.currentUser == null) {
      final signedIn = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => AuthScreen(supabaseClient: client),
        ),
      );
      if (signedIn != true || !mounted) return;
      await _loadSaved();
      if (!mounted || _isSaved) return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      final saved = await ProgressRepository(
        client,
      ).toggleSavedProverb(_proverb);
      if (mounted) setState(() => _isSaved = saved);
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on PostgrestException catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo guardar: ${error.message}');
      }
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'No se pudo guardar: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proverbio del día')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.wb_sunny_outlined,
                  color: AppColors.gold,
                  size: 44,
                ),
                const SizedBox(height: 22),
                Text(
                  _proverb.reference.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '“${_proverb.text}”',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reina-Valera 1909 · Texto de dominio público',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.blueTint,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PARA REFLEXIONAR',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _proverb.reflection,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.terracotta),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _toggleSaved,
                  icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(
                    _isSaving
                        ? 'Guardando...'
                        : _isSaved
                        ? 'Guardado en favoritos'
                        : 'Guardar en favoritos',
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Cada día encontrarás una lectura distinta. La selección '
                  'cambia automáticamente con la fecha.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
