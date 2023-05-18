import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/openions/entities/openion_response.dart';

abstract class OpenionsRepository {
  Future<Either<Failure, OpenionResponse>> addOpenion({
    required final String text,
  });
}
