import 'package:netzoon/data/datasource/local/lang/lang_local_data_resource.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/lang/repositories/lang_repository.dart';

class LangRepositoryImpl implements LangRepository {
  final LangLocalDataResource langLocalDataResource;

  LangRepositoryImpl({required this.langLocalDataResource});
  @override
  Future<Either<Failure, String>> changelang(String eventlan) async {
    final lang = await langLocalDataResource.setLang(eventlan);
    return Right(lang);
  }

  @override
  Future<Either<Failure, String>> initlang() async {
    final language = await langLocalDataResource.getInit();
    return Right(language);
  }
}
