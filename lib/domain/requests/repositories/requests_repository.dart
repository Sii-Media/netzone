import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/requests/entities/request_response.dart';

abstract class RequestsRepository {
  Future<Either<Failure, RequestResponse>> addRequest({
    required final String address,
    required final String text,
  });
}
