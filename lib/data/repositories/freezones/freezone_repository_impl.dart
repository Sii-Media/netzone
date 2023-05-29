import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/freezones/freezone_remote_data_source.dart';
import 'package:netzoon/data/models/freezone/freezone_company/freezone_company_response_model.dart';
import 'package:netzoon/data/models/freezone/freezone_places/freezone_response_model.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company_response.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_response.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/freezone_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class FreeZoneRepositoryImpl implements FreeZoneRepository {
  final NetworkInfo networkInfo;

  final FreeZoneRemoteDataSource freeZoneRemoteDataSource;

  FreeZoneRepositoryImpl({
    required this.freeZoneRemoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, FreeZoneResponse>> getFreeZonePlaces() async {
    try {
      if (await networkInfo.isConnected) {
        final freezoneplaces =
            await freeZoneRemoteDataSource.getFreeZonePlaces();

        return Right(freezoneplaces.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FreeZoneCompanyResponse>> getFreeZonePlacesById(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final freezonecompanies =
            await freeZoneRemoteDataSource.getFreeZonePlacesById(id);
        return Right(freezonecompanies.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
