import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseConfigured =
      _supabaseUrl.isNotEmpty && _supabasePublishableKey.isNotEmpty;
  if (supabaseConfigured) {
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _supabasePublishableKey,
    );
  }

  runApp(
    ProverbiosApp(
      supabaseClient: supabaseConfigured ? Supabase.instance.client : null,
    ),
  );
}
