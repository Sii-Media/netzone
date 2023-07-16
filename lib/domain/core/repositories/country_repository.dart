import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class CountryRepository {
  Future<Either<Failure, String?>> getCountry();
  Future<Either<Failure, void>> setCountry({
    required String country,
  });
}
