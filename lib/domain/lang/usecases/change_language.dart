import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/lang/repositories/lang_repository.dart';

class ChangeLanguage extends UseCase<String, LanguageParam> {
  final LangRepository languageRepository;

  ChangeLanguage({required this.languageRepository});
  @override
  Future<Either<Failure, String>> call(LanguageParam params) async {
    final res = await languageRepository.changelang(params.eventLan);
    return res;
  }
}

class LanguageParam {
  final String eventLan;

  LanguageParam(this.eventLan);
}
