import 'package:rxdart/rxdart.dart';

BehaviorSubject<AppLanguage> languageSubject = BehaviorSubject();

///
/// [AppLanguage] enum is declaring the supported languages in our app
///
enum AppLanguage {
  ar,
  en,
}
