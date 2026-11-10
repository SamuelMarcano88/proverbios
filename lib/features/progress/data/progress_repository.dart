import 'package:supabase_flutter/supabase_flutter.dart';

import '../../daily_proverb/domain/daily_proverbs.dart';
import '../../quiz/domain/quiz_content.dart';

class ProgressRepository {
  const ProgressRepository(this.client);

  final SupabaseClient client;

  Future<void> saveQuizResult(QuizResult result) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Inicia sesión para guardar tu resultado.');
    }

    await client.from('quiz_attempts').insert({
      'profile': result.profile.key,
      'scores': {
        for (final entry in result.scores.entries) entry.key.key: entry.value,
      },
    });
  }

  Future<List<Map<String, dynamic>>> loadQuizHistory() async {
    final data = await client
        .from('quiz_attempts')
        .select('profile, scores, created_at')
        .order('created_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<bool> isProverbSaved(DailyProverb proverb) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Inicia sesión para guardar proverbios.');
    }

    final row = await client
        .from('saved_proverbs')
        .select('proverb_id')
        .eq('proverb_id', proverb.id)
        .maybeSingle();
    return row != null;
  }

  Future<bool> toggleSavedProverb(DailyProverb proverb) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Inicia sesión para guardar proverbios.');
    }

    final existing = await client
        .from('saved_proverbs')
        .select('proverb_id')
        .eq('proverb_id', proverb.id)
        .maybeSingle();

    if (existing != null) {
      await client.from('saved_proverbs').delete().eq('proverb_id', proverb.id);
      return false;
    }

    await client.from('saved_proverbs').insert({
      'proverb_id': proverb.id,
      'reference': proverb.reference,
      'text': proverb.text,
    });
    return true;
  }
}
