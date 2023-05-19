import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/complaints/complaints_remote_data_source.dart';
import 'package:netzoon/data/models/complaints/complaints_response_model.dart';
import 'package:netzoon/domain/complaints/entities/complaints_response.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/complaints/repositories/complaints_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final NetworkInfo networkInfo;
  final ComplaintsRemoteDataSource complaintsRemoteDataSource;

  ComplaintsRepositoryImpl(
      {required this.networkInfo, required this.complaintsRemoteDataSource});

  @override
  Future<Either<Failure, String>> addComplaints(
      {required String address, required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final complaint =
            await complaintsRemoteDataSource.addComplaints(address, text);
        return Right(complaint);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ComplaintsResponse>> getComplaints() async {
    try {
      if (await networkInfo.isConnected) {
        final complaints = await complaintsRemoteDataSource.getComplaints();
        return Right(complaints.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
