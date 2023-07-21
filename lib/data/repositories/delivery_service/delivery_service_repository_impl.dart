import 'package:netzoon/data/datasource/remote/delivery_service/delivery_service_remote_data_source.dart';
import 'package:netzoon/data/models/delivery_service/delivery_service_model.dart';
import 'package:netzoon/domain/categories/entities/delivery_service/delivery_service.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/delivery_service_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../core/utils/network/network_info.dart';

class DeliveryServiceRepositoryImpl implements DeliveryServiceRepository {
  final NetworkInfo networkInfo;
  final DeliveryServiceRemoteDataSource dataSource;
  DeliveryServiceRepositoryImpl({
    required this.networkInfo,
    required this.dataSource,
  });

  @override
  Future<Either<Failure, String>> addDeliveryService(
      {required String title,
      required String description,
      required String from,
      required String to,
      required int price,
      required String owner}) async {
    try {
      if (await networkInfo.isConnected) {
        final message = await dataSource.addDeliveryService(
            title, description, from, to, price, owner);
        return Right(message);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<DeliveryService>>> getDeliveryCompanyServices(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final services = await dataSource.getDeliveryCompanyServices(id);
        return Right(services.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
