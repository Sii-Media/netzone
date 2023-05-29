import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_companies.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class GovermentalRepository {
  Future<Either<Failure, List<Govermental>>> getAllGovermental();
  Future<Either<Failure, GovermentalCompanies>> getGovermentalCompanies({
    required String id,
  });
}
