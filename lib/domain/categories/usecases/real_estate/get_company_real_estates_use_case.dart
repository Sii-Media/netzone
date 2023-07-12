import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:netzoon/domain/categories/repositories/real_estate_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../../core/usecase/usecase.dart';

class GetCompanyRealEstatesUseCase extends UseCase<List<RealEstate>, String> {
  final RealEstateRepository realEstateRepository;

  GetCompanyRealEstatesUseCase({required this.realEstateRepository});
  @override
  Future<Either<Failure, List<RealEstate>>> call(String params) {
    return realEstateRepository.getcompanyRealEstates(id: params);
  }
}
