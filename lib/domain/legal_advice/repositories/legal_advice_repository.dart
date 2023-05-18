import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice_response.dart';

abstract class LegalAdviceRepository {
  Future<Either<Failure, LegalAdviceResponse>> getLegalAdvices();
}
