import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/providers/locale_provider.dart';
import 'core/supabase/supabase_client.dart';
import 'l10n/app_localizations.dart';

Future<void> _tryInitFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Future.wait([
    openPrefsBox(),
    Hive.openBox<List>('saved_ports'),
  ]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables first — everything else depends on them
  await dotenv.load(fileName: '.env');

  // Initialise services in parallel where possible.
  // Firebase is skipped gracefully when google-services.json is absent
  // (common in development before the file is provisioned).
  await Future.wait([
    initSupabase(),
    _initHive(),
    _tryInitFirebase(),
  ]);

  runApp(
    const ProviderScope(
      child: SadamaAgentApp(),
    ),
  );
}

class SadamaAgentApp extends ConsumerWidget {
  const SadamaAgentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'SadamaAgent',
      theme: buildAppTheme(),
      routerConfig: router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
