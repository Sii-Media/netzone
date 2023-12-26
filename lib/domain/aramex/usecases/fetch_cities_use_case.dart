import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/aramex/entities/fetch_cities_respomse.dart';
import 'package:netzoon/domain/aramex/repositories/aramex_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class FetchCitiesUseCase extends UseCase<FetchCitiesResponse, String> {
  final AramexRepository aramexRepository;

  FetchCitiesUseCase({required this.aramexRepository});
  @override
  Future<Either<Failure, FetchCitiesResponse>> call(String params) {
    return aramexRepository.fetchCities(country: params);
  }
}
