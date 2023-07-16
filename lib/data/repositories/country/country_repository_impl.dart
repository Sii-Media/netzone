import 'package:netzoon/data/datasource/local/country/country_local_data_source.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryLocalDataSource countryLocalDataSource;

  CountryRepositoryImpl({required this.countryLocalDataSource});
  @override
  Future<Either<Failure, String?>> getCountry() async {
    return right(countryLocalDataSource.getCountry());
  }

  @override
  Future<Either<Failure, void>> setCountry({required String country}) async {
    return right(countryLocalDataSource.setCountry(country));
  }
}
