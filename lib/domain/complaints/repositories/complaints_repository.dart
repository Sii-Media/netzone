import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/complaints/entities/complaints_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class ComplaintsRepository {
  Future<Either<Failure, ComplaintsResponse>> getComplaints();
  Future<Either<Failure, String>> addComplaints({
    required final String address,
    required final String text,
  });
}
