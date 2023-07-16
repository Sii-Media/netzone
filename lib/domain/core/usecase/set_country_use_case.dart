import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/country_repository.dart';

class SetCountryUseCase extends UseCase<void, String> {
  final CountryRepository countryRepository;

  SetCountryUseCase({required this.countryRepository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return countryRepository.setCountry(country: params);
  }
}
