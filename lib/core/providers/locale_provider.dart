import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _kLocaleKey = 'locale_code';

/// The Hive box name used for user preferences (locale, etc.).
/// Open this box before the provider is first read — call [openPrefsBox]
/// from main() after [Hive.initFlutter].
const kPrefsBox = 'preferences';

/// Opens the shared preferences Hive box. Call once from main().
Future<void> openPrefsBox() => Hive.openBox(kPrefsBox);

/// Persists and exposes the app locale.  Defaults to English on first launch.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = Hive.box(kPrefsBox).get(_kLocaleKey) as String?;
    return code != null ? Locale(code) : const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await Hive.box(kPrefsBox).put(_kLocaleKey, locale.languageCode);
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
