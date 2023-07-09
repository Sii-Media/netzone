import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:netzoon/domain/categories/repositories/real_estate_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllRealEstatesUseCase extends UseCase<List<RealEstate>, NoParams> {
  final RealEstateRepository realEstateRepository;

  GetAllRealEstatesUseCase({required this.realEstateRepository});
  @override
  Future<Either<Failure, List<RealEstate>>> call(NoParams params) {
    return realEstateRepository.getAllRealEstates();
  }
}
