part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {
  final String lang;

  const LanguageInitial(this.lang);
}

class EnglishState extends LanguageState {}

class ArabicState extends LanguageState {}
