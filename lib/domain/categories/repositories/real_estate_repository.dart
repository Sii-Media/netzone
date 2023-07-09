import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class RealEstateRepository {
  Future<Either<Failure, List<RealEstate>>> getAllRealEstates();
}
