import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  static const _profiles = [
    _Profile(
      title: 'El sabio',
      reference: 'Proverbios 1:5',
      icon: Icons.lightbulb_outline_rounded,
      color: AppColors.gold,
      background: AppColors.goldTint,
      summary: 'Escucha y sigue aprendiendo.',
      body:
          'La sabiduría no significa saberlo todo. En Proverbios, el sabio '
          'acepta consejo, aprende de la experiencia y está dispuesto a '
          'corregir su camino.',
      practice: 'Práctica: pide una opinión sincera antes de decidir.',
    ),
    _Profile(
      title: 'El simple',
      reference: 'Proverbios 1:4',
      icon: Icons.explore_outlined,
      color: AppColors.blue,
      background: AppColors.blueTint,
      summary: 'Está en camino de aprender discernimiento.',
      body:
          'La persona simple todavía puede ser influida por lo que la rodea. '
          'El libro de Proverbios invita a buscar prudencia y a pensar en las '
          'consecuencias antes de actuar.',
      practice:
          'Práctica: antes de elegir, considera qué podría pasar después.',
    ),
    _Profile(
      title: 'El insensato',
      reference: 'Proverbios 1:7',
      icon: Icons.warning_amber_rounded,
      color: AppColors.terracotta,
      background: AppColors.terracottaTint,
      summary: 'Desprecia la corrección y rechaza aprender.',
      body:
          'En Proverbios, la insensatez describe una manera de actuar, no una '
          'identidad permanente. Rechazar consejo puede traer daño, pero '
          'detenerse, escuchar y cambiar de rumbo sigue siendo posible.',
      practice: 'Práctica: reconoce una reacción que quieras hacer diferente.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aprende a ser sabio')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tres maneras de responder a la vida',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Estos perfiles describen actitudes que podemos mostrar en '
                  'distintos momentos. No son etiquetas fijas ni diagnósticos.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                for (final profile in _profiles) ...[
                  _ProfileCard(profile: profile),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 8),
                Text(
                  'Referencias sugeridas: Proverbios 1:4–7 y 9:8–10.',
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final _Profile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: profile.background,
                  foregroundColor: profile.color,
                  child: Icon(profile.icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    profile.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  profile.reference,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: profile.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              profile.summary,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(profile.body),
            const SizedBox(height: 10),
            Text(
              profile.practice,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: profile.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Profile {
  const _Profile({
    required this.title,
    required this.reference,
    required this.icon,
    required this.color,
    required this.background,
    required this.summary,
    required this.body,
    required this.practice,
  });

  final String title;
  final String reference;
  final IconData icon;
  final Color color;
  final Color background;
  final String summary;
  final String body;
  final String practice;
}
