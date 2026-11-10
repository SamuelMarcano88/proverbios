enum WisdomProfile { wise, simple, foolish }

class QuizAnswer {
  const QuizAnswer(this.label, this.profile);

  final String label;
  final WisdomProfile profile;
}

class QuizQuestion {
  const QuizQuestion(this.prompt, this.answers);

  final String prompt;
  final List<QuizAnswer> answers;
}

class QuizResult {
  const QuizResult(this.profile, this.scores);

  final WisdomProfile profile;
  final Map<WisdomProfile, int> scores;

  int get total => scores.values.fold(0, (sum, score) => sum + score);

  int get percentage =>
      total == 0 ? 0 : ((scores[profile]! / total) * 100).round();
}

const quizQuestions = <QuizQuestion>[
  QuizQuestion('Cuando recibes una crítica justa, ¿cómo sueles responder?', [
    QuizAnswer('Escucho y considero qué puedo aprender.', WisdomProfile.wise),
    QuizAnswer(
      'Me cuesta aceptarla, pero la pienso después.',
      WisdomProfile.simple,
    ),
    QuizAnswer(
      'La rechazo sin considerar si tiene razón.',
      WisdomProfile.foolish,
    ),
  ]),
  QuizQuestion('Antes de una decisión importante, ¿qué haces?', [
    QuizAnswer(
      'Busco consejo y pienso en las consecuencias.',
      WisdomProfile.wise,
    ),
    QuizAnswer(
      'Decido según lo que siento en el momento.',
      WisdomProfile.simple,
    ),
    QuizAnswer(
      'Actúo impulsivamente aunque vea el riesgo.',
      WisdomProfile.foolish,
    ),
  ]),
  QuizQuestion('Si una persona cercana piensa distinto a ti, ¿qué haces?', [
    QuizAnswer('Escucho su punto de vista con respeto.', WisdomProfile.wise),
    QuizAnswer('Evito el tema para no incomodarme.', WisdomProfile.simple),
    QuizAnswer(
      'Respondo con enojo o intento humillarla.',
      WisdomProfile.foolish,
    ),
  ]),
  QuizQuestion('Cuando cometes un error, ¿cuál es tu reacción más frecuente?', [
    QuizAnswer('Lo reconozco y procuro reparar el daño.', WisdomProfile.wise),
    QuizAnswer(
      'Espero que pase y trato de seguir adelante.',
      WisdomProfile.simple,
    ),
    QuizAnswer('Busco a quién culpar para no asumirlo.', WisdomProfile.foolish),
  ]),
  QuizQuestion('¿Cómo manejas una promesa o compromiso?', [
    QuizAnswer(
      'La tomo en serio y aviso si no podré cumplirla.',
      WisdomProfile.wise,
    ),
    QuizAnswer(
      'A veces olvido revisar si puedo cumplir.',
      WisdomProfile.simple,
    ),
    QuizAnswer(
      'Prometo lo que sea aunque no piense cumplirlo.',
      WisdomProfile.foolish,
    ),
  ]),
  QuizQuestion('Cuando tienes éxito, ¿cómo lo vives?', [
    QuizAnswer(
      'Con gratitud, recordando a quienes me ayudaron.',
      WisdomProfile.wise,
    ),
    QuizAnswer(
      'Disfruto el momento sin pensar mucho en ello.',
      WisdomProfile.simple,
    ),
    QuizAnswer(
      'Creo que eso me hace superior a los demás.',
      WisdomProfile.foolish,
    ),
  ]),
  QuizQuestion('Si alguien necesita ayuda y puedes brindarla, ¿qué haces?', [
    QuizAnswer('Busco una manera responsable de ayudar.', WisdomProfile.wise),
    QuizAnswer(
      'Dudo y suelo esperar a que alguien más actúe.',
      WisdomProfile.simple,
    ),
    QuizAnswer(
      'Me aprovecho de su necesidad o la ignoro con desprecio.',
      WisdomProfile.foolish,
    ),
  ]),
  QuizQuestion('Cuando sientes enojo, ¿qué haces primero?', [
    QuizAnswer('Hago una pausa antes de responder.', WisdomProfile.wise),
    QuizAnswer('Respondo rápido y luego me arrepiento.', WisdomProfile.simple),
    QuizAnswer('Busco herir con mis palabras.', WisdomProfile.foolish),
  ]),
];

QuizResult scoreQuiz(List<WisdomProfile> answers) {
  if (answers.length != quizQuestions.length) {
    throw ArgumentError.value(
      answers.length,
      'answers.length',
      'El test debe estar completo.',
    );
  }

  final scores = {for (final profile in WisdomProfile.values) profile: 0};
  for (final profile in answers) {
    scores[profile] = scores[profile]! + 1;
  }

  final highestScore = scores.values.reduce((a, b) => a > b ? a : b);
  final highestProfiles = scores.entries
      .where((entry) => entry.value == highestScore)
      .map((entry) => entry.key)
      .toList();
  final profile = highestProfiles.length == 1
      ? highestProfiles.single
      : WisdomProfile.simple;

  return QuizResult(profile, scores);
}

extension WisdomProfileContent on WisdomProfile {
  String get title => switch (this) {
    WisdomProfile.wise => 'Una tendencia hacia la sabiduría',
    WisdomProfile.simple => 'Un camino de aprendizaje',
    WisdomProfile.foolish => 'Una invitación a detenerte y reflexionar',
  };

  String get description => switch (this) {
    WisdomProfile.wise =>
      'Tus respuestas muestran disposición para escuchar, aprender y pensar '
          'en las consecuencias. Sigue cultivando esas decisiones con humildad.',
    WisdomProfile.simple =>
      'Tus respuestas reflejan áreas en las que todavía estás formando hábitos. '
          'La enseñanza bíblica presenta el aprendizaje como un camino posible.',
    WisdomProfile.foolish =>
      'Tus respuestas señalan reacciones que pueden lastimarte o lastimar a '
          'otros. No es una etiqueta: puedes pausar, pedir consejo y elegir '
          'un paso distinto.',
  };

  String get reference => switch (this) {
    WisdomProfile.wise => 'Proverbios 1:5',
    WisdomProfile.simple => 'Proverbios 1:4',
    WisdomProfile.foolish => 'Proverbios 1:7',
  };

  String get key => name;
}
