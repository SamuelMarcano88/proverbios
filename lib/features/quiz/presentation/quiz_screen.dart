import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme/app_theme.dart';
import '../../progress/data/progress_repository.dart';
import '../../shared/presentation/auth_screen.dart';
import '../domain/quiz_content.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({this.supabaseClient, super.key});

  final SupabaseClient? supabaseClient;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _answers = <WisdomProfile>[];
  QuizResult? _result;
  bool _isSaving = false;
  bool _isSaved = false;
  String? _saveError;

  Future<void> _answer(QuizAnswer answer) async {
    setState(() => _answers.add(answer.profile));
    if (_answers.length == quizQuestions.length) {
      final result = scoreQuiz(_answers);
      setState(() => _result = result);
      if (widget.supabaseClient?.auth.currentUser != null) {
        await _saveResult(result);
      }
    }
  }

  Future<void> _saveResult(QuizResult result) async {
    final client = widget.supabaseClient;
    if (client == null) {
      setState(() {
        _saveError =
            'Para guardar resultados, configura SUPABASE_URL y '
            'SUPABASE_PUBLISHABLE_KEY en Netlify.';
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
    }

    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    try {
      await ProgressRepository(client).saveQuizResult(result);
      if (mounted) setState(() => _isSaved = true);
    } on AuthException catch (error) {
      if (mounted) setState(() => _saveError = error.message);
    } on PostgrestException catch (error) {
      if (mounted) {
        setState(() {
          _saveError =
              'No se pudo guardar. Revisa la configuración de Supabase: '
              '${error.message}';
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _saveError = 'No se pudo guardar el resultado: $error');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _restart() {
    setState(() {
      _answers.clear();
      _result = null;
      _isSaved = false;
      _saveError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('¿Qué tan sabio puedo ser?')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: result == null
                ? _buildQuestion(context)
                : _buildResult(context, result),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final question = quizQuestions[_answers.length];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PREGUNTA ${_answers.length + 1} DE ${quizQuestions.length}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: _answers.length / quizQuestions.length),
        const SizedBox(height: 32),
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 22),
        for (final answer in question.answers) ...[
          Card(
            child: InkWell(
              onTap: () => _answer(answer),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(answer.label)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        const Spacer(),
        Text(
          'No es un diagnóstico ni una etiqueta: es una pausa personal para '
          'reflexionar.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context, QuizResult result) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.spa_outlined, size: 54, color: AppColors.gold),
          const SizedBox(height: 18),
          Text(
            'TU REFLEXIÓN',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.profile.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          Text(
            result.profile.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          Text(
            'Referencia para seguir reflexionando: ${result.profile.reference}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          for (final profile in WisdomProfile.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(_scoreLabel(profile))),
                  Text('${result.scores[profile]} de ${quizQuestions.length}'),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (_isSaved)
            const _StatusMessage(
              text: 'Resultado guardado en tu cuenta.',
              isError: false,
            )
          else if (_saveError != null)
            _StatusMessage(text: _saveError!, isError: true)
          else if (widget.supabaseClient?.auth.currentUser == null)
            const _StatusMessage(
              text: 'Inicia sesión para guardar este resultado en tu progreso.',
              isError: false,
            ),
          if (_isSaving) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          if (!_isSaved)
            OutlinedButton.icon(
              onPressed: _isSaving ? null : () => _saveResult(result),
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(
                widget.supabaseClient?.auth.currentUser == null
                    ? 'Iniciar sesión y guardar'
                    : 'Guardar resultado',
              ),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _restart,
            child: const Text('Volver a hacer el test'),
          ),
        ],
      ),
    );
  }

  String _scoreLabel(WisdomProfile profile) => switch (profile) {
    WisdomProfile.wise => 'Sabio',
    WisdomProfile.simple => 'Simple',
    WisdomProfile.foolish => 'Insensato',
  };
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? AppColors.terracottaTint : AppColors.blueTint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }
}
