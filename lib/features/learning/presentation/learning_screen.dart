import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  static const _profiles = [
    _Profile(
      title: 'El sabio',
      icon: Icons.lightbulb_outline_rounded,
      color: AppColors.gold,
      background: AppColors.goldTint,
      lessons: [
        _Lesson(
          reference: 'Proverbios 1:5',
          summary: 'Escucha y sigue aprendiendo.',
          body:
              'La sabiduría no significa saberlo todo. El sabio acepta consejo, '
              'aprende de la experiencia y está dispuesto a corregir su camino.',
          practice: 'Práctica: pide una opinión sincera antes de decidir.',
        ),
        _Lesson(
          reference: 'Proverbios 9:9',
          summary: 'Recibe la instrucción y crece en entendimiento.',
          body:
              'La persona sabia no deja de aprender. Puede recibir una idea '
              'nueva sin sentir que eso disminuye su valor.',
          practice: 'Práctica: escucha una sugerencia antes de responder.',
        ),
        _Lesson(
          reference: 'Proverbios 12:15',
          summary: 'Busca consejo en lugar de confiar solo en tu parecer.',
          body:
              'Pedir consejo ayuda a ver aspectos que quizá no habías notado. '
              'La humildad abre espacio para decisiones más prudentes.',
          practice: 'Práctica: consulta a alguien de confianza sobre un plan.',
        ),
      ],
    ),
    _Profile(
      title: 'El simple',
      icon: Icons.explore_outlined,
      color: AppColors.blue,
      background: AppColors.blueTint,
      lessons: [
        _Lesson(
          reference: 'Proverbios 1:4',
          summary: 'Está en camino de aprender discernimiento.',
          body:
              'La persona simple todavía puede ser influida por lo que la '
              'rodea. Proverbios invita a buscar prudencia y pensar en las '
              'consecuencias antes de actuar.',
          practice: 'Práctica: antes de elegir, considera qué podría pasar.',
        ),
        _Lesson(
          reference: 'Proverbios 14:15',
          summary: 'No todo lo que oye merece una respuesta inmediata.',
          body:
              'La prudencia ayuda a examinar una idea antes de aceptarla. '
              'Tomarse un momento puede evitar decisiones precipitadas.',
          practice: 'Práctica: verifica la información antes de compartirla.',
        ),
        _Lesson(
          reference: 'Proverbios 19:2',
          summary: 'El entusiasmo también necesita dirección.',
          body:
              'Actuar con prisa y sin conocimiento puede desviarnos. Aprender '
              'a detenerse es parte de crecer en discernimiento.',
          practice: 'Práctica: date tiempo para pensar antes de comprometerte.',
        ),
      ],
    ),
    _Profile(
      title: 'El insensato',
      icon: Icons.warning_amber_rounded,
      color: AppColors.terracotta,
      background: AppColors.terracottaTint,
      lessons: [
        _Lesson(
          reference: 'Proverbios 1:7',
          summary: 'Desprecia la corrección y rechaza aprender.',
          body:
              'La insensatez describe una manera de actuar, no una identidad '
              'permanente. Detenerse, escuchar y cambiar de rumbo sigue siendo '
              'posible.',
          practice: 'Práctica: reconoce una reacción que quieras cambiar.',
        ),
        _Lesson(
          reference: 'Proverbios 12:1',
          summary: 'Aceptar corrección puede ser el comienzo del crecimiento.',
          body:
              'La corrección puede incomodar, pero también muestra una '
              'oportunidad de mejorar. Rechazarla de inmediato nos impide '
              'aprender.',
          practice: 'Práctica: agradece una corrección antes de explicarte.',
        ),
        _Lesson(
          reference: 'Proverbios 15:5',
          summary: 'Escuchar consejo es una decisión que puedes tomar hoy.',
          body:
              'Una respuesta impulsiva no tiene que definir lo que hagas '
              'después. Siempre puedes volver a escuchar y buscar reparación.',
          practice:
              'Práctica: si reaccionaste mal, da el primer paso para reparar.',
        ),
      ],
    ),
  ];

  late final List<_Profile> _sessionProfiles = _createSessionProfiles();

  List<_Profile> _createSessionProfiles() {
    final random = Random();
    final profiles = _profiles.map((profile) {
      final lesson = profile.lessons[random.nextInt(profile.lessons.length)];
      return profile.withLesson(lesson);
    }).toList()..shuffle(random);
    return profiles;
  }

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
                for (final profile in _sessionProfiles) ...[
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
                  profile.lesson!.reference,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: profile.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              profile.lesson!.summary,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(profile.lesson!.body),
            const SizedBox(height: 10),
            Text(
              profile.lesson!.practice,
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
    required this.icon,
    required this.color,
    required this.background,
    required this.lessons,
    this.lesson,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Color background;
  final List<_Lesson> lessons;
  final _Lesson? lesson;

  _Profile withLesson(_Lesson lesson) => _Profile(
    title: title,
    icon: icon,
    color: color,
    background: background,
    lessons: lessons,
    lesson: lesson,
  );
}

class _Lesson {
  const _Lesson({
    required this.reference,
    required this.summary,
    required this.body,
    required this.practice,
  });

  final String reference;
  final String summary;
  final String body;
  final String practice;
}
