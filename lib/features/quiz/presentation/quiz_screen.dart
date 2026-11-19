import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/localization.dart';
import '../../../app/presentation/language_selector.dart';
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
  late List<QuizQuestion> _questions;
  final _answers = <WisdomProfile>[];
  QuizResult? _result;
  bool _isSaving = false;
  bool _isSaved = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _questions = createRandomizedQuiz(Random());
  }

  Future<void> _answer(QuizAnswer answer) async {
    setState(() => _answers.add(answer.profile));
    if (_answers.length == _questions.length) {
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
        _saveError = context.tr('quiz_save_config');
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
      if (mounted) {
        setState(
          () => _saveError =
              '${context.tr('operation_failed')}: ${error.message}',
        );
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        setState(() {
          _saveError = context
              .tr('quiz_save_error')
              .replaceAll('{error}', error.message);
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(
          () => _saveError = context
              .tr('quiz_save_error')
              .replaceAll('{error}', '$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _restart() {
    setState(() {
      _questions = createRandomizedQuiz(Random());
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
      appBar: AppBar(
        title: Text(context.tr('quiz_title')),
        actions: const [LanguageSelector()],
      ),
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
    final question = _questions[_answers.length];
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context
                .tr('question_progress')
                .replaceAll('{current}', '${_answers.length + 1}')
                .replaceAll('{total}', '${_questions.length}'),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: _answers.length / _questions.length),
          const SizedBox(height: 32),
          Text(
            context.l10n.content(question.prompt),
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
                      Expanded(child: Text(context.l10n.content(answer.label))),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          Text(
            context.tr('no_diagnosis'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
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
            context.tr('your_reflection'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.content(result.profile.title),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          Text(
            context.l10n.content(result.profile.description),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          Text(
            context
                .tr('reflection_reference')
                .replaceAll(
                  '{reference}',
                  context.l10n.content(result.profile.reference),
                ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          for (final profile in WisdomProfile.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(_scoreLabel(profile, context))),
                  Text(
                    context
                        .tr('score')
                        .replaceAll('{score}', '${result.scores[profile]}')
                        .replaceAll('{total}', '${quizQuestions.length}'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (_isSaved)
            _StatusMessage(text: context.tr('result_saved'), isError: false)
          else if (_saveError != null)
            _StatusMessage(text: _saveError!, isError: true)
          else if (widget.supabaseClient == null)
            _StatusMessage(
              text: context.tr('no_registration_result'),
              isError: false,
            )
          else if (widget.supabaseClient?.auth.currentUser == null)
            _StatusMessage(
              text: context.tr('save_result_prompt'),
              isError: false,
            ),
          if (_isSaving) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          if (!_isSaved && widget.supabaseClient != null)
            OutlinedButton.icon(
              onPressed: _isSaving ? null : () => _saveResult(result),
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(
                widget.supabaseClient?.auth.currentUser == null
                    ? context.tr('login_save')
                    : context.tr('save_result'),
              ),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _restart,
            child: Text(context.tr('retake_test')),
          ),
        ],
      ),
    );
  }

  String _scoreLabel(WisdomProfile profile, BuildContext context) =>
      switch (profile) {
        WisdomProfile.wise => context.tr('wise'),
        WisdomProfile.simple => context.tr('simple'),
        WisdomProfile.foolish => context.tr('foolish'),
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
