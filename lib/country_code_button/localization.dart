import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nice_text_form/country_code_button/country_codes.dart';
import 'package:nice_text_form/nice_text_form.dart';

class CountryLocalization {
  Locale? locale;
  Map<String, String>? countryNameGroup;

  CountryLocalization([this.locale]);

  bool get isLocalized => countryNameGroup != null;

  Future<bool> load() async {
    if (locale == null) return false;

    if (!isSupported(locale!)) return false;

    String jsonString =
        await rootBundle.loadString('packages/nice_text_form/assets/i18n/${locale!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    countryNameGroup = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  CountryCode getCountryCodeDetails(String countryCode) {
    String? countryCodeName;
    String? dialCode;

    if (isLocalized) {
      countryCodeName = countryNameGroup![countryCode.toUpperCase()]!;
    }

    Map<String, String> data = codes
        .where((data) => (data["code"] == countryCode.toUpperCase()))
        .first;
    countryCodeName ??= data["name"];
    dialCode = data["dial_code"];

    return CountryCode(
        countryCode,
        'assets/flags/${countryCode.toLowerCase()}.png',
        dialCode ?? "",
        countryCodeName!);
  }

  bool isSupported(Locale locale) => ([
        "af",
        "am",
        "ar",
        "az",
        "be",
        "bg",
        "bn",
        "bs",
        "ca",
        "cs",
        "da",
        "de",
        "el",
        "en",
        "es",
        "et",
        "fa",
        "fi",
        "fr",
        "gl",
        "ha",
        "he",
        "hi",
        "hr",
        "hu",
        "hy",
        "id",
        "is",
        "it",
        "ja",
        "ka",
        "kk",
        "km",
        "ko",
        "ku",
        "ky",
        "lt",
        "lv",
        "mk",
        "ml",
        "mn",
        "ms",
        "nb",
        "nl",
        "nn",
        "no",
        "pl",
        "ps",
        "pt",
        "ro",
        "ru",
        "sd",
        "sk",
        "sl",
        "so",
        "sq",
        "sr",
        "sv",
        "ta",
        "tg",
        "th",
        "tk",
        "tr",
        "tt",
        "uk",
        "ug",
        "ur",
        "uz",
        "vi",
        "zh",
      ].contains(locale.languageCode));
}
