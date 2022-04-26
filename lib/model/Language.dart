import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';

class Language {
  String code;
  String englishName;
  String localName;
  String flag;
  bool selected;

  Language(this.code, this.englishName, this.localName,
      {this.selected = false});

  static Future<List<Language>> getList() async {
    String selected = await PreferenceManager.getDefaultLanguage();
    List<Language> _languages = [
      new Language("en", S.current.englishLanguage, "English", selected: selected == 'en'),
      new Language("fr", S.current.frenchLanguage, "Français - France", selected: selected == 'fr'),
    ];
    return _languages;
  }
}