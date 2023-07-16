import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/country_repository.dart';

class GetCountryUseCase extends UseCase<String?, NoParams> {
  final CountryRepository countryRepository;

  GetCountryUseCase({required this.countryRepository});
  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return countryRepository.getCountry();
  }
}
