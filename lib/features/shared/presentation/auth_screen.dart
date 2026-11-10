import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.supabaseClient, super.key});

  final SupabaseClient supabaseClient;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;
  bool _isSubmitting = false;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
      _message = null;
    });

    try {
      if (_isRegistering) {
        final response = await widget.supabaseClient.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (!mounted) return;
        if (response.session == null) {
          setState(() {
            _message =
                'Cuenta creada. Revisa tu correo para confirmar la dirección '
                'y luego inicia sesión.';
            _isRegistering = false;
          });
        } else {
          Navigator.of(context).pop(true);
        }
      } else {
        await widget.supabaseClient.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) Navigator.of(context).pop(true);
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo completar la operación: $error');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
      _message = null;
    });

    try {
      final started = await widget.supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: Uri.base.origin,
      );
      if (!started && mounted) {
        setState(() {
          _error =
              'No se pudo iniciar el acceso con Google. Inténtalo otra vez.';
        });
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo conectar con Google: $error');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tu cuenta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isRegistering ? 'Crea tu cuenta' : 'Bienvenido',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Regístrate con Google o con tu correo para guardar tus '
                    'resultados y proverbios favoritos. También puedes hacer '
                    'el test sin registrarte.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 22),
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _continueWithGoogle,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'G',
                            style: TextStyle(
                              color: Color(0xFF4285F4),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Continuar con Google'),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('o con correo'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  if (_isRegistering) ...[
                    Text(
                      'Crear cuenta con correo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!email.contains('@') || !email.contains('.')) {
                        return 'Escribe un correo válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: [
                      _isRegistering
                          ? AutofillHints.newPassword
                          : AutofillHints.password,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if ((value ?? '').length < 8) {
                        return 'Usa al menos 8 caracteres.';
                      }
                      return null;
                    },
                  ),
                  if (_isRegistering) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      obscureText: true,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: const InputDecoration(
                        labelText: 'Repite la contraseña',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden.';
                        }
                        return null;
                      },
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    _MessageBox(text: _error!, isError: true),
                  ],
                  if (_message != null) ...[
                    const SizedBox(height: 14),
                    _MessageBox(text: _message!, isError: false),
                  ],
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _isSubmitting
                            ? 'Un momento...'
                            : _isRegistering
                            ? 'Registrarme con correo'
                            : 'Iniciar sesión con correo',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => setState(() {
                            _isRegistering = !_isRegistering;
                            _error = null;
                            _message = null;
                          }),
                    child: Text(
                      _isRegistering
                          ? 'Ya tengo cuenta: iniciar sesión'
                          : 'Crear cuenta con correo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¿Solo quieres conocer el test? Puedes responderlo sin '
                    'cuenta desde la pantalla principal.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({required this.text, required this.isError});

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
