import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/lang/repositories/lang_repository.dart';

class GetInitLanguage extends UseCase<String, NoParams> {
  final LangRepository languageRepository;

  GetInitLanguage({required this.languageRepository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    final res = await languageRepository.initlang();
    return res;
  }
}
