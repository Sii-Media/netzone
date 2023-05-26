import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class LangRepository {
  Future<Either<Failure, String>> changelang(String eventlan);
  Future<Either<Failure, String>> initlang();
}
