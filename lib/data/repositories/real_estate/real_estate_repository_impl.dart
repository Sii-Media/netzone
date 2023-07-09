import 'package:netzoon/data/datasource/remote/real_estate/real_estate_remote_data_source.dart';
import 'package:netzoon/data/models/real_estate/real_estate_model.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/real_estate_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../core/utils/network/network_info.dart';

class RealEstateRepositoryImpl implements RealEstateRepository {
  final NetworkInfo networkInfo;
  final RealEstateRemoteDataSource realEstateRemoteDataSource;
  RealEstateRepositoryImpl({
    required this.networkInfo,
    required this.realEstateRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<RealEstate>>> getAllRealEstates() async {
    try {
      if (await networkInfo.isConnected) {
        final realEstates =
            await realEstateRemoteDataSource.getAllRealEstates();
        return Right(realEstates.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
