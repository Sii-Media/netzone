import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/deals/deals_remote_data_source.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_items_response_model.dart';
import 'package:netzoon/data/models/deals/deals_response/deals_response_model.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class DealsRepositoryImpl implements DealsRepository {
  final DealsRemoteDataSource dealsRemoteDataSource;
  final NetworkInfo networkInfo;

  DealsRepositoryImpl(
      {required this.dealsRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, DealsResponse>> getDealsCategories() async {
    try {
      if (await networkInfo.isConnected) {
        final dealsCat = await dealsRemoteDataSource.getDealsCategories();
        return Right(dealsCat.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DealsItemsResponse>> getDealsByCategory(
      {required String category}) async {
    try {
      if (await networkInfo.isConnected) {
        final dealsItem =
            await dealsRemoteDataSource.getDealsByCategory(category);
        return Right(dealsItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DealsItemsResponse>> getDealsItems() async {
    try {
      if (await networkInfo.isConnected) {
        final dealItem = await dealsRemoteDataSource.getDealsItems();
        return Right(dealItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
