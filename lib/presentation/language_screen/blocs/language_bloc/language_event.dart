part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class InitLanguage extends LanguageEvent {}

class ChooseOnetherLang extends LanguageEvent {
  final String lang;

  const ChooseOnetherLang(this.lang);
}

class GetLanguage extends LanguageEvent {}
