import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/data/core/constants/constants.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/lang/usecases/change_language.dart';
import 'package:netzoon/domain/lang/usecases/get_init_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;
  final ChangeLanguage changeLanguage;
  final GetInitLanguage getInitLanguage;
  LanguageBloc(
      {required this.sharedPreferences,
      required this.changeLanguage,
      required this.getInitLanguage})
      : super(LanguageInitial(
            sharedPreferences.getString(SharedPreferencesKeys.language) ??
                'ar')) {
    on<ChooseOnetherLang>((event, emit) async {
      // ignore: unused_local_variable
      var res = await changeLanguage.call(LanguageParam(event.lang));
      emit(event.lang == 'en' ? EnglishState() : ArabicState());
    });
    on<InitLanguage>((event, emit) async {
      emit(ArabicState());
    });
    on<GetLanguage>((event, emit) async {
      var res = await getInitLanguage.call(NoParams());
      var rr = res.fold((l) => null, (r) => r.toString());
      emit(rr == 'en' ? EnglishState() : ArabicState());
    });
  }
}
