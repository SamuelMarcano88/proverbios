import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme/app_theme.dart';
import '../../progress/data/progress_repository.dart';
import '../../quiz/domain/quiz_content.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({required this.supabaseClient, super.key});

  final SupabaseClient supabaseClient;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final Future<List<Map<String, dynamic>>> _history = ProgressRepository(
    widget.supabaseClient,
  ).loadQuizHistory();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi progreso')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _history,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se pudo cargar tu progreso: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final attempts = snapshot.data!;
          if (attempts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Todavía no tienes resultados guardados. Completa el test '
                  'para comenzar tu historial.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: attempts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final attempt = attempts[index];
              final profile = WisdomProfile.values.firstWhere(
                (value) => value.key == attempt['profile'],
              );
              final date = DateTime.parse(
                attempt['created_at'] as String,
              ).toLocal();

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.goldTint,
                    child: Icon(Icons.spa_outlined, color: AppColors.gold),
                  ),
                  title: Text(profile.title),
                  subtitle: Text(
                    '${date.day}/${date.month}/${date.year} · ${profile.reference}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
