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

  String content(String spanish) {
    final translated = _contentTranslations[spanish]?[language.name];
    if (translated != null) return translated;
    if (isPortuguese) {
      return spanish
          .replaceAll('Proverbios', 'Provérbios')
          .replaceAll('Práctica:', 'Prática:');
    }
    return spanish;
  }

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
  'account_title': {'es': 'Tu cuenta', 'ptBr': 'Sua conta'},
  'welcome': {'es': 'Bienvenido', 'ptBr': 'Boas-vindas'},
  'register_heading': {'es': 'Crea tu cuenta', 'ptBr': 'Crie sua conta'},
  'auth_intro': {
    'es':
        'Regístrate con Google o con tu correo para guardar tus resultados y proverbios favoritos. También puedes hacer el test sin registrarte.',
    'ptBr':
        'Cadastre-se com o Google ou seu e-mail para salvar seus resultados e provérbios favoritos. Você também pode fazer o teste sem se cadastrar.',
  },
  'continue_google': {
    'es': 'Continuar con Google',
    'ptBr': 'Continuar com o Google',
  },
  'or_email': {'es': 'o con correo', 'ptBr': 'ou com e-mail'},
  'register_email': {
    'es': 'Crear cuenta con correo',
    'ptBr': 'Criar conta com e-mail',
  },
  'email': {'es': 'Correo electrónico', 'ptBr': 'E-mail'},
  'password': {'es': 'Contraseña', 'ptBr': 'Senha'},
  'repeat_password': {'es': 'Repite la contraseña', 'ptBr': 'Repita a senha'},
  'invalid_email': {
    'es': 'Escribe un correo válido.',
    'ptBr': 'Digite um e-mail válido.',
  },
  'password_length': {
    'es': 'Usa al menos 8 caracteres.',
    'ptBr': 'Use pelo menos 8 caracteres.',
  },
  'password_mismatch': {
    'es': 'Las contraseñas no coinciden.',
    'ptBr': 'As senhas não coincidem.',
  },
  'working': {'es': 'Un momento...', 'ptBr': 'Aguarde...'},
  'register_button': {
    'es': 'Registrarme con correo',
    'ptBr': 'Cadastrar-me com e-mail',
  },
  'login_button': {
    'es': 'Iniciar sesión con correo',
    'ptBr': 'Entrar com e-mail',
  },
  'already_account': {
    'es': 'Ya tengo cuenta: iniciar sesión',
    'ptBr': 'Já tenho uma conta: entrar',
  },
  'need_account': {
    'es': '¿No tienes cuenta? Crear cuenta',
    'ptBr': 'Não tem uma conta? Criar conta',
  },
  'register_confirm': {
    'es':
        'Cuenta creada. Revisa tu correo para confirmar la dirección y luego inicia sesión.',
    'ptBr':
        'Conta criada. Verifique seu e-mail para confirmar o endereço e depois entre.',
  },
  'anonymous_test': {
    'es':
        '¿Solo quieres conocer el test? Puedes responderlo sin cuenta desde la pantalla principal.',
    'ptBr':
        'Quer apenas conhecer o teste? Você pode respondê-lo sem uma conta na tela inicial.',
  },
  'email_separator': {
    'es':
        'El test funciona sin registro. Para crear una cuenta y guardar el progreso, configura SUPABASE_URL y SUPABASE_PUBLISHABLE_KEY en Netlify y vuelve a publicar la app.',
    'ptBr':
        'O teste funciona sem cadastro. Para criar uma conta e salvar o progresso, configure SUPABASE_URL e SUPABASE_PUBLISHABLE_KEY no Netlify e publique o aplicativo novamente.',
  },
  'create_account_option': {'es': 'Crear cuenta', 'ptBr': 'Criar conta'},
  'failed_post': {
    'es':
        'No se pudo publicar. Verifica que ejecutaste el esquema actualizado de Supabase y que tu sesión sigue activa.',
    'ptBr':
        'Não foi possível publicar. Verifique se executou o esquema atualizado do Supabase e se sua sessão continua ativa.',
  },
  'failed_feed': {
    'es':
        'No se pudieron cargar las publicaciones. Ejecuta el contenido actualizado de supabase/schema.sql en Supabase.',
    'ptBr':
        'Não foi possível carregar as publicações. Execute o conteúdo atualizado de supabase/schema.sql no Supabase.',
  },
  'operation_failed': {
    'es': 'No se pudo completar la operación',
    'ptBr': 'Não foi possível concluir a operação',
  },
  'community_login_required': {
    'es': 'Inicia sesión o crea una cuenta para publicar.',
    'ptBr': 'Entre ou crie uma conta para publicar.',
  },
  'verses_source': {
    'es': 'Reina-Valera 1909 · Texto de dominio público',
    'ptBr': 'Reina-Valera 1909 · Texto em domínio público',
  },
  'daily_note': {
    'es':
        'Cada día encontrarás una lectura distinta. La selección cambia automáticamente con la fecha.',
    'ptBr':
        'A cada dia você encontrará uma leitura diferente. A seleção muda automaticamente conforme a data.',
  },
  'question_progress': {
    'es': 'PREGUNTA {current} DE {total}',
    'ptBr': 'PERGUNTA {current} DE {total}',
  },
  'no_diagnosis': {
    'es':
        'No es un diagnóstico ni una etiqueta: es una pausa personal para reflexionar.',
    'ptBr':
        'Isto não é um diagnóstico nem um rótulo: é uma pausa pessoal para refletir.',
  },
  'your_reflection': {'es': 'TU REFLEXIÓN', 'ptBr': 'SUA REFLEXÃO'},
  'reflection_reference': {
    'es': 'Referencia para seguir reflexionando: {reference}',
    'ptBr': 'Referência para continuar refletindo: {reference}',
  },
  'score': {'es': '{score} de {total}', 'ptBr': '{score} de {total}'},
  'no_registration_result': {
    'es':
        'Completaste el test sin registrarte. El resultado es solo para esta sesión y no se guarda.',
    'ptBr':
        'Você concluiu o teste sem se cadastrar. O resultado vale apenas para esta sessão e não é salvo.',
  },
  'save_result_prompt': {
    'es':
        'Inicia sesión o crea una cuenta si quieres guardar este resultado. El test no requiere registro.',
    'ptBr':
        'Entre ou crie uma conta se quiser salvar este resultado. O teste não exige cadastro.',
  },
  'learning_title': {
    'es': 'Tres maneras de responder a la vida',
    'ptBr': 'Três maneiras de responder à vida',
  },
  'learning_intro': {
    'es':
        'Estos perfiles describen actitudes que podemos mostrar en distintos momentos. No son etiquetas fijas ni diagnósticos.',
    'ptBr':
        'Esses perfis descrevem atitudes que podemos demonstrar em diferentes momentos. Não são rótulos fixos nem diagnósticos.',
  },
  'suggested_references': {
    'es': 'Referencias sugeridas: Proverbios 1:4–7 y 9:8–10.',
    'ptBr': 'Referências sugeridas: Provérbios 1:4–7 e 9:8–10.',
  },
  'wise': {'es': 'Sabio', 'ptBr': 'Sábio'},
  'simple': {'es': 'Simple', 'ptBr': 'Simples'},
  'foolish': {'es': 'Insensato', 'ptBr': 'Insensato'},
  'progress_empty': {
    'es':
        'Todavía no tienes resultados guardados. Completa el test para comenzar tu historial.',
    'ptBr':
        'Você ainda não tem resultados salvos. Conclua o teste para começar seu histórico.',
  },
  'progress_load_error': {
    'es': 'No se pudo cargar tu progreso: {error}',
    'ptBr': 'Não foi possível carregar seu progresso: {error}',
  },
  'google_start_failed': {
    'es': 'No se pudo iniciar el acceso con Google. Inténtalo otra vez.',
    'ptBr': 'Não foi possível iniciar o acesso com o Google. Tente novamente.',
  },
  'google_auth_failed': {
    'es': 'Falló el acceso con Google',
    'ptBr': 'Falha ao entrar com o Google',
  },
  'google_setup_hint': {
    'es':
        'Verifica que Google esté habilitado en Supabase y que la URL de este sitio esté autorizada en Redirect URLs.',
    'ptBr':
        'Verifique se o Google está habilitado no Supabase e se a URL deste site está autorizada em Redirect URLs.',
  },
  'google_connecting': {
    'es': 'Conectando con Google...',
    'ptBr': 'Conectando ao Google...',
  },
  'google_redirecting': {
    'es':
        'Se inició el acceso con Google. Si no continúa, revisa la configuración de OAuth en Supabase.',
    'ptBr':
        'O acesso com o Google foi iniciado. Se não continuar, verifique a configuração de OAuth no Supabase.',
  },
  'sign_in_or_register': {
    'es': 'Iniciar sesión o crear cuenta',
    'ptBr': 'Entrar ou criar uma conta',
  },
  'community_setup_error': {
    'es':
        'No se pudo acceder a las publicaciones. Ejecuta el contenido actualizado de supabase/schema.sql en el SQL Editor de Supabase.',
    'ptBr':
        'Não foi possível acessar as publicações. Execute o conteúdo atualizado de supabase/schema.sql no SQL Editor do Supabase.',
  },
  'account_setup_title': {'es': 'Activa tu cuenta', 'ptBr': 'Ative as contas'},
  'account_setup_action': {'es': 'Entendido', 'ptBr': 'Entendi'},
  'sign_out_failed': {
    'es': 'No se pudo cerrar sesión: {error}',
    'ptBr': 'Não foi possível sair: {error}',
  },
  'quiz_save_config': {
    'es':
        'Para guardar resultados, configura SUPABASE_URL y SUPABASE_PUBLISHABLE_KEY en Netlify.',
    'ptBr':
        'Para salvar resultados, configure SUPABASE_URL e SUPABASE_PUBLISHABLE_KEY no Netlify.',
  },
  'favorite_save_config': {
    'es':
        'Para guardar favoritos, configura Supabase en las variables de entorno de Netlify.',
    'ptBr':
        'Para salvar favoritos, configure o Supabase nas variáveis de ambiente do Netlify.',
  },
  'favorite_load_error': {
    'es': 'No se pudo cargar el favorito: {error}',
    'ptBr': 'Não foi possível carregar o favorito: {error}',
  },
  'favorite_save_error': {
    'es': 'No se pudo guardar: {error}',
    'ptBr': 'Não foi possível salvar: {error}',
  },
  'quiz_save_error': {
    'es': 'No se pudo guardar el resultado: {error}',
    'ptBr': 'Não foi possível salvar o resultado: {error}',
  },
  'user_fallback': {'es': 'Usuario', 'ptBr': 'Usuário'},
  'auth_decode_error': {
    'es':
        'Supabase devolvió una respuesta inválida al crear la cuenta. Verifica que SUPABASE_URL sea la URL del proyecto y que SUPABASE_PUBLISHABLE_KEY corresponda a ese mismo proyecto.',
    'ptBr':
        'O Supabase retornou uma resposta inválida ao criar a conta. Verifique se SUPABASE_URL é a URL do projeto e se SUPABASE_PUBLISHABLE_KEY pertence ao mesmo projeto.',
  },
  'google_decode_error': {
    'es':
        'Supabase devolvió una respuesta inválida al iniciar Google. Verifica la URL del proyecto y la configuración del proveedor Google.',
    'ptBr':
        'O Supabase retornou uma resposta inválida ao iniciar o Google. Verifique a URL do projeto e a configuração do provedor Google.',
  },
  'copy_error': {
    'es': 'Copiar detalle del error',
    'ptBr': 'Copiar detalhes do erro',
  },
  'error_copied': {
    'es': 'Detalle copiado al portapapeles.',
    'ptBr': 'Detalhes copiados para a área de transferência.',
  },
  'auth_success': {'es': 'Sesión iniciada.', 'ptBr': 'Sessão iniciada.'},
};

const _contentTranslations = <String, Map<String, String>>{
  'Usuario': {'es': 'Usuario', 'ptBr': 'Usuário'},
  'Proverbios del día': {
    'es': 'Proverbios del día',
    'ptBr': 'Provérbios do dia',
  },
  'Proverbios 1:4': {'es': 'Proverbios 1:4', 'ptBr': 'Provérbios 1:4'},
  'Proverbios 1:5': {'es': 'Proverbios 1:5', 'ptBr': 'Provérbios 1:5'},
  'Proverbios 1:7': {'es': 'Proverbios 1:7', 'ptBr': 'Provérbios 1:7'},
  'Proverbios 9:9': {'es': 'Proverbios 9:9', 'ptBr': 'Provérbios 9:9'},
  'Proverbios 12:15': {'es': 'Proverbios 12:15', 'ptBr': 'Provérbios 12:15'},
  'Proverbios 14:15': {'es': 'Proverbios 14:15', 'ptBr': 'Provérbios 14:15'},
  'Proverbios 19:2': {'es': 'Proverbios 19:2', 'ptBr': 'Provérbios 19:2'},
  'Proverbios 12:1': {'es': 'Proverbios 12:1', 'ptBr': 'Provérbios 12:1'},
  'Proverbios 15:5': {'es': 'Proverbios 15:5', 'ptBr': 'Provérbios 15:5'},
  'El sabio': {'es': 'El sabio', 'ptBr': 'O sábio'},
  'El simple': {'es': 'El simple', 'ptBr': 'O simples'},
  'El insensato': {'es': 'El insensato', 'ptBr': 'O insensato'},
  'Una tendencia hacia la sabiduría': {
    'es': 'Una tendencia hacia la sabiduría',
    'ptBr': 'Uma tendência à sabedoria',
  },
  'Un camino de aprendizaje': {
    'es': 'Un camino de aprendizaje',
    'ptBr': 'Um caminho de aprendizado',
  },
  'Una invitación a detenerte y reflexionar': {
    'es': 'Una invitación a detenerte y reflexionar',
    'ptBr': 'Um convite para parar e refletir',
  },
  'Tus respuestas muestran disposición para escuchar, aprender y pensar en las consecuencias. Sigue cultivando esas decisiones con humildad.': {
    'es':
        'Tus respuestas muestran disposición para escuchar, aprender y pensar en las consecuencias. Sigue cultivando esas decisiones con humildad.',
    'ptBr':
        'Suas respostas demonstram disposição para ouvir, aprender e pensar nas consequências. Continue cultivando essas escolhas com humildade.',
  },
  'Tus respuestas reflejan áreas en las que todavía estás formando hábitos. La enseñanza bíblica presenta el aprendizaje como un camino posible.': {
    'es':
        'Tus respuestas reflejan áreas en las que todavía estás formando hábitos. La enseñanza bíblica presenta el aprendizaje como un camino posible.',
    'ptBr':
        'Suas respostas refletem áreas em que você ainda está formando hábitos. O ensinamento bíblico apresenta o aprendizado como um caminho possível.',
  },
  'Tus respuestas señalan reacciones que pueden lastimarte o lastimar a otros. No es una etiqueta: puedes pausar, pedir consejo y elegir un paso distinto.': {
    'es':
        'Tus respuestas señalan reacciones que pueden lastimarte o lastimar a otros. No es una etiqueta: puedes pausar, pedir consejo y elegir un paso distinto.',
    'ptBr':
        'Suas respostas apontam reações que podem machucar você ou outras pessoas. Isto não é um rótulo: você pode fazer uma pausa, pedir conselho e escolher outro caminho.',
  },
  'Cuando recibes una crítica justa, ¿cómo sueles responder?': {
    'es': 'Cuando recibes una crítica justa, ¿cómo sueles responder?',
    'ptBr': 'Quando você recebe uma crítica justa, como costuma reagir?',
  },
  'Escucho y considero qué puedo aprender.': {
    'es': 'Escucho y considero qué puedo aprender.',
    'ptBr': 'Escuto e penso no que posso aprender.',
  },
  'Me cuesta aceptarla, pero la pienso después.': {
    'es': 'Me cuesta aceptarla, pero la pienso después.',
    'ptBr': 'Tenho dificuldade para aceitar, mas penso no assunto depois.',
  },
  'La rechazo sin considerar si tiene razón.': {
    'es': 'La rechazo sin considerar si tiene razón.',
    'ptBr': 'Rejeito sem considerar se ela tem razão.',
  },
  'Antes de una decisión importante, ¿qué haces?': {
    'es': 'Antes de una decisión importante, ¿qué haces?',
    'ptBr': 'O que você faz antes de uma decisão importante?',
  },
  'Busco consejo y pienso en las consecuencias.': {
    'es': 'Busco consejo y pienso en las consecuencias.',
    'ptBr': 'Peço conselho e penso nas consequências.',
  },
  'Decido según lo que siento en el momento.': {
    'es': 'Decido según lo que siento en el momento.',
    'ptBr': 'Decido de acordo com o que sinto no momento.',
  },
  'Actúo impulsivamente aunque vea el riesgo.': {
    'es': 'Actúo impulsivamente aunque vea el riesgo.',
    'ptBr': 'Ajo por impulso mesmo percebendo o risco.',
  },
  'Si una persona cercana piensa distinto a ti, ¿qué haces?': {
    'es': 'Si una persona cercana piensa distinto a ti, ¿qué haces?',
    'ptBr': 'O que você faz quando alguém próximo pensa diferente de você?',
  },
  'Escucho su punto de vista con respeto.': {
    'es': 'Escucho su punto de vista con respeto.',
    'ptBr': 'Escuto o ponto de vista da pessoa com respeito.',
  },
  'Evito el tema para no incomodarme.': {
    'es': 'Evito el tema para no incomodarme.',
    'ptBr': 'Evito o assunto para não me sentir desconfortável.',
  },
  'Respondo con enojo o intento humillarla.': {
    'es': 'Respondo con enojo o intento humillarla.',
    'ptBr': 'Respondo com raiva ou tento humilhá-la.',
  },
  'Cuando cometes un error, ¿cuál es tu reacción más frecuente?': {
    'es': 'Cuando cometes un error, ¿cuál es tu reacción más frecuente?',
    'ptBr': 'Quando comete um erro, qual é sua reação mais frequente?',
  },
  'Lo reconozco y procuro reparar el daño.': {
    'es': 'Lo reconozco y procuro reparar el daño.',
    'ptBr': 'Reconheço e procuro reparar o dano.',
  },
  'Espero que pase y trato de seguir adelante.': {
    'es': 'Espero que pase y trato de seguir adelante.',
    'ptBr': 'Espero passar e tento seguir em frente.',
  },
  'Busco a quién culpar para no asumirlo.': {
    'es': 'Busco a quién culpar para no asumirlo.',
    'ptBr': 'Procuro alguém para culpar e não assumir a responsabilidade.',
  },
  '¿Cómo manejas una promesa o compromiso?': {
    'es': '¿Cómo manejas una promesa o compromiso?',
    'ptBr': 'Como você lida com uma promessa ou compromisso?',
  },
  'La tomo en serio y aviso si no podré cumplirla.': {
    'es': 'La tomo en serio y aviso si no podré cumplirla.',
    'ptBr': 'Levo a sério e aviso se não puder cumprir.',
  },
  'A veces olvido revisar si puedo cumplir.': {
    'es': 'A veces olvido revisar si puedo cumplir.',
    'ptBr': 'Às vezes esqueço de verificar se posso cumprir.',
  },
  'Prometo lo que sea aunque no piense cumplirlo.': {
    'es': 'Prometo lo que sea aunque no piense cumplirlo.',
    'ptBr': 'Prometo qualquer coisa mesmo sem intenção de cumprir.',
  },
  'Cuando tienes éxito, ¿cómo lo vives?': {
    'es': 'Cuando tienes éxito, ¿cómo lo vives?',
    'ptBr': 'Como você reage quando alcança o sucesso?',
  },
  'Con gratitud, recordando a quienes me ayudaron.': {
    'es': 'Con gratitud, recordando a quienes me ayudaron.',
    'ptBr': 'Com gratidão, lembrando de quem me ajudou.',
  },
  'Disfruto el momento sin pensar mucho en ello.': {
    'es': 'Disfruto el momento sin pensar mucho en ello.',
    'ptBr': 'Aproveito o momento sem pensar muito nisso.',
  },
  'Creo que eso me hace superior a los demás.': {
    'es': 'Creo que eso me hace superior a los demás.',
    'ptBr': 'Acho que isso me torna superior às outras pessoas.',
  },
  'Si alguien necesita ayuda y puedes brindarla, ¿qué haces?': {
    'es': 'Si alguien necesita ayuda y puedes brindarla, ¿qué haces?',
    'ptBr': 'O que você faz quando alguém precisa de ajuda e você pode ajudar?',
  },
  'Busco una manera responsable de ayudar.': {
    'es': 'Busco una manera responsable de ayudar.',
    'ptBr': 'Procuro uma maneira responsável de ajudar.',
  },
  'Dudo y suelo esperar a que alguien más actúe.': {
    'es': 'Dudo y suelo esperar a que alguien más actúe.',
    'ptBr': 'Hesito e costumo esperar que outra pessoa aja.',
  },
  'Me aprovecho de su necesidad o la ignoro con desprecio.': {
    'es': 'Me aprovecho de su necesidad o la ignoro con desprecio.',
    'ptBr': 'Tiro proveito da necessidade ou a ignoro com desprezo.',
  },
  'Cuando sientes enojo, ¿qué haces primero?': {
    'es': 'Cuando sientes enojo, ¿qué haces primero?',
    'ptBr': 'O que você faz primeiro quando sente raiva?',
  },
  'Hago una pausa antes de responder.': {
    'es': 'Hago una pausa antes de responder.',
    'ptBr': 'Faço uma pausa antes de responder.',
  },
  'Respondo rápido y luego me arrepiento.': {
    'es': 'Respondo rápido y luego me arrepiento.',
    'ptBr': 'Respondo rapidamente e depois me arrependo.',
  },
  'Busco herir con mis palabras.': {
    'es': 'Busco herir con mis palabras.',
    'ptBr': 'Tento ferir com minhas palavras.',
  },
  'El principio de la sabiduría es el temor de Jehová: Los insensatos desprecian la sabiduría y la enseñanza.': {
    'es':
        'El principio de la sabiduría es el temor de Jehová: Los insensatos desprecian la sabiduría y la enseñanza.',
    'ptBr':
        'O temor do Senhor é o princípio do conhecimento; os insensatos desprezam a sabedoria e a instrução.',
  },
  'Fíate de Jehová de todo tu corazón, Y no estribes en tu prudencia.': {
    'es': 'Fíate de Jehová de todo tu corazón, Y no estribes en tu prudencia.',
    'ptBr':
        'Confie no Senhor de todo o seu coração e não se apoie no seu próprio entendimento.',
  },
  'Reconócelo en todos tus caminos, Y él enderezará tus veredas.': {
    'es': 'Reconócelo en todos tus caminos, Y él enderezará tus veredas.',
    'ptBr':
        'Reconheça o Senhor em todos os seus caminhos, e ele endireitará as suas veredas.',
  },
  'La blanda respuesta quita la ira: Mas la palabra áspera hace subir el furor.': {
    'es':
        'La blanda respuesta quita la ira: Mas la palabra áspera hace subir el furor.',
    'ptBr':
        'A resposta branda desvia o furor, mas a palavra dura suscita a ira.',
  },
  'Encomienda á Jehová tus obras, Y tus pensamientos serán afirmados.': {
    'es': 'Encomienda á Jehová tus obras, Y tus pensamientos serán afirmados.',
    'ptBr':
        'Consagre ao Senhor tudo o que você faz, e os seus planos serão bem-sucedidos.',
  },
  'El corazón del hombre piensa su camino: Mas Jehová endereza sus pasos.': {
    'es':
        'El corazón del hombre piensa su camino: Mas Jehová endereza sus pasos.',
    'ptBr':
        'O coração do homem planeja o seu caminho, mas o Senhor lhe dirige os passos.',
  },
  'En todo tiempo ama el amigo; Y el hermano para la angustia es nacido.': {
    'es':
        'En todo tiempo ama el amigo; Y el hermano para la angustia es nacido.',
    'ptBr': 'O amigo ama em todos os momentos; é um irmão na adversidade.',
  },
  'Torre fuerte es el nombre de Jehová: A él correrá el justo, y será levantado.': {
    'es':
        'Torre fuerte es el nombre de Jehová: A él correrá el justo, y será levantado.',
    'ptBr':
        'O nome do Senhor é uma torre forte; os justos correm para ela e estão seguros.',
  },
  'Escucha el consejo, y recibe la corrección, Para que seas sabio en tu vejez.': {
    'es':
        'Escucha el consejo, y recibe la corrección, Para que seas sabio en tu vejez.',
    'ptBr':
        'Ouça o conselho e aceite a correção, para que você seja sábio no futuro.',
  },
  'Instruye al niño en su carrera: Aun cuando fuere viejo no se apartará de ella.': {
    'es':
        'Instruye al niño en su carrera: Aun cuando fuere viejo no se apartará de ella.',
    'ptBr':
        'Ensine a criança no caminho em que deve andar, e mesmo quando envelhecer não se desviará dele.',
  },
  '¿Qué enseñanza puedes recibir hoy con humildad?': {
    'es': '¿Qué enseñanza puedes recibir hoy con humildad?',
    'ptBr': 'Que ensinamento você pode receber hoje com humildade?',
  },
  '¿En qué decisión necesitas pedir orientación?': {
    'es': '¿En qué decisión necesitas pedir orientación?',
    'ptBr': 'Em que decisão você precisa pedir orientação?',
  },
  '¿Cómo puedes incluir a Dios en una decisión de hoy?': {
    'es': '¿Cómo puedes incluir a Dios en una decisión de hoy?',
    'ptBr': 'Como você pode incluir Deus em uma decisão de hoje?',
  },
  '¿Qué conversación podría cambiar con una respuesta amable?': {
    'es': '¿Qué conversación podría cambiar con una respuesta amable?',
    'ptBr': 'Que conversa poderia mudar com uma resposta gentil?',
  },
  '¿Qué tarea puedes encomendar antes de comenzar?': {
    'es': '¿Qué tarea puedes encomendar antes de comenzar?',
    'ptBr': 'Que tarefa você pode confiar a Deus antes de começar?',
  },
  '¿Qué plan estás dispuesto a revisar con sabiduría?': {
    'es': '¿Qué plan estás dispuesto a revisar con sabiduría?',
    'ptBr': 'Que plano você está disposto a rever com sabedoria?',
  },
  '¿A quién puedes acompañar o agradecer hoy?': {
    'es': '¿A quién puedes acompañar o agradecer hoy?',
    'ptBr': 'Quem você pode acompanhar ou agradecer hoje?',
  },
  '¿Dónde buscas refugio cuando atraviesas una dificultad?': {
    'es': '¿Dónde buscas refugio cuando atraviesas una dificultad?',
    'ptBr': 'Onde você busca refúgio quando enfrenta uma dificuldade?',
  },
  '¿Qué consejo valioso has recibido últimamente?': {
    'es': '¿Qué consejo valioso has recibido últimamente?',
    'ptBr': 'Que conselho valioso você recebeu recentemente?',
  },
  '¿Qué ejemplo de bien puedes transmitir a alguien más joven?': {
    'es': '¿Qué ejemplo de bien puedes transmitir a alguien más joven?',
    'ptBr': 'Que bom exemplo você pode transmitir a alguém mais jovem?',
  },
  'Escucha y sigue aprendiendo.': {
    'es': 'Escucha y sigue aprendiendo.',
    'ptBr': 'Escute e continue aprendendo.',
  },
  'La sabiduría no significa saberlo todo. El sabio acepta consejo, aprende de la experiencia y está dispuesto a corregir su camino.': {
    'es':
        'La sabiduría no significa saberlo todo. El sabio acepta consejo, aprende de la experiencia y está dispuesto a corregir su camino.',
    'ptBr':
        'Sabedoria não significa saber tudo. A pessoa sábia aceita conselhos, aprende com a experiência e está disposta a corrigir seu caminho.',
  },
  'Práctica: pide una opinión sincera antes de decidir.': {
    'es': 'Práctica: pide una opinión sincera antes de decidir.',
    'ptBr': 'Prática: peça uma opinião sincera antes de decidir.',
  },
  'Recibe la instrucción y crece en entendimiento.': {
    'es': 'Recibe la instrucción y crece en entendimiento.',
    'ptBr': 'Receba a instrução e cresça em entendimento.',
  },
  'La persona sabia no deja de aprender. Puede recibir una idea nueva sin sentir que eso disminuye su valor.': {
    'es':
        'La persona sabia no deja de aprender. Puede recibir una idea nueva sin sentir que eso disminuye su valor.',
    'ptBr':
        'A pessoa sábia nunca deixa de aprender. Ela pode receber uma nova ideia sem sentir que isso diminui seu valor.',
  },
  'Práctica: escucha una sugerencia antes de responder.': {
    'es': 'Práctica: escucha una sugerencia antes de responder.',
    'ptBr': 'Prática: escute uma sugestão antes de responder.',
  },
  'Busca consejo en lugar de confiar solo en tu parecer.': {
    'es': 'Busca consejo en lugar de confiar solo en tu parecer.',
    'ptBr': 'Busque conselho em vez de confiar apenas na própria opinião.',
  },
  'Pedir consejo ayuda a ver aspectos que quizá no habías notado. La humildad abre espacio para decisiones más prudentes.': {
    'es':
        'Pedir consejo ayuda a ver aspectos que quizá no habías notado. La humildad abre espacio para decisiones más prudentes.',
    'ptBr':
        'Pedir conselho ajuda a perceber aspectos que talvez você não tenha notado. A humildade abre espaço para decisões mais prudentes.',
  },
  'Práctica: consulta a alguien de confianza sobre un plan.': {
    'es': 'Práctica: consulta a alguien de confianza sobre un plan.',
    'ptBr': 'Prática: converse com alguém de confiança sobre um plano.',
  },
  'Está en camino de aprender discernimiento.': {
    'es': 'Está en camino de aprender discernimiento.',
    'ptBr': 'Está no caminho para aprender discernimento.',
  },
  'La persona simple todavía puede ser influida por lo que la rodea. Proverbios invita a buscar prudencia y pensar en las consecuencias antes de actuar.': {
    'es':
        'La persona simple todavía puede ser influida por lo que la rodea. Proverbios invita a buscar prudencia y pensar en las consecuencias antes de actuar.',
    'ptBr':
        'A pessoa simples ainda pode ser influenciada pelo que a cerca. Provérbios convida a buscar prudência e pensar nas consequências antes de agir.',
  },
  'Práctica: antes de elegir, considera qué podría pasar.': {
    'es': 'Práctica: antes de elegir, considera qué podría pasar.',
    'ptBr': 'Prática: antes de escolher, considere o que pode acontecer.',
  },
  'No todo lo que oye merece una respuesta inmediata.': {
    'es': 'No todo lo que oye merece una respuesta inmediata.',
    'ptBr': 'Nem tudo o que você ouve merece uma resposta imediata.',
  },
  'La prudencia ayuda a examinar una idea antes de aceptarla. Tomarse un momento puede evitar decisiones precipitadas.': {
    'es':
        'La prudencia ayuda a examinar una idea antes de aceptarla. Tomarse un momento puede evitar decisiones precipitadas.',
    'ptBr':
        'A prudência ajuda a examinar uma ideia antes de aceitá-la. Fazer uma pausa pode evitar decisões precipitadas.',
  },
  'Práctica: verifica la información antes de compartirla.': {
    'es': 'Práctica: verifica la información antes de compartirla.',
    'ptBr': 'Prática: verifique a informação antes de compartilhá-la.',
  },
  'El entusiasmo también necesita dirección.': {
    'es': 'El entusiasmo también necesita dirección.',
    'ptBr': 'O entusiasmo também precisa de direção.',
  },
  'Actuar con prisa y sin conocimiento puede desviarnos. Aprender a detenerse es parte de crecer en discernimiento.': {
    'es':
        'Actuar con prisa y sin conocimiento puede desviarnos. Aprender a detenerse es parte de crecer en discernimiento.',
    'ptBr':
        'Agir com pressa e sem conhecimento pode nos desviar. Aprender a parar faz parte do crescimento em discernimento.',
  },
  'Práctica: date tiempo para pensar antes de comprometerte.': {
    'es': 'Práctica: date tiempo para pensar antes de comprometerte.',
    'ptBr':
        'Prática: reserve um tempo para pensar antes de assumir um compromisso.',
  },
  'Desprecia la corrección y rechaza aprender.': {
    'es': 'Desprecia la corrección y rechaza aprender.',
    'ptBr': 'Despreza a correção e se recusa a aprender.',
  },
  'La insensatez describe una manera de actuar, no una identidad permanente. Detenerse, escuchar y cambiar de rumbo sigue siendo posible.': {
    'es':
        'La insensatez describe una manera de actuar, no una identidad permanente. Detenerse, escuchar y cambiar de rumbo sigue siendo posible.',
    'ptBr':
        'A insensatez descreve uma maneira de agir, não uma identidade permanente. Ainda é possível parar, ouvir e mudar de caminho.',
  },
  'Práctica: reconoce una reacción que quieras cambiar.': {
    'es': 'Práctica: reconoce una reacción que quieras cambiar.',
    'ptBr': 'Prática: reconheça uma reação que você queira mudar.',
  },
  'Aceptar corrección puede ser el comienzo del crecimiento.': {
    'es': 'Aceptar corrección puede ser el comienzo del crecimiento.',
    'ptBr': 'Aceitar correção pode ser o começo do crescimento.',
  },
  'La corrección puede incomodar, pero también muestra una oportunidad de mejorar. Rechazarla de inmediato nos impide aprender.': {
    'es':
        'La corrección puede incomodar, pero también muestra una oportunidad de mejorar. Rechazarla de inmediato nos impide aprender.',
    'ptBr':
        'A correção pode incomodar, mas também revela uma oportunidade de melhorar. Rejeitá-la imediatamente nos impede de aprender.',
  },
  'Práctica: agradece una corrección antes de explicarte.': {
    'es': 'Práctica: agradece una corrección antes de explicarte.',
    'ptBr': 'Prática: agradeça uma correção antes de se explicar.',
  },
  'Escuchar consejo es una decisión que puedes tomar hoy.': {
    'es': 'Escuchar consejo es una decisión que puedes tomar hoy.',
    'ptBr': 'Ouvir conselhos é uma decisão que você pode tomar hoje.',
  },
  'Una respuesta impulsiva no tiene que definir lo que hagas después. Siempre puedes volver a escuchar y buscar reparación.': {
    'es':
        'Una respuesta impulsiva no tiene que definir lo que hagas después. Siempre puedes volver a escuchar y buscar reparación.',
    'ptBr':
        'Uma resposta impulsiva não precisa definir o que você fará depois. Você sempre pode voltar a ouvir e buscar reparar o dano.',
  },
  'Práctica: si reaccionaste mal, da el primer paso para reparar.': {
    'es': 'Práctica: si reaccionaste mal, da el primer paso para reparar.',
    'ptBr': 'Prática: se você reagiu mal, dê o primeiro passo para reparar.',
  },
};
