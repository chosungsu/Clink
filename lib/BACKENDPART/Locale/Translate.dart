// ignore_for_file: file_names
import 'dart:convert';

class Translate {
  final String ko;
  final String en;

  Translate({required this.ko, required this.en});

  factory Translate.fromJson(Map<String, dynamic> json) {
    return Translate(
      ko: json['ko'] as String,
      en: json['en'] as String,
    );
  }
}

Future<Translate> fetchTranslating(what) async {
  return Translate.fromJson(jsonDecode(what));
}
