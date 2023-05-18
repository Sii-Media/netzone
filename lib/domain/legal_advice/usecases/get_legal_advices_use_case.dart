import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice_response.dart';
import 'package:netzoon/domain/legal_advice/repositories/legal_advice_repository.dart';

class GetLegalAdvicesUseCase extends UseCase<LegalAdviceResponse, NoParams> {
  final LegalAdviceRepository legalAdviceRepository;

  GetLegalAdvicesUseCase({required this.legalAdviceRepository});
  @override
  Future<Either<Failure, LegalAdviceResponse>> call(NoParams params) {
    return legalAdviceRepository.getLegalAdvices();
  }
}
