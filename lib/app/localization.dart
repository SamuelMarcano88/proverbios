import 'package:flutter/material.dart';

enum AppLanguage { es, ptBr }

class AppLocalizations extends InheritedWidget {
  const AppLocalizations({
    required this.language,
    required this.onLanguageChanged,
    required super.child,
    super.key,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static AppLocalizations of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<AppLocalizations>();
    assert(result != null, 'No AppLocalizations found in context');
    return result!;
  }

  static AppLocalizations? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLocalizations>();

  Locale get locale => Locale(language == AppLanguage.es ? 'es' : 'pt', 'BR');

  bool get isPortuguese => language == AppLanguage.ptBr;

  String text(String key) =>
      _translations[key]?[language.name] ?? _translations[key]?['es'] ?? key;

  @override
  bool updateShouldNotify(AppLocalizations oldWidget) =>
      language != oldWidget.language;
}

extension AppLocalizationContext on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.maybeOf(this) ??
      const AppLocalizations(
        language: AppLanguage.es,
        onLanguageChanged: _noopLanguageChange,
        child: SizedBox.shrink(),
      );
  String tr(String key) => l10n.text(key);
}

void _noopLanguageChange(AppLanguage language) {}

const _translations = <String, Map<String, String>>{
  'profile_title': {'es': '¿QUÉ PERFIL ERES?', 'ptBr': 'QUAL É O SEU PERFIL?'},
  'quiz_title': {
    'es': '¿Qué tan sabio puedo ser?',
    'ptBr': 'Quão sábio posso ser?',
  },
  'quiz_description': {
    'es': 'Reflexiona sobre tus decisiones cotidianas a la luz de Proverbios.',
    'ptBr': 'Reflita sobre suas decisões diárias à luz de Provérbios.',
  },
  'daily_title': {'es': 'Proverbio del día', 'ptBr': 'Provérbio do dia'},
  'daily_description': {
    'es': 'Una enseñanza de la Palabra para inspirar y orientar tu día.',
    'ptBr': 'Um ensino da Palavra para inspirar e orientar o seu dia.',
  },
  'learn_title': {'es': 'Aprende a ser sabio', 'ptBr': 'Aprenda a ser sábio'},
  'learn_description': {
    'es': 'Conoce cómo responden el sabio, el simple y el insensato.',
    'ptBr': 'Conheça como o sábio, o simples e o insensato respondem.',
  },
  'community_title': {'es': 'Comunidad', 'ptBr': 'Comunidade'},
  'community_description': {
    'es': 'Comparte aprendizajes, reflexiones y conversaciones con otros.',
    'ptBr': 'Compartilhe aprendizados, reflexões e conversas com outros.',
  },
  'create_account': {'es': 'Crear cuenta', 'ptBr': 'Criar conta'},
  'sign_in': {'es': 'Iniciar sesión', 'ptBr': 'Entrar'},
  'sign_out': {'es': 'Cerrar sesión', 'ptBr': 'Sair'},
  'progress': {'es': 'Mi progreso', 'ptBr': 'Meu progresso'},
  'guest': {'es': 'Invitado', 'ptBr': 'Visitante'},
  'account_progress': {'es': 'Cuenta y progreso', 'ptBr': 'Conta e progresso'},
  'language': {'es': 'Idioma', 'ptBr': 'Idioma'},
  'spanish': {'es': 'Español', 'ptBr': 'Espanhol'},
  'portuguese_br': {'es': 'Portugués de Brasil', 'ptBr': 'Português do Brasil'},
  'reflection_path': {
    'es': 'UN CAMINO DE REFLEXIÓN',
    'ptBr': 'UM CAMINHO DE REFLEXÃO',
  },
  'each_decision': {
    'es': 'Cada decisión cuenta.',
    'ptBr': 'Cada decisão conta.',
  },
  'intro': {
    'es':
        'Tres maneras de vivir. Una invitación a la sabiduría. Explora las enseñanzas de Proverbios y encuentra nuevas formas de crecer cada día.',
    'ptBr':
        'Três maneiras de viver. Um convite à sabedoria. Explore os ensinamentos de Provérbios e encontre novas formas de crescer a cada dia.',
  },
  'anonymous_notice': {
    'es':
        'Puedes hacer el test sin registrarte. Crear una cuenta es opcional y sirve para guardar tu progreso.',
    'ptBr':
        'Você pode fazer o teste sem se registrar. Criar uma conta é opcional e serve para salvar seu progresso.',
  },
  'footer': {
    'es': 'Una pausa para pensar. Un paso para crecer.',
    'ptBr': 'Uma pausa para pensar. Um passo para crescer.',
  },
  'explore': {'es': 'EXPLORAR', 'ptBr': 'EXPLORAR'},
  'configuration_notice': {
    'es':
        'La app ya funciona, pero para crear cuentas y guardar tu progreso falta conectar las variables públicas de Supabase en Netlify.',
    'ptBr':
        'O aplicativo já funciona, mas para criar contas e salvar seu progresso é necessário conectar as variáveis públicas do Supabase no Netlify.',
  },
  'save_favorite': {
    'es': 'Guardar en favoritos',
    'ptBr': 'Salvar nos favoritos',
  },
  'saved_favorite': {
    'es': 'Guardado en favoritos',
    'ptBr': 'Salvo nos favoritos',
  },
  'saving': {'es': 'Guardando...', 'ptBr': 'Salvando...'},
  'reflect': {'es': 'PARA REFLEXIONAR', 'ptBr': 'PARA REFLETIR'},
  'result_saved': {
    'es': 'Resultado guardado en tu cuenta.',
    'ptBr': 'Resultado salvo na sua conta.',
  },
  'retake_test': {
    'es': 'Volver a hacer el test',
    'ptBr': 'Fazer o teste novamente',
  },
  'login_save': {'es': 'Iniciar sesión y guardar', 'ptBr': 'Entrar e salvar'},
  'save_result': {'es': 'Guardar resultado', 'ptBr': 'Salvar resultado'},
  'community_feed': {'es': 'Publicaciones', 'ptBr': 'Publicações'},
  'new_post': {'es': 'Nueva publicación', 'ptBr': 'Nova publicação'},
  'post_placeholder': {
    'es': '¿Qué quieres compartir con la comunidad?',
    'ptBr': 'O que você quer compartilhar com a comunidade?',
  },
  'publish': {'es': 'Publicar', 'ptBr': 'Publicar'},
  'login_to_post': {
    'es': 'Inicia sesión para publicar.',
    'ptBr': 'Entre para publicar.',
  },
  'empty_feed': {
    'es': 'Todavía no hay publicaciones.',
    'ptBr': 'Ainda não há publicações.',
  },
  'delete_post': {'es': 'Eliminar publicación', 'ptBr': 'Excluir publicação'},
};
