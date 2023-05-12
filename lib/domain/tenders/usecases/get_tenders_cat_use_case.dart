import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/entities/tender_response.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';

class GetTendersCategoriesUseCase extends UseCase<TenderResponse, NoParams> {
  final TenderRepository tenderRepository;

  GetTendersCategoriesUseCase({
    required this.tenderRepository,
  });
  @override
  Future<Either<Failure, TenderResponse>> call(NoParams params) {
    return tenderRepository.getTendersCategories();
  }
}
