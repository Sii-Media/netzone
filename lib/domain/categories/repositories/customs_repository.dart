import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/customs/customs.dart';
import 'package:netzoon/domain/categories/entities/customs/customs_company.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class CustomsRepository {
  Future<Either<Failure, List<Customs>>> getAllCustoms();

  Future<Either<Failure, CustomsCompanies>> getCustomCompanies({
    required String id,
  });
}
