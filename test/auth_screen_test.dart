import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proverbios/features/shared/presentation/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('offers Google and email account registration', (tester) async {
    final client = SupabaseClient(
      'https://example.supabase.co',
      'test-publishable-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    await tester.pumpWidget(
      MaterialApp(home: AuthScreen(supabaseClient: client)),
    );

    expect(find.text('Continuar con Google'), findsOneWidget);
    expect(find.text('Iniciar sesión con correo'), findsOneWidget);
    expect(
      find.textContaining('También puedes hacer el test sin registrarte.'),
      findsOneWidget,
    );

    final createAccount = find.text('Crear cuenta con correo');
    await tester.ensureVisible(createAccount);
    await tester.tap(createAccount);
    await tester.pumpAndSettle();

    expect(find.text('Crea tu cuenta'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Repite la contraseña'), findsOneWidget);
    expect(find.text('Registrarme con correo'), findsOneWidget);
  });
}
