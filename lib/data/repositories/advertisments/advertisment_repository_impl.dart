import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/models/advertisements/advertising/advertising_model.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class AdvertismentRepositoryImpl implements AdvertismentRepository {
  final AdvertismentRemotDataSource advertismentRemotDataSource;
  final NetworkInfo networkInfo;

  AdvertismentRepositoryImpl({
    required this.advertismentRemotDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Advertising>> getAllAds() async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getAllAdvertisment();

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertising>> getAdvertisementByType(
      {required String userAdvertisingType}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource
            .getAdvertisementByType(userAdvertisingType);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      // print(e);
      return Left(ServerFailure());
    }
  }
}
