import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SupportLanguages {
  final String key;
  final String name;
  final Locale locale;

  const SupportLanguages(this.key, this.name, this.locale);
}

class Locales {
  // static const String auto = "auto";
  static const String zh = "zh";
  static const String en = "en";
}

const defaultLocale = Locale('zh', 'CN');
Locale deviceLocale = defaultLocale;

const Map<String, Locale> supportLocale = {
  Locales.zh: Locale('zh', 'CN'),
  Locales.en: Locale('en', 'US'),
};

final supportLanguages = [
  // SupportLanguages(Locales.auto, "language_auto", getSystemLocale()),
  SupportLanguages(Locales.zh, "简体中文", supportLocale[Locales.zh]!),
  SupportLanguages(Locales.en, "English", supportLocale[Locales.en]!),
];

Locale getSystemLocale() {
  var locale = Get.locale;

  if (supportLocale.containsKey(locale?.languageCode)) {
    return supportLocale[locale?.languageCode]!;
  }

  return defaultLocale;
}

bool isFollowDevice() {
  return deviceLocale.languageCode == getSystemLocale().languageCode;
}

SupportLanguages getDeviceLanguage() {
  SupportLanguages sl = supportLanguages.where((element) => element.key == deviceLocale.languageCode).firstOrNull ??
      supportLanguages.first;
  return sl;
}
