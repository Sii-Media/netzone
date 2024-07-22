import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/fees/entities/fees_resposne.dart';

abstract class FeesRepository {
  Future<Either<Failure, FeesResponse>> getFeesInfo();
}
