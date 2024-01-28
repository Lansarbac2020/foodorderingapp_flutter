import 'package:get/get.dart';

class Messagess extends Translations {
  final Map<String, Map<String, String>> languages;
  Messagess({required this.languages});

  @override
  Map<String, Map<String, String>> get keys {
    return languages;
  }
}
