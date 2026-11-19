import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/localization.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/presentation/language_selector.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    required this.supabaseClient,
    this.startInRegistration = false,
    super.key,
  });

  final SupabaseClient supabaseClient;
  final bool startInRegistration;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;
  bool _isSubmitting = false;
  bool _isGoogleLoading = false;
  String? _message;
  String? _error;

  @override
  void initState() {
    super.initState();
    _isRegistering = widget.startInRegistration;
  }

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
            _message = context.tr('register_confirm');
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
      _isGoogleLoading = true;
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
          _error = context.tr('google_start_failed');
        });
      } else if (mounted) {
        setState(() => _message = context.tr('google_redirecting'));
      }
    } on AuthException catch (error) {
      if (mounted) {
        setState(
          () => _error =
              '${context.tr('google_auth_failed')}: ${error.message}\n${context.tr('google_setup_hint')}',
        );
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(
          () => _error =
              '${context.tr('google_auth_failed')}: $error\n${context.tr('google_setup_hint')}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('account_title')),
        actions: const [LanguageSelector()],
      ),
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
                    _isRegistering
                        ? context.tr('register_heading')
                        : context.tr('welcome'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('auth_intro'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 22),
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _continueWithGoogle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isGoogleLoading) ...[
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 10),
                            Text(context.tr('google_connecting')),
                          ] else ...[
                            const Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(context.tr('continue_google')),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    _MessageBox(text: _error!, isError: true),
                  ],
                  if (_message != null) ...[
                    const SizedBox(height: 14),
                    _MessageBox(text: _message!, isError: false),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(context.tr('or_email')),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  if (_isRegistering) ...[
                    Text(
                      context.tr('register_email'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: context.tr('email'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!email.contains('@') || !email.contains('.')) {
                        return context.tr('invalid_email');
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
                    decoration: InputDecoration(
                      labelText: context.tr('password'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if ((value ?? '').length < 8) {
                        return context.tr('password_length');
                      }
                      return null;
                    },
                  ),
                  if (_isRegistering) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      obscureText: true,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: context.tr('repeat_password'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return context.tr('password_mismatch');
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _isSubmitting
                            ? context.tr('working')
                            : _isRegistering
                            ? context.tr('register_button')
                            : context.tr('login_button'),
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
                          ? context.tr('already_account')
                          : context.tr('need_account'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('anonymous_test'),
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
