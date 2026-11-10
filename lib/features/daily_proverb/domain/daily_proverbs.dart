class DailyProverb {
  const DailyProverb({
    required this.id,
    required this.reference,
    required this.text,
    required this.reflection,
  });

  final String id;
  final String reference;
  final String text;
  final String reflection;
}

const dailyProverbs = <DailyProverb>[
  DailyProverb(
    id: 'prov-1-7',
    reference: 'Proverbios 1:7',
    text:
        'El principio de la sabiduría es el temor de Jehová: '
        'Los insensatos desprecian la sabiduría y la enseñanza.',
    reflection: '¿Qué enseñanza puedes recibir hoy con humildad?',
  ),
  DailyProverb(
    id: 'prov-3-5',
    reference: 'Proverbios 3:5',
    text: 'Fíate de Jehová de todo tu corazón, Y no estribes en tu prudencia.',
    reflection: '¿En qué decisión necesitas pedir orientación?',
  ),
  DailyProverb(
    id: 'prov-3-6',
    reference: 'Proverbios 3:6',
    text: 'Reconócelo en todos tus caminos, Y él enderezará tus veredas.',
    reflection: '¿Cómo puedes incluir a Dios en una decisión de hoy?',
  ),
  DailyProverb(
    id: 'prov-15-1',
    reference: 'Proverbios 15:1',
    text:
        'La blanda respuesta quita la ira: Mas la palabra áspera hace subir '
        'el furor.',
    reflection: '¿Qué conversación podría cambiar con una respuesta amable?',
  ),
  DailyProverb(
    id: 'prov-16-3',
    reference: 'Proverbios 16:3',
    text: 'Encomienda á Jehová tus obras, Y tus pensamientos serán afirmados.',
    reflection: '¿Qué tarea puedes encomendar antes de comenzar?',
  ),
  DailyProverb(
    id: 'prov-16-9',
    reference: 'Proverbios 16:9',
    text:
        'El corazón del hombre piensa su camino: Mas Jehová endereza sus '
        'pasos.',
    reflection: '¿Qué plan estás dispuesto a revisar con sabiduría?',
  ),
  DailyProverb(
    id: 'prov-17-17',
    reference: 'Proverbios 17:17',
    text:
        'En todo tiempo ama el amigo; Y el hermano para la angustia es '
        'nacido.',
    reflection: '¿A quién puedes acompañar o agradecer hoy?',
  ),
  DailyProverb(
    id: 'prov-18-10',
    reference: 'Proverbios 18:10',
    text:
        'Torre fuerte es el nombre de Jehová: A él correrá el justo, y será '
        'levantado.',
    reflection: '¿Dónde buscas refugio cuando atraviesas una dificultad?',
  ),
  DailyProverb(
    id: 'prov-19-20',
    reference: 'Proverbios 19:20',
    text:
        'Escucha el consejo, y recibe la corrección, Para que seas sabio en '
        'tu vejez.',
    reflection: '¿Qué consejo valioso has recibido últimamente?',
  ),
  DailyProverb(
    id: 'prov-22-6',
    reference: 'Proverbios 22:6',
    text:
        'Instruye al niño en su carrera: Aun cuando fuere viejo no se apartará '
        'de ella.',
    reflection: '¿Qué ejemplo de bien puedes transmitir a alguien más joven?',
  ),
];

DailyProverb proverbForDate(DateTime date) {
  final day = DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(2024)).inDays;
  final index = day % dailyProverbs.length;
  return dailyProverbs[index < 0 ? index + dailyProverbs.length : index];
}
