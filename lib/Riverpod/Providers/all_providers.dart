import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slim30/Riverpod/Providers/locale_provider.dart';

export 'package:slim30/Riverpod/Providers/locale_provider.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
