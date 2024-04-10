library i18n;

import 'package:get/get.dart';

import '../configs/languages.dart';

part 'i18n_zh.dart';
part 'i18n_en.dart';

class I18n extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        Locales.zh: zhMessage,
        Locales.en: enMessage,
      };
}
